"""
KinéCare Local API Server
Flask REST API pour données locales
"""
from flask import Flask, jsonify, request, send_from_directory
from flask_cors import CORS
from flask_jwt_extended import (
    JWTManager, create_access_token, jwt_required, get_jwt_identity
)
from werkzeug.security import check_password_hash, generate_password_hash
from datetime import datetime, timedelta
import os
import sys
from pathlib import Path

# Add parent directory to path for imports
sys.path.insert(0, str(Path(__file__).parent.parent))

from database.db_manager import get_db
from services.statistics_service import StatisticsService

# Initialize Flask app
app = Flask(__name__, static_folder='../../../build/web')
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'medidesk-local-secret-change-in-production')
app.config['JWT_SECRET_KEY'] = os.environ.get('JWT_SECRET_KEY', 'jwt-secret-key-change-in-production')
app.config['JWT_ACCESS_TOKEN_EXPIRES'] = timedelta(hours=24)

# Enable CORS for Flutter Web
CORS(app, resources={
    r"/api/*": {
        "origins": "*",  # Local network access
        "methods": ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
        "allow_headers": ["Content-Type", "Authorization"]
    }
})

# Initialize JWT
jwt = JWTManager(app)

# Initialize database
db = get_db()
stats_service = StatisticsService(db)


# ============================================
# HEALTH CHECK ENDPOINT (for Docker/monitoring)
# ============================================

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint for Docker healthcheck and monitoring"""
    try:
        # Vérifier que la base de données est accessible
        info = db.get_database_info()
        return jsonify({
            'status': 'healthy',
            'timestamp': datetime.utcnow().isoformat(),
            'database': {
                'connected': True,
                'total_records': info.get('total_records', 0)
            }
        }), 200
    except Exception as e:
        return jsonify({
            'status': 'unhealthy',
            'timestamp': datetime.utcnow().isoformat(),
            'error': str(e)
        }), 503


# ============================================
# AUTHENTICATION ENDPOINTS
# ============================================

@app.route('/api/auth/login', methods=['POST'])
def login():
    """Login endpoint"""
    data = request.get_json()
    
    if not data or not data.get('email') or not data.get('password'):
        return jsonify({'error': 'Email and password required'}), 400
    
    email = data['email']
    password = data['password']
    
    # Get user from database
    user = db.get_user_by_email(email)
    
    if not user:
        return jsonify({'error': 'Invalid credentials'}), 401
    
    # Verify password
    if not check_password_hash(user['password_hash'], password):
        return jsonify({'error': 'Invalid credentials'}), 401
    
    # Create access token
    access_token = create_access_token(identity=user['id'])
    
    # Update last login
    db.update('users', {'last_login': datetime.utcnow().isoformat()}, 'id = ?', (user['id'],))
    
    # Create audit log
    db.create_audit_log(
        user_id=user['id'],
        action_type='login',
        ip_address=request.remote_addr,
        user_agent=request.headers.get('User-Agent')
    )
    
    # Return user data (without password)
    user_data = {k: v for k, v in user.items() if k != 'password_hash'}
    
    return jsonify({
        'user': user_data,
        'access_token': access_token
    }), 200


@app.route('/api/auth/me', methods=['GET'])
@jwt_required()
def get_current_user():
    """Get current user from JWT token"""
    current_user_id = get_jwt_identity()
    user = db.get_user_by_id(current_user_id)
    
    if not user:
        return jsonify({'error': 'User not found'}), 404
    
    # Return user data (without password)
    user_data = {k: v for k, v in user.items() if k != 'password_hash'}
    return jsonify(user_data), 200


# ============================================
# USER MANAGEMENT ENDPOINTS
# ============================================

@app.route('/api/users', methods=['GET'])
@jwt_required()
def get_users():
    """Get all users (filtered by role if specified)"""
    role = request.args.get('role')
    
    if role:
        users = db.fetch_all("SELECT * FROM users WHERE role = ? AND is_active = 1", (role,))
    else:
        users = db.fetch_all("SELECT * FROM users WHERE is_active = 1")
    
    # Remove passwords
    users_data = [{k: v for k, v in user.items() if k != 'password_hash'} for user in users]
    
    return jsonify(users_data), 200


@app.route('/api/users/<user_id>', methods=['GET'])
@jwt_required()
def get_user(user_id):
    """Get specific user"""
    user = db.get_user_by_id(user_id)
    
    if not user:
        return jsonify({'error': 'User not found'}), 404
    
    # Remove password
    user_data = {k: v for k, v in user.items() if k != 'password_hash'}
    return jsonify(user_data), 200


@app.route('/api/users', methods=['POST'])
@jwt_required()
def create_user():
    """Create new user"""
    current_user_id = get_jwt_identity()
    data = request.get_json()
    
    # Validate required fields
    required = ['email', 'password', 'first_name', 'last_name', 'role']
    if not all(field in data for field in required):
        return jsonify({'error': f'Missing required fields: {required}'}), 400
    
    # Check if email already exists
    existing = db.get_user_by_email(data['email'])
    if existing:
        return jsonify({'error': 'Email already exists'}), 409
    
    # Generate user ID
    import uuid
    user_id = f"user_{uuid.uuid4().hex[:12]}"
    
    # Hash password
    password_hash = generate_password_hash(data['password'])
    
    # Prepare user data
    user_data = {
        'id': user_id,
        'email': data['email'],
        'password_hash': password_hash,
        'first_name': data['first_name'],
        'last_name': data['last_name'],
        'role': data['role'],
        'phone': data.get('phone'),
        'birth_date': data.get('birth_date'),
        'created_at': datetime.utcnow().isoformat(),
        'updated_at': datetime.utcnow().isoformat(),
        'is_active': 1
    }
    
    # Insert user
    db.insert('users', user_data)
    
    # Create audit log
    db.create_audit_log(
        user_id=current_user_id,
        action_type='create_patient' if data['role'] == 'patient' else 'create_user',
        entity_type='user',
        entity_id=user_id,
        new_values={'email': data['email'], 'role': data['role']},
        ip_address=request.remote_addr
    )
    
    # Return created user (without password)
    created_user = db.get_user_by_id(user_id)
    user_response = {k: v for k, v in created_user.items() if k != 'password_hash'}
    
    return jsonify(user_response), 201


# ============================================
# PAIN POINTS ENDPOINTS
# ============================================

@app.route('/api/pain-points', methods=['GET'])
@jwt_required()
def get_pain_points():
    """Get pain points (filtered by patient_id if specified)"""
    patient_id = request.args.get('patient_id')
    
    if patient_id:
        query = """
        SELECT pp.*, u.first_name || ' ' || u.last_name as patient_name
        FROM pain_points pp
        JOIN users u ON pp.patient_id = u.id
        WHERE pp.patient_id = ?
        ORDER BY pp.timestamp DESC
        """
        points = db.fetch_all(query, (patient_id,))
    else:
        query = """
        SELECT pp.*, u.first_name || ' ' || u.last_name as patient_name
        FROM pain_points pp
        JOIN users u ON pp.patient_id = u.id
        ORDER BY pp.timestamp DESC
        LIMIT 100
        """
        points = db.fetch_all(query)
    
    return jsonify(points), 200


@app.route('/api/pain-points', methods=['POST'])
@jwt_required()
def create_pain_point():
    """Create new pain point"""
    current_user_id = get_jwt_identity()
    data = request.get_json()
    
    # Validate required fields
    required = ['patient_id', 'zone', 'intensity']
    if not all(field in data for field in required):
        return jsonify({'error': f'Missing required fields: {required}'}), 400
    
    # Generate pain point ID
    import uuid
    point_id = f"pain_{uuid.uuid4().hex[:12]}"
    
    # Prepare data
    point_data = {
        'id': point_id,
        'patient_id': data['patient_id'],
        'professional_id': current_user_id,
        'zone': data['zone'],
        'intensity': data['intensity'],
        'timestamp': data.get('timestamp', datetime.utcnow().isoformat()),
        'session_id': data.get('session_id'),
        'is_before_session': data.get('is_before_session', 0),
        'notes': data.get('notes')
    }
    
    # Insert pain point
    db.insert('pain_points', point_data)
    
    # Create audit log
    db.create_audit_log(
        user_id=current_user_id,
        action_type='create_pain_point',
        entity_type='pain_point',
        entity_id=point_id,
        new_values={'zone': data['zone'], 'intensity': data['intensity']},
        ip_address=request.remote_addr
    )
    
    return jsonify(point_data), 201


# ============================================
# SESSIONS ENDPOINTS
# ============================================

@app.route('/api/sessions', methods=['GET'])
@jwt_required()
def get_sessions():
    """Get sessions (filtered by patient_id if specified)"""
    patient_id = request.args.get('patient_id')
    
    if patient_id:
        sessions = db.fetch_all(
            "SELECT * FROM v_sessions_with_improvement WHERE patient_id = ? ORDER BY date DESC",
            (patient_id,)
        )
    else:
        sessions = db.fetch_all(
            "SELECT * FROM v_sessions_with_improvement ORDER BY date DESC LIMIT 50"
        )
    
    return jsonify(sessions), 200


@app.route('/api/sessions', methods=['POST'])
@jwt_required()
def create_session():
    """Create new session"""
    current_user_id = get_jwt_identity()
    data = request.get_json()
    
    # Validate required fields
    required = ['patient_id', 'session_type']
    if not all(field in data for field in required):
        return jsonify({'error': f'Missing required fields: {required}'}), 400
    
    # Generate session ID
    import uuid
    session_id = f"session_{uuid.uuid4().hex[:12]}"
    
    # Prepare data
    session_data = {
        'id': session_id,
        'patient_id': data['patient_id'],
        'professional_id': current_user_id,
        'session_type': data['session_type'],
        'date': data.get('date', datetime.utcnow().isoformat()),
        'duration_minutes': data.get('duration_minutes'),
        'treatment_notes': data.get('treatment_notes'),
        'status': data.get('status', 'completed')
    }
    
    # Insert session
    db.insert('pain_sessions', session_data)
    
    # Create audit log
    db.create_audit_log(
        user_id=current_user_id,
        action_type='create_session',
        entity_type='session',
        entity_id=session_id,
        new_values={'session_type': data['session_type']},
        ip_address=request.remote_addr
    )
    
    return jsonify(session_data), 201


# ============================================
# STATISTICS ENDPOINTS
# ============================================

@app.route('/api/stats/realtime', methods=['GET'])
@jwt_required()
def get_realtime_stats():
    """Get real-time statistics"""
    stats = db.get_realtime_stats()
    return jsonify(stats), 200


@app.route('/api/stats/pathologies', methods=['GET'])
@jwt_required()
def get_pathology_stats():
    """Get pathology statistics"""
    pathology_code = request.args.get('code')
    
    stats = stats_service.get_latest_pathology_stats(pathology_code)
    return jsonify(stats), 200


@app.route('/api/stats/pathologies/calculate', methods=['POST'])
@jwt_required()
def calculate_pathology_stats():
    """Calculate and save pathology statistics"""
    all_stats = stats_service.calculate_all_pathologies()
    
    return jsonify({
        'calculated': len(all_stats),
        'stats': all_stats
    }), 200


@app.route('/api/stats/patients', methods=['GET'])
@jwt_required()
def get_patients_stats():
    """Get patients with latest pain data"""
    patients = db.get_patients_with_latest_pain()
    return jsonify(patients), 200


# ============================================
# AUDIT LOG ENDPOINTS
# ============================================

@app.route('/api/audit-logs', methods=['GET'])
@jwt_required()
def get_audit_logs():
    """Get audit logs (filtered by user_id or entity_id if specified)"""
    user_id = request.args.get('user_id')
    entity_id = request.args.get('entity_id')
    limit = request.args.get('limit', 100, type=int)
    
    if user_id:
        logs = db.fetch_all(
            "SELECT * FROM audit_logs WHERE user_id = ? ORDER BY timestamp DESC LIMIT ?",
            (user_id, limit)
        )
    elif entity_id:
        logs = db.fetch_all(
            "SELECT * FROM audit_logs WHERE entity_id = ? ORDER BY timestamp DESC LIMIT ?",
            (entity_id, limit)
        )
    else:
        logs = db.fetch_all(
            f"SELECT * FROM audit_logs ORDER BY timestamp DESC LIMIT ?",
            (limit,)
        )
    
    return jsonify(logs), 200


# ============================================
# DATABASE MANAGEMENT ENDPOINTS
# ============================================

@app.route('/api/db/info', methods=['GET'])
@jwt_required()
def get_db_info():
    """Get database information"""
    info = db.get_database_info()
    return jsonify(info), 200


@app.route('/api/db/backup', methods=['POST'])
@jwt_required()
def create_backup():
    """Create database backup"""
    try:
        backup_path = db.backup_database()
        return jsonify({
            'success': True,
            'backup_path': backup_path
        }), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500


# ============================================
# FLUTTER WEB SERVING
# ============================================

@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def serve_flutter(path):
    """Serve Flutter web application"""
    if path and os.path.exists(os.path.join(app.static_folder, path)):
        return send_from_directory(app.static_folder, path)
    else:
        return send_from_directory(app.static_folder, 'index.html')


# ============================================
# ERROR HANDLERS
# ============================================

@app.errorhandler(404)
def not_found(error):
    """Handle 404 errors"""
    return jsonify({'error': 'Not found'}), 404


@app.errorhandler(500)
def internal_error(error):
    """Handle 500 errors"""
    return jsonify({'error': 'Internal server error'}), 500


# ============================================
# STARTUP
# ============================================

def print_startup_info():
    """Print server startup information"""
    import socket
    
    # Get local IP
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        local_ip = s.getsockname()[0]
        s.close()
    except:
        local_ip = "Unable to determine"
    
    port = int(os.environ.get('PORT', 8080))
    
    print("\n" + "="*60)
    print("🏥 KinéCare Local Server Started")
    print("="*60)
    print(f"\n✅ Database: {db.db_path}")
    print(f"✅ API Endpoints: http://localhost:{port}/api/")
    print(f"✅ Flutter Web: http://localhost:{port}/")
    print(f"\n📱 Access from other devices on LAN:")
    print(f"   http://{local_ip}:{port}/")
    print("\n" + "="*60)
    print("Press Ctrl+C to stop server\n")


if __name__ == '__main__':
    print_startup_info()
    
    port = int(os.environ.get('PORT', 8080))
    debug = os.environ.get('DEBUG', 'False').lower() == 'true'
    
    app.run(
        host='0.0.0.0',  # Listen on all network interfaces
        port=port,
        debug=debug,
        threaded=True
    )
