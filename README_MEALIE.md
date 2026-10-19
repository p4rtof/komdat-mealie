# Laporan Proyek Akhir: Instalasi Mealie

**Disusun Oleh:**
- Fadhla (M0403241004)
- Nadia Arifatun Nisa (M0403241028)
- Muhammad Al Fatih (M0403241040) 
- Nadine Putri Agustin (M0403241041)
- Fahira Fasya (M0403241071)

## 1. Dokumentasi Instalasi (VM Lokal)
Bagian ini menjelaskan langkah-langkah untuk menginstal Mealie di Virtual Machine lokal.

### Kebutuhan Sistem
- [Sebutkan OS atau sistem seperti Docker yang digunakan]

### Langkah-langkah Instalasi
1. **Siapkan Direktori Proyek**
   Pertama, buat direktori khusus untuk menyimpan konfigurasi dan data aplikasi Mealie, lalu masuk ke direktori tersebut.
   ```bash
   mkdir -p ~/meali
   cd ~/mealie   

## Konfigurasi
[^ kembali ke atas ^](#aplikasi-web-mealie)

Konfigurasi Mealie diatur di dua tempat: file `docker-compose.yml` di server, dan menu admin di dalam aplikasi. Setiap perubahan pada file `docker-compose.yml` dijalankan dengan perintah berikut. Docker akan membuat ulang container dengan konfigurasi baru, sedangkan data aplikasi tetap aman karena tersimpan di volume.

```
$ docker compose up -d
```
