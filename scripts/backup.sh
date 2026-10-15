#!/usr/bin/env bash
# Sauvegarde du site EduAfrica -> dossier local -> Mega
set -euo pipefail

SITE="eduafrica.local"
PROJECT="eduafrica"
CONTAINER="eduafrica-backend-1"
DEST="$HOME/PROJECT/eduafrica-platform/backups"
REMOTE="MegaLimaEduca:EDU_AF_BACKUP"

mkdir -p "$DEST"

echo "[1/3] Création du backup dans le conteneur..."
docker compose -p "$PROJECT" exec -T backend bench --site "$SITE" backup --with-files

echo "[2/3] Copie vers $DEST ..."
docker cp "$CONTAINER:/home/frappe/frappe-bench/sites/$SITE/private/backups/." "$DEST/"

echo "[3/3] Envoi vers Mega ($REMOTE) ..."
rclone copy "$DEST" "$REMOTE"

echo "Terminé. Derniers fichiers :"
ls -1t "$DEST" | head -4
