#!/usr/bin/env python3
"""
Script pour générer les hash de mots de passe pour les comptes MediDesk
"""

from werkzeug.security import generate_password_hash

# Mots de passe des comptes par défaut
passwords = {
    'sadmin@medidesk.local': 'sadmin123',
    'patron@medidesk.local': 'manager123',
    'patient@demo.com': 'patient123',
    'kine@demo.com': 'kine123',
    'coach@demo.com': 'coach123'
}

print("=" * 60)
print("🔐 HASH DE MOTS DE PASSE MEDIDESK")
print("=" * 60)
print()

for email, password in passwords.items():
    hash_pw = generate_password_hash(password)
    print(f"📧 {email}")
    print(f"🔑 Mot de passe: {password}")
    print(f"🔒 Hash: {hash_pw}")
    print()

print("=" * 60)
print("✅ Copier ces hash dans backend/database/schema.sql")
print("=" * 60)
