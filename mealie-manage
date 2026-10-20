#!/bin/bash
# Script pengelolaan Mealie (menu interaktif)

DIR="$HOME/mealie"
BACKUP_DIR="$HOME/mealie-backup"

cd "$DIR" || { echo "Direktori $DIR tidak ditemukan."; exit 1; }
mkdir -p "$BACKUP_DIR"

buat_backup() {
    FILE="$BACKUP_DIR/mealie-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
    tar -czf "$FILE" -C "$DIR" data compose.yaml
    echo "Backup berhasil dibuat: $FILE"
}

restore_backup() {
    echo "Daftar backup yang tersedia:"
    ls -1 "$BACKUP_DIR"/*.tar.gz 2>/dev/null || { echo "Belum ada backup."; return; }
    read -rp "Ketik nama file backup (tanpa path): " NAMA
    if [ ! -f "$BACKUP_DIR/$NAMA" ]; then
        echo "File tidak ditemukan."
        return
    fi
    read -rp "Data saat ini akan ditimpa. Lanjutkan? (y/N): " YAKIN
    if [ "$YAKIN" = "y" ]; then
        docker compose down
        tar -xzf "$BACKUP_DIR/$NAMA" -C "$DIR"
        docker compose up -d
        echo "Restore selesai."
    else
        echo "Restore dibatalkan."
    fi
}

while true; do
    echo ""
    echo "========== MENU MEALIE =========="
    echo "1) Jalankan Mealie"
    echo "2) Hentikan Mealie"
    echo "3) Restart Mealie"
    echo "4) Lihat status container"
    echo "5) Lihat log Mealie"
    echo "6) Buat backup sekarang"
    echo "7) Lihat daftar backup"
    echo "8) Restore dari backup"
    echo "0) Keluar"
    echo "================================="
    read -rp "Pilih menu: " PILIHAN

    case "$PILIHAN" in
        1) docker compose up -d ;;
        2) docker compose down ;;
        3) docker compose restart ;;
        4) docker compose ps ;;
        5) docker compose logs --tail 50 mealie ;;
        6) buat_backup ;;
        7) ls -lh "$BACKUP_DIR" ;;
        8) restore_backup ;;
        0) echo "Keluar."; exit 0 ;;
        *) echo "Pilihan tidak valid." ;;
    esac
done
Mealie manage
