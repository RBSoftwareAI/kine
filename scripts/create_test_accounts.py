#!/usr/bin/env python3
"""
Script pour créer les comptes de test Firebase Auth + Firestore
pour les utilisateurs affichés sur l'écran de connexion
"""

import sys
from datetime import datetime

try:
    import firebase_admin
    from firebase_admin import credentials, firestore, auth
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

# Récupérer les IDs des centres existants
def get_centre_by_name(name):
    """Récupérer un centre par son nom"""
    centres = db.collection('centres').where('nom', '==', name).limit(1).get()
    if centres:
        return centres[0].id
    return None

# Comptes de test à créer
TEST_ACCOUNTS = [
    {
        'email': 'marie.lefebvre@kine-paris.fr',
        'password': 'password123',
        'nom': 'Lefebvre',
        'prenom': 'Marie',
        'specialite': 'Kinésithérapeute',
        'centre_name': 'Cabinet Kiné Paris Centre',
        'role': 'admin',
    },
    {
        'email': 'pierre.girard@osteo-lyon.fr',
        'password': 'password123',
        'nom': 'Girard',
        'prenom': 'Pierre',
        'specialite': 'Ostéopathe',
        'centre_name': 'Centre Ostéo Lyon',
        'role': 'admin',
    },
]

def create_test_account(account_data):
    """Créer un compte de test dans Firebase Auth et Firestore"""
    email = account_data['email']
    password = account_data['password']
    
    # 1. Récupérer le centre_id
    centre_id = get_centre_by_name(account_data['centre_name'])
    if not centre_id:
        print(f"❌ Centre '{account_data['centre_name']}' non trouvé")
        return False
    
    try:
        # 2. Créer ou récupérer le compte Firebase Auth
        try:
            user = auth.create_user(
                email=email,
                password=password,
                display_name=f"{account_data['prenom']} {account_data['nom']}",
            )
            print(f"  ✅ Compte Firebase Auth créé : {email} (UID: {user.uid})")
        except auth.EmailAlreadyExistsError:
            user = auth.get_user_by_email(email)
            print(f"  ℹ️  Compte Firebase Auth existe déjà : {email} (UID: {user.uid})")
        
        # 3. Créer ou mettre à jour l'utilisateur dans Firestore
        user_ref = db.collection('users').document(user.uid)
        user_doc = user_ref.get()
        
        user_data = {
            'centre_id': centre_id,
            'nom': account_data['nom'],
            'prenom': account_data['prenom'],
            'email': email,
            'role': account_data['role'],
            'specialite': account_data['specialite'],
            'numero_ordre': None,
            'actif': True,
            'date_creation': firestore.SERVER_TIMESTAMP if not user_doc.exists else user_doc.get('date_creation'),
            'date_modification': firestore.SERVER_TIMESTAMP if user_doc.exists else None,
            'derniere_connexion': None,
        }
        
        user_ref.set(user_data)
        
        if user_doc.exists:
            print(f"  ✅ Utilisateur Firestore mis à jour : {account_data['prenom']} {account_data['nom']}")
        else:
            print(f"  ✅ Utilisateur Firestore créé : {account_data['prenom']} {account_data['nom']}")
        
        return True
        
    except Exception as e:
        print(f"  ❌ Erreur lors de la création du compte {email} : {e}")
        return False

def main():
    """Créer tous les comptes de test"""
    print("\n🔧 Création des comptes de test pour MediDesk Demo\n")
    
    success_count = 0
    for account in TEST_ACCOUNTS:
        print(f"\n📝 Traitement du compte : {account['email']}")
        if create_test_account(account):
            success_count += 1
    
    print(f"\n✅ {success_count}/{len(TEST_ACCOUNTS)} comptes créés avec succès")
    print("\n🎯 Comptes de test disponibles :")
    for account in TEST_ACCOUNTS:
        print(f"  - {account['email']} / {account['password']}")
    print()

if __name__ == '__main__':
    main()
