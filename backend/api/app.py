"""
API REST Flask pour KinéCare
Backend local autonome et léger
"""
from flask import Flask, jsonify, request
from flask_cors import CORS
import os
import sys
from pathlib import Path

# Ajoute le répertoire parent au path pour les imports
sys.path.insert(0, str(Path(__file__).parent.parent))

from database.db_manager import get_db
from services.auth_service import AuthService
from services.pain_service import PainService
from services.stats_service import StatsService

# ============================================
# Configuration Flask
# ============================================
app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False  # Support UTF-8 pour le français
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'kinecare-local-dev-key-2024')

# Active CORS pour permettre l'accès depuis Flutter Web
CORS(app, resources={
    r"/api/*": {
        "origins": ["http://localhost:*", "http://127.0.0.1:*"],
        "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
        "allow_headers": ["Content-Type", "Authorization"]
    }
})

# ============================================
# Initialisation des services
# ============================================
db = get_db()
auth_service = AuthService(db)
pain_service = PainService(db)
stats_service = StatsService(db)


# ============================================
# Routes d'authentification
# ============================================

@app.route('/api/auth/login', methods=['POST'])
def login():
    """
    Connexion utilisateur
    Body: {"email": "...", "password": "..."}
    """
    try:
        data = request.get_json()
        email = data.get('email')
        password = data.get('password')
        
        if not email or not password:
            return jsonify({"error": "Email et mot de passe requis"}), 400
        
        result = auth_service.authenticate(email, password, request.remote_addr, request.headers.get('User-Agent'))
        
        if result['success']:
            return jsonify({
                "success": True,
                "token": result['token'],
                "user": result['user']
            }), 200
        else:
            return jsonify({"error": result['error']}), 401
    
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/api/auth/register', methods=['POST'])
def register():
    """
    Inscription nouvel utilisateur
    Body: {"email": "...", "password": "...", "firstName": "...", "lastName": "...", "role": "..."}
    """
    try:
        data = request.get_json()
        result = auth_service.register_user(data)
        
        if result['success']:
            return jsonify({
                "success": True,
                "user_id": result['user_id']
            }), 201
        else:
            return jsonify({"error": result['error']}), 400
    
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/api/auth/verify', methods=['GET'])
def verify_token():
    """Vérifie la validité d'un token JWT"""
    try:
        token = request.headers.get('Authorization', '').replace('Bearer ', '')
        
        if not token:
            return jsonify({"valid": False, "error": "Token manquant"}), 401
        
        result = auth_service.verify_token(token)
        
        if result['valid']:
            return jsonify({"valid": True, "user": result['user']}), 200
        else:
            return jsonify({"valid": False, "error": result['error']}), 401
    
    except Exception as e:
        return jsonify({"valid": False, "error": str(e)}), 500


# ============================================
# Routes des douleurs
# ============================================

@app.route('/api/pain/points/<patient_id>', methods=['GET'])
def get_pain_points(patient_id):
    """Récupère tous les points de douleur d'un patient"""
    try:
        points = pain_service.get_patient_pain_points(patient_id)
        return jsonify({"success": True, "pain_points": points}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/api/pain/points', methods=['POST'])
def create_pain_point():
    """
    Crée un nouveau point de douleur
    Body: {"patientId": "...", "zone": "...", "intensity": 0-10, "description": "..."}
    """
    try:
        token = request.headers.get('Authorization', '').replace('Bearer ', '')
        user = auth_service.verify_token(token)
        
        if not user['valid']:
            return jsonify({"error": "Non autorisé"}), 401
        
        data = request.get_json()
        result = pain_service.create_pain_point(
            pain_data=data,
            user_id=user['user']['id'],
            ip_address=request.remote_addr,
            user_agent=request.headers.get('User-Agent')
        )
        
        if result['success']:
            return jsonify(result), 201
        else:
            return jsonify({"error": result['error']}), 400
    
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/api/pain/history/<patient_id>', methods=['GET'])
def get_pain_history(patient_id):
    """
    Récupère l'historique des douleurs d'un patient
    Query params: start_date, end_date (format ISO)
    """
    try:
        start_date = request.args.get('start_date')
        end_date = request.args.get('end_date')
        
        history = pain_service.get_pain_history(patient_id, start_date, end_date)
        return jsonify({"success": True, "history": history}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/api/pain/evolution/<patient_id>', methods=['GET'])
def get_pain_evolution(patient_id):
    """
    Récupère les données d'évolution pour les graphiques
    Query params: start_date, end_date, period (7d, 30d, 3m, 6m, 1y)
    """
    try:
        start_date = request.args.get('start_date')
        end_date = request.args.get('end_date')
        period = request.args.get('period', '30d')
        
        evolution = pain_service.get_evolution_data(patient_id, start_date, end_date, period)
        return jsonify({"success": True, "evolution": evolution}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ============================================
# Routes des statistiques
# ============================================

@app.route('/api/stats/pathologies', methods=['GET'])
def get_pathology_stats():
    """
    Récupère les statistiques de temps de guérison par pathologie
    """
    try:
        stats = stats_service.get_pathology_healing_stats()
        return jsonify({"success": True, "stats": stats}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/api/stats/cabinet', methods=['GET'])
def get_cabinet_stats():
    """
    Statistiques globales du cabinet
    """
    try:
        stats = stats_service.get_cabinet_overview()
        return jsonify({"success": True, "stats": stats}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/api/stats/improvement/<patient_id>', methods=['GET'])
def get_patient_improvement(patient_id):
    """
    Calcule le taux d'amélioration d'un patient
    """
    try:
        improvement = stats_service.calculate_improvement_rate(patient_id)
        return jsonify({"success": True, "improvement": improvement}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ============================================
# Routes de santé (health checks)
# ============================================

@app.route('/api/health', methods=['GET'])
def health_check():
    """Vérification de santé du backend"""
    return jsonify({
        "status": "healthy",
        "service": "KinéCare Local Backend",
        "version": "1.0.0",
        "database": "connected"
    }), 200


@app.route('/api/info', methods=['GET'])
def app_info():
    """Informations sur l'application"""
    return jsonify({
        "app_name": "KinéCare",
        "version": "1.0.0",
        "description": "Application locale de suivi des douleurs",
        "storage": "SQLite local",
        "data_location": db.db_path,
        "compliance": "RGPD - Données 100% locales"
    }), 200


# ============================================
# Gestion des erreurs
# ============================================

@app.errorhandler(404)
def not_found(error):
    return jsonify({"error": "Endpoint non trouvé"}), 404


@app.errorhandler(500)
def internal_error(error):
    return jsonify({"error": "Erreur serveur interne"}), 500


# ============================================
# Point d'entrée principal
# ============================================

if __name__ == '__main__':
    print("=" * 60)
    print("🏥 KinéCare - Backend Local Démarré")
    print("=" * 60)
    print(f"📍 URL: http://localhost:8080")
    print(f"🗄️  Base de données: {db.db_path}")
    print(f"🔒 Données 100% locales - Aucune connexion Internet requise")
    print(f"📊 Statistiques temps guérison: Activées")
    print("=" * 60)
    print("")
    
    # Démarre le serveur Flask
    app.run(
        host='0.0.0.0',  # Accessible depuis le réseau local
        port=8080,
        debug=True,  # Mode développement avec rechargement automatique
        use_reloader=True
    )
