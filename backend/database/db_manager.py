"""
KinéCare Local Database Manager
Handles SQLite connection and operations
"""
import sqlite3
import os
from pathlib import Path
from typing import Optional, List, Dict, Any
from datetime import datetime
import json


class DatabaseManager:
    """Manages SQLite database connection and operations"""
    
    def __init__(self, db_path: Optional[str] = None):
        """
        Initialize database manager
        
        Args:
            db_path: Path to SQLite database file. If None, uses default location.
        """
        if db_path is None:
            # Default: data folder next to backend
            app_dir = Path(__file__).parent.parent.parent
            data_dir = app_dir / 'data'
            data_dir.mkdir(exist_ok=True)
            db_path = str(data_dir / 'medidesk.db')
        
        self.db_path = db_path
        self.connection: Optional[sqlite3.Connection] = None
        
    def connect(self):
        """Establish database connection"""
        if self.connection is None:
            self.connection = sqlite3.connect(
                self.db_path,
                check_same_thread=False,  # Allow multi-threaded access
                timeout=10.0  # Wait up to 10s for locks
            )
            # Enable foreign keys
            self.connection.execute("PRAGMA foreign_keys = ON")
            # Use Row factory for dict-like access
            self.connection.row_factory = sqlite3.Row
            
    def disconnect(self):
        """Close database connection"""
        if self.connection:
            self.connection.close()
            self.connection = None
    
    def initialize_schema(self):
        """Create database schema from schema.sql file"""
        schema_path = Path(__file__).parent / 'schema.sql'
        
        if not schema_path.exists():
            raise FileNotFoundError(f"Schema file not found: {schema_path}")
        
        with open(schema_path, 'r', encoding='utf-8') as f:
            schema_sql = f.read()
        
        self.connect()
        
        # Execute schema (split by semicolon for multiple statements)
        try:
            self.connection.executescript(schema_sql)
            self.connection.commit()
            print(f"✅ Database schema initialized: {self.db_path}")
        except sqlite3.Error as e:
            print(f"❌ Error initializing schema: {e}")
            raise
    
    def execute(self, query: str, params: tuple = ()) -> sqlite3.Cursor:
        """
        Execute a SQL query
        
        Args:
            query: SQL query string
            params: Query parameters (tuple)
            
        Returns:
            Cursor object
        """
        self.connect()
        try:
            cursor = self.connection.cursor()
            cursor.execute(query, params)
            return cursor
        except sqlite3.Error as e:
            print(f"❌ SQL Error: {e}")
            print(f"   Query: {query}")
            print(f"   Params: {params}")
            raise
    
    def execute_many(self, query: str, params_list: List[tuple]) -> int:
        """
        Execute a SQL query multiple times with different parameters
        
        Args:
            query: SQL query string
            params_list: List of parameter tuples
            
        Returns:
            Number of rows affected
        """
        self.connect()
        try:
            cursor = self.connection.cursor()
            cursor.executemany(query, params_list)
            self.connection.commit()
            return cursor.rowcount
        except sqlite3.Error as e:
            print(f"❌ SQL Error (executemany): {e}")
            raise
    
    def fetch_one(self, query: str, params: tuple = ()) -> Optional[Dict[str, Any]]:
        """
        Fetch a single row as dictionary
        
        Args:
            query: SQL query string
            params: Query parameters
            
        Returns:
            Dictionary of column:value or None
        """
        cursor = self.execute(query, params)
        row = cursor.fetchone()
        return dict(row) if row else None
    
    def fetch_all(self, query: str, params: tuple = ()) -> List[Dict[str, Any]]:
        """
        Fetch all rows as list of dictionaries
        
        Args:
            query: SQL query string
            params: Query parameters
            
        Returns:
            List of dictionaries
        """
        cursor = self.execute(query, params)
        rows = cursor.fetchall()
        return [dict(row) for row in rows]
    
    def insert(self, table: str, data: Dict[str, Any]) -> str:
        """
        Insert a row into a table
        
        Args:
            table: Table name
            data: Dictionary of column:value
            
        Returns:
            Inserted row ID
        """
        columns = ', '.join(data.keys())
        placeholders = ', '.join(['?' for _ in data])
        query = f"INSERT INTO {table} ({columns}) VALUES ({placeholders})"
        
        cursor = self.execute(query, tuple(data.values()))
        self.connection.commit()
        
        return cursor.lastrowid
    
    def update(self, table: str, data: Dict[str, Any], where: str, where_params: tuple = ()) -> int:
        """
        Update rows in a table
        
        Args:
            table: Table name
            data: Dictionary of column:value to update
            where: WHERE clause (without 'WHERE' keyword)
            where_params: Parameters for WHERE clause
            
        Returns:
            Number of rows affected
        """
        set_clause = ', '.join([f"{col} = ?" for col in data.keys()])
        query = f"UPDATE {table} SET {set_clause} WHERE {where}"
        
        params = tuple(data.values()) + where_params
        cursor = self.execute(query, params)
        self.connection.commit()
        
        return cursor.rowcount
    
    def delete(self, table: str, where: str, where_params: tuple = ()) -> int:
        """
        Delete rows from a table
        
        Args:
            table: Table name
            where: WHERE clause (without 'WHERE' keyword)
            where_params: Parameters for WHERE clause
            
        Returns:
            Number of rows affected
        """
        query = f"DELETE FROM {table} WHERE {where}"
        
        cursor = self.execute(query, where_params)
        self.connection.commit()
        
        return cursor.rowcount
    
    def get_user_by_email(self, email: str) -> Optional[Dict[str, Any]]:
        """Get user by email"""
        return self.fetch_one(
            "SELECT * FROM users WHERE email = ? AND is_active = 1",
            (email,)
        )
    
    def get_user_by_id(self, user_id: str) -> Optional[Dict[str, Any]]:
        """Get user by ID"""
        return self.fetch_one(
            "SELECT * FROM users WHERE id = ? AND is_active = 1",
            (user_id,)
        )
    
    def create_audit_log(
        self, 
        user_id: str, 
        action_type: str, 
        entity_type: Optional[str] = None,
        entity_id: Optional[str] = None,
        old_values: Optional[Dict] = None,
        new_values: Optional[Dict] = None,
        reason: Optional[str] = None,
        ip_address: Optional[str] = None,
        user_agent: Optional[str] = None
    ) -> str:
        """
        Create an audit log entry
        
        Args:
            user_id: User who performed the action
            action_type: Type of action (see schema for valid values)
            entity_type: Type of entity affected
            entity_id: ID of entity affected
            old_values: Values before modification (dict -> JSON)
            new_values: Values after modification (dict -> JSON)
            reason: Reason for action
            ip_address: IP address of request
            user_agent: User agent of request
            
        Returns:
            Audit log ID
        """
        import uuid
        
        log_id = f"audit_{uuid.uuid4().hex[:12]}"
        
        data = {
            'id': log_id,
            'user_id': user_id,
            'action_type': action_type,
            'entity_type': entity_type,
            'entity_id': entity_id,
            'timestamp': datetime.utcnow().isoformat(),
            'ip_address': ip_address,
            'user_agent': user_agent,
            'old_values': json.dumps(old_values) if old_values else None,
            'new_values': json.dumps(new_values) if new_values else None,
            'reason': reason
        }
        
        self.insert('audit_logs', data)
        return log_id
    
    def get_realtime_stats(self) -> Dict[str, Any]:
        """Get real-time statistics from view"""
        return self.fetch_one("SELECT * FROM v_realtime_stats") or {}
    
    def get_patients_with_latest_pain(self) -> List[Dict[str, Any]]:
        """Get all patients with their latest pain data"""
        return self.fetch_all("SELECT * FROM v_patients_latest_pain ORDER BY last_pain_date DESC")
    
    def backup_database(self, backup_path: Optional[str] = None) -> str:
        """
        Create a backup of the database
        
        Args:
            backup_path: Path for backup file. If None, auto-generates.
            
        Returns:
            Path to backup file
        """
        if backup_path is None:
            backup_dir = Path(self.db_path).parent / 'backups'
            backup_dir.mkdir(exist_ok=True)
            timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
            backup_path = str(backup_dir / f'medidesk_backup_{timestamp}.db')
        
        self.connect()
        
        # Use SQLite backup API
        backup_conn = sqlite3.connect(backup_path)
        try:
            self.connection.backup(backup_conn)
            backup_conn.close()
            print(f"✅ Database backed up to: {backup_path}")
            return backup_path
        except sqlite3.Error as e:
            print(f"❌ Backup failed: {e}")
            raise
    
    def vacuum(self):
        """Optimize database (reclaim space, rebuild indexes)"""
        self.connect()
        self.connection.execute("VACUUM")
        self.connection.commit()
        print("✅ Database optimized")
    
    def get_database_info(self) -> Dict[str, Any]:
        """Get database information"""
        self.connect()
        
        # Get file size
        db_size = os.path.getsize(self.db_path)
        
        # Get table counts
        tables = self.fetch_all(
            "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"
        )
        
        table_counts = {}
        for table in tables:
            table_name = table['name']
            count = self.fetch_one(f"SELECT COUNT(*) as count FROM {table_name}")
            table_counts[table_name] = count['count'] if count else 0
        
        # Get version
        version = self.fetch_one("PRAGMA user_version")
        
        return {
            'db_path': self.db_path,
            'db_size_bytes': db_size,
            'db_size_mb': round(db_size / 1024 / 1024, 2),
            'schema_version': version['user_version'] if version else 0,
            'table_counts': table_counts,
            'total_records': sum(table_counts.values())
        }


# Global database instance
_db_instance: Optional[DatabaseManager] = None

def get_db() -> DatabaseManager:
    """Get global database instance (singleton pattern)"""
    global _db_instance
    if _db_instance is None:
        _db_instance = DatabaseManager()
        _db_instance.initialize_schema()
    return _db_instance


# Standalone testing
if __name__ == "__main__":
    print("🧪 Testing DatabaseManager...")
    
    # Create test database
    test_db = DatabaseManager('test_medidesk.db')
    test_db.initialize_schema()
    
    # Get info
    info = test_db.get_database_info()
    print("\n📊 Database Info:")
    for key, value in info.items():
        print(f"   {key}: {value}")
    
    # Test queries
    print("\n👥 Users:")
    users = test_db.fetch_all("SELECT id, email, role FROM users")
    for user in users:
        print(f"   - {user['email']} ({user['role']})")
    
    # Test stats
    print("\n📈 Real-time Stats:")
    stats = test_db.get_realtime_stats()
    for key, value in stats.items():
        print(f"   {key}: {value}")
    
    print("\n✅ All tests passed!")
