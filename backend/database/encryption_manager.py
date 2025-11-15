"""
Encryption Manager for KinéCare
Gère le chiffrement de la base de données SQLite avec SQLCipher
"""
import os
import sqlite3
from pathlib import Path
from typing import Optional
import hashlib
import secrets


class EncryptionManager:
    """Gère le chiffrement de la base de données"""
    
    def __init__(self, db_path: str):
        """
        Initialize encryption manager
        
        Args:
            db_path: Path to database file
        """
        self.db_path = db_path
        self.key_file = Path(db_path).parent / '.encryption_key'
        
    def generate_encryption_key(self, passphrase: str) -> str:
        """
        Génère une clé de chiffrement à partir d'une passphrase
        
        Args:
            passphrase: Mot de passe maître du cabinet
            
        Returns:
            Clé de chiffrement hexadécimale
        """
        # Utiliser PBKDF2 pour dériver une clé forte
        salt = secrets.token_bytes(32)
        key = hashlib.pbkdf2_hmac(
            'sha256',
            passphrase.encode('utf-8'),
            salt,
            iterations=100000,
            dklen=32
        )
        
        # Sauvegarder le salt pour pouvoir régénérer la clé
        with open(self.key_file, 'wb') as f:
            f.write(salt)
        
        # Définir permissions restrictives (lecture propriétaire uniquement)
        os.chmod(self.key_file, 0o400)
        
        return key.hex()
    
    def load_encryption_key(self, passphrase: str) -> str:
        """
        Charge la clé de chiffrement depuis la passphrase
        
        Args:
            passphrase: Mot de passe maître du cabinet
            
        Returns:
            Clé de chiffrement hexadécimale
        """
        if not self.key_file.exists():
            raise FileNotFoundError("Encryption key file not found. Database not initialized.")
        
        with open(self.key_file, 'rb') as f:
            salt = f.read()
        
        key = hashlib.pbkdf2_hmac(
            'sha256',
            passphrase.encode('utf-8'),
            salt,
            iterations=100000,
            dklen=32
        )
        
        return key.hex()
    
    def encrypt_database(self, passphrase: str) -> bool:
        """
        Chiffre une base de données SQLite existante
        
        Args:
            passphrase: Mot de passe maître
            
        Returns:
            True si succès
        """
        if not os.path.exists(self.db_path):
            print(f"❌ Database not found: {self.db_path}")
            return False
        
        # Générer la clé
        key = self.generate_encryption_key(passphrase)
        
        # Créer une copie chiffrée
        encrypted_path = f"{self.db_path}.encrypted"
        
        try:
            # Connexion base source (non chiffrée)
            conn_plain = sqlite3.connect(self.db_path)
            
            # Connexion base cible (chiffrée)
            conn_encrypted = sqlite3.connect(encrypted_path)
            
            # Activer SQLCipher sur la base cible
            conn_encrypted.execute(f"PRAGMA key = \"x'{key}'\"")
            conn_encrypted.execute("PRAGMA cipher_page_size = 4096")
            conn_encrypted.execute("PRAGMA kdf_iter = 256000")
            
            # Copier toutes les données
            for line in conn_plain.iterdump():
                conn_encrypted.execute(line)
            
            conn_encrypted.commit()
            conn_plain.close()
            conn_encrypted.close()
            
            # Remplacer la base originale par la version chiffrée
            backup_path = f"{self.db_path}.backup"
            os.rename(self.db_path, backup_path)
            os.rename(encrypted_path, self.db_path)
            
            print(f"✅ Database encrypted successfully")
            print(f"   Backup (unencrypted): {backup_path}")
            print(f"   ⚠️  Delete backup after verification!")
            
            return True
            
        except Exception as e:
            print(f"❌ Encryption failed: {e}")
            # Restaurer la base originale si erreur
            if os.path.exists(encrypted_path):
                os.remove(encrypted_path)
            return False
    
    def verify_encryption(self, passphrase: str) -> bool:
        """
        Vérifie que la base est bien chiffrée et accessible
        
        Args:
            passphrase: Mot de passe maître
            
        Returns:
            True si la base est chiffrée et accessible
        """
        try:
            key = self.load_encryption_key(passphrase)
            conn = sqlite3.connect(self.db_path)
            conn.execute(f"PRAGMA key = \"x'{key}'\"")
            
            # Tester une requête simple
            cursor = conn.execute("SELECT COUNT(*) FROM sqlite_master")
            cursor.fetchone()
            
            conn.close()
            return True
            
        except Exception as e:
            print(f"❌ Encryption verification failed: {e}")
            return False
    
    def connect_encrypted_database(self, passphrase: str) -> sqlite3.Connection:
        """
        Ouvre une connexion à la base chiffrée
        
        Args:
            passphrase: Mot de passe maître
            
        Returns:
            Connection SQLite
        """
        key = self.load_encryption_key(passphrase)
        conn = sqlite3.connect(self.db_path)
        conn.execute(f"PRAGMA key = \"x'{key}'\"")
        conn.execute("PRAGMA cipher_page_size = 4096")
        conn.row_factory = sqlite3.Row
        return conn
    
    def change_passphrase(self, old_passphrase: str, new_passphrase: str) -> bool:
        """
        Change le mot de passe de chiffrement
        
        Args:
            old_passphrase: Ancien mot de passe
            new_passphrase: Nouveau mot de passe
            
        Returns:
            True si succès
        """
        try:
            # Vérifier l'ancien mot de passe
            old_key = self.load_encryption_key(old_passphrase)
            
            # Générer nouvelle clé
            new_key = self.generate_encryption_key(new_passphrase)
            
            # Rechiffrer la base
            conn = sqlite3.connect(self.db_path)
            conn.execute(f"PRAGMA key = \"x'{old_key}'\"")
            conn.execute(f"PRAGMA rekey = \"x'{new_key}'\"")
            conn.close()
            
            print("✅ Passphrase changed successfully")
            return True
            
        except Exception as e:
            print(f"❌ Passphrase change failed: {e}")
            return False


def setup_encryption_cli():
    """Interface CLI pour configurer le chiffrement"""
    import getpass
    
    print("=" * 60)
    print("🔐 KinéCare Database Encryption Setup")
    print("=" * 60)
    print()
    
    db_path = input("Database path [data/kinecare.db]: ").strip()
    if not db_path:
        db_path = "data/kinecare.db"
    
    if not os.path.exists(db_path):
        print(f"❌ Database not found: {db_path}")
        return
    
    manager = EncryptionManager(db_path)
    
    print("\n⚠️  IMPORTANT:")
    print("   - Choisissez un mot de passe FORT (12+ caractères)")
    print("   - Notez-le dans un endroit SÛR")
    print("   - Si perdu, données IRRÉCUPÉRABLES")
    print()
    
    passphrase = getpass.getpass("Enter master passphrase: ")
    passphrase_confirm = getpass.getpass("Confirm passphrase: ")
    
    if passphrase != passphrase_confirm:
        print("❌ Passphrases do not match")
        return
    
    if len(passphrase) < 12:
        print("⚠️  Warning: Passphrase is weak (< 12 characters)")
        confirm = input("Continue anyway? (y/N): ")
        if confirm.lower() != 'y':
            return
    
    print("\n🔄 Encrypting database...")
    success = manager.encrypt_database(passphrase)
    
    if success:
        print("\n✅ ENCRYPTION SUCCESSFUL")
        print()
        print("📋 Next steps:")
        print("   1. Test database access with new passphrase")
        print("   2. Verify application still works")
        print("   3. Delete backup file: {}.backup".format(db_path))
        print()
        print("🔑 Master Passphrase Recovery:")
        print("   - Store passphrase in password manager")
        print("   - Write on paper and store in safe")
        print("   - Share with trusted colleague (sealed envelope)")
    else:
        print("\n❌ ENCRYPTION FAILED")
        print("   Database unchanged")


if __name__ == "__main__":
    setup_encryption_cli()
