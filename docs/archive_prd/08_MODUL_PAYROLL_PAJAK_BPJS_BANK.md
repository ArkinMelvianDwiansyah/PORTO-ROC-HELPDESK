# PRD 08 — MODUL PAYROLL, PPH 21 TER, BPJS, THR & EKSPOR BANK
**Versi:** 1.1.0  
**Tanggal:** 2 Oktober 2026  
**Status:** Disetujui (Telah Direvisi Berdasarkan Review Regulasi)  
**Rujukan Dokumen:** [`00_INDEX.md`](file:///d:/ARKIN/tes%20aim/docs/prd/00_INDEX.md), [`03_MODEL_DATA_DAN_ERD.md`](file:///d:/ARKIN/tes%20aim/docs/prd/03_MODEL_DATA_DAN_ERD.md), [`04_RBAC_KEAMANAN_DAN_UU_PDP.md`](file:///d:/ARKIN/tes%20aim/docs/prd/04_RBAC_KEAMANAN_DAN_UU_PDP.md)

---

## 1. Deskripsi Modul & Sasaran Fungsional

Modul Penggajian (*Payroll Engine*) bertanggung jawab untuk menghitung seluruh komponen pendapatan bruto, potongan kehadiran/kasbon, iuran 5 program BPJS, kepatuhan perpajakan **PPh 21 skema Tarif Efektif Rata-Rata (TER) sesuai PP No. 58 Tahun 2023 & PMK 168/2023**, kalkulator **Tunjangan Hari Raya (THR) sesuai Permenaker No. 6 Tahun 2016**, penerbitan slip gaji digital terlindungi PIN, dan berkas transfer massal perbankan nasional (**BCA, Mandiri, BRI, BNI**).

---

## 2. Struktur Komponen Penggajian & Alur Agregasi

```mermaid
flowchart TD
    subgraph PENDAPATAN BRUTO
        GajiPokok["Gaji Pokok"]
        TunjanganTetap["Tunjangan Tetap (Jabatan/Fungsional)"]
        TunjanganVariabel["Tunjangan Variabel (Makan/Transport)"]
        Lembur["Upah Lembur Resmi (Overtime)"]
        Reimburse["Reimbursement Masuk Payroll (Non-Taxable / Taxable)"]
        BonusTHR["THR Keagamaan / Bonus / Insentif"]
        BPJS_Company["Premi BPJS Ditanggung Perusahaan\n(JKK + JKM + BPJS Kes 4%)"]
    end

    subgraph POTONGAN GAJI
        PotAbsen["Potongan Denda Terlambat / Alpha / Unpaid Leave"]
        PotKasbon["Cicilan Pinjaman / Kasbon Karyawan"]
        BPJS_Emp["Iuran BPJS Ditanggung Karyawan\n(JHT 2% + JP 1% + Kes 1%)"]
        PPh21["Potongan Pajak PPh 21 (TER / Pasal 17)"]
    end

    PENDAPATAN BRUTO --> NetPay["Gaji Bersih Diterima (Take Home Pay)\n= Total Pendapatan Tunai - Total Potongan"]
    POTONGAN GAJI --> NetPay
```

---

## 3. Mesin Pajak PPh 21 Skema TER (PP 58/2023 & PMK 168/2023)

Sesuai regulasi resmi perpajakan Indonesia:

### 3.1 Pemetaan Kategori TER Berdasarkan Status PTKP
* **TER Kategori A:** Untuk penerima penghasilan dengan status PTKP:
  * Tidak Kawin tanpa tanggungan (`TK/0`) — PTKP Rp 54.000.000
  * Tidak Kawin 1 tanggungan (`TK/1`) — PTKP Rp 58.500.000
  * Kawin tanpa tanggungan (`K/0`) — PTKP Rp 58.500.000
* **TER Kategori B:** Untuk penerima penghasilan dengan status PTKP:
  * Tidak Kawin 2 tanggungan (`TK/2`) — PTKP Rp 63.000.000
  * Tidak Kawin 3 tanggungan (`TK/3`) — PTKP Rp 67.500.000
  * Kawin 1 tanggungan (`K/1`) — PTKP Rp 63.000.000
  * Kawin 2 tanggungan (`K/2`) — PTKP Rp 67.500.000
* **TER Kategori C:** Untuk penerima penghasilan dengan status PTKP:
  * Kawin 3 tanggungan (`K/3`) — PTKP Rp 72.000.000

### 3.2 Tabel Layer Tarif TER Bulanan Resmi
Tabel tarif disimpan dalam database berversi (`tax_ter_brackets`). Beberapa contoh layer representatif:
* **TER Kategori A:**
  * $\le \text{Rp } 5.400.000$: $0\%$
  * $> \text{Rp } 5.400.000\text{ s.d. } 5.650.000$: $0.25\%$
  * ...
  * $> \text{Rp } 9.650.000\text{ s.d. } 10.050.000$: $1.75\%$
  * $> \text{Rp } 10.050.000\text{ s.d. } 10.350.000$: $2.00\%$
  * **$> \text{Rp } 10.350.000\text{ s.d. } 10.700.000$: $2.50\%$** *(Penting: Bruto Rp 10.423.200 masuk layer ini)*
  * $> \text{Rp } 10.700.000\text{ s.d. } 11.050.000$: $3.00\%$
  * ...
  * $> \text{Rp } 1.400.000.000$: $34.00\%$

### 3.3 Rumus Perhitungan Masa Bulanan (Januari – November)
$$\text{Penghasilan Bruto Sebulan} = \text{Gaji Pokok} + \text{Tunjangan Tetap} + \text{Tunjangan Variabel} + \text{Lembur} + \text{Premi JKK/JKM} + \text{BPJS Kes Perusahaan}$$
$$\text{PPh 21 Bulanan} = \text{Penghasilan Bruto Sebulan} \times \text{Tarif TER (\%) Sesuai Tabel Layer}$$

### 3.4 Rekalkulasi Masa Pajak Terakhir (Desember / Karyawan Resign)
1. Hitung seluruh Penghasilan Bruto selama 1 tahun (Januari s.d. Desember).
2. Kurangkan Biaya Jabatan ($5\%$, maksimal Rp 6.000.000 setahun atau Rp 500.000 per bulan).
3. Kurangkan iuran JHT ($2\%$) dan JP ($1\%$) yang dibayar sendiri oleh karyawan selama setahun.
4. Hitung Penghasilan Neto Setahun, lalu kurangkan PTKP tahunan untuk memperoleh **Penghasilan Kena Pajak (PKP)** (dibulatkan ke ribuan ke bawah).
5. Terapkan tarif progresif **Pasal 17 ayat (1) huruf a UU HPP**:
   * Lapisan s.d. Rp 60.000.000: $5\%$
   * Di atas Rp 60.000.000 s.d. Rp 250.000.000: $15\%$
   * Di atas Rp 250.000.000 s.d. Rp 500.000.000: $25\%$
   * Di atas Rp 500.000.000 s.d. Rp 5.000.000.000: $30\%$
   * Di atas Rp 5.000.000.000: $35\%$
6. PPh 21 Masa Desember dihitung:
   $$\text{PPh 21 Desember} = \text{PPh 21 Terutang Setahun (Pasal 17)} - \sum_{m=1}^{11} \text{PPh 21 yang Telah Dipotong}$$
   *(Jika bernilai negatif, terjadi lebih bayar yang wajib dikembalikan ke karyawan pada slip Desember).*

### 3.5 Metode Pemotongan Pajak: Gross, Gross-Up, dan Netto
* **Gross:** PPh 21 dipotong langsung dari upah karyawan.
* **Netto:** PPh 21 ditanggung penuh oleh perusahaan (tidak mengurangi gaji dan bukan objek penambah bruto).
* **Gross-Up (Tunjangan Pajak Otomatis di Bawah Sistem TER):**
  Perusahaan memberikan Tunjangan Pajak ($TP$) sedemikian sehingga $TP = \text{PPh 21}$. Karena penambahan $TP$ menaikkan Bruto dan dapat menaikkan layer TER, sistem menggunakan **metode iteratif presisi (*convergent iteration*)**:
  1. Inisialisasi: $TP_0 = 0$.
  2. Iterasi $k$: $\text{Bruto}_k = \text{Bruto Dasar} + TP_{k-1}$.
  3. Ambil tarif $\text{TER}(\text{Bruto}_k)$, hitung $\text{Pajak}_k = \text{Bruto}_k \times \text{TER}(\text{Bruto}_k)$.
  4. Tetapkan $TP_k = \text{Pajak}_k$.
  5. Ulangi sampai $|TP_k - TP_{k-1}| < 1\text{ Rupiah}$ (konvergen dalam 2–3 iterasi).

---

## 4. Modul Tunjangan Hari Raya (THR Keagamaan - Permenaker No. 6/2016)

### 4.1 Aturan & Waktu Pembayaran
* Pengusaha wajib memberikan THR Keagamaan kepada pekerja yang telah mempunyai masa kerja minimal 1 bulan terus-menerus.
* Dibayarkan paling lambat **7 hari sebelum hari raya keagamaan (H-7)**.

### 4.2 Formula Perhitungan Nilai THR
Dasar perhitungan 1 bulan upah adalah **Gaji Pokok + Tunjangan Tetap**.
1. **Masa kerja $\ge 12$ bulan terus menerus:**
   $$\text{THR} = 1 \times \text{Upah 1 Bulan}$$
2. **Masa kerja $\ge 1$ bulan tetapi $< 12$ bulan (Prorata):**
   $$\text{THR} = \frac{\text{Masa Kerja (Bulan)}}{12} \times \text{Upah 1 Bulan}$$

### 4.3 Perlakuan Pajak PPh 21 THR
* Pada bulan pembayaran THR, nominal THR digabungkan ke dalam Penghasilan Bruto bulan bersangkutan.
* Seluruh Bruto (Gaji reguler + THR) dikenakan tarif TER bulanan sesuai layer penghasilan total.
* Selisih pajak yang timbul akibat THR tercatat transparan di rincian slip pembayaran THR.

---

## 5. Mesin BPJS & Plafon Upah Berversi

| Program BPJS | Pemberi Kerja (%) | Pekerja (%) | Plafon Batas Upah (Cap) | Keterangan & Referensi Regulasi |
|---|:---:|:---:|:---:|---|
| **BPJS Kesehatan** | $4.00\%$ | $1.00\%$ | **Rp 12.000.000** | Mencakup pekerja + 4 anggota keluarga inti |
| **BPJS TK - JKK** | $0.24\% - 1.74\%$ | $0.00\%$ | Tanpa batas maksimal | Sesuai tingkat risiko kerja cabang |
| **BPJS TK - JKM** | $0.30\%$ | $0.00\%$ | Tanpa batas maksimal | Jaminan Kematian |
| **BPJS TK - JHT** | $3.70\%$ | $2.00\%$ | Tanpa batas maksimal | Jaminan Hari Tua |
| **BPJS TK - JP** | $2.00\%$ | $1.00\%$ | **Rp 10.042.300** *(Konfigurasi Berversi)* | Dievaluasi per 1 Maret oleh BPJS TK sesuai inflasi & PDB |

> [!IMPORTANT]
> Plafon Jaminan Pensiun (JP) disimpan dalam tabel `bpjs_configurations` berpenanggalan `effective_date`, sehingga perubahan plafon tahunan tidak merusak histori hitungan tahun sebelumnya.

---

## 6. Modul Pinjaman & Kasbon Karyawan

* Pengajuan via ESS dengan batas plafon (default: maks $50\%$ gaji pokok) dan pilihan tenor 1–12 bulan.
* Persetujuan 2 tingkat: Atasan Langsung $\rightarrow$ Finance Admin.
* Pemotongan otomatis cicilan pokok bulanan pada tabel `payroll_items` dan rekonsiliasi ke `loan_installments`.
* Fitur pelunasan dipercepat langsung di Finance yang otomatis menghentikan sisa potongan.

---

## 7. Format Ekspor Transfer Perbankan Massal (4 Bank Utama)

Sistem menyediakan berkas siap-unggah (*direct upload*) untuk 4 bank terbesar di Indonesia:

| Nama Bank | Format Berkas | Spesifikasi Teknis |
|---|---|---|
| **BCA** | KlikBCA Bisnis (Payroll BCA `.csv`) | Delimiter koma/titik-koma, memuat kolom No Rekening, Nama Penerima, Nominal (tanpa desimal), Kode Transaksi Payroll, dan Berita Acara. |
| **Bank Mandiri** | Mandiri Cash Management (MCM 2.0 `.csv`/`.txt`) | Format fixed-width / delimited resmi MCM dengan Header Batch, Rekening Debet Perusahaan, Rekening Kredit Karyawan, Tanggal Efektif, dan Checksum Total. |
| **BRI** | CMS BRI (Corporate Cash Management `.xlsx`/`.csv`) | Format standar Mass Transfer BRI CMS memuat Rekening Sumber, Rekening Tujuan, Nama Karyawan, Jumlah Transfer, dan Keterangan. |
| **BNI** | BNI Direct (Mass Payment `.txt`/`.csv`) | Format standar BNI Direct Batch Transfer dengan record indicator (Record 01 Header, Record 02 Data Karyawan, Record 03 Trailer). |

---

## 8. Keamanan Slip Gaji Digital (Pemberantasan Celah PIN Lemah)

Merespons potensi celah keamanan tebakan PIN:
1. **Bukan Menggunakan Tanggal Lahir Otomatis:** Sistem **tidak lagi** menggunakan rumus bawaan tanggal lahir + 4 digit NIK karena mudah ditebak.
2. **Karyawan Mengatur PIN Rahasia 6-Digit Sendiri:** Saat login pertama di portal ESS, karyawan wajib membuat **PIN Rahasia Slip Gaji (6 Angka)** yang di-hash menggunakan algoritma Bcrypt di database (`users.payslip_pin_hash`).
3. **Perlindungan Brute-Force & Lockout:**
   * Endpoint verifikasi token slip gaji dibatasi maksimal **3 kali salah percobaan**.
   * Jika gagal 3 kali berturut-turut, tautan token otomatis terkunci (*lockout*) selama 15 menit dan memicu notifikasi peringatan keamanan ke email karyawan.
4. **Opsi Akses Terbaik:** Karyawan dapat langsung melihat dan mengunduh slip PDF secara aman di portal ESS setelah login berotentikasi Sanctum.

---

## 9. Kriteria Penerimaan Fitur (Acceptance Criteria)

### Skenario 1: Koreksi Pemotongan PPh 21 TER Masa Pajak Reguler (Maret)
```gherkin
Given Karyawan tetap berstatus PTKP "TK/0" (Kategori TER A)
And Gaji Pokok Rp 8.000.000, Tunjangan Rp 1.500.000, Lembur Rp 500.000 (Total Bruto Tunai Rp 10.000.000)
And Premi JKK (0.24%) Rp 19.200, JKM (0.30%) Rp 24.000, BPJS Kes Perusahaan (4%) Rp 380.000
And Total Penghasilan Bruto Objek Pajak = Rp 10.423.200
When Sistem menghitung payroll bulan Maret
Then Sistem mengidentifikasi layer TER Kategori A untuk bruto Rp 10.423.200 berada pada rentang Rp 10.350.001 s.d. Rp 10.700.000 dengan tarif 2.50%
And PPh 21 terpotong sebesar 2.50% * Rp 10.423.200 = Rp 260.580
And Slip gaji menampilkan rincian tarif 2.50% dan nominal Rp 260.580 secara presisi
```

### Skenario 2: Kalkulasi THR Karyawan Masa Kerja 6 Bulan
```gherkin
Given Karyawan tetap dengan Gaji Pokok Rp 6.000.000 dan Tunjangan Tetap Rp 1.000.000 (Upah Sebulan = Rp 7.000.000)
And Karyawan memiliki masa kerja 6 bulan saat hari raya keagamaan
When HR Admin memproses modul THR Keagamaan
Then Sistem menghitung nilai THR prorata: (6 / 12) * Rp 7.000.000 = Rp 3.500.000
And Nominal THR dimasukkan ke slip THR dan dipotong PPh 21 TER sesuai ketentuan
```

---

## 10. Pertanyaan Terbuka & Keputusan Lanjutan ⚠️

1. **Sinkronisasi Hari Raya Keagamaan:** Apakah tanggal pembayaran THR mengacu pada agama masing-masing karyawan (Idul Fitri, Natal, Nyepi, Waisak, Imlek) atau dibayarkan serentak per perusahaan menjelang Hari Raya Idul Fitri (kebijakan umum)?
2. **Kompensasi Sisa Pinjaman saat Resign:** Jika karyawan resign namun sisa kasbon melebihi take home pay bulan terakhir, apakah sisa piutang otomatis memotong uang pesangon/kompensasi PKWT atau dibuatkan surat perjanjian penagihan piutang terpisah?
