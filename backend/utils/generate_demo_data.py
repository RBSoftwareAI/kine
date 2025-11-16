"""
Generate Demo Data for KinéCare
Crée des données de test réalistes pour démonstration
"""
import sys
from pathlib import Path
from datetime import datetime, timedelta
import random
import uuid

# Add parent directory to path
sys.path.insert(0, str(Path(__file__).parent.parent))

from database.db_manager import get_db
from services.statistics_service import StatisticsService
from werkzeug.security import generate_password_hash


# Configuration
NUM_PATIENTS = 15
NUM_KINES = 3
NUM_COACHES = 2
MIN_SESSIONS_PER_PATIENT = 3
MAX_SESSIONS_PER_PATIENT = 12

# Zones corporelles
BODY_ZONES = [
    'head', 'neck', 'upper_back', 'lower_back', 'pelvis',
    'shoulder_left', 'shoulder_right',
    'upper_arm_left', 'upper_arm_right',
    'elbow_left', 'elbow_right',
    'forearm_left', 'forearm_right',
    'wrist_left', 'wrist_right',
    'hand_left', 'hand_right',
    'upper_leg_left', 'upper_leg_right',
    'knee_left', 'knee_right',
    'lower_leg_left', 'lower_leg_right',
    'ankle_left', 'ankle_right',
    'foot_left', 'foot_right'
]

# Pathologies communes
PATHOLOGIES = {
    'lombalgie': ['lower_back', 'pelvis'],
    'cervicalgie': ['neck', 'upper_back'],
    'tendinite_epaule': ['shoulder_left', 'shoulder_right', 'upper_arm_left', 'upper_arm_right'],
    'gonalgie': ['knee_left', 'knee_right'],
    'entorse_cheville': ['ankle_left', 'ankle_right', 'foot_left', 'foot_right'],
}


def generate_users(db):
    """Générer des utilisateurs de démonstration"""
    
    print("\n👥 Génération des utilisateurs...")
    
    users = []
    
    # Kinésithérapeutes
    kine_names = [
        ('Marie', 'Dubois'),
        ('Thomas', 'Martin'),
        ('Sophie', 'Bernard'),
    ]
    
    for i, (first, last) in enumerate(kine_names[:NUM_KINES]):
        user_id = f"kine_{uuid.uuid4().hex[:12]}"
        email = f"{first.lower()}.{last.lower()}@medidesk.demo"
        
        user_data = {
            'id': user_id,
            'email': email,
            'password_hash': generate_password_hash('demo123'),
            'first_name': first,
            'last_name': last,
            'role': 'kine',
            'phone': f"06{random.randint(10000000, 99999999)}",
            'is_active': 1,
            'created_at': datetime.utcnow().isoformat()
        }
        
        db.insert('users', user_data)
        users.append((user_id, 'kine', f"{first} {last}"))
        print(f"   ✅ Kiné: {first} {last} ({email})")
    
    # Coachs APA
    coach_names = [
        ('Pierre', 'Leroy'),
        ('Julie', 'Moreau'),
    ]
    
    for i, (first, last) in enumerate(coach_names[:NUM_COACHES]):
        user_id = f"coach_{uuid.uuid4().hex[:12]}"
        email = f"{first.lower()}.{last.lower()}@medidesk.demo"
        
        user_data = {
            'id': user_id,
            'email': email,
            'password_hash': generate_password_hash('demo123'),
            'first_name': first,
            'last_name': last,
            'role': 'coach_apa',
            'phone': f"06{random.randint(10000000, 99999999)}",
            'is_active': 1,
            'created_at': datetime.utcnow().isoformat()
        }
        
        db.insert('users', user_data)
        users.append((user_id, 'coach_apa', f"{first} {last}"))
        print(f"   ✅ Coach: {first} {last} ({email})")
    
    # Patients
    patient_names = [
        ('Jean', 'Dupont'), ('Marie', 'Lambert'), ('Paul', 'Rousseau'),
        ('Claire', 'Simon'), ('Luc', 'Michel'), ('Anne', 'Lefebvre'),
        ('Marc', 'Garcia'), ('Sophie', 'Roux'), ('David', 'Girard'),
        ('Laura', 'Blanc'), ('Nicolas', 'Bonnet'), ('Emma', 'François'),
        ('Hugo', 'Mercier'), ('Léa', 'Perrin'), ('Arthur', 'Morel'),
    ]
    
    for i, (first, last) in enumerate(patient_names[:NUM_PATIENTS]):
        user_id = f"patient_{uuid.uuid4().hex[:12]}"
        email = f"{first.lower()}.{last.lower()}@email.demo"
        
        # Age aléatoire entre 25 et 75 ans
        age = random.randint(25, 75)
        birth_date = datetime.now() - timedelta(days=age*365)
        
        user_data = {
            'id': user_id,
            'email': email,
            'password_hash': generate_password_hash('demo123'),
            'first_name': first,
            'last_name': last,
            'role': 'patient',
            'phone': f"06{random.randint(10000000, 99999999)}",
            'birth_date': birth_date.date().isoformat(),
            'is_active': 1,
            'created_at': datetime.utcnow().isoformat()
        }
        
        db.insert('users', user_data)
        users.append((user_id, 'patient', f"{first} {last}"))
        print(f"   ✅ Patient: {first} {last} ({age} ans)")
    
    return users


def generate_sessions_and_pain_points(db, users):
    """Générer séances et points de douleur"""
    
    print("\n💉 Génération des séances et points de douleur...")
    
    # Filtrer professionnels et patients
    professionals = [(uid, name) for uid, role, name in users if role in ['kine', 'coach_apa']]
    patients = [(uid, name) for uid, role, name in users if role == 'patient']
    
    total_sessions = 0
    total_pain_points = 0
    
    for patient_id, patient_name in patients:
        # Choisir une pathologie aléatoire
        pathology = random.choice(list(PATHOLOGIES.keys()))
        affected_zones = PATHOLOGIES[pathology]
        
        # Nombre de séances aléatoire
        num_sessions = random.randint(MIN_SESSIONS_PER_PATIENT, MAX_SESSIONS_PER_PATIENT)
        
        # Intensité initiale entre 6 et 9
        initial_intensity = random.randint(6, 9)
        current_intensity = initial_intensity
        
        # Date de début (entre 6 mois et 1 mois en arrière)
        start_date = datetime.now() - timedelta(days=random.randint(30, 180))
        
        print(f"\n   👤 {patient_name} - {pathology.replace('_', ' ').title()}")
        print(f"      Intensité initiale: {initial_intensity}/10")
        
        for session_num in range(num_sessions):
            # Professionnel aléatoire
            professional_id, professional_name = random.choice(professionals)
            
            # Date de la séance (espacées de 5-14 jours)
            session_date = start_date + timedelta(days=session_num * random.randint(5, 14))
            
            # Type de séance
            if session_num == 0:
                session_type = 'initial'
            elif session_num == num_sessions - 1:
                session_type = 'discharge'
            else:
                session_type = 'followup'
            
            # Créer la séance
            session_id = f"session_{uuid.uuid4().hex[:12]}"
            
            session_data = {
                'id': session_id,
                'patient_id': patient_id,
                'professional_id': professional_id,
                'session_type': session_type,
                'date': session_date.isoformat(),
                'duration_minutes': random.randint(30, 60),
                'status': 'completed',
                'treatment_notes': f"Séance {session_num + 1} - {pathology}"
            }
            
            db.insert('pain_sessions', session_data)
            total_sessions += 1
            
            # Points de douleur AVANT la séance
            pain_before_avg = current_intensity
            
            for zone in affected_zones:
                # Variation aléatoire autour de l'intensité actuelle
                intensity = max(0, min(10, current_intensity + random.randint(-1, 1)))
                
                point_id = f"pain_{uuid.uuid4().hex[:12]}"
                point_data = {
                    'id': point_id,
                    'patient_id': patient_id,
                    'professional_id': professional_id,
                    'zone': zone,
                    'intensity': intensity,
                    'timestamp': session_date.isoformat(),
                    'session_id': session_id,
                    'is_before_session': 1
                }
                
                db.insert('pain_points', point_data)
                total_pain_points += 1
            
            # Amélioration après la séance (entre 1 et 3 points)
            improvement = random.uniform(1.0, 3.0)
            current_intensity = max(0, current_intensity - improvement)
            
            # Points de douleur APRÈS la séance
            pain_after_avg = current_intensity
            
            for zone in affected_zones:
                intensity = max(0, min(10, current_intensity + random.randint(-1, 1)))
                
                point_id = f"pain_{uuid.uuid4().hex[:12]}"
                point_data = {
                    'id': point_id,
                    'patient_id': patient_id,
                    'professional_id': professional_id,
                    'zone': zone,
                    'intensity': intensity,
                    'timestamp': (session_date + timedelta(hours=1)).isoformat(),
                    'session_id': session_id,
                    'is_before_session': 0
                }
                
                db.insert('pain_points', point_data)
                total_pain_points += 1
            
            # Mettre à jour la séance avec les moyennes
            db.update(
                'pain_sessions',
                {
                    'pain_before_avg': pain_before_avg,
                    'pain_after_avg': pain_after_avg,
                    'improvement': pain_before_avg - pain_after_avg
                },
                'id = ?',
                (session_id,)
            )
            
            print(f"      Séance {session_num + 1}: {pain_before_avg:.1f} → {pain_after_avg:.1f} (-{improvement:.1f})")
        
        print(f"      ✅ {num_sessions} séances créées")
    
    print(f"\n   📊 Total: {total_sessions} séances, {total_pain_points} points de douleur")


def main():
    """Point d'entrée principal"""
    
    print("=" * 60)
    print("🧪 KinéCare - Génération de données de démonstration")
    print("=" * 60)
    
    # Get database
    db = get_db()
    
    # Vérifier que la base est vide
    user_count = db.fetch_one("SELECT COUNT(*) as count FROM users WHERE id NOT LIKE 'admin_%' AND id NOT LIKE '%_demo_%'")
    
    if user_count and user_count['count'] > 0:
        response = input(f"\n⚠️  La base contient déjà {user_count['count']} utilisateurs. Continuer ? (y/N): ")
        if response.lower() != 'y':
            print("❌ Annulé")
            return
    
    # Générer les données
    users = generate_users(db)
    generate_sessions_and_pain_points(db, users)
    
    # Calculer les statistiques
    print("\n📊 Calcul des statistiques par pathologie...")
    stats_service = StatisticsService(db)
    all_stats = stats_service.calculate_all_pathologies()
    
    if all_stats:
        print(f"   ✅ {len(all_stats)} pathologies analysées")
        for stats in all_stats:
            print(f"      - {stats['pathology_name']}: {stats['total_patients']} patients")
    else:
        print("   ⚠️  Pas assez de données pour les statistiques (minimum 5 patients par pathologie)")
    
    # Backup
    print("\n💾 Création d'une sauvegarde...")
    backup_path = db.backup_database()
    print(f"   ✅ Sauvegarde: {backup_path}")
    
    # Info finale
    info = db.get_database_info()
    
    print("\n" + "=" * 60)
    print("✅ GÉNÉRATION TERMINÉE")
    print("=" * 60)
    print(f"\n📊 Statistiques finales:")
    print(f"   - Base de données: {info['db_path']}")
    print(f"   - Taille: {info['db_size_mb']} MB")
    print(f"   - Enregistrements totaux: {info['total_records']}")
    print(f"\n📁 Détail par table:")
    for table, count in info['table_counts'].items():
        if count > 0:
            print(f"   - {table}: {count}")
    
    print("\n🔑 Comptes de démonstration:")
    print("   - admin@medidesk.local / admin123")
    print("   - marie.dubois@medidesk.demo / demo123")
    print("   - jean.dupont@email.demo / demo123")
    
    print("\n🚀 Démarrer le serveur:")
    print("   python3 backend/start_server.py")
    print()


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n❌ Annulé par l'utilisateur")
        sys.exit(1)
    except Exception as e:
        print(f"\n❌ Erreur: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
