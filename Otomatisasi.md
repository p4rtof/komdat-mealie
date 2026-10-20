# Otomatisasi Mealie

Agar pengelolaan Mealie tidak perlu mengetik perintah berulang kali, tersedia dua script shell:

- `mealie-manage.sh`: menu interaktif untuk menjalankan, menghentikan, memeriksa, mem-backup, dan me-restore Mealie.
- `mealie-backup.sh`: backup otomatis tanpa menu (dijalankan oleh cron). Yang dicadangkan adalah folder `data` dan file `compose.yaml`, disimpan di `~/mealie-backup`. Backup yang lebih tua dari 7 hari dihapus otomatis.

## Script Pengelolaan Interaktif

Salin kedua script ke direktori `~/mealie`, lalu beri izin eksekusi dan jalankan:

```bash
cd ~/mealie
chmod +x mealie-manage.sh mealie-backup.sh
./mealie-manage.sh
```

Menu yang tersedia:

| Pilihan | Fungsi |
|---|---|
| 1 | Jalankan Mealie |
| 2 | Hentikan Mealie |
| 3 | Restart Mealie |
| 4 | Lihat status container |
| 5 | Lihat log Mealie |
| 6 | Buat backup sekarang |
| 7 | Lihat daftar backup |
| 8 | Restore dari backup |
| 0 | Keluar |

## Backup Otomatis dengan Cron

Uji script backup secara manual terlebih dahulu:

```bash
~/mealie/mealie-backup.sh
ls -lh ~/mealie-backup
```

Lalu buka crontab dengan `crontab -e` dan tambahkan baris berikut (ganti `<nama-pengguna>` dengan nama pengguna di server):

```
0 2 * * * /home/<nama-pengguna>/mealie/mealie-backup.sh >> /home/<nama-pengguna>/mealie-backup/backup.log 2>&1
```

Artinya backup dijalankan **setiap hari pukul 02.00** (mengikuti jam server), dan hasilnya dicatat di `backup.log`. Periksa jadwal yang aktif dengan:

```bash
crontab -l
```

## Catatan

- Untuk menguji cron tanpa menunggu pukul 02.00, ubah jadwal sementara menjadi `* * * * *` (tiap menit), cek `ls -lh ~/mealie-backup`, lalu kembalikan ke `0 2 * * *`.
- Salinan backup sebaiknya juga disimpan di luar server, misalnya diunduh dengan `scp`.
