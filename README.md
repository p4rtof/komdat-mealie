# Laporan Proyek Akhir: Instalasi Mealie

**Mata Kuliah:** Komunikasi Data dan Jaringan Komputer (KDJK) · **Kelompok:** 8

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
- [Cara Pemakaian](#cara-pemakaian)
  - [Login dan akses awal](#login-dan-akses-awal)
  - [Melihat dan menambahkan resep](#melihat-dan-menambahkan-resep)
  - [Impor resep dari URL](#impor-resep-dari-url)
  - [Bookmarklet untuk impor resep](#bookmarklet-untuk-impor-resep)
  - [Fitur pendukung](#fitur-pendukung)
- [Konfigurasi dan hasil pengujian](#konfigurasi-dan-hasil-pengujian)
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

## Cara Pemakaian

Bagian ini menjelaskan alur penggunaan Mealie setelah aplikasi berhasil dipasang dan dapat diakses melalui domain.

### Login dan akses awal

1. Buka domain Mealie melalui browser.
2. Masuk menggunakan akun yang sudah dibuat. Jika pendaftaran diaktifkan, buat akun melalui halaman pendaftaran.
3. Setelah login, dashboard menampilkan halaman utama aplikasi.

![Halaman login Mealie](./Images/Login%20dan%20akses%20awal/mealie-login.png)

![Halaman pendaftaran Mealie](./Images/Login%20dan%20akses%20awal/mealie-registration.png)

![Dashboard Mealie](./Images/Login%20dan%20akses%20awal/mealie-dashboard.png)

### Melihat dan menambahkan resep

1. Buka menu pembuatan resep dari dashboard.
2. Pilih metode pembuatan resep secara manual.
3. Isi nama resep dan informasi yang tersedia, seperti bahan serta langkah memasak.
4. Simpan resep, lalu buka resep tersebut untuk melihat detailnya.

![Menu untuk membuat resep](./Images/Melihat%20dan%20menambahkan%20resep/mealie-metode-create-menu.png)

![Formulir untuk menambahkan resep](./Images/Melihat%20dan%20menambahkan%20resep/mealie-add-recipe.png)

![Formulir untuk menambahkan bahan resep](./Images/Melihat%20dan%20menambahkan%20resep/mealie-create-manual-ingredients.png)

![Halaman detail resep](./Images/Melihat%20dan%20menambahkan%20resep/mealie-recipe-detail.png)

### Impor resep dari URL

Mealie dapat mengambil resep dari URL situs sumber. Hasil impor dapat ditinjau dan disesuaikan sebelum disimpan. Tidak semua situs mendukung proses impor.

1. Buka menu impor resep.
2. Masukkan URL halaman resep.
3. Tinjau bahan dan informasi resep yang berhasil dibaca.
4. Simpan resep ke Mealie.

![Memasukkan URL resep](./Images/Import%20URL/mealie-import-url.png)

![Meninjau bahan hasil impor](./Images/Import%20URL/mealie-import-ingredient-review.png)

![Ringkasan hasil pembacaan resep](./Images/Import%20URL/mealie-import-parsed-summary.png)

![Resep yang sudah diimpor](./Images/Import%20URL/mealie-import-recipe-result.png)

### Bookmarklet untuk impor resep

Bookmarklet dapat digunakan untuk memulai impor resep langsung dari halaman situs sumber.

1. Buka [dokumentasi bookmarklet Mealie](https://docs.mealie.io/documentation/community-guide/import-recipe-bookmarklet/) dan buat bookmarklet sesuai alamat Mealie yang digunakan.
2. Tambahkan bookmarklet ke bilah bookmark browser.
3. Buka halaman resep yang ingin diimpor, lalu klik bookmarklet.
4. Tinjau hasil impor di Mealie dan simpan resep jika hasilnya sudah sesuai.

Keberhasilan impor bergantung pada situs sumber; beberapa situs membatasi pengambilan resep.

### Fitur pendukung

Berikut beberapa fitur Mealie yang tersedia untuk membantu pengelolaan resep dan perencanaan makanan.

#### Perencana menu

![Perencana menu Mealie](./Images/Fitur%20Pendukung/mealie-meal-planner.png)

#### Daftar belanja

![Daftar belanja Mealie](./Images/Fitur%20Pendukung/mealie-shopping-lists.png)

#### Kategori dan tag resep

![Kategori resep Mealie](./Images/Fitur%20Pendukung/mealie-organizers-categories.png)

![Tag resep Mealie](./Images/Fitur%20Pendukung/mealie-organizers-tags.png)

#### Buku resep

![Buku resep Mealie](./Images/Fitur%20Pendukung/mealie-cookbooks.png)

#### Pencarian dan alat pengelolaan resep

![Pencarian resep Mealie](./Images/Fitur%20Pendukung/mealie-recipe-finder.png)

![Alat pengelolaan resep Mealie](./Images/Fitur%20Pendukung/mealie-organizers-tools.png)

#### Linimasa

![Linimasa Mealie](./Images/Fitur%20Pendukung/mealie-timeline.png)

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

## Otomatisasi

Dokumentasi pengelolaan dan backup otomatis tersedia di [Otomatisasi.md](./Otomatisasi.md). Dokumen tersebut membahas script pengelolaan interaktif dan penjadwalan backup menggunakan cron.
