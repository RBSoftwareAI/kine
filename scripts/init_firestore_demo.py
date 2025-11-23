#!/usr/bin/env python3
"""
Script d'initialisation de la base de données Firestore pour MediDesk Demo
Crée les collections et génère des données de test pour chaque centre
"""

import sys
from datetime import datetime, timedelta
import random

try:
    import firebase_admin
    from firebase_admin import credentials, firestore
    print("✅ firebase-admin importé avec succès")
except ImportError:
    print("❌ Erreur : firebase-admin n'est pas installé")
    print("📦 Installation requise : pip install firebase-admin==7.1.0")
    sys.exit(1)

# Initialiser Firebase Admin SDK
try:
    cred = credentials.Certificate('/opt/flutter/firebase-admin-sdk.json')
    firebase_admin.initialize_app(cred)
    db = firestore.client()
    print("✅ Firebase Admin SDK initialisé")
except Exception as e:
    print(f"❌ Erreur lors de l'initialisation Firebase : {e}")
    sys.exit(1)

# Données de test
CENTRES_DATA = [
    {
        'nom': 'Cabinet Kiné Paris Centre',
        'adresse': '15 Rue de Rivoli, 75001 Paris',
        'telephone': '01 42 60 38 38',
        'email': 'contact@kine-paris-centre.fr',
        'site_web': 'https://kine-paris-centre.fr',
        'duree_consultation_defaut': 30,
        'heure_ouverture': '08:00',
        'heure_fermeture': '19:00',
        'jours_ouverture': [1, 2, 3, 4, 5],  # Lundi-Vendredi
        'actif': True,
    },
    {
        'nom': 'Centre Ostéo Lyon',
        'adresse': '42 Cours Vitton, 69006 Lyon',
        'telephone': '04 78 52 63 74',
        'email': 'contact@osteo-lyon.fr',
        'site_web': 'https://osteo-lyon.fr',
        'duree_consultation_defaut': 45,
        'heure_ouverture': '09:00',
        'heure_fermeture': '18:00',
        'jours_ouverture': [1, 2, 3, 4, 5, 6],  # Lundi-Samedi
        'actif': True,
    },
]

PRENOMS_PATIENTS = ['Marie', 'Pierre', 'Sophie', 'Jean', 'Camille', 'Lucas', 'Emma', 'Thomas', 'Julie', 'Alexandre']
NOMS_PATIENTS = ['Martin', 'Bernard', 'Dubois', 'Thomas', 'Robert', 'Richard', 'Petit', 'Durand', 'Leroy', 'Moreau']

MOTIFS_CONSULTATION = [
    'Douleur lombaire',
    'Entorse cheville',
    'Tendinite épaule',
    'Rééducation post-opératoire',
    'Sciatique',
    'Cervicalgie',
    'Douleur genou',
    'Rééducation post-traumatique',
    'Arthrose',
    'Troubles posturaux',
]

def create_centre(centre_data, proprietaire_id):
    """Créer un centre de santé"""
    centre_ref = db.collection('centres').document()
    centre_data['proprietaire_id'] = proprietaire_id
    centre_data['date_creation'] = firestore.SERVER_TIMESTAMP
    centre_data['date_modification'] = None
    
    centre_ref.set(centre_data)
    print(f"  ✅ Centre créé : {centre_data['nom']} (ID: {centre_ref.id})")
    return centre_ref.id

def create_users(centre_id, nb_users=3):
    """Créer des utilisateurs pour un centre"""
    users = []
    prenoms = ['Dr. Marie', 'Dr. Pierre', 'Dr. Sophie']
    noms = ['Lefebvre', 'Girard', 'Rousseau']
    specialites = ['Kinésithérapeute', 'Ostéopathe', 'Kinésithérapeute du sport']
    
    for i in range(nb_users):
        user_ref = db.collection('users').document()
        user_data = {
            'centre_id': centre_id,
            'nom': noms[i],
            'prenom': prenoms[i],
            'email': f"{prenoms[i].lower().replace('. ', '')}.{noms[i].lower()}@medidesk-demo.fr",
            'telephone': f"06{random.randint(10000000, 99999999)}",
            'role': 'admin' if i == 0 else 'praticien',
            'specialite': specialites[i],
            'numero_ordre': f"{random.randint(100000, 999999)}",
            'date_creation': firestore.SERVER_TIMESTAMP,
            'date_modification': None,
            'derniereConnexion': None,
            'actif': True,
        }
        user_ref.set(user_data)
        users.append(user_ref.id)
        print(f"    ✅ Utilisateur créé : {user_data['prenom']} {user_data['nom']} ({user_data['role']})")
    
    return users

def create_patients(centre_id, nb_patients=10):
    """Créer des patients pour un centre"""
    patients = []
    
    for i in range(nb_patients):
        patient_ref = db.collection('patients').document()
        
        prenom = random.choice(PRENOMS_PATIENTS)
        nom = random.choice(NOMS_PATIENTS)
        age = random.randint(18, 80)
        
        patient_data = {
            'centre_id': centre_id,
            'nom': nom,
            'prenom': prenom,
            'date_naissance': datetime.now() - timedelta(days=age*365),
            'telephone': f"06{random.randint(10000000, 99999999)}",
            'email': f"{prenom.lower()}.{nom.lower()}@example.fr",
            'adresse': f"{random.randint(1, 150)} Rue de la République",
            'ville': random.choice(['Paris', 'Lyon', 'Marseille', 'Toulouse']),
            'code_postal': f"{random.randint(10000, 99000)}",
            'date_creation': firestore.SERVER_TIMESTAMP,
            'actif': True,
        }
        patient_ref.set(patient_data)
        patients.append(patient_ref.id)
    
    print(f"    ✅ {nb_patients} patients créés")
    return patients

def create_appointments(centre_id, user_ids, patient_ids, nb_appointments=15):
    """Créer des rendez-vous pour un centre"""
    now = datetime.now()
    
    for i in range(nb_appointments):
        appointment_ref = db.collection('appointments').document()
        
        # Créer RDV dans les 30 prochains jours
        days_offset = random.randint(0, 30)
        hour = random.randint(8, 17)
        minute = random.choice([0, 15, 30, 45])
        
        date_rdv = now + timedelta(days=days_offset)
        date_rdv = date_rdv.replace(hour=hour, minute=minute, second=0, microsecond=0)
        
        # 70% RDV avec patients existants, 30% RDV publics
        if random.random() < 0.7:
            patient_id = random.choice(patient_ids)
            patient_nom = None
            patient_prenom = None
            patient_telephone = None
            patient_email = None
        else:
            patient_id = None
            patient_nom = random.choice(NOMS_PATIENTS)
            patient_prenom = random.choice(PRENOMS_PATIENTS)
            patient_telephone = f"06{random.randint(10000000, 99999999)}"
            patient_email = f"{patient_prenom.lower()}.{patient_nom.lower()}@example.fr"
        
        statuts = ['planifié', 'confirmé', 'planifié', 'confirmé', 'terminé']
        
        appointment_data = {
            'centre_id': centre_id,
            'praticien_id': random.choice(user_ids),
            'patient_id': patient_id,
            'date_heure': date_rdv,
            'duree': random.choice([30, 45, 60]),
            'type': 'consultation',
            'motif': random.choice(MOTIFS_CONSULTATION),
            'statut': random.choice(statuts),
            'notes': None,
            'date_creation': firestore.SERVER_TIMESTAMP,
            'date_modification': None,
            'patient_nom': patient_nom,
            'patient_prenom': patient_prenom,
            'patient_telephone': patient_telephone,
            'patient_email': patient_email,
        }
        appointment_ref.set(appointment_data)
    
    print(f"    ✅ {nb_appointments} rendez-vous créés")

def main():
    """Fonction principale"""
    print("\n" + "="*60)
    print("🚀 INITIALISATION BASE DE DONNÉES MEDIDESK DEMO")
    print("="*60 + "\n")
    
    try:
        # Pour chaque centre de test
        for centre_data in CENTRES_DATA:
            print(f"\n📍 Traitement du centre : {centre_data['nom']}")
            
            # Créer un ID temporaire pour le propriétaire
            # En production, ce sera l'ID de l'utilisateur qui s'inscrit
            proprietaire_id = f"demo_user_{random.randint(1000, 9999)}"
            
            # 1. Créer le centre
            centre_id = create_centre(centre_data, proprietaire_id)
            
            # 2. Créer les utilisateurs (praticiens)
            print(f"  👥 Création des utilisateurs...")
            user_ids = create_users(centre_id, nb_users=3)
            
            # 3. Créer les patients
            print(f"  🏥 Création des patients...")
            patient_ids = create_patients(centre_id, nb_patients=10)
            
            # 4. Créer les rendez-vous
            print(f"  📅 Création des rendez-vous...")
            create_appointments(centre_id, user_ids, patient_ids, nb_appointments=15)
            
            print(f"  ✅ Centre {centre_data['nom']} : Terminé !\n")
        
        print("\n" + "="*60)
        print("✅ INITIALISATION TERMINÉE AVEC SUCCÈS !")
        print("="*60)
        print("\n📊 Résumé :")
        print(f"  • Centres créés : {len(CENTRES_DATA)}")
        print(f"  • Utilisateurs par centre : 3")
        print(f"  • Patients par centre : 10")
        print(f"  • Rendez-vous par centre : 15")
        print(f"\n  Total : {len(CENTRES_DATA)*3} utilisateurs, {len(CENTRES_DATA)*10} patients, {len(CENTRES_DATA)*15} RDV")
        print("\n🎉 La base de données est prête pour la démo !\n")
        
    except Exception as e:
        print(f"\n❌ Erreur lors de l'initialisation : {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)

if __name__ == '__main__':
    main()
