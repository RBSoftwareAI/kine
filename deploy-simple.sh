#!/bin/bash

# 🚀 Script de déploiement simplifié pour MediDesk
# Usage : ./deploy-simple.sh

set -e

echo "🚀 Déploiement MediDesk sur Firebase Hosting"
echo "=============================================="
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

# Étape 2 : Copier le site vitrine
echo "📋 Étape 2/4 : Copie du site vitrine"
if [ -d "website" ]; then
    cp -r website build/web/
    echo "✅ Site vitrine copié dans build/web/website/"
else
    echo "⚠️  Dossier website/ non trouvé, ignoré"
fi
echo ""

# Étape 3 : Vérification
echo "🔍 Étape 3/4 : Vérification du build"
if [ ! -d "build/web" ]; then
    echo "❌ Le dossier build/web n'existe pas"
    exit 1
fi
echo "✅ Build vérifié"
echo ""

# Étape 4 : Déploiement
echo "🚀 Étape 4/4 : Déploiement sur Firebase"
echo ""
echo "⚠️  Vous devez être connecté à Firebase (firebase login)"
echo "   Appuyez sur Entrée pour continuer ou Ctrl+C pour annuler"
read

firebase deploy --only hosting

echo ""
echo "=============================================="
echo "✅ Déploiement terminé !"
echo "=============================================="
echo ""
echo "🌐 Votre application est accessible sur :"
echo "   📱 Application : https://demo.medidesk.fr"
echo "   🌐 Site vitrine : https://demo.medidesk.fr/website/"
echo ""
echo "   Autres URLs Firebase :"
echo "   • https://kinecare-81f52.web.app"
echo "   • https://kinecare-81f52.firebaseapp.com"
echo ""
