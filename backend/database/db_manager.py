"""
Gestionnaire de base de données SQLite local
Architecture simple et autonome
"""
import sqlite3
import os
import json
from datetime import datetime
from pathlib import Path
from typing import Optional, List, Dict, Any


class DatabaseManager:
    """Gestionnaire SQLite pour stockage local des données de santé"""
    
    def __init__(self, db_path: str = None):
        """
        Initialise la connexion à la base de données locale
        
        Args:
            db_path: Chemin vers le fichier SQLite (par défaut: ./data/kinecare.db)
        """
        if db_path is None:
            # Crée le dossier data dans le répertoire de l'application
            data_dir = Path(__file__).parent.parent / "data"
            data_dir.mkdir(exist_ok=True)
            db_path = str(data_dir / "kinecare.db")
        
        self.db_path = db_path
        self.connection: Optional[sqlite3.Connection] = None
        self._initialize_database()
    
    def _initialize_database(self):
        """Initialise la base de données avec le schéma"""
        # Crée la base si elle n'existe pas
        self.connection = sqlite3.connect(self.db_path, check_same_thread=False)
        self.connection.row_factory = sqlite3.Row  # Retourne des dictionnaires
        
        # Exécute le schéma SQL
        schema_path = Path(__file__).parent / "schema.sql"
        if schema_path.exists():
            with open(schema_path, 'r', encoding='utf-8') as f:
                schema_sql = f.read()
                self.connection.executescript(schema_sql)
                self.connection.commit()
                print(f"✅ Base de données initialisée : {self.db_path}")
        else:
            print(f"⚠️ Schéma SQL non trouvé : {schema_path}")
    
    def execute_query(self, query: str, params: tuple = ()) -> List[Dict[str, Any]]:
        """
        Exécute une requête SELECT et retourne les résultats
        
        Args:
            query: Requête SQL SELECT
            params: Paramètres de la requête
            
        Returns:
            Liste de dictionnaires représentant les lignes
        """
        cursor = self.connection.cursor()
        cursor.execute(query, params)
        rows = cursor.fetchall()
        return [dict(row) for row in rows]
    
    def execute_update(self, query: str, params: tuple = ()) -> int:
        """
        Exécute une requête INSERT/UPDATE/DELETE
        
        Args:
            query: Requête SQL de modification
            params: Paramètres de la requête
            
        Returns:
            Nombre de lignes affectées
        """
        cursor = self.connection.cursor()
        cursor.execute(query, params)
        self.connection.commit()
        return cursor.rowcount
    
    def execute_many(self, query: str, params_list: List[tuple]) -> int:
        """
        Exécute une requête INSERT en batch
        
        Args:
            query: Requête SQL INSERT
            params_list: Liste de tuples de paramètres
            
        Returns:
            Nombre de lignes affectées
        """
        cursor = self.connection.cursor()
        cursor.executemany(query, params_list)
        self.connection.commit()
        return cursor.rowcount
    
    # ============================================
    # Méthodes spécifiques métier
    # ============================================
    
    def create_user(self, user_data: Dict[str, Any]) -> str:
        """Crée un utilisateur et retourne son ID"""
        query = """
        INSERT INTO users (id, email, password_hash, first_name, last_name, role, phone)
        VALUES (?, ?, ?, ?, ?, ?, ?)
        """
        user_id = user_data['id']
        params = (
            user_id,
            user_data['email'],
            user_data['password_hash'],
            user_data['first_name'],
            user_data['last_name'],
            user_data['role'],
            user_data.get('phone')
        )
        self.execute_update(query, params)
        return user_id
    
    def get_user_by_email(self, email: str) -> Optional[Dict[str, Any]]:
        """Récupère un utilisateur par email"""
        query = "SELECT * FROM users WHERE email = ?"
        results = self.execute_query(query, (email,))
        return results[0] if results else None
    
    def create_pain_point(self, pain_data: Dict[str, Any]) -> str:
        """Crée un point de douleur"""
        query = """
        INSERT INTO pain_points (id, patient_id, zone, intensity, description)
        VALUES (?, ?, ?, ?, ?)
        """
        pain_id = pain_data['id']
        params = (
            pain_id,
            pain_data['patient_id'],
            pain_data['zone'],
            pain_data['intensity'],
            pain_data.get('description')
        )
        self.execute_update(query, params)
        return pain_id
    
    def get_patient_pain_points(self, patient_id: str) -> List[Dict[str, Any]]:
        """Récupère tous les points de douleur d'un patient"""
        query = """
        SELECT * FROM pain_points 
        WHERE patient_id = ? 
        ORDER BY created_at DESC
        """
        return self.execute_query(query, (patient_id,))
    
    def get_pain_history(self, patient_id: str, start_date: str = None, end_date: str = None) -> List[Dict[str, Any]]:
        """
        Récupère l'historique des douleurs d'un patient
        
        Args:
            patient_id: ID du patient
            start_date: Date de début (format ISO)
            end_date: Date de fin (format ISO)
        """
        query = """
        SELECT * FROM pain_history 
        WHERE patient_id = ?
        """
        params = [patient_id]
        
        if start_date:
            query += " AND timestamp >= ?"
            params.append(start_date)
        
        if end_date:
            query += " AND timestamp <= ?"
            params.append(end_date)
        
        query += " ORDER BY timestamp ASC"
        
        results = self.execute_query(query, tuple(params))
        
        # Parse le JSON zone_intensities
        for row in results:
            if row['zone_intensities']:
                row['zone_intensities'] = json.loads(row['zone_intensities'])
        
        return results
    
    def create_audit_log(self, log_data: Dict[str, Any]):
        """Crée un log d'audit pour la traçabilité RGPD"""
        query = """
        INSERT INTO audit_logs (
            id, user_id, action_type, target_type, target_id,
            old_values, new_values, ip_address, user_agent
        )
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        """
        params = (
            log_data['id'],
            log_data['user_id'],
            log_data['action_type'],
            log_data['target_type'],
            log_data.get('target_id'),
            json.dumps(log_data.get('old_values')) if log_data.get('old_values') else None,
            json.dumps(log_data.get('new_values')) if log_data.get('new_values') else None,
            log_data.get('ip_address'),
            log_data.get('user_agent')
        )
        self.execute_update(query, params)
    
    def get_pathology_stats(self) -> List[Dict[str, Any]]:
        """
        Récupère les statistiques de temps de guérison par pathologie
        Utilise la vue v_pathology_healing_times
        """
        query = """
        SELECT 
            pathology_name,
            total_cases,
            ROUND(avg_healing_days, 1) as avg_healing_days,
            ROUND(min_healing_days, 1) as min_healing_days,
            ROUND(max_healing_days, 1) as max_healing_days
        FROM v_pathology_healing_times
        ORDER BY total_cases DESC
        """
        return self.execute_query(query)
    
    def update_pathology_status(self, pathology_id: str, status: str, resolution_date: str = None):
        """
        Met à jour le statut d'une pathologie
        
        Args:
            pathology_id: ID de la pathologie
            status: Nouveau statut (active, in_treatment, resolved)
            resolution_date: Date de résolution si status = resolved
        """
        query = """
        UPDATE pathologies 
        SET status = ?, resolution_date = ?
        WHERE id = ?
        """
        params = (status, resolution_date, pathology_id)
        self.execute_update(query, params)
        
        # Recalcule les statistiques si pathologie résolue
        if status == 'resolved':
            self._update_pathology_cache()
    
    def _update_pathology_cache(self):
        """Met à jour le cache des statistiques de pathologies"""
        query = """
        INSERT OR REPLACE INTO pathology_stats (
            id, pathology_name, total_cases, active_cases, resolved_cases,
            average_healing_days, median_initial_intensity, median_final_intensity,
            last_updated
        )
        SELECT
            'stat_' || pathology_name,
            pathology_name,
            COUNT(*) as total_cases,
            SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END) as active_cases,
            SUM(CASE WHEN status = 'resolved' THEN 1 ELSE 0 END) as resolved_cases,
            AVG(CASE 
                WHEN status = 'resolved' AND diagnosis_date IS NOT NULL AND resolution_date IS NOT NULL
                THEN JULIANDAY(resolution_date) - JULIANDAY(diagnosis_date)
                ELSE NULL
            END) as average_healing_days,
            NULL as median_initial_intensity,
            NULL as median_final_intensity,
            CURRENT_TIMESTAMP
        FROM pathologies
        GROUP BY pathology_name
        """
        self.execute_update(query)
    
    def get_cached_pathology_stats(self) -> List[Dict[str, Any]]:
        """Récupère les statistiques depuis le cache"""
        query = """
        SELECT * FROM pathology_stats 
        ORDER BY total_cases DESC
        """
        return self.execute_query(query)
    
    def close(self):
        """Ferme la connexion à la base de données"""
        if self.connection:
            self.connection.close()
            print("🔒 Connexion base de données fermée")


# ============================================
# Instance globale singleton
# ============================================
_db_instance: Optional[DatabaseManager] = None

def get_db() -> DatabaseManager:
    """Retourne l'instance singleton du gestionnaire de base de données"""
    global _db_instance
    if _db_instance is None:
        _db_instance = DatabaseManager()
    return _db_instance
