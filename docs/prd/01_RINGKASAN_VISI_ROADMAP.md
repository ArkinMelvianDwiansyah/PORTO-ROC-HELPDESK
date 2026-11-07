# PRD 01 — RINGKASAN PRODUK, VISI, PERSONA & ROADMAP FASE
**Versi:** 1.0.0  
**Tanggal:** 2 Oktober 2026  
**Status:** Disetujui  
**Rujukan Dokumen:** [`00_INDEX.md`](file:///d:/ARKIN/tes%20aim/docs/prd/00_INDEX.md)

---

## 1. Visi & Latar Belakang Produk

### 1.1 Pernyataan Masalah (Problem Statement)
Sebagian besar perusahaan skala berkembang dan menengah di Indonesia masih mengelola operasional SDM (Sumber Daya Manusia) secara manual dan terfragmentasi:
1. **Pencatatan Kehadiran Rentan Manipulasi:** Penggunaan kertas atau mesin fingerprint offline sering terhambat oleh antrean fisik, kendala pemadaman listrik, dan ketidakmampuan memvalidasi karyawan lapangan/WFH. Aplikasi pihak ketiga yang ada rentan terhadap manipulasi *fake GPS* dan "titip absen".
2. **Kalkulasi Payroll & Kepatuhan Pajak Sangat Rumit:** Implementasi aturan perpajakan terbaru (PPh 21 skema TER berdasarkan PP 58/2023) serta 5 program BPJS (Kesehatan, JKK, JKM, JHT, JP) membutuhkan ketelitian tinggi. Kesalahan rumus di lembar kerja Excel menyebabkan ketidakpuasan karyawan dan risiko sanksi pajak.
3. **Pengelolaan Cuti & Kontrak yang Tercecer:** Pengajuan cuti lewat chat WhatsApp sering terlewat, saldo cuti tidak terdata secara akuntabel, dan masa berakhirnya kontrak karyawan PKWT sering terlupakan hingga melewati batas waktu evaluasi (risiko hukum kompensasi PP 35/2021).
4. **Keamanan Data & Jejak Audit Lemah:** Dokumen sensitif seperti KTP, NPWP, nomor rekening, dan nominal gaji disimpan dalam folder bersama atau spreadsheet tanpa enkripsi dan tanpa *access log*, melanggar prinsip kepatuhan Undang-Undang Perlindungan Data Pribadi (UU PDP No. 27/2022).

### 1.2 Solusi Produk (Product Solution)
Membangun platform HRIS mandiri (*Single-Tenant Configurable*) berbasis web modern dan Progressive Web App (PWA) untuk Karyawan (*Employee Self-Service* / ESS) yang menggabungkan seluruh siklus hidup kepegawaian dalam satu sistem terpadu:
* **Absensi Mobile PWA Berintegritas:** Validasi jam server, kamera selfie langsung, batasan radius geofencing per cabang, dan deteksi anomali GPS.
* **Mesin Penggajian Otomatis (Compliant Payroll Engine):** Penghitungan instan PPh 21 TER (Kategori A, B, C) + Pasal 17, BPJS TK & BPJS Kesehatan, potongan denda absensi, pinjaman/kasbon, serta ekspor format transfer bank resmi (BCA KlikBCA Bisnis, Mandiri MCM, BRI CMS, BNI Direct).
* **Alur Persetujuan 2-Tingkat Terstandar:** Pengajuan cuti, lembur, absensi, dan reimbursement dengan mekanisme eskalasi dan delegasi.
* **Notifikasi Handal & Aman:** Dukungan In-App, Email SMTP, dan WhatsApp Fonnte dengan perlindungan *anti-banned* dan link slip gaji bertoken tanpa mengekspos angka gaji di pesan publik.

---

## 2. Sasaran Kuantitatif & Indikator Keberhasilan (KPI)

| Indikator | Baseline (Sebelum) | Target HRIS (Setelah Go-Live) |
|---|---|---|
| Waktu Rekap Absensi & Payroll Bulanan | 3–5 hari kerja per periode | < 3 jam kerja (pengurangan > 60%) |
| Tingkat Kesalahan Hitung Payroll | 2% – 5% insiden per bulan | 0% (kalkulasi terverifikasi otomatis) |
| SLA Persetujuan Cuti & Klaim | 2–4 hari | < 24 jam untuk 90% pengajuan |
| Adopsi Pengguna Karyawan (ESS) | Rendah (keberatan instal app berat) | ≥ 85% aktif via browser/PWA dalam 30 hari |
| Insiden Keterlambatan Notifikasi PKWT | Kerap terlewat H-14 | 0 insiden terlewat (alert H-60, H-30, H-7) |

---

## 3. Persona Pengguna

### 3.1 Persona 1: Super Admin / IT Administrator (Budi, 34)
* **Karakteristik:** Bertanggung jawab atas ketersediaan infrastruktur, lisensi, integritas data, dan konfigurasi tingkat sistem.
* **Kebutuhan Utama:**
  * Konfigurasi profil instansi/perusahaan (whitelabeling: logo, nama, NPWP, alamat kantor pusat & cabang).
  * Pengaturan integrasi gateway (SMTP email, token Fonnte WhatsApp, kredensial storage).
  * Pemantauan audit log sistem, session login, backup database, dan *health check* antrean background worker (Redis).
* **Pain Point:** Takut aplikasi tidak stabil saat lonjakan jam absensi pagi hari dan kesulitan melacak log perubahan jika terjadi kebocoran data.

### 3.2 Persona 2: HR Admin / HR Manager (Siti, 29)
* **Karakteristik:** Menangani administrasi harian, penerimaan karyawan baru, mutasi, absensi, cuti, kontrak kerja, dan penutupan payroll bulanan.
* **Kebutuhan Utama:**
  * Impor data karyawan massal via Excel/CSV.
  * Dasbor monitoring absensi *real-time* dan antrean review anomali absen (fake GPS / offline submission).
  * Pengingat otomatis masa berlaku kontrak kerja PKWT dan kalkulator kompensasi PP 35/2021.
  * Kemudahan proses penutupan periode payroll: Draf $\rightarrow$ Simulasi $\rightarrow$ Final $\rightarrow$ Kunci $\rightarrow$ Kirim Slip Gaji massal.
* **Pain Point:** Stres menjelang akhir bulan karena harus mencocokkan lembar absensi fisik/excel dengan denda keterlambatan dan potongan pinjaman.

### 3.3 Persona 3: Line Manager / Atasan Langsung (Hendro, 38)
* **Karakteristik:** Memimpin tim divisi/cabang (10–30 orang) dengan target operasional harian.
* **Kebutuhan Utama:**
  * Notifikasi instan saat bawahan mengajukan cuti, lembur, tukar shift, atau reimbursement.
  * Tampilan kalender cuti tim untuk memastikan operasional tidak kekurangan personil sebelum memberikan approval.
  * Opsi delegasi approval jika dirinya sedang dinas luar atau cuti.
* **Pain Point:** Terlalu banyak pesan WhatsApp pengajuan cuti yang tenggelam di chat personal.

### 3.4 Persona 4: Finance Admin (Dewi, 31)
* **Karakteristik:** Memverifikasi pengeluaran kas perusahaan, klaim reimbursement, dan pencairan gaji bulanan.
* **Kebutuhan Utama:**
  * Review klaim reimbursement dengan nominal di atas ambang batas (*threshold*).
  * Verifikasi rekapitulasi payroll final sebelum periode dikunci.
  * Pengunduhan file transfer massal bank (BCA, Mandiri, dll) yang langsung siap diunggah ke portal *Cash Management*.
  * Pencatatan pencairan reimbursement off-cycle dengan nomor referensi transfer bank.
* **Pain Point:** Format file ekspor sering ditolak oleh sistem bank karena ketidaksesuaian kolom atau delimiter.

### 3.5 Persona 5: Karyawan / ESS User (Rian, 24)
* **Karakteristik:** Karyawan operasional/lapangan yang menggunakan smartphone Android/iOS sehari-hari.
* **Kebutuhan Utama:**
  * Absensi masuk/pulang cepat dalam < 5 detik dengan kamera selfie dan deteksi lokasi otomatis tanpa harus install aplikasi 100MB dari Play Store.
  * Pengajuan cuti, izin sakit (unggah surat dokter), dan lembur langsung dari ponsel.
  * Akses slip gaji digital ber-password kapan saja dengan aman.
  * Notifikasi pengingat shift kerja dan status persetujuan pengajuannya.
* **Pain Point:** Aplikasi HR sebelumnya sering macet (*force close*), boros memori ponsel, dan memotong gaji padahal sudah datang tepat waktu karena jam HP tidak sinkron.

---

## 4. Batasan Ruang Lingkup (Scope Boundaries)

### 4.1 In-Scope (Fokus Rilis)
* Manajemen Perusahaan & Konfigurasi Multi-Cabang (Geofencing GPS).
* Manajemen Kepegawaian Lengkap (PKWT/PKWTT/Magang, Mutasi, Promosi, Kompensasi PP 35/2021).
* Absensi PWA Mobile (Selfie Live Camera, Jam Server, Anti-Fake GPS, Bounded Offline Sync, Shift Normal & 24 Jam).
* Manajemen Cuti & Izin (Ledger Saldo Transaksional, Akrual vs Di Muka, Carry-Over, Integrasi SKB 3 Menteri).
* Payroll Lengkap (PPh 21 skema TER PP 58/2023 + Pasal 17, BPJS TK & Kes, Kasbon Cicilan Otomatis, Slip Gaji PDF, Ekspor Transfer Bank BCA/Mandiri/BRI/BNI).
* Manajemen Klaim & Reimbursement (Plafon Jabatan, Upload Struk, Advance/Settlement, Pencairan Payroll vs Off-cycle).
* Multi-Channel Notification (In-App Bell, Email SMTP, WhatsApp Fonnte dengan *Jitter Queue*).
* RBAC Mendalam, Audit Log Forensik, dan Kepatuhan UU PDP (Enkripsi Data Sensitif).

### 4.2 Out-of-Scope (Bukan Prioritas v1 / Ditunda ke Fase Depan)
* Sistem Rekrutmen Pelamar Penuh (*Full Applicant Tracking System* / ATS publik).
* Integrasi Mesin Fingerprint Fisik SDK C/C++ (Fase 3).
* Verifikasi Biometrik AI Liveness / Face Matching 3D (Fase 2-3, saat ini validasi live camera capture tanpa upload galeri).
* Modul Akuntansi Jurnal Umum Penuh (*General Ledger* / Neraca - sistem hanya menyediakan ekspor jurnal payroll).
* Push Notification Service Worker Web Push & Bot Telegram (Fase 2).

---

## 5. Roadmap Rilis Berfase (Implementation Roadmap)

```mermaid
timeline
    title Roadmap Pengembangan & Rilis HRIS
    section Fase 1 : MVP Inti (Bulan 1 - 3)
        Fondasi & Setup : Laravel 11, Livewire 3, MySQL 8, Redis, Base Layout Tailwind
        Auth & RBAC : Multi-role, Session, Enkripsi Field Sensitif
        Master Data : Data Karyawan, Organisasi, Cabang Geofence, Konfigurasi Perusahaan
        Absensi PWA : Clock In/Out Live Camera, Validasi Jam Server, Shift Normal & Rotasi
        Cuti & Kalender : Saldo Ledger, Pengajuan Cuti/Sakit, Hari Libur Nasional
        Payroll MVP : PPh 21 TER, BPJS, Potongan Absen, Slip Gaji PDF, Ekspor Excel
        Notifikasi Dasar : In-App Bell + Email SMTP
    section Fase 2 : Kepatuhan & Automasi (Bulan 4 - 5)
        Peningkatan Absensi : Deteksi Anomali GPS, Teleportasi, Device Binding, Bounded Offline Sync
        Kepatuhan Kontrak : Peringatan PKWT H-60/30/7, Kalkulator Kompensasi PP 35/2021, Generator Dokumen SK
        Payroll Lanjutan : Modul Kasbon/Cicilan, Formula Lembur Depnaker, Ekspor Bank BCA KlikBCA & Mandiri MCM
        Reimbursement : Plafon Jabatan, Cash Advance & Settlement, Pencairan Off-Cycle
        Integrasi WhatsApp : Fonnte Queue dengan Random Delay & Circuit Breaker Failover
    section Fase 3 : Lanjutan & Optimasi (Bulan 6+)
        Kinerja & Penilaian : Modul KPI / OKR, Penilaian Kinerja 360 Berjenjang
        Inventaris Aset : Peminjaman Laptop/Kendaraan, Serah Terima Clearance Offboarding
        Integrasi Eksternal : Bank API Direct Host-to-Host, e-Bupot 21 DJP, Meta WhatsApp Official API
        Push Notification : Web Push PWA & Integrasi Bot Telegram
```

---

## 6. Pertanyaan Terbuka & Mitigasi Risiko Produk

| Risiko Teridentifikasi | Tingkat Dampak | Rencana Mitigasi |
|---|---|---|
| **Perubahan Formula Pajak/BPJS di Masa Depan** | Tinggi | Formula perhitungan PPh 21 dan tarif BPJS disimpan dalam tabel database berversi (*Versioned Configuration Engine*), bukan ditulis *hardcode* dalam script aplikasi. |
| **Nomor WhatsApp Fonnte Terblokir Akibat Spam** | Tinggi | Menerapkan jeda acak (*jitter* 5–15 detik) pada antrean Redis, batas harian 500 pesan/nomor, himbauan simpan nomor, serta failover otomatis ke In-App dan Email (*Circuit Breaker*). |
| **Karyawan Menggunakan Aplikasi Mock Location (Fake GPS)** | Sedang | Kombinasi pengecekan flag `isMock` browser, validasi akurasi koordinat (radius error > 100m ditolak), deteksi lompatan jarak tidak wajar, dan review wajib HR jika terindikasi anomali. |
