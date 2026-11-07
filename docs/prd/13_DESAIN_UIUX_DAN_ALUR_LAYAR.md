# PRD 13 — DESAIN UI/UX, SISTEM DESAIN & ALUR LAYAR ANTARMUKA
**Versi:** 1.2.0  
**Tanggal:** 2 Oktober 2026  
**Status:** Disetujui (Telah Dilengkapi dengan Alur Detail Layar-per-Layar Kritis)  
**Rujukan Dokumen:** [`00_INDEX.md`](file:///d:/ARKIN/tes%20aim/docs/prd/00_INDEX.md), [`02_ARSITEKTUR_DAN_TECH_STACK.md`](file:///d:/ARKIN/tes%20aim/docs/prd/02_ARSITEKTUR_DAN_TECH_STACK.md), [`06_MODUL_ABSENSI_PWA_SHIFT_ANTI_FRAUD.md`](file:///d:/ARKIN/tes%20aim/docs/prd/06_MODUL_ABSENSI_PWA_SHIFT_ANTI_FRAUD.md)

---

## 1. Filosofi & Karakter Visual Antarmuka

Antarmuka mengadopsi gaya **Modern Clean B2B SaaS** terinspirasi dari referensi visual yang disetujui:
1. **Latar Berlapis Lembut:** Kanvas abu-abu sangat lembut (`#F8FAFC`), kartu putih bersih (`#FFFFFF`) dengan sudut membulat lebar (`rounded-2xl` s/d `rounded-3xl`).
2. **Elevasi Halus:** Bayangan kartu ambient lembut (`box-shadow: 0 4px 25px -4px rgba(0, 0, 0, 0.04)`) dipadu garis tepi mikro (`border border-slate-200/60`).
3. **Warna Aksen:** Royal Indigo / Violet (`#4F46E5` / `#6366F1`) untuk aksi primer, didukung status pastel (*emerald* untuk hadir/approved, *amber* untuk pending/terlambat, *rose* untuk anomali/urgent).

---

## 2. Alur Layar Kritis Rinci (Screen-by-Screen Wireflows)

### 2.1 Alur Layar 1: Absensi Masuk (Clock-In) PWA Mobile
Layar utama saat karyawan membuka tab "Absen" di ponsel:

```text
+------------------------------------------+
|  [Logo] PT Maju Bersama        [GPS: OK] |
|  Senin, 2 Oktober 2026 - 07:54 WIB       |
+------------------------------------------+
|  [KARTU STATUS KEHADIRAN]                |
|  Status Hari Ini: Belum Hadir            |
|  Jadwal Shift: 08:00 - 17:00 (Pagi)      |
+------------------------------------------+
|                                          |
|        +------------------------+        |
|        |                        |        |
|        |    [ KAMERA DEPAN ]    |        |
|        |   Viewfinder Selfie    |        |
|        |                        |        |
|        +------------------------+        |
|                                          |
|   (•) Lokasi: Kantor Pusat (Jarak: 35m)  |
|   Akurasi Sinyal GPS: +/- 12m [Aman]     |
|                                          |
|   Mode Kerja:                            |
|   [ * ] WFO (Kantor)   [   ] WFH/Dinas   |
|                                          |
|   +----------------------------------+   |
|   |   [ O ] AMBIL FOTO & CLOCK-IN    |   |
|   +----------------------------------+   |
|                                          |
+------------------------------------------+
| [Beranda]    (ABSEN)    [Ajukan]  [Profil]|
+------------------------------------------+
```

* **Langkah 1:** Peramban meminta akses kamera depan dan GPS.
* **Langkah 2:** Sistem menghitung jarak Haversine ke titik cabang terdaftar secara *real-time*. Jika jarak $\le 100\text{ m}$, teks indikator berwarna hijau: *"Dalam Radius Kantor"*. Jika di luar area, tombol berubah oranye dengan opsi ganti mode ke WFH/Dinas (membutuhkan alasan).
* **Langkah 3:** Karyawan menekan *"Ambil Foto & Clock-In"*. Frame aktif kamera ditangkap sebagai file JPEG, dikirim ke server backend Laravel bersama koordinat GPS.
* **Langkah 4:** Layar menampilkan modal animasi centang hijau sukses: *"Absen Masuk Berhasil! 07:54 WIB (Tepat Waktu)"*.

---

### 2.2 Alur Layar 2: Pengajuan Cuti (Leave Request) di Portal Karyawan
Layar formulir interaktif di tab "Ajukan":

```text
+------------------------------------------+
|  < Kembali           Pengajuan Cuti Kerja|
+------------------------------------------+
|  Jenis Cuti:                             |
|  [ Cuti Tahunan (Sisa: 8 Hari)       v ] |
|                                          |
|  Rentang Tanggal Cuti:                   |
|  Mulai:   [ 16 Okt 2026 ]                |
|  Sampai:  [ 20 Okt 2026 ]                |
|                                          |
|  +------------------------------------+  |
|  | [i] Kalkulasi Hari Kerja Efektif:  |  |
|  |     Total Durasi: 5 Hari           |  |
|  |     Sabtu/Minggu: -2 Hari Libur    |  |
|  |     Hari Kerja Dipotong: 3 Hari    |  |
|  |     Sisa Kuota Nanti: 5 Hari       |  |
|  +------------------------------------+  |
|                                          |
|  Alasan Cuti:                            |
|  [ Acara keluarga di luar kota....... ]  |
|                                          |
|  Dokumen Lampiran (Opsional):            |
|  [ + Unggah Dokumen / Surat ]            |
|                                          |
|  Hierarki Persetujuan:                   |
|  1. Hendro (Manager Divisi)              |
|  2. Siti (HR Admin)                      |
|                                          |
|  +------------------------------------+  |
|  |        [ KIRIM PENGAJUAN ]         |  |
|  +------------------------------------+  |
+------------------------------------------+
```

* **Langkah 1:** Memilih tipe cuti. Sistem menampilkan sisa kuota aktif dari buku besar cuti.
* **Langkah 2:** Memilih rentang tanggal. Reaktivitas Livewire secara instan mengurai hari kalender dan menghapus hari libur/akhir pekan secara otomatis.
* **Langkah 3:** Mengisi alasan dan mengunggah lampiran (wajib jika memilih Izin Sakit).
* **Langkah 4:** Menekan tombol kirim. Data tersimpan di `leave_requests` dengan status `pending_level_1` dan notifikasi WhatsApp/Email terkirim ke Atasan Langsung.

---

### 2.3 Alur Layar 3: Pengajuan Reimbursement & Klaim
Formulir klaim keuangan dengan kontrol plafon:

```text
+------------------------------------------+
|  < Kembali         Klaim Biaya Operasional|
+------------------------------------------+
|  Kategori Klaim:                         |
|  [ Transportasi & Bensin Dinas       v ] |
|  Plafon Bulanan: Rp 1.500.000            |
|  Sisa Plafon Aktif: Rp 850.000           |
|                                          |
|  Tanggal Transaksi: [ 01 Okt 2026 ]      |
|  (Maksimal 30 hari dari tanggal nota)    |
|                                          |
|  Nominal Klaim:                          |
|  Rp [ 350.000                       ]    |
|                                          |
|  Keterangan Transaksi:                   |
|  [ BBM kendaraan dinas ke Gudang Cikarang]|
|                                          |
|  Foto Struk / Nota Pembelian:            |
|  +------------------------------------+  |
|  | [ Foto_Struk_BBM.jpg ]  [ Lihat ]  |  |
|  +------------------------------------+  |
|                                          |
|  Metode Pencairan:                       |
|  (•) Masuk ke Payroll Bulan Berjalan     |
|  ( ) Transfer Langsung Off-Cycle         |
|                                          |
|  +------------------------------------+  |
|  |       [ AJUKAN REIMBURSEMENT ]     |  |
|  +------------------------------------+  |
+------------------------------------------+
```

---

### 2.4 Alur Layar 4: Antrean Persetujuan Manajer (Manager Approval Queue)
Dasbor desktop bagi atasan langsung:

```text
+----------------------------------------------------------------------------------+
|  Antrean Persetujuan Tim (Pending: 4)          [ Filter: Semua Tipe v ] [Cari..] |
+----------------------------------------------------------------------------------+
|  PEMOHON        | TIPE PENGAJUAN | RINCIAN DURASI/NOMINAL | AKSI CEPAT           |
+-----------------+----------------+------------------------+----------------------+
| [Foto] Agus S.  | Cuti Tahunan   | 3 Hari (16-18 Okt)     | [ Setujui ] [Tolak]  |
| [Foto] Rian P.  | Lembur (SPKL)  | 3 Jam (Hari Kerja)     | [ Setujui ] [Tolak]  |
| [Foto] Dewi K.  | Reimbursement  | Rp 350.000 (Transport) | [ Setujui ] [Tolak]  |
| [Foto] Budi M.  | Koreksi Absen  | Lupa Clock-Out (29 Sep)| [ Review Detail ]    |
+----------------------------------------------------------------------------------+
```

* **Aksi Cepat:** Manajer dapat menekan tombol `[Setujui]` langsung dengan modal konfirmasi singkat.
* **Penolakan:** Jika memilih `[Tolak]`, sistem mewajibkan pengisian catatan alasan penolakan yang otomatis terkirim ke karyawan via WhatsApp dan In-App.

---

## 3. Pertanyaan Terbuka & Keputusan Lanjutan ⚠️

1. **Aksi Persetujuan Massal (Bulk Approval):** Apakah Manager diizinkan mencentang banyak pengajuan sekaligus dan melakukan *Bulk Approve* untuk menghemat waktu, atau wajib ditinjau satu per satu demi akuntabilitas audit?
2. **Kustomisasi Kolom Tabel Admin:** Apakah pengguna admin menginginkan fitur menyembunyikan/menampilkan kolom tabel (*custom column visibility toggle*) pada daftar karyawan dan rekapitulasi absensi?
