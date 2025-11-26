#!/bin/bash

# 🚀 Script de déploiement multi-sites pour MediDesk
# Usage : ./deploy-multi-sites.sh

set -e

echo "🚀 Déploiement Multi-Sites MediDesk"
echo "===================================="
echo ""

# Vérifier que Firebase CLI est installé
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI n'est pas installé"
    echo "   Installez-le avec : npm install -g firebase-tools"
    exit 1
fi

echo "✅ Firebase CLI détecté"
echo ""

# Étape 1 : Build Flutter
echo "📦 Étape 1/3 : Build Flutter Web"
flutter pub get
flutter build web --release
echo "✅ Build réussi"
echo ""

# Étape 2 : Déployer le site vitrine (medidesk.fr)
echo "🌐 Étape 2/3 : Déploiement du site vitrine"
echo "   Cible : medidesk.fr"
echo ""
echo "⚠️  Vous devez être connecté à Firebase (firebase login)"
echo "   Appuyez sur Entrée pour continuer ou Ctrl+C pour annuler"
read

firebase deploy --only hosting:website --project kinecare-81f52
echo "✅ Site vitrine déployé"
echo ""

# Étape 3 : Déployer l'application (demo.medidesk.fr)
echo "📱 Étape 3/3 : Déploiement de l'application"
echo "   Cible : demo.medidesk.fr"
echo ""

firebase deploy --only hosting:app --project kinecare-81f52
echo "✅ Application déployée"
echo ""

echo "============================================"
echo "✅ Déploiement Multi-Sites terminé !"
echo "============================================"
echo ""
echo "🌐 Vos URLs :"
echo "   📄 Site vitrine : https://medidesk.fr"
echo "   📱 Application   : https://demo.medidesk.fr"
echo ""
echo "📊 Firebase Console :"
echo "   https://console.firebase.google.com/project/kinecare-81f52/hosting/sites"
echo ""
