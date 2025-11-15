#!/usr/bin/env python3
"""
KinéCare Server Launcher
Script de démarrage simplifié pour le serveur local
"""
import os
import sys
from pathlib import Path

# Add backend to path
backend_dir = Path(__file__).parent
sys.path.insert(0, str(backend_dir))

def check_dependencies():
    """Vérifier que toutes les dépendances sont installées"""
    required_packages = [
        'flask',
        'flask_cors',
        'flask_jwt_extended',
        'werkzeug',
        'sqlalchemy'
    ]
    
    missing = []
    for package in required_packages:
        try:
            __import__(package)
        except ImportError:
            missing.append(package)
    
    if missing:
        print("❌ Dépendances manquantes:")
        print(f"   {', '.join(missing)}")
        print("\n💡 Installation:")
        print(f"   pip install -r {backend_dir}/requirements.txt")
        return False
    
    return True


def main():
    """Point d'entrée principal"""
    print("🏥 KinéCare - Démarrage du serveur local...")
    
    # Check dependencies
    if not check_dependencies():
        sys.exit(1)
    
    # Initialize database
    from database.db_manager import get_db
    
    print("\n📊 Initialisation de la base de données...")
    db = get_db()
    
    # Get database info
    info = db.get_database_info()
    print(f"✅ Base de données: {info['db_path']}")
    print(f"   Taille: {info['db_size_mb']} MB")
    print(f"   Enregistrements: {info['total_records']}")
    
    # Start Flask server
    print("\n🚀 Démarrage du serveur Flask...\n")
    
    from api.app import app, print_startup_info
    
    print_startup_info()
    
    # Get configuration from environment or use defaults
    port = int(os.environ.get('PORT', 8080))
    debug = os.environ.get('DEBUG', 'False').lower() == 'true'
    
    app.run(
        host='0.0.0.0',  # Écoute sur toutes les interfaces réseau
        port=port,
        debug=debug,
        threaded=True
    )


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n👋 Arrêt du serveur...")
        print("✅ Données sauvegardées")
        sys.exit(0)
    except Exception as e:
        print(f"\n❌ Erreur: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
