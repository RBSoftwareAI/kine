"""
Script de génération de données demo pour KinéCare
Crée des patients, douleurs, séances et pathologies réalistes
"""
import sys
from pathlib import Path
import uuid
from datetime import datetime, timedelta
import random

# Ajoute le répertoire backend au path
sys.path.insert(0, str(Path(__file__).parent))

from database.db_manager import get_db
from services.auth_service import AuthService


# ============================================
# Données réalistes pour la génération
# ============================================

PATHOLOGIES = [
    {
        'name': 'Lombalgie chronique',
        'zones': ['lower_back'],
        'initial_intensity': (6, 8),
        'healing_days': (30, 90)
    },
    {
        'name': 'Cervicalgie',
        'zones': ['neck', 'upper_back'],
        'initial_intensity': (5, 7),
        'healing_days': (20, 60)
    },
    {
        'name': 'Tendinite épaule',
        'zones': ['left_shoulder', 'right_shoulder'],
        'initial_intensity': (6, 8),
        'healing_days': (40, 120)
    },
    {
        'name': 'Gonalgie (douleur genou)',
        'zones': ['left_knee', 'right_knee'],
        'initial_intensity': (5, 9),
        'healing_days': (30, 90)
    },
    {
        'name': 'Sciatique',
        'zones': ['lower_back', 'left_hip', 'right_hip', 'left_thigh', 'right_thigh'],
        'initial_intensity': (7, 9),
        'healing_days': (45, 120)
    },
    {
        'name': 'Syndrome du canal carpien',
        'zones': ['left_hand', 'right_hand', 'left_arm', 'right_arm'],
        'initial_intensity': (4, 7),
        'healing_days': (60, 180)
    },
    {
        'name': 'Entorse cheville',
        'zones': ['left_foot', 'right_foot'],
        'initial_intensity': (6, 9),
        'healing_days': (15, 45)
    }
]

FIRST_NAMES = [
    'Jean', 'Marie', 'Pierre', 'Sophie', 'Luc', 'Anne', 'Thomas', 'Emma',
    'Nicolas', 'Julie', 'François', 'Claire', 'Marc', 'Isabelle', 'David'
]

LAST_NAMES = [
    'Martin', 'Bernard', 'Dubois', 'Thomas', 'Robert', 'Richard', 'Petit',
    'Durand', 'Leroy', 'Moreau', 'Simon', 'Laurent', 'Lefebvre', 'Michel'
]


# ============================================
# Fonctions de génération
# ============================================

def create_demo_patients(db, auth_service, count: int = 15):
    """
    Crée des patients demo avec des profils variés
    
    Args:
        db: Instance DatabaseManager
        auth_service: Instance AuthService
        count: Nombre de patients à créer
    """
    print(f"\n📝 Création de {count} patients demo...")
    
    created_patients = []
    
    for i in range(count):
        first_name = random.choice(FIRST_NAMES)
        last_name = random.choice(LAST_NAMES)
        email = f"{first_name.lower()}.{last_name.lower()}{i}@demo.com"
        
        # Crée le compte utilisateur
        user_data = {
            'email': email,
            'password': 'demo123',
            'firstName': first_name,
            'lastName': last_name,
            'role': 'patient',
            'birthYear': random.randint(1950, 2000),
            'gender': random.choice(['M', 'F'])
        }
        
        result = auth_service.register_user(user_data)
        
        if result['success']:
            # Récupère l'ID patient créé
            query = "SELECT id FROM patients WHERE user_id = ?"
            patient = db.execute_query(query, (result['user_id'],))
            
            if patient:
                created_patients.append({
                    'patient_id': patient[0]['id'],
                    'user_id': result['user_id'],
                    'name': f"{first_name} {last_name}"
                })
                print(f"  ✅ {first_name} {last_name}")
    
    print(f"✅ {len(created_patients)} patients créés")
    return created_patients


def create_pathologies_for_patients(db, patients: list):
    """
    Attribue des pathologies réalistes aux patients
    
    Args:
        db: Instance DatabaseManager
        patients: Liste des patients créés
    """
    print(f"\n🏥 Attribution des pathologies...")
    
    created_pathologies = []
    
    for patient in patients:
        # 70% de chance d'avoir une pathologie active
        if random.random() < 0.7:
            pathology_template = random.choice(PATHOLOGIES)
            
            # Date de diagnostic (entre 1 et 180 jours dans le passé)
            days_ago = random.randint(1, 180)
            diagnosis_date = datetime.utcnow() - timedelta(days=days_ago)
            
            # Détermine si la pathologie est résolue
            expected_healing_days = random.randint(*pathology_template['healing_days'])
            
            if days_ago > expected_healing_days:
                status = 'resolved'
                resolution_date = diagnosis_date + timedelta(days=expected_healing_days)
            elif days_ago > expected_healing_days * 0.5:
                status = 'in_treatment'
                resolution_date = None
            else:
                status = 'active'
                resolution_date = None
            
            # Zone primaire affectée
            primary_zone = random.choice(pathology_template['zones'])
            
            # Sévérité
            initial_intensity = random.randint(*pathology_template['initial_intensity'])
            if initial_intensity >= 8:
                severity = 'severe'
            elif initial_intensity >= 5:
                severity = 'moderate'
            else:
                severity = 'mild'
            
            pathology_id = f'patho_{uuid.uuid4().hex}'
            
            query = """
            INSERT INTO pathologies (
                id, patient_id, pathology_name, diagnosis_date,
                primary_zone, severity, status, resolution_date
            )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """
            
            db.execute_update(query, (
                pathology_id,
                patient['patient_id'],
                pathology_template['name'],
                diagnosis_date.date().isoformat(),
                primary_zone,
                severity,
                status,
                resolution_date.date().isoformat() if resolution_date else None
            ))
            
            created_pathologies.append({
                'pathology_id': pathology_id,
                'patient_id': patient['patient_id'],
                'name': pathology_template['name'],
                'zones': pathology_template['zones'],
                'initial_intensity': initial_intensity,
                'status': status,
                'diagnosis_date': diagnosis_date
            })
            
            print(f"  ✅ {patient['name']}: {pathology_template['name']} ({status})")
    
    print(f"✅ {len(created_pathologies)} pathologies créées")
    return created_pathologies


def create_pain_history_for_pathologies(db, pathologies: list):
    """
    Génère l'historique de douleur réaliste pour chaque pathologie
    
    Args:
        db: Instance DatabaseManager
        pathologies: Liste des pathologies créées
    """
    print(f"\n📊 Génération de l'historique des douleurs...")
    
    total_points = 0
    
    for pathology in pathologies:
        patient_id = pathology['patient_id']
        zones = pathology['zones']
        initial_intensity = pathology['initial_intensity']
        diagnosis_date = pathology['diagnosis_date']
        status = pathology['status']
        
        # Nombre de jours depuis le diagnostic
        days_since_diagnosis = (datetime.utcnow() - diagnosis_date).days
        
        # Génère des points tous les 3-7 jours
        current_date = diagnosis_date
        current_intensity = initial_intensity
        
        while (datetime.utcnow() - current_date).days > 0:
            # Variation de l'intensité (-0.1 à -0.3 par point si en traitement)
            if status in ['in_treatment', 'resolved']:
                improvement = random.uniform(0.1, 0.3)
                current_intensity = max(0, current_intensity - improvement)
            else:
                # Variation aléatoire si pas de traitement
                current_intensity += random.uniform(-0.5, 0.5)
                current_intensity = max(0, min(10, current_intensity))
            
            # Crée un point d'historique
            history_id = f'hist_{uuid.uuid4().hex}'
            
            # Sélectionne 1-3 zones affectées
            affected_zones = random.sample(zones, min(len(zones), random.randint(1, 3)))
            
            # Génère les intensités par zone
            zone_intensities = {}
            for zone in affected_zones:
                zone_intensity = max(0, min(10, int(current_intensity + random.uniform(-1, 1))))
                zone_intensities[zone] = zone_intensity
            
            # Calcule moyenne
            avg_intensity = sum(zone_intensities.values()) / len(zone_intensities)
            
            query = """
            INSERT INTO pain_history (
                id, patient_id, timestamp, average_intensity,
                zone_intensities, is_before_session
            )
            VALUES (?, ?, ?, ?, ?, ?)
            """
            
            db.execute_update(query, (
                history_id,
                patient_id,
                current_date.isoformat(),
                avg_intensity,
                str(zone_intensities),  # Convertir dict en string pour SQLite
                0
            ))
            
            total_points += 1
            
            # Avance de 3-7 jours
            current_date += timedelta(days=random.randint(3, 7))
    
    print(f"✅ {total_points} points d'historique générés")


def update_pathology_stats_cache(db):
    """
    Met à jour le cache des statistiques de pathologies
    
    Args:
        db: Instance DatabaseManager
    """
    print(f"\n📈 Mise à jour du cache statistiques...")
    
    db._update_pathology_cache()
    
    # Affiche les statistiques générées
    stats = db.get_cached_pathology_stats()
    
    print("\n📊 Statistiques générées:")
    print(f"{'Pathologie':<30} | {'Cas':<8} | {'Actifs':<8} | {'Résolus':<8} | {'Temps guérison (j)'}")
    print("-" * 90)
    
    for stat in stats:
        healing_time = f"{stat['average_healing_days']:.1f}" if stat['average_healing_days'] else "N/A"
        print(f"{stat['pathology_name']:<30} | {stat['total_cases']:<8} | {stat['active_cases']:<8} | {stat['resolved_cases']:<8} | {healing_time}")
    
    print(f"\n✅ Cache statistiques mis à jour")


# ============================================
# Script principal
# ============================================

def main():
    """
    Script principal de génération de données demo
    """
    print("=" * 70)
    print("🏥 KinéCare - Génération de Données Demo")
    print("=" * 70)
    
    # Initialise la base de données
    db = get_db()
    auth_service = AuthService(db)
    
    # Crée les comptes demo professionnels
    print("\n👥 Création des comptes professionnels...")
    auth_service.create_demo_accounts()
    
    # Crée les patients demo
    patients = create_demo_patients(db, auth_service, count=15)
    
    # Crée les pathologies
    pathologies = create_pathologies_for_patients(db, patients)
    
    # Génère l'historique
    create_pain_history_for_pathologies(db, pathologies)
    
    # Met à jour le cache statistiques
    update_pathology_stats_cache(db)
    
    print("\n" + "=" * 70)
    print("✅ Génération de données demo terminée !")
    print("=" * 70)
    print("\n📝 Comptes disponibles:")
    print("  - patient@demo.com / patient123 (patient)")
    print("  - kine@demo.com / kine123 (kinésithérapeute)")
    print("  - coach@demo.com / coach123 (coach APA)")
    print("\n🚀 Démarrez le serveur avec: python api/app.py")
    print("")


if __name__ == '__main__':
    main()
