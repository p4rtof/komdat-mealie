### Otomatisasi
^ kembali ke atas ^

Untuk mempermudah pengelolaan dan perawatan aplikasi Mealie di VPS, kami menerapkan dua bentuk otomatisasi:

**1. Script Manajemen Interaktif (`manage.sh`)**

Kami membuat *script* shell interaktif untuk menyederhanakan perintah perawatan. Admin server hanya perlu menjalankan `./manage.sh` dan memilih angka untuk melakukan *Start, Stop, Update*, atau *Backup* tanpa harus mengetik perintah Docker secara manual.

```bash
#!/bin/bash
echo "=== Otomatisasi Mealie ==="
echo "1. Start | 2. Stop | 3. Update | 4. Backup"
read -p "Pilih menu (1-4): " menu

case $menu in
    1) docker compose up -d ;;
    2) docker compose down ;;
    3) docker compose pull && docker compose up -d ;;
    4) docker run --rm -v mealie_data:/volume -v $(pwd):/backup alpine tar -cvf /backup/mealie_backup_$(date +%F).tar /volume ;;
    *) echo "Pilihan salah." ;;
esac
```
**2. Backup Otomatis Terjadwal (Cron Job)**

Agar data resep selalu aman, kami mengotomatiskan proses backup menggunakan cron. Sistem diatur untuk otomatis membuat arsip data Mealie setiap hari Minggu pukul 02:00 pagi.

Cara mengaktifkannya, jalankan `crontab -e` di terminal VPS dan tambahkan baris berikut:

```bash
0 2 * * 0 docker run --rm -v mealie_data:/volume -v /home/username/mealie:/backup alpine tar -cvf /backup/mealie_backup_$(date +\%F).tar /volume
```
