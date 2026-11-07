# PRD 16 — HISTORI CHAT, BRAINSTORMING & REKAM JEJAK KEPUTUSAN DESAIN
**Versi:** 1.0.0  
**Tanggal Rilis:** 2 Oktober 2026  
**Status:** Disetujui (Dokumen Rekam Jejak Percakapan & Musyawarah Desain)  
**Rujukan Dokumen:** [`00_INDEX.md`](file:///d:/ARKIN/tes%20aim/docs/prd/00_INDEX.md)

---

## 1. Latar Belakang Dokumen

Dokumen ini mendokumentasikan secara lengkap seluruh kronologi percakapan, proses wawancara interaktif (*grill-me session*), pertukaran referensi desain antarmuka, hingga proses *peer review* kritis antara Pengguna (Product Owner / Stakeholder) dan Asisten AI (Antigravity).

Tujuan pencatatan ini adalah agar tim pengembang (Claude Code / Software Engineer) dapat memahami **konteks di balik setiap keputusan (*the rationale behind decisions*)**, mengetahui alternatif yang pernah ditolak, serta mencegah terulangnya asumsi keliru saat implementasi kode dimulai.

---

## 2. Kronologi Fase 1: Inisiasi Awal & Arahan `/grill-me`

### 2.1 Prompt Awal Pengguna
* **Input Pengguna:** Pengguna melampirkan draf kasar PRD HRIS v0.2 (bertanggal 2 Oktober 2026) dan memicu perintah `/grill-me mau buat aps pengelolaan karyawan`.
* **Kebutuhan Utama Pengguna:** Membangun aplikasi HRIS yang fokus pada UMKM-menengah Indonesia: data karyawan terpusat, absensi selfie GPS, cuti, shift, penggajian patuh pajak Indonesia (PPh 21 TER, BPJS), reimbursement, dan kalender perusahaan.
* **Instruksi Kritis Pengguna:** Pengguna secara tegas menginstruksikan untuk **tidak langsung membuat kode aplikasi**, melainkan melakukan *brainstorming* terstruktur hingga menghasilkan paket dokumen PRD yang lengkap, komprehensif, dan matang.

---

## 3. Kronologi Fase 2: Wawancara Interaktif & Rekam Keputusan Arsitektur

Melalui serangkaian pertanyaan terarah satu-demi-satu, seluruh percabangan desain disepakati sebagai berikut:

### Putaran 1: Arsitektur Tenancy
* **Pertanyaan:** Apakah aplikasi ditargetkan sebagai SaaS Multi-Tenant publik atau Single-Tenant internal perusahaan?
* **Keputusan Pengguna:** **Single-Tenant / Internal Perusahaan**, namun wajib memiliki pengaturan dinamis (*company settings / whitelabeling*) agar nama, logo, NPWP, dan profil perusahaan dapat disesuaikan per entitas bisnis.

### Putaran 2: Tech Stack & Target Platform
* **Pertanyaan:** Tech stack dan platform apa yang ingin digunakan?
* **Keputusan Pengguna:**
  * **Backend & Web:** Laravel 11 + Livewire 3 + Alpine.js + Tailwind CSS.
  * **Basis Data & Antrean:** MySQL 8.0 + Redis (Queue & Cache).
  * **Platform Karyawan (ESS):** Progressive Web App (PWA) Mobile untuk absensi selfie kamera langsung dan GPS.
  * **Infrastruktur Hosting:** VPS Linux Ubuntu dikelola melalui panel aaPanel.
  * **Gateway WhatsApp:** Fonnte API (menggunakan nomor dan token milik tenant sendiri).

### Putaran 3: Ruang Lingkup Penggajian (Payroll)
* **Pertanyaan:** Bagaimana kedalaman perhitungan payroll yang diinginkan?
* **Keputusan Pengguna:** **Hitung otomatis penuh sesuai hukum Indonesia:** PPh 21 skema Tarif Efektif Rata-Rata (TER) PP 58/2023 + Pasal 17 masa Desember, 5 program BPJS (Ketenagakerjaan: JKK, JKM, JHT, JP; dan BPJS Kesehatan), dengan pilihan metode Gross, Gross-Up, dan Netto.

### Putaran 4: Lokasi Cabang & Shift Kerja
* **Pertanyaan:** Bagaimana skenario kantor dan pola jam kerja pada modul absensi?
* **Keputusan Pengguna:** **Multi-cabang / multi-lokasi** dengan koordinat dan radius geofence masing-masing. Mendukung **Multi-Shift** (shift reguler, rotasi 3 shift 24 jam melintasi tengah malam / *overnight shift*, dan tukar shift antar rekan kerja dengan persetujuan).

### Putaran 5: Alur Persetujuan (Approval Engine)
* **Pertanyaan:** Bagaimana mekanisme alur persetujuan pengajuan karyawan?
* **Keputusan Pengguna:**
  * **Default 2 Tingkat:** Atasan Langsung $\rightarrow$ HR Admin (khusus reimbursement/kasbon diteruskan ke Finance).
  * **Fallback:** Jika karyawan belum memiliki atasan, otomatis langsung ke HR Admin.
  * **Fleksibilitas:** Jumlah tingkat (1 atau 2) dapat diatur per jenis pengajuan oleh HR Admin.
  * **Aturan Batas Nominal (*Threshold*):** Pada reimbursement, klaim di bawah batas cukup atasan; di atas batas wajib ke Finance.
  * **Delegasi & Eskalasi SLA:** Manajer yang cuti dapat mendelegasikan wewenang; tiket yang tidak direspons dalam batas waktu otomatis dieskalasikan.

### Putaran 6: Notifikasi & Integrasi WhatsApp
* **Pertanyaan:** Bagaimana pengaturan kanal notifikasi dan integrasi WhatsApp Fonnte?
* **Keputusan Pengguna:**
  * In-App Bell dan Email SMTP sebagai kanal utama yang selalu aktif.
  * WhatsApp sebagai kanal sekunder opsional menggunakan *Adapter Pattern* (`NotificationChannelInterface`) agar mudah beralih ke Meta Official API di masa depan.
  * Antrean Redis dengan *jitter delay* (jeda acak 5–15 detik), batas 500 pesan/hari/nomor, dan *circuit breaker failover* ke email jika nomor terputus.
  * **Kerahasiaan Slip Gaji via WhatsApp:** Dikirim dalam bentuk tautan aman bertoken dengan masa berlaku (*TTL 72 jam*) dan wajib PIN, **tanpa memuat nominal gaji di badan pesan WhatsApp** demi mematuhi UU PDP No. 27/2022.

### Putaran 7: Manajemen Karyawan & Kontrak PKWT (PP 35/2021)
* **Pertanyaan:** Bagaimana aturan kontrak PKWT dan kepatuhan regulasi ketenagakerjaan?
* **Keputusan Pengguna:** Status PKWT, PKWTT, probation, magang, freelance. Pengingat kontrak H-60, H-30, dan H-7. Pembatasan total masa PKWT maksimal 5 tahun. Kalkulator kompensasi berakhirnya PKWT otomatis $(\text{Masa Kerja}/12 \times \text{Upah})$ sebagai aturan berversi. Riwayat mutasi/promosi tercatat di audit log.

### Putaran 8: Validasi Absensi & Pencegahan Kecurangan (Anti-Fraud)
* **Pertanyaan:** Bagaimana validasi waktu dan penanganan kecurangan absensi?
* **Keputusan Pengguna:** Validasi waktu server mutlak (jam HP diabaikan), kamera selfie langsung (tanpa upload galeri), batasan radius geofence, pengikatan perangkat (*device binding*: 1 akun = 1 HP terdaftar), mode bounded offline di IndexedDB ($\le 24$ jam dengan wajib persetujuan), dan antrean review anomali untuk HR.

### Putaran 9: Payroll Cut-Off, Denda & Ekspor Bank
* **Pertanyaan:** Bagaimana aturan cut-off, lembur, dan pembayaran bank?
* **Keputusan Pengguna:** Cut-off dinamis (misal tanggal 21 s.d. 20), toleransi keterlambatan (grace period 10 menit), formula lembur Depnaker berversi, kasbon cicilan otomatis, slip gaji PDF ber-password, dan ekspor transfer bank utama (BCA KlikBCA Bisnis, Mandiri MCM, disusul BRI CMS dan BNI Direct). Status payroll: Draf $\rightarrow$ Simulasi $\rightarrow$ Final $\rightarrow$ Terkunci.

### Putaran 10: Kebijakan Cuti, Carry-Over & Kalender
* **Pertanyaan:** Bagaimana aturan cuti tahunan dan hari libur nasional?
* **Keputusan Pengguna:** Konfigurasi cuti fleksibel (pemberian penuh 12 hari di muka vs akrual bulanan), carry-over dengan batas waktu kedaluwarsa (misal hangus 31 Maret), saldo cuti dikelola dengan **sistem buku besar transaksional (*ledger pattern*)**, cuti khusus berbayar sesuai UU, dan sinkronisasi libur nasional SKB 3 Menteri di mana hari libur tidak memotong kuota cuti.

### Putaran 11: Modul Reimbursement & Cash Advance
* **Pertanyaan:** Bagaimana pencairan klaim biaya dan plafon?
* **Keputusan Pengguna:** Dua metode pencairan yang bisa dipilih: digabung ke payroll bulanan ATAU transfer langsung off-cycle oleh Finance. Plafon per jabatan, bukti struk wajib maksimal 30 hari, fitur uang muka dinas (*cash advance*) dengan penyelesaian nota (*settlement*).

---

## 4. Kronologi Fase 3: Referensi Desain Visual UI/UX Pengguna

Pengguna mengunggah 10 gambar referensi visual yang menjadi acuan baku sistem desain antarmuka:
1. **Batch 1 (5 Gambar):** *Weihu*, *Weihu zoom*, *Dhub*, *Wavespace*, dan *Uxerflow*.
   * Menetapkan tema visual: **Clean Modern B2B SaaS**, latar belakang *off-white/slate-50* lembut (`#F8FAFC`), sudut membulat lebar (`rounded-2xl` s/d `rounded-3xl`), bayangan sangat halus (*ambient elevation*), warna aksen dominan **Royal Indigo / Violet** (`#4F46E5` / `#6366F1`), dan penggunaan *pill badge* pastel lembut untuk status.
2. **Batch 2 (5 Gambar):** *Stich Corp*, *Finsight*, *Crisply*, *Safetac*, dan *Metalic*.
   * Menetapkan pola komponen antarmuka:
     * *Safetac:* Peta interaktif pemantauan geofence cabang dengan pin lokasi karyawan dan tabel kehadiran *real-time*.
     * *Stich Corp:* Tampilan kalender *timeline Gantt* horizontal untuk memvisualisasikan cuti tim dan shift kerja.
     * *Finsight & Metalic:* Grafik finansial area chart bergradasi lembut, diagram donat beban gaji, dan kartu metrik KPI dengan tren persentase.
     * *Crisply:* Tata letak pengaturan akun dan profil yang bersih, input presisi, tombol aksi kontras, dan sakelar *toggle* modern.

---

## 5. Kronologi Fase 4: Peer-Review Kritis Pengguna & Penambalan Celah

Pada tahapan review draf PRD, Pengguna memberikan evaluasi komprehensif yang menemukan beberapa kesalahan substansi dan celah teknis. Seluruh poin tersebut langsung diselesaikan:

| No | Poin Temuan Pengguna | Masalah Asli | Solusi & Koreksi yang Diterapkan di PRD | Berkas Terdampak |
|---|---|---|---|---|
| **1** | **Salah Tarif PPh 21 TER A** | Bruto Rp 10.423.200 disebut dikenakan TER A 2,0% (Rp 208.464). | Dikoreksi menjadi **tarif 2,50%** sesuai tabel PP 58/2023 (rentang Rp 10.350.001 s.d. 10.700.000), menghasilkan PPh 21 **Rp 260.580**. Gherkin test case diselaraskan. | Dokumen 08 & 14 |
| **2** | **Multiplier Lembur Hari Libur Tertukar** | Skema 5 hari kerja dan 6 hari kerja terbalik pada batas jam pertama 2x. | Dikoreksi sesuai Pasal 31 PP 35/2021: **5 Hari Kerja:** 8 jam pertama 2x, jam ke-9 3x, jam ke-10+ 4x. **6 Hari Kerja:** 7 jam pertama 2x, jam ke-8 3x, jam ke-9+ 4x. | Dokumen 07 & 14 |
| **3** | **Klaim Deteksi `isMock` di Browser** | Dokumen mengklaim browser mengecek flag mock location (tidak ada di Web API). | Menghapus klaim `isMock`. Menggantinya dengan **mesin deteksi heuristik server-side**: uji teleportasi ($v > 100\text{ km/jam}$), *device binding*, *zero-jitter*, dan rekonsiliasi GeoIP. | Dokumen 06 |
| **4** | **Cuti Melahirkan UU KIA 2024** | Cuti melahirkan hanya tertulis 3 bulan flat. | Diperbarui sesuai **UU KIA No. 4/2024**: hak dasar 3 bulan + tambahan s.d. 3 bulan untuk komplikasi medis (upah berjenjang 100% dan 75%) serta hak cuti suami (2+3 hari). | Dokumen 07 |
| **5** | **PIN Slip Gaji Lemah** | PIN kombinasi tanggal lahir + NIK mudah ditebak rekan kerja. | Dirombak total: Karyawan **wajib membuat PIN Rahasia 6-Angka mandiri** (Bcrypt hash). Ditambahkan proteksi *rate-limiting* (3x salah) dan *lockout 15 menit*. | Dokumen 04, 08, 12 |
| **6** | **Skema Database Belum Lengkap** | Tabel `employees` kurang kolom identitas, dan 12 tabel operasional belum ditulis kamus datanya. | Ditambahkan seluruh kolom profil lengkap `employees`, kolom ringkasan payroll, dan didefinisikan kamus data untuk **12 tabel baru** di ERD. | Dokumen 03 |
| **7** | **Kolom Terenkripsi Tidak Bisa Dicari** | NIK terenkripsi AES-256 tidak dapat dicari via SQL `WHERE` dan tidak bisa dipasang `UNIQUE`. | Menerapkan pola **Blind Index (HMAC-SHA256)** pada kolom `nik_bidx` untuk pencarian dan indeks unik. Ditambahkan SOP pencadangan mandiri `APP_KEY`. | Dokumen 03 & 04 |
| **8** | **Header Webhook Fonnte Fiktif** | Mengandalkan header fiktif `X-Fonnte-Signature` yang tidak didukung Fonnte. | Menggantinya dengan **URL Secret Token Acak per Tenant** (`POST /webhook/fonnte/{secret_token}`). | Dokumen 10 & 12 |
| **9** | **Urutan Build Dependensi Terbalik** | Cuti dan Lembur (langkah 6) membutuhkan Approval Engine (langkah 8). | Menggeser **Unified Approval Engine ke Langkah 5** dan **Notifikasi ke Langkah 6** sebelum modul Cuti, Lembur, dan Reimbursement dibangun. | Dokumen 14 |
| **10** | **Inkonsistensi & Komponen Belum Ada** | Belum ada aturan hitung THR, Gross-up TER, dan ekspor bank baru BCA/Mandiri. | Menambahkan modul **THR Permenaker 6/2016**, formula Gross-Up iteratif konvergen, dan format berkas ekspor **4 bank lengkap (BCA, Mandiri, BRI, BNI)**. | Dokumen 08 |

---

## 6. Ringkasan Status Akhir & Rujukan Silang

Dengan terselesaikannya seluruh tahapan di atas:
* Paket PRD kini terdiri dari **16 dokumen resmi** (Dokumen 00 s.d. 14, ditambah Dokumen 16 ini).
* Versi dokumen dinaikkan menjadi **v1.2.0**.
* Dokumen siap menjadi spesifikasi tunggal (*single source of truth*) yang solid bagi tim *engineering* saat fase penulisan kode dimulai.
