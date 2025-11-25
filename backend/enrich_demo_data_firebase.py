#!/usr/bin/env python3
"""
Script d'enrichissement des données de démonstration Firebase pour MediDesk
Crée des patients réalistes avec historiques sur 2-3 mois

Auteur: RBSoftwareAI
Date: 25 Novembre 2025
"""

import sys
import os
from datetime import datetime, timedelta
import random
import uuid

# Configuration Firebase
try:
    import firebase_admin
    from firebase_admin import credentials, firestore, auth
    print("✅ firebase-admin importé avec succès")
except ImportError as e:
    print(f"❌ Erreur d'import firebase-admin: {e}")
    print("📦 Installation requise: pip install firebase-admin==7.1.0")
    sys.exit(1)

# Configuration
FIREBASE_ADMIN_SDK_PATH = "/opt/flutter/firebase-admin-sdk.json"

# Patients réalistes avec pathologies
DEMO_PATIENTS = [
    {
        'firstName': 'Jean',
        'lastName': 'Dupont',
        'age': 45,
        'pathology': 'Lombalgie chronique',
        'zones': ['lower_back', 'pelvis'],
        'initial_intensity': 8,
        'description': 'Douleur lombaire persistante depuis 3 mois, travail de bureau',
    },
    {
        'firstName': 'Marie',
        'lastName': 'Martin',
        'age': 32,
        'pathology': 'Tendinite épaule droite',
        'zones': ['shoulder_right', 'upper_arm_right'],
        'initial_intensity': 7,
        'description': 'Tendinite suite à pratique intensive du tennis',
    },
    {
        'firstName': 'Pierre',
        'lastName': 'Lefebvre',
        'age': 58,
        'pathology': 'Gonalgie (arthrose genou gauche)',
        'zones': ['knee_left'],
        'initial_intensity': 6,
        'description': 'Douleur genou gauche, arthrose débutante',
    },
    {
        'firstName': 'Sophie',
        'lastName': 'Durand',
        'age': 41,
        'pathology': 'Cervicalgie',
        'zones': ['neck', 'upper_back'],
        'initial_intensity': 7,
        'description': 'Douleurs cervicales liées au travail sur ordinateur',
    },
    {
        'firstName': 'Thomas',
        'lastName': 'Bernard',
        'age': 29,
        'pathology': 'Entorse cheville droite',
        'zones': ['ankle_right', 'foot_right'],
        'initial_intensity': 8,
        'description': 'Entorse suite à pratique du basket-ball',
    },
]

def initialize_firebase():
    """Initialise Firebase Admin SDK"""
    try:
        # Vérifier si Firebase est déjà initialisé
        if not firebase_admin._apps:
            cred = credentials.Certificate(FIREBASE_ADMIN_SDK_PATH)
            firebase_admin.initialize_app(cred)
            print("✅ Firebase Admin SDK initialisé")
        else:
            print("ℹ️  Firebase Admin SDK déjà initialisé")
        
        return firestore.client()
    except Exception as e:
        print(f"❌ Erreur initialisation Firebase: {e}")
        sys.exit(1)

def check_firestore_database(db):
    """Vérifie si la base Firestore existe"""
    try:
        # Test simple: essayer de lire une collection
        users_ref = db.collection('users').limit(1)
        list(users_ref.stream())
        print("✅ Base de données Firestore détectée")
        return True
    except Exception as e:
        print(f"❌ Base de données Firestore non accessible: {e}")
        print("\n📋 Étapes pour créer la base Firestore:")
        print("1. Aller sur: https://console.firebase.google.com/")
        print("2. Sélectionner le projet")
        print("3. Build → Firestore Database → Create Database")
        return False

def generate_pain_history(zones, initial_intensity, num_months=2):
    """
    Génère un historique de douleur progressif sur plusieurs mois
    
    Args:
        zones: Liste des zones affectées
        initial_intensity: Intensité initiale (0-10)
        num_months: Nombre de mois d'historique
    
    Returns:
        Liste d'enregistrements pain_history
    """
    history = []
    current_date = datetime.now() - timedelta(days=num_months * 30)
    current_intensity = initial_intensity
    
    # Génère un point tous les 3-5 jours
    while (datetime.now() - current_date).days > 0:
        # Amélioration progressive (-0.1 à -0.3 par mesure)
        improvement = random.uniform(0.1, 0.3)
        current_intensity = max(0, current_intensity - improvement)
        
        # Ajouter un peu de variation naturelle
        variation = random.uniform(-0.5, 0.2)
        measured_intensity = max(0, min(10, current_intensity + variation))
        
        # Créer un enregistrement pour chaque zone
        for zone in zones:
            zone_intensity = max(0, min(10, measured_intensity + random.uniform(-0.5, 0.5)))
            
            history.append({
                'zone': zone,
                'intensity': round(zone_intensity, 1),
                'date': current_date,
                'notes': f'Mesure automatique - Zone {zone}'
            })
        
        # Avancer de 3-5 jours
        current_date += timedelta(days=random.randint(3, 5))
    
    return history

def generate_session_notes(session_num, pathology, zones, intensity_before, intensity_after):
    """Génère des notes de séance réalistes"""
    notes_templates = [
        f"Séance {session_num} - {pathology}. Travail sur {', '.join(zones)}. "
        f"Douleur avant séance: {intensity_before:.1f}/10, après séance: {intensity_after:.1f}/10. "
        f"Amélioration de {intensity_before - intensity_after:.1f} points.",
        
        f"Traitement {pathology} - Séance {session_num}. "
        f"Exercices de mobilisation et renforcement. "
        f"Évolution positive: douleur passée de {intensity_before:.1f} à {intensity_after:.1f}.",
        
        f"Séance n°{session_num} pour {pathology}. "
        f"Zones traitées: {', '.join(zones)}. "
        f"Patient signale amélioration significative. Douleur réduite de {intensity_before - intensity_after:.1f} points.",
    ]
    
    return random.choice(notes_templates)

def create_patient_with_history(db, patient_data, practitioner_id):
    """
    Crée un patient avec historique complet
    
    Args:
        db: Client Firestore
        patient_data: Données du patient
        practitioner_id: ID du praticien
    """
    try:
        patient_id = str(uuid.uuid4())
        
        # Calcul date de naissance
        birth_year = datetime.now().year - patient_data['age']
        birth_date = f"{birth_year}-01-01"
        
        # Créer le document utilisateur patient
        user_data = {
            'firstName': patient_data['firstName'],
            'lastName': patient_data['lastName'],
            'email': f"{patient_data['firstName'].lower()}.{patient_data['lastName'].lower()}@demo-medidesk.fr",
            'role': 'patient',
            'birthDate': birth_date,
            'phone': f"+33 6 {random.randint(10, 99)} {random.randint(10, 99)} {random.randint(10, 99)} {random.randint(10, 99)}",
            'gender': random.choice(['male', 'female']),
            'medicalHistory': patient_data['description'],
            'currentPathology': patient_data['pathology'],
            'createdAt': firestore.SERVER_TIMESTAMP,
            'updatedAt': firestore.SERVER_TIMESTAMP,
        }
        
        db.collection('users').document(patient_id).set(user_data)
        print(f"   ✅ Patient créé: {patient_data['firstName']} {patient_data['lastName']} ({patient_data['age']} ans)")
        
        # Générer l'historique des douleurs
        pain_history = generate_pain_history(
            patient_data['zones'],
            patient_data['initial_intensity'],
            num_months=random.randint(2, 3)
        )
        
        print(f"      📊 Génération de {len(pain_history)} enregistrements d'historique...")
        
        # Ajouter les enregistrements pain_history
        for i, record in enumerate(pain_history):
            pain_id = str(uuid.uuid4())
            pain_data = {
                'userId': patient_id,
                'practitionerId': practitioner_id,
                'zone': record['zone'],
                'intensity': record['intensity'],
                'timestamp': record['date'],
                'notes': record['notes'],
                'pathology': patient_data['pathology'],
            }
            
            db.collection('pain_history').document(pain_id).set(pain_data)
            
            # Afficher progression tous les 10 enregistrements
            if (i + 1) % 10 == 0:
                print(f"         ... {i + 1}/{len(pain_history)} enregistrements ajoutés")
        
        print(f"      ✅ Historique complet créé ({len(pain_history)} points)")
        
        # Générer des séances de traitement
        num_sessions = random.randint(5, 10)
        current_intensity = patient_data['initial_intensity']
        session_start_date = datetime.now() - timedelta(days=len(pain_history) // 2)
        
        print(f"      💉 Création de {num_sessions} séances de traitement...")
        
        for session_num in range(1, num_sessions + 1):
            session_id = str(uuid.uuid4())
            session_date = session_start_date + timedelta(days=session_num * 7)
            
            intensity_before = current_intensity
            improvement = random.uniform(0.5, 1.5)
            intensity_after = max(0, current_intensity - improvement)
            current_intensity = intensity_after
            
            session_data = {
                'patientId': patient_id,
                'practitionerId': practitioner_id,
                'date': session_date,
                'duration': random.randint(30, 60),
                'type': 'followup' if session_num > 1 else 'initial',
                'intensityBefore': round(intensity_before, 1),
                'intensityAfter': round(intensity_after, 1),
                'improvement': round(improvement, 1),
                'zones': patient_data['zones'],
                'pathology': patient_data['pathology'],
                'notes': generate_session_notes(
                    session_num,
                    patient_data['pathology'],
                    patient_data['zones'],
                    intensity_before,
                    intensity_after
                ),
                'createdAt': firestore.SERVER_TIMESTAMP,
            }
            
            db.collection('sessions').document(session_id).set(session_data)
        
        print(f"      ✅ {num_sessions} séances créées")
        print(f"      📈 Évolution: {patient_data['initial_intensity']:.1f}/10 → {current_intensity:.1f}/10")
        
        return patient_id
        
    except Exception as e:
        print(f"   ❌ Erreur création patient {patient_data['firstName']}: {e}")
        return None

def get_or_create_practitioner(db):
    """Récupère ou crée un praticien pour associer aux patients"""
    try:
        # Chercher un praticien existant
        practitioners = db.collection('users').where('role', '==', 'kine').limit(1).stream()
        
        for prac in practitioners:
            print(f"✅ Praticien trouvé: {prac.to_dict().get('firstName', 'Inconnu')}")
            return prac.id
        
        # Si aucun praticien, créer un praticien démo
        print("ℹ️  Aucun praticien trouvé, création d'un praticien démo...")
        prac_id = str(uuid.uuid4())
        
        prac_data = {
            'firstName': 'Pierre',
            'lastName': 'Durand',
            'email': 'pierre.durand@medidesk.fr',
            'role': 'kine',
            'phone': '+33 6 12 34 56 78',
            'speciality': 'Kinésithérapie générale',
            'createdAt': firestore.SERVER_TIMESTAMP,
        }
        
        db.collection('users').document(prac_id).set(prac_data)
        print(f"✅ Praticien créé: Pierre Durand")
        
        return prac_id
        
    except Exception as e:
        print(f"❌ Erreur récupération praticien: {e}")
        return None

def main():
    """Point d'entrée principal"""
    print("=" * 70)
    print("🏥 MediDesk - Enrichissement Données de Démonstration Firebase")
    print("=" * 70)
    print(f"📅 Date: {datetime.now().strftime('%d/%m/%Y %H:%M')}")
    print()
    
    # Initialiser Firebase
    db = initialize_firebase()
    
    # Vérifier base Firestore
    if not check_firestore_database(db):
        sys.exit(1)
    
    # Récupérer ou créer un praticien
    print("\n👨‍⚕️ Récupération du praticien...")
    practitioner_id = get_or_create_practitioner(db)
    
    if not practitioner_id:
        print("❌ Impossible de continuer sans praticien")
        sys.exit(1)
    
    # Créer les patients avec historiques
    print(f"\n👥 Création de {len(DEMO_PATIENTS)} patients réalistes...")
    print()
    
    created_count = 0
    for i, patient_data in enumerate(DEMO_PATIENTS, 1):
        print(f"📝 Patient {i}/{len(DEMO_PATIENTS)}")
        patient_id = create_patient_with_history(db, patient_data, practitioner_id)
        
        if patient_id:
            created_count += 1
        
        print()  # Ligne vide entre chaque patient
    
    # Résumé
    print("=" * 70)
    print("✅ ENRICHISSEMENT TERMINÉ")
    print("=" * 70)
    print(f"\n📊 Résumé:")
    print(f"   - Patients créés: {created_count}/{len(DEMO_PATIENTS)}")
    print(f"   - Historiques générés: ~{created_count * 60} points de douleur")
    print(f"   - Séances créées: ~{created_count * 7} séances de traitement")
    print()
    print("🌐 Testez sur: https://demo.medidesk.fr")
    print()

if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print("\n\n⚠️  Opération annulée par l'utilisateur")
        sys.exit(1)
    except Exception as e:
        print(f"\n❌ Erreur fatale: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
