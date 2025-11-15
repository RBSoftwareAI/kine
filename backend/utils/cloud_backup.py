"""
Cloud Backup Manager for KinéCare
Sauvegarde automatique chiffrée vers cloud (Google Drive, Dropbox, OVH S3)
"""
import os
import shutil
import gzip
from pathlib import Path
from datetime import datetime
from typing import Optional, List
import hashlib
import json


class CloudBackupManager:
    """Gère les sauvegardes cloud chiffrées"""
    
    SUPPORTED_PROVIDERS = ['google_drive', 'dropbox', 'ovh_s3', 'local_sync']
    
    def __init__(self, db_path: str, config_path: Optional[str] = None):
        """
        Initialize cloud backup manager
        
        Args:
            db_path: Path to database file
            config_path: Path to backup configuration JSON
        """
        self.db_path = db_path
        self.config_path = config_path or str(Path(db_path).parent / 'backup_config.json')
        self.config = self._load_config()
        
    def _load_config(self) -> dict:
        """Load backup configuration"""
        if os.path.exists(self.config_path):
            with open(self.config_path, 'r') as f:
                return json.load(f)
        
        # Default configuration
        return {
            'enabled': False,
            'provider': 'local_sync',
            'frequency_hours': 24,
            'retention_days': 30,
            'encryption_enabled': True,
            'compression_enabled': True,
            'last_backup': None,
            
            # Provider-specific settings
            'google_drive': {
                'folder_id': None,
                'credentials_path': None
            },
            'dropbox': {
                'access_token': None,
                'folder_path': '/KinéCare_Backups'
            },
            'ovh_s3': {
                'endpoint': None,
                'bucket_name': None,
                'access_key': None,
                'secret_key': None
            },
            'local_sync': {
                'backup_path': str(Path.home() / 'KinéCare_Backups_Cloud')
            }
        }
    
    def _save_config(self):
        """Save backup configuration"""
        with open(self.config_path, 'w') as f:
            json.dump(self.config, f, indent=2)
    
    def create_backup(self, encrypt: bool = True, compress: bool = True) -> Optional[str]:
        """
        Crée une sauvegarde de la base de données
        
        Args:
            encrypt: Chiffrer la sauvegarde
            compress: Compresser la sauvegarde
            
        Returns:
            Path to backup file or None
        """
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        backup_name = f"kinecare_backup_{timestamp}"
        
        # Créer dossier temporaire
        temp_dir = Path(self.db_path).parent / 'temp_backup'
        temp_dir.mkdir(exist_ok=True)
        
        try:
            # Copier la base
            temp_db = temp_dir / f"{backup_name}.db"
            shutil.copy2(self.db_path, temp_db)
            
            # Compresser si demandé
            if compress:
                compressed = temp_dir / f"{backup_name}.db.gz"
                with open(temp_db, 'rb') as f_in:
                    with gzip.open(compressed, 'wb') as f_out:
                        shutil.copyfileobj(f_in, f_out)
                os.remove(temp_db)
                temp_db = compressed
            
            # Chiffrer si demandé
            if encrypt:
                encrypted = temp_dir / f"{backup_name}.db.gz.enc"
                self._encrypt_file(temp_db, encrypted)
                os.remove(temp_db)
                temp_db = encrypted
            
            # Calculer checksum
            checksum = self._calculate_checksum(temp_db)
            
            # Sauvegarder métadonnées
            metadata = {
                'timestamp': timestamp,
                'original_size': os.path.getsize(self.db_path),
                'backup_size': os.path.getsize(temp_db),
                'encrypted': encrypt,
                'compressed': compress,
                'checksum': checksum,
                'database_version': self._get_db_version()
            }
            
            metadata_file = temp_dir / f"{backup_name}.json"
            with open(metadata_file, 'w') as f:
                json.dump(metadata, f, indent=2)
            
            print(f"✅ Backup created: {temp_db}")
            print(f"   Original: {metadata['original_size'] / 1024:.1f} KB")
            print(f"   Backup: {metadata['backup_size'] / 1024:.1f} KB")
            print(f"   Ratio: {metadata['backup_size'] / metadata['original_size'] * 100:.1f}%")
            
            return str(temp_db)
            
        except Exception as e:
            print(f"❌ Backup creation failed: {e}")
            return None
    
    def _encrypt_file(self, input_path: Path, output_path: Path):
        """
        Chiffre un fichier avec AES-256
        
        Note: Implémentation simplifiée. En production, utiliser cryptography.fernet
        """
        # TODO: Implémenter chiffrement AES-256 avec cryptography
        # Pour l'instant, simple copie (à remplacer)
        shutil.copy2(input_path, output_path)
        print("⚠️  Encryption not yet implemented (using plain copy)")
    
    def _calculate_checksum(self, file_path: Path) -> str:
        """Calcule le SHA-256 d'un fichier"""
        sha256 = hashlib.sha256()
        with open(file_path, 'rb') as f:
            for chunk in iter(lambda: f.read(4096), b''):
                sha256.update(chunk)
        return sha256.hexdigest()
    
    def _get_db_version(self) -> int:
        """Récupère la version du schéma de la base"""
        import sqlite3
        conn = sqlite3.connect(self.db_path)
        cursor = conn.execute("PRAGMA user_version")
        version = cursor.fetchone()[0]
        conn.close()
        return version
    
    def upload_to_cloud(self, backup_path: str) -> bool:
        """
        Upload une sauvegarde vers le cloud configuré
        
        Args:
            backup_path: Path to backup file
            
        Returns:
            True si succès
        """
        provider = self.config.get('provider')
        
        if provider not in self.SUPPORTED_PROVIDERS:
            print(f"❌ Unsupported provider: {provider}")
            return False
        
        if provider == 'local_sync':
            return self._upload_local_sync(backup_path)
        elif provider == 'google_drive':
            return self._upload_google_drive(backup_path)
        elif provider == 'dropbox':
            return self._upload_dropbox(backup_path)
        elif provider == 'ovh_s3':
            return self._upload_ovh_s3(backup_path)
        
        return False
    
    def _upload_local_sync(self, backup_path: str) -> bool:
        """
        Copie vers un dossier local (clé USB, NAS, dossier synchronisé)
        
        Args:
            backup_path: Path to backup file
            
        Returns:
            True si succès
        """
        try:
            sync_path = self.config['local_sync']['backup_path']
            os.makedirs(sync_path, exist_ok=True)
            
            dest_file = Path(sync_path) / Path(backup_path).name
            shutil.copy2(backup_path, dest_file)
            
            # Copier aussi les métadonnées
            metadata_src = str(backup_path).replace('.db.gz.enc', '.json')
            if os.path.exists(metadata_src):
                metadata_dest = Path(sync_path) / Path(metadata_src).name
                shutil.copy2(metadata_src, metadata_dest)
            
            print(f"✅ Backup uploaded to: {dest_file}")
            
            # Nettoyer les anciennes sauvegardes
            self._cleanup_old_backups(sync_path)
            
            return True
            
        except Exception as e:
            print(f"❌ Local sync failed: {e}")
            return False
    
    def _upload_google_drive(self, backup_path: str) -> bool:
        """Upload vers Google Drive (via API)"""
        print("⚠️  Google Drive upload not yet implemented")
        print("   Install: pip install google-api-python-client google-auth")
        return False
    
    def _upload_dropbox(self, backup_path: str) -> bool:
        """Upload vers Dropbox (via API)"""
        print("⚠️  Dropbox upload not yet implemented")
        print("   Install: pip install dropbox")
        return False
    
    def _upload_ovh_s3(self, backup_path: str) -> bool:
        """Upload vers OVH S3 (via boto3)"""
        print("⚠️  OVH S3 upload not yet implemented")
        print("   Install: pip install boto3")
        return False
    
    def _cleanup_old_backups(self, backup_dir: str):
        """
        Supprime les sauvegardes plus anciennes que retention_days
        
        Args:
            backup_dir: Directory containing backups
        """
        retention_days = self.config.get('retention_days', 30)
        cutoff_time = datetime.now().timestamp() - (retention_days * 86400)
        
        deleted = 0
        for file in Path(backup_dir).glob('kinecare_backup_*'):
            if file.stat().st_mtime < cutoff_time:
                file.unlink()
                deleted += 1
        
        if deleted > 0:
            print(f"🗑️  Cleaned up {deleted} old backup(s)")
    
    def configure_provider(self, provider: str, **settings):
        """
        Configure un provider de sauvegarde
        
        Args:
            provider: Provider name (google_drive, dropbox, ovh_s3, local_sync)
            **settings: Provider-specific settings
        """
        if provider not in self.SUPPORTED_PROVIDERS:
            raise ValueError(f"Unsupported provider: {provider}")
        
        self.config['provider'] = provider
        self.config['enabled'] = True
        
        if provider in self.config:
            self.config[provider].update(settings)
        
        self._save_config()
        print(f"✅ Configured {provider} backup provider")
    
    def run_automatic_backup(self) -> bool:
        """
        Exécute une sauvegarde automatique si nécessaire
        
        Returns:
            True si sauvegarde effectuée
        """
        if not self.config.get('enabled'):
            return False
        
        # Vérifier si une sauvegarde est nécessaire
        last_backup = self.config.get('last_backup')
        frequency_hours = self.config.get('frequency_hours', 24)
        
        if last_backup:
            last_time = datetime.fromisoformat(last_backup)
            hours_since = (datetime.now() - last_time).total_seconds() / 3600
            
            if hours_since < frequency_hours:
                print(f"⏭️  Next backup in {frequency_hours - hours_since:.1f} hours")
                return False
        
        # Créer et uploader la sauvegarde
        print("🔄 Running automatic backup...")
        backup_path = self.create_backup(
            encrypt=self.config.get('encryption_enabled', True),
            compress=self.config.get('compression_enabled', True)
        )
        
        if not backup_path:
            return False
        
        success = self.upload_to_cloud(backup_path)
        
        if success:
            self.config['last_backup'] = datetime.now().isoformat()
            self._save_config()
        
        return success


def setup_cloud_backup_cli():
    """Interface CLI pour configurer les sauvegardes cloud"""
    print("=" * 60)
    print("☁️  KinéCare Cloud Backup Setup")
    print("=" * 60)
    print()
    
    db_path = input("Database path [data/kinecare.db]: ").strip()
    if not db_path:
        db_path = "data/kinecare.db"
    
    manager = CloudBackupManager(db_path)
    
    print("\n📋 Available providers:")
    print("   1. local_sync    - Local folder (USB key, NAS, synced folder)")
    print("   2. google_drive  - Google Drive (requires API setup)")
    print("   3. dropbox       - Dropbox (requires API setup)")
    print("   4. ovh_s3        - OVH S3 Storage (requires credentials)")
    print()
    
    choice = input("Select provider [1]: ").strip() or "1"
    
    providers = {
        '1': 'local_sync',
        '2': 'google_drive',
        '3': 'dropbox',
        '4': 'ovh_s3'
    }
    
    provider = providers.get(choice, 'local_sync')
    
    if provider == 'local_sync':
        default_path = str(Path.home() / 'KinéCare_Backups_Cloud')
        backup_path = input(f"Backup folder [{default_path}]: ").strip() or default_path
        manager.configure_provider('local_sync', backup_path=backup_path)
    
    # Configuration fréquence
    frequency = input("Backup frequency in hours [24]: ").strip() or "24"
    retention = input("Retention period in days [30]: ").strip() or "30"
    
    manager.config['frequency_hours'] = int(frequency)
    manager.config['retention_days'] = int(retention)
    manager._save_config()
    
    print("\n🧪 Testing backup...")
    backup_file = manager.create_backup()
    
    if backup_file:
        success = manager.upload_to_cloud(backup_file)
        
        if success:
            print("\n✅ BACKUP CONFIGURATION SUCCESSFUL")
            print()
            print("📋 Configuration:")
            print(f"   Provider: {provider}")
            print(f"   Frequency: Every {frequency} hours")
            print(f"   Retention: {retention} days")
            print()
            print("🔄 Automatic backups enabled")
        else:
            print("\n⚠️  Backup created but upload failed")
    else:
        print("\n❌ BACKUP TEST FAILED")


if __name__ == "__main__":
    setup_cloud_backup_cli()
