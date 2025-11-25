FROM python:3.11-slim

# Métadonnées
LABEL maintainer="RBSoftwareAI <support@medidesk.fr>"
LABEL version="1.3"
LABEL description="MediDesk Backend API - Gestion médicale pour kinésithérapeutes"

# Variables d'environnement
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Créer répertoire de travail
WORKDIR /app

# Installer dépendances système
RUN apt-get update && apt-get install -y \
    gcc \
    postgresql-client \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copier requirements
COPY requirements.txt .

# Installer dépendances Python
RUN pip install --no-cache-dir -r requirements.txt

# Copier le code de l'application
COPY . .

# Créer répertoires nécessaires
RUN mkdir -p /app/logs /app/uploads /app/backups && \
    chmod -R 755 /app

# Utilisateur non-root pour la sécurité
RUN useradd -m -u 1000 medidesk && \
    chown -R medidesk:medidesk /app
USER medidesk

# Port exposé
EXPOSE 5000

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1

# Point d'entrée
CMD ["python", "start_server.py"]
