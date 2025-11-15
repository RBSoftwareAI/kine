"""
Service d'authentification avec JWT
Gestion sécurisée des utilisateurs
"""
import jwt
import bcrypt
import uuid
from datetime import datetime, timedelta
from typing import Dict, Any, Optional


class AuthService:
    """Service d'authentification et gestion des utilisateurs"""
    
    def __init__(self, db_manager, secret_key: str = 'kinecare-jwt-secret-2024'):
        self.db = db_manager
        self.secret_key = secret_key
        self.algorithm = 'HS256'
        self.token_expiration_hours = 24
    
    def hash_password(self, password: str) -> str:
        """Hash un mot de passe avec bcrypt"""
        salt = bcrypt.gensalt()
        hashed = bcrypt.hashpw(password.encode('utf-8'), salt)
        return hashed.decode('utf-8')
    
    def verify_password(self, password: str, hashed: str) -> bool:
        """Vérifie un mot de passe contre son hash"""
        return bcrypt.checkpw(password.encode('utf-8'), hashed.encode('utf-8'))
    
    def generate_token(self, user_data: Dict[str, Any]) -> str:
        """
        Génère un token JWT pour l'utilisateur
        
        Args:
            user_data: Données utilisateur (id, email, role)
            
        Returns:
            Token JWT signé
        """
        payload = {
            'user_id': user_data['id'],
            'email': user_data['email'],
            'role': user_data['role'],
            'exp': datetime.utcnow() + timedelta(hours=self.token_expiration_hours),
            'iat': datetime.utcnow()
        }
        token = jwt.encode(payload, self.secret_key, algorithm=self.algorithm)
        return token
    
    def verify_token(self, token: str) -> Dict[str, Any]:
        """
        Vérifie et décode un token JWT
        
        Args:
            token: Token JWT à vérifier
            
        Returns:
            Dict avec 'valid' (bool) et 'user' ou 'error'
        """
        try:
            payload = jwt.decode(token, self.secret_key, algorithms=[self.algorithm])
            return {
                'valid': True,
                'user': {
                    'id': payload['user_id'],
                    'email': payload['email'],
                    'role': payload['role']
                }
            }
        except jwt.ExpiredSignatureError:
            return {'valid': False, 'error': 'Token expiré'}
        except jwt.InvalidTokenError:
            return {'valid': False, 'error': 'Token invalide'}
    
    def authenticate(self, email: str, password: str, ip_address: str = None, user_agent: str = None) -> Dict[str, Any]:
        """
        Authentifie un utilisateur
        
        Args:
            email: Email de l'utilisateur
            password: Mot de passe en clair
            ip_address: Adresse IP (pour audit log)
            user_agent: User agent (pour audit log)
            
        Returns:
            Dict avec 'success', 'token', 'user' ou 'error'
        """
        # Récupère l'utilisateur
        user = self.db.get_user_by_email(email)
        
        if not user:
            return {'success': False, 'error': 'Email ou mot de passe incorrect'}
        
        # Vérifie le mot de passe
        if not self.verify_password(password, user['password_hash']):
            return {'success': False, 'error': 'Email ou mot de passe incorrect'}
        
        # Génère le token
        token = self.generate_token(user)
        
        # Crée un log d'audit
        self.db.create_audit_log({
            'id': f'log_{uuid.uuid4().hex}',
            'user_id': user['id'],
            'action_type': 'login',
            'target_type': 'system',
            'target_id': None,
            'old_values': None,
            'new_values': {'login_time': datetime.utcnow().isoformat()},
            'ip_address': ip_address,
            'user_agent': user_agent
        })
        
        # Retourne les données sans le hash du mot de passe
        user_safe = {
            'id': user['id'],
            'email': user['email'],
            'firstName': user['first_name'],
            'lastName': user['last_name'],
            'role': user['role'],
            'phone': user['phone']
        }
        
        return {
            'success': True,
            'token': token,
            'user': user_safe
        }
    
    def register_user(self, user_data: Dict[str, Any]) -> Dict[str, Any]:
        """
        Enregistre un nouvel utilisateur
        
        Args:
            user_data: Données utilisateur (email, password, firstName, lastName, role)
            
        Returns:
            Dict avec 'success', 'user_id' ou 'error'
        """
        email = user_data.get('email')
        password = user_data.get('password')
        first_name = user_data.get('firstName')
        last_name = user_data.get('lastName')
        role = user_data.get('role', 'patient')
        phone = user_data.get('phone')
        
        # Validation
        if not email or not password:
            return {'success': False, 'error': 'Email et mot de passe requis'}
        
        if not first_name or not last_name:
            return {'success': False, 'error': 'Prénom et nom requis'}
        
        if role not in ['patient', 'kine', 'coach', 'admin']:
            return {'success': False, 'error': 'Rôle invalide'}
        
        # Vérifie si l'email existe déjà
        existing_user = self.db.get_user_by_email(email)
        if existing_user:
            return {'success': False, 'error': 'Cet email est déjà utilisé'}
        
        # Hash le mot de passe
        password_hash = self.hash_password(password)
        
        # Crée l'utilisateur
        user_id = f'user_{uuid.uuid4().hex}'
        
        try:
            self.db.create_user({
                'id': user_id,
                'email': email,
                'password_hash': password_hash,
                'first_name': first_name,
                'last_name': last_name,
                'role': role,
                'phone': phone
            })
            
            # Si c'est un patient, crée aussi l'entrée patient
            if role == 'patient':
                patient_id = f'patient_{uuid.uuid4().hex}'
                query = """
                INSERT INTO patients (id, user_id, birth_year, gender)
                VALUES (?, ?, ?, ?)
                """
                self.db.execute_update(query, (
                    patient_id,
                    user_id,
                    user_data.get('birthYear'),
                    user_data.get('gender')
                ))
            
            return {'success': True, 'user_id': user_id}
        
        except Exception as e:
            return {'success': False, 'error': f'Erreur lors de la création: {str(e)}'}
    
    def create_demo_accounts(self):
        """
        Crée les comptes demo pour les tests
        Utilisé lors de la première initialisation
        """
        demo_accounts = [
            {
                'email': 'patient@demo.com',
                'password': 'patient123',
                'firstName': 'Jean',
                'lastName': 'Patient',
                'role': 'patient',
                'birthYear': 1985,
                'gender': 'M'
            },
            {
                'email': 'kine@demo.com',
                'password': 'kine123',
                'firstName': 'Marie',
                'lastName': 'Kiné',
                'role': 'kine',
                'phone': '06 12 34 56 78'
            },
            {
                'email': 'coach@demo.com',
                'password': 'coach123',
                'firstName': 'Pierre',
                'lastName': 'Coach',
                'role': 'coach',
                'phone': '06 98 76 54 32'
            }
        ]
        
        created_count = 0
        for account_data in demo_accounts:
            # Vérifie si le compte existe déjà
            existing = self.db.get_user_by_email(account_data['email'])
            if not existing:
                result = self.register_user(account_data)
                if result['success']:
                    created_count += 1
                    print(f"✅ Compte demo créé: {account_data['email']}")
        
        if created_count > 0:
            print(f"📝 {created_count} comptes demo créés")
        else:
            print("ℹ️  Les comptes demo existent déjà")
