#!/bin/bash
# Script backup otomatis Mealie (dijalankan oleh cron)

DIR="$HOME/mealie"
BACKUP_DIR="$HOME/mealie-backup"
SIMPAN_HARI=7

mkdir -p "$BACKUP_DIR"

FILE="$BACKUP_DIR/mealie-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
tar -czf "$FILE" -C "$DIR" data compose.yaml
echo "$(date '+%Y-%m-%d %H:%M:%S') Backup dibuat: $FILE"

# Hapus backup yang lebih lama dari $SIMPAN_HARI hari
find "$BACKUP_DIR" -name "mealie-backup-*.tar.gz" -mtime +"$SIMPAN_HARI" -delete
echo "$(date '+%Y-%m-%d %H:%M:%S') Backup lama (> $SIMPAN_HARI hari) dibersihkan."
