# Laporan Proyek Akhir: Instalasi Mealie

**Disusun Oleh:**
- Fadhla (M0403241004)
- Nadia Arifatun Nisa (M0403241028)
- Muhammad Al Fatih (M0403241040) 
- Nadine Putri Agustin (M0403241041)
- Fahira Fasya (M0403241071)

## **Sekilas Tentang**

Mealie adalah aplikasi manajemen resep (recipe manager) dan perencanaan menu makanan (meal planner) berbasis web yang bersifat open-source dan self-hosted. Aplikasi ini dirancang menggunakan arsitektur modern dengan FastAPI (Python) pada sisi backend dan Vue.js pada sisi frontend.
Fitur utama Mealie meliputi kemampuan impor resep otomatis hanya dengan, pembuatan rencana makan mingguan secara dinamis, otomatisasi daftar belanjaan, 


## 1. Dokumentasi Instalasi (VM Lokal)
Bagian ini menjelaskan langkah-langkah untuk menginstal Mealie di Virtual Machine lokal.

### Kebutuhan Sistem
- VPS berbasis ubuntu
- Docker versi 20.10.21
- Nginx Proxy Manager
- DNS provider
  

### Langkah-langkah Instalasi
1. **Masuk ke VPS dengan ssh**
``` ssh root@103.160.213.51 ```
   

2. **Siapkan Direktori Proyek**
   Pertama, buat direktori khusus untuk menyimpan konfigurasi dan data aplikasi Mealie, lalu masuk ke direktori tersebut.
   ```bash
   mkdir -p ~/meali
   cd ~/mealie

3. **Buat file konfigurasi**
   ```nano docker-compose.yml```

4. **Isi file docker-compose.yml**
   ```
      version: '3'

   services:'
      mealie:
       image: ghcr.io/mealie-recipes/mealie:latest
       container_name: mealie
       restart: always
       ports:
         - "9000:9000"
       volumes:
         - mealie-data:/app/data/
       environment:
         - ALLOW_SIGNUP=true
         - PUID=1000
         - PGID=1000
         - TZ=Asia/Jakarta
         - BASE_URL=http://mealie.fatihost.web.id

   volumes:
      mealie-data:

   ```

5. **Mengatur DNS (Domain Name System)**

   
6. **jalankan container Docker**
   ```docker-compose up -d```
   
7**Mengarahkan domain ke port website dengan Nginx Proxy Manager**

## Konfigurasi
[^ kembali ke atas ^](#)

* Konfigurasi dasar Mealie diatur melalui file `docker-compose.yml`, meliputi port aplikasi, penyimpanan data, kebijakan restart, dan variabel lingkungan.
```
   version: '3'

   services:
      mealie:
       image: ghcr.io/mealie-recipes/mealie:latest
       container_name: mealie
       restart: always
       ports:
         - "9000:9000"
       volumes:
         - mealie-data:/app/data/
       environment:
         - ALLOW_SIGNUP=true
         - PUID=1000
         - PGID=1000
         - TZ=Asia/Jakarta
         - BASE_URL=http://mealie.fatihost.web.id

   volumes:
      mealie-data:
```

* Port aplikasi. Port host dapat diubah tanpa mengubah port internal Mealie. Pada pengujian, konfigurasi `8080:9000` membuat aplikasi dapat diakses melalui `localhost:8080`.

<img width="1913" height="1065" alt="Screenshot 2026-10-19 124550" src="https://github.com/user-attachments/assets/0eaf78c7-4dba-4e4d-85f2-213d2aa6df63" /> 
<img width="1913" height="1064" alt="Screenshot 2026-10-19 124615" src="https://github.com/user-attachments/assets/69314f07-1ab8-4e4b-a468-126b39ff5723" />
Port 9000 menjadi tidak bisa diakses, baru bisa diakses ketika nomor port host diganti kembali ke 9000.

* Penyimpanan data. Named volume `mealie-data` digunakan untuk mempertahankan data aplikasi. Resep contoh tetap tersedia setelah container dihentikan dan dijalankan kembali.

<img width="1913" height="1065" alt="Screenshot 2026-10-19 124550" src="https://github.com/user-attachments/assets/609a2e80-c0d6-4359-ac2c-174e933ead7c" />
<img width="821" height="88" alt="Screenshot 2026-10-19 201556" src="https://github.com/user-attachments/assets/16cc26a3-fef4-4313-a02d-aa5fb31a7d9b" />

* Restart otomatis. Pengaturan `restart: always` memungkinkan container berjalan kembali setelah Docker dimulai ulang.

<img width="1910" height="1077" alt="Screenshot 2026-10-19 124350" src="https://github.com/user-attachments/assets/febe2827-a9ee-45d1-a902-8b6af2c9d837" /> 

* Batas memori. Batas memori container dapat diatur melalui konfigurasi resource Docker Compose. Pengujian dilakukan dengan menetapkan batas `1000M`.

```
       deploy:
         resources:
           limits:
             memory: 1000M
```
tambahkan di bawah `restart: always`

<img width="1475" height="87" alt="image" src="https://github.com/user-attachments/assets/27867e83-82af-4132-8abc-8d014af80064" />

* Logging. Variabel `LOG_LEVEL=debug` digunakan untuk meningkatkan detail log. Pada pengujian, jumlah baris log meningkat dari 158 menjadi 169.

<img width="1351" height="58" alt="image" src="https://github.com/user-attachments/assets/584151e9-a381-4553-94c6-ceae2e55a599" />
setelah ditambahkan `- LOG_LEVEL=debug` di bawah base_URL
<img width="1342" height="59" alt="image" src="https://github.com/user-attachments/assets/64ccae93-0de8-4141-9697-d21476770f59" />

* Dokumentasi API. Variabel `API_DOCS` digunakan untuk mengatur ketersediaan dokumentasi API. Pada pengujian, halaman `/docs` menampilkan `404 Not Found` ketika fitur dinonaktifkan.

<img width="1913" height="1192" alt="Screenshot 2026-10-19 144657" src="https://github.com/user-attachments/assets/6c266e11-b305-44f1-bbd2-68f1ac8546e3" />
setelah ditambahkan `- API_DOCS=False` di bawah base_URL (default true).
<img width="1914" height="1192" alt="Screenshot 2026-10-19 144809" src="https://github.com/user-attachments/assets/72a110fc-baea-4da9-878b-58f0d191bb2f" /> 

* Kustomisasi tampilan. Variabel `BRANDING_NAME` dapat digunakan untuk mengubah nama aplikasi. Pada pengujian, nama aplikasi menjadi "Resep Kita".

<img width="1918" height="1199" alt="Screenshot 2026-10-19 132949" src="https://github.com/user-attachments/assets/cb264356-76e0-48a7-8328-3e9fb39ddb1b" />

* Manajemen pengguna. Mealie menyediakan pengaturan pengguna dan hak akses melalui menu administrasi. Pengguna biasa tidak dapat membuka halaman Site Settings pada pengujian.

<img width="1914" height="1193" alt="Screenshot 2026-10-19 163331" src="https://github.com/user-attachments/assets/0c31e1a6-c813-40e1-9d67-bc0b4378d40f" />
pengguna dengan username teman_kelompok tidak bisa membuka site settings karena bukan admin
<img width="1896" height="1057" alt="Screenshot 2026-10-19 123048" src="https://github.com/user-attachments/assets/72e26c39-f9ea-4579-8a31-2792211f5a82" />

### Plugin untuk Fungsi Tambahan

* Boorkmarklet impor resep. Bookmarklet memungkinkan pengguna mengimpor resep dari situs lain ke Mealie. Fitur ini berhasil diuji pada situs sumber yang digunakan.
[dokumentasi bookmarklet](https://docs.mealie.io/documentation/community-guide/import-recipe-bookmarklet/)
sesuaikan port -> klik bookmark generator site -> paste kode template yang sudah diganti port nya -> drag hasil bookmarklet nya (yang warnanya biru) ke bilah bookmark browser
<img width="1910" height="1066" alt="image" src="https://github.com/user-attachments/assets/8c95c7a6-1261-44b0-ac06-db7ccafa4f99" />
<img width="1212" height="928" alt="Screenshot 2026-10-19 151951" src="https://github.com/user-attachments/assets/a8189396-7c18-498a-8520-4c7118ff8eda" />

cara add resep ke bookmark: buka website resep yang ingin ditambahkan (tidak semua website mengizinkan, beberapa ada yang memblokir impor) -> pencet bookmarlet yang ada di bilah bookmark (tekan ctrl + shift + B jika tidak muncul) -> klik 'create' -> resep akan diparse ke daftar resep di beranda
<img width="1919" height="1072" alt="image" src="https://github.com/user-attachments/assets/6809c895-9186-4c1a-aed3-7f35c50176a6" />
<img width="1910" height="1068" alt="image" src="https://github.com/user-attachments/assets/100aff80-da10-4653-ba16-806578770bba" />
<img width="1913" height="1071" alt="image" src="https://github.com/user-attachments/assets/ea78df39-c414-4141-8aa2-fa7056b3d51a" />
<img width="1918" height="1071" alt="image" src="https://github.com/user-attachments/assets/8044406b-7085-41c6-aaad-1a2b4e7d9a30" />
