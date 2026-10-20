<p align="center">
  <img src="./Screenshots/Logo%20Mealie.png" alt="Logo Mealie" width="150">
</p>

# Laporan Proyek Akhir: Instalasi Mealie

**Mata Kuliah:** Komunikasi Data dan Jaringan Komputer (KDJK)  
**Kelompok:** 7

| NIM | Nama |
| --- | --- |
| M0403241004 | Fadhla |
| M0403241028 | Nadia Arifatun Nisa |
| M0403241040 | Muhammad Al Fatih |
| M0403241041 | Nadine Putri Agustin |
| M0403241071 | Fahira Fasya |

**Aplikasi:** [Mealie](http://mealie.fatihost.web.id)

---

## Daftar Isi

- [Tentang Mealie](#tentang-mealie)
- [Arsitektur dan kebutuhan sistem](#arsitektur-dan-kebutuhan-sistem)
- [Instalasi](#instalasi)
- [Konfigurasi dan hasil pengujian](#konfigurasi-dan-hasil-pengujian)
- [Cara Pemakaian](#cara-pemakaian)
- [Otomatisasi](#otomatisasi)

## Tentang Mealie

Mealie adalah aplikasi manajemen resep dan perencanaan menu berbasis web yang bersifat *open source* dan dapat dipasang di server sendiri (*self-hosted*). Mealie menyediakan fitur untuk menyimpan dan mengimpor resep, merencanakan menu, serta membuat daftar belanja.

Dalam proyek ini, Mealie dijalankan di VM/VPS menggunakan Docker Compose. Domain diarahkan ke aplikasi melalui DNS dan Nginx Proxy Manager.

## Arsitektur dan kebutuhan sistem

Alur akses aplikasi:

```text
Pengguna → Domain/DNS → Nginx Proxy Manager → Mealie di VM/VPS
```

Kebutuhan yang digunakan:

- VM/VPS dengan Ubuntu
- Docker dan Docker Compose
- Domain atau DNS yang mengarah ke server
- Nginx Proxy Manager untuk meneruskan trafik domain ke Mealie

## Instalasi

### 1. Hubungkan ke server

Jalankan SSH dari terminal dan ganti nilai contoh dengan akun serta alamat server yang digunakan:

```bash
ssh <nama-pengguna>@<alamat-ip-server>
```

### 2. Buat direktori kerja

```bash
mkdir -p ~/mealie
cd ~/mealie
```

### 3. Buat konfigurasi Docker Compose

Buat file `compose.yaml`:

```bash
nano compose.yaml
```

Isi file dengan konfigurasi berikut:

```yaml
services:
  mealie:
    image: ghcr.io/mealie-recipes/mealie:v3.28.0
    container_name: mealie
    restart: unless-stopped
    ports:
      - "9925:9000"
    deploy:
      resources:
        limits:
          memory: 1000M
    volumes:
      - ./data:/app/data
    environment:
      ALLOW_SIGNUP: "true"
      PUID: 1000
      PGID: 1000
      TZ: Asia/Jakarta
```

Port `9925` adalah port pada server, sedangkan `9000` adalah port di dalam container. Data aplikasi disimpan pada direktori `./data`.

### 4. Jalankan dan periksa container

```bash
docker compose up -d
docker compose ps
docker compose logs mealie
```

Pastikan container Mealie berjalan. Pada konfigurasi di atas, aplikasi dapat dijangkau dari server melalui port `9925`.

### 5. Arahkan domain melalui DNS dan Nginx Proxy Manager

1. Buat record DNS yang mengarah ke alamat IP server.
2. Di Nginx Proxy Manager, tambahkan *proxy host* untuk domain tersebut.
3. Arahkan *forward hostname/IP* ke server tempat Mealie berjalan dan *forward port* ke `9925`.
4. Simpan konfigurasi, lalu uji akses melalui domain aplikasi.

Jika Nginx Proxy Manager berada di server yang berbeda, gunakan alamat IP server Mealie yang dapat dijangkau dari Nginx Proxy Manager.

## Konfigurasi dan hasil pengujian

### Port aplikasi

Port host dapat dipetakan ke port internal Mealie `9000`. Contohnya, konfigurasi proyek ini menggunakan `9925:9000`, sehingga port yang dituju dari host atau proxy adalah `9925`. Jika port host diubah, gunakan port host yang baru saat mengakses aplikasi.

Pada percobaan awal, port host diubah menjadi `8080` sementara port container tetap `9000`. Bukti percobaan:

![Pemetaan port pada percobaan awal](https://github.com/user-attachments/assets/0eaf78c7-4dba-4e4d-85f2-213d2aa6df63)

![Pengujian akses setelah perubahan port](https://github.com/user-attachments/assets/69314f07-1ab8-4e4b-a468-126b39ff5723)

### Penyimpanan data

Konfigurasi Compose menggunakan bind mount `./data:/app/data` agar data aplikasi disimpan di direktori `data` pada server dan tetap tersedia setelah container dibuat ulang.

Pengujian persistensi sebelumnya dilakukan dengan named volume. Gambar berikut merupakan bukti dari pengujian tersebut; konfigurasi yang digunakan saat ini menyimpan data di `./data`.

![Pengujian penyimpanan data](https://github.com/user-attachments/assets/609a2e80-c0d6-4359-ac2c-174e933ead7c)

![Data tetap tersedia setelah container dijalankan ulang](https://github.com/user-attachments/assets/16cc26a3-fef4-4313-a02d-aa5fb31a7d9b)

### Kebijakan restart

Container menggunakan `restart: unless-stopped`, sehingga Docker akan mencoba menjalankannya kembali setelah berhenti, kecuali container dihentikan secara manual.

Pengujian awal menggunakan `restart: always`:

![Pengujian restart otomatis](https://github.com/user-attachments/assets/febe2827-a9ee-45d1-a902-8b6af2c9d837)

### Batas memori

Batas memori pada konfigurasi ditetapkan sebesar `1000M`:

```yaml
deploy:
  resources:
    limits:
      memory: 1000M
```

![Konfigurasi batas memori](https://github.com/user-attachments/assets/27867e83-82af-4132-8abc-8d014af80064)

### Logging

`LOG_LEVEL=debug` digunakan saat pengujian untuk menampilkan log yang lebih terperinci. Pada hasil pengujian, jumlah baris log berubah dari 158 menjadi 169.

![Log sebelum pengaturan debug](https://github.com/user-attachments/assets/584151e9-a381-4553-94c6-ceae2e55a599)

![Log setelah pengaturan debug](https://github.com/user-attachments/assets/64ccae93-0de8-4141-9697-d21476770f59)

### Dokumentasi API

Pada pengujian, dokumentasi API dinonaktifkan menggunakan `API_DOCS=False`. Halaman `/docs` kemudian menampilkan `404 Not Found`.

![Dokumentasi API sebelum dinonaktifkan](https://github.com/user-attachments/assets/6c266e11-b305-44f1-bbd2-68f1ac8546e3)

![Dokumentasi API setelah dinonaktifkan](https://github.com/user-attachments/assets/72a110fc-baea-4da9-878b-58f0d191bb2f)

### Kustomisasi nama aplikasi

`BRANDING_NAME` dapat digunakan untuk mengubah nama yang ditampilkan pada aplikasi. Pada pengujian, nama aplikasi diubah menjadi **Resep Kita**.

![Nama aplikasi setelah dikustomisasi](https://github.com/user-attachments/assets/cb264356-76e0-48a7-8328-3e9fb39ddb1b)

### Manajemen pengguna

Pengaturan pengguna dan hak akses tersedia melalui menu administrasi. Pada pengujian, pengguna non-admin tidak dapat membuka halaman **Site Settings**.

![Pengaturan pengguna](https://github.com/user-attachments/assets/0c31e1a6-c813-40e1-9d67-bc0b4378d40f)

![Halaman Site Settings](https://github.com/user-attachments/assets/72e26c39-f9ea-4579-8a31-2792211f5a82)

## Cara Pemakaian

Mealie merupakan aplikasi manajemen resep berbasis web yang memudahkan pengguna untuk menyimpan, mengelola, dan merencanakan menu makanan. Berikut tahapan penggunaan Mealie beserta fitur-fitur pendukungnya.

### 1. Login dan Akses Awal

#### a. Login

Pengguna yang telah memiliki akun dapat masuk ke aplikasi Mealie melalui halaman login.

![Halaman Login Mealie](./Screenshots/Login%20dan%20akses%20awal/mealie-login.png)

#### b. Registrasi dan Akses Grup

Pengguna yang belum memiliki akun dapat melakukan registrasi melalui halaman yang tersedia. Pada halaman tersebut, pengguna dapat memilih **Join a Group** untuk bergabung dengan grup atau **Create a New Group** untuk membuat grup baru.

![Halaman Registrasi Mealie](./Screenshots/Login%20dan%20akses%20awal/mealie-registration.png)

#### c. Dashboard

Setelah berhasil masuk, pengguna akan diarahkan ke dashboard sebagai halaman utama untuk mengakses fitur Mealie.

![Dashboard Mealie](./Screenshots/Login%20dan%20akses%20awal/mealie-dashboard.png)

### 2. Melihat dan Menambahkan Resep

#### a. Melihat Detail Resep

Pengguna dapat membuka resep yang tersedia untuk melihat informasi resep, termasuk bahan-bahan dan langkah pembuatannya.

![Detail Resep](./Screenshots/Melihat%20dan%20menambahkan%20resep/mealie-recipe-detail.png)

#### b. Memilih Metode Penambahan Resep

Melalui menu **Create**, pengguna dapat memilih untuk membuat resep secara manual atau mengimpor resep menggunakan URL.

![Menu Metode Pembuatan Resep](./Screenshots/Melihat%20dan%20menambahkan%20resep/mealie-metode-create-menu.png)

#### c. Membuat Resep Secara Manual

Pengguna dapat memasukkan informasi resep melalui formulir yang tersedia, termasuk bahan-bahan yang dibutuhkan.

![Form Penambahan Resep](./Screenshots/Melihat%20dan%20menambahkan%20resep/mealie-add-recipe.png)

![Form Bahan Resep Manual](./Screenshots/Melihat%20dan%20menambahkan%20resep/mealie-create-manual-ingredients.png)

#### d. Mengimpor Resep dari URL

Pengguna dapat memasukkan URL halaman resep dari situs web. Setelah URL diproses, pengguna dapat meninjau ringkasan hasil parsing dan memeriksa bahan-bahan yang dikenali sebelum melihat hasil impor di aplikasi.

Pada pengujian ini, URL resep **Es Teler** dari [Cookpad](https://cookpad.com/id/resep/26277768) digunakan sebagai sumber impor.

1. Memasukkan URL resep:

   ![Memasukkan URL resep](./Screenshots/Import%20URL/mealie-import-url.png)

2. Meninjau ringkasan hasil parsing:

   ![Ringkasan hasil parsing resep](./Screenshots/Import%20URL/mealie-import-parsed-summary.png)

3. Memeriksa bahan resep:

   ![Meninjau bahan resep](./Screenshots/Import%20URL/mealie-import-ingredient-review.png)

4. Melihat hasil impor:

   ![Hasil resep yang diimpor](./Screenshots/Import%20URL/mealie-import-recipe-result.png)

### 3. Fitur Pendukung

Selain melihat, membuat, dan mengimpor resep, Mealie menyediakan fitur pendukung untuk membantu pengguna mengatur resep serta merencanakan aktivitas memasak.

#### a. Recipes

Menu Recipes menampilkan resep yang tersimpan di Mealie. Pengguna dapat membuka resep untuk melihat bahan dan langkah pembuatannya.

![Detail resep di Mealie](./Screenshots/Melihat%20dan%20menambahkan%20resep/mealie-recipe-detail.png)

#### b. Recipe Finder

Recipe Finder membantu pengguna mencari resep yang tersedia di dalam aplikasi.

![Recipe Finder](./Screenshots/Fitur%20Pendukung/mealie-recipe-finder.png)

#### c. Meal Planner

Meal Planner digunakan untuk menyusun dan melihat rencana menu berdasarkan jadwal.

![Meal Planner](./Screenshots/Fitur%20Pendukung/mealie-meal-planner.png)

#### d. Shopping Lists

Shopping Lists membantu pengguna menyusun daftar belanja bahan makanan.

![Shopping Lists](./Screenshots/Fitur%20Pendukung/mealie-shopping-lists.png)

#### e. Timeline

Timeline menampilkan informasi aktivitas berdasarkan urutan waktu sesuai informasi yang tersedia di aplikasi.

![Timeline](./Screenshots/Fitur%20Pendukung/mealie-timeline.png)

#### f. Cookbooks

Cookbooks menampilkan kumpulan resep yang disusun dalam buku resep.

![Cookbooks](./Screenshots/Fitur%20Pendukung/mealie-cookbooks.png)

#### g. Organizers

Organizers menyediakan halaman Categories, Tags, dan Tools untuk mengatur informasi resep.

**Categories**

![Categories](./Screenshots/Fitur%20Pendukung/mealie-organizers-categories.png)

**Tags**

![Tags](./Screenshots/Fitur%20Pendukung/mealie-organizers-tags.png)

**Tools**

![Tools](./Screenshots/Fitur%20Pendukung/mealie-organizers-tools.png)

## Otomatisasi

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
