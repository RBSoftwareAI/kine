#!/bin/bash

# 🚀 Script de déploiement Firebase Hosting pour MediDesk
# Usage : ./deploy.sh [FIREBASE_TOKEN]

set -e  # Arrêter en cas d'erreur

echo "🚀 Déploiement MediDesk sur Firebase Hosting"
echo "=============================================="
echo ""

# Couleurs pour les messages
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Vérifier si le token Firebase est fourni
if [ -z "$1" ] && [ -z "$FIREBASE_TOKEN" ]; then
    echo -e "${RED}❌ Erreur : Token Firebase manquant${NC}"
    echo ""
    echo "Usage :"
    echo "  ./deploy.sh VOTRE_TOKEN_FIREBASE"
    echo "  ou"
    echo "  export FIREBASE_TOKEN='votre_token' && ./deploy.sh"
    echo ""
    echo "Pour générer un token :"
    echo "  firebase login:ci"
    exit 1
fi

# Utiliser le token fourni en argument ou la variable d'environnement
TOKEN=${1:-$FIREBASE_TOKEN}

echo -e "${BLUE}📦 Étape 1/4 : Installation des dépendances Flutter${NC}"
flutter pub get
echo -e "${GREEN}✅ Dépendances installées${NC}"
echo ""

echo -e "${BLUE}🔨 Étape 2/4 : Build Flutter Web (Release)${NC}"
flutter build web --release
echo -e "${GREEN}✅ Build réussi${NC}"
echo ""

echo -e "${BLUE}📊 Étape 3/4 : Vérification du build${NC}"
if [ ! -d "build/web" ]; then
    echo -e "${RED}❌ Erreur : Le dossier build/web n'existe pas${NC}"
    exit 1
fi

BUILD_SIZE=$(du -sh build/web | cut -f1)
echo -e "${GREEN}✅ Build prêt (Taille : $BUILD_SIZE)${NC}"
echo ""

echo -e "${BLUE}🚀 Étape 4/4 : Déploiement sur Firebase Hosting${NC}"
firebase deploy --only hosting --token "$TOKEN"

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}=============================================="
    echo -e "✅ Déploiement réussi !"
    echo -e "==============================================\n${NC}"
    echo ""
    echo "🌐 Votre application est accessible sur :"
    echo "   • https://kinecare-81f52.web.app"
    echo "   • https://kinecare-81f52.firebaseapp.com"
    echo ""
    echo "📝 Pour configurer le domaine personnalisé demo.medidesk.fr :"
    echo "   1. Firebase Console → Hosting → Domaines personnalisés"
    echo "   2. Ajouter : demo.medidesk.fr"
    echo "   3. Configurer les enregistrements DNS fournis"
    echo ""
    echo "📚 Documentation complète : DEPLOIEMENT_FIREBASE.md"
    echo ""
else
    echo ""
    echo -e "${RED}=============================================="
    echo -e "❌ Erreur lors du déploiement"
    echo -e "==============================================\n${NC}"
    echo ""
    echo "🔍 Vérifications :"
    echo "   • Token Firebase valide ?"
    echo "   • Connexion internet ?"
    echo "   • Projet kinecare-81f52 accessible ?"
    echo ""
    echo "💡 Pour régénérer un token :"
    echo "   firebase login:ci"
    exit 1
fi
