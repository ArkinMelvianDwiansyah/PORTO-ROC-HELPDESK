# PRD 10 — NOTIFIKASI & INTEGRASI GATEWAY
**Versi:** 1.1.0  
**Tanggal:** 2 Oktober 2026  
**Status:** Disetujui (Telah Direvisi: Autentikasi Webhook Fonnte & Protokol Keamanan)  
**Rujukan Dokumen:** [`00_INDEX.md`](file:///d:/ARKIN/tes%20aim/docs/prd/00_INDEX.md), [`02_ARSITEKTUR_DAN_TECH_STACK.md`](file:///d:/ARKIN/tes%20aim/docs/prd/02_ARSITEKTUR_DAN_TECH_STACK.md), [`04_RBAC_KEAMANAN_DAN_UU_PDP.md`](file:///d:/ARKIN/tes%20aim/docs/prd/04_RBAC_KEAMANAN_DAN_UU_PDP.md)

---

## 1. Deskripsi Modul & Arsitektur Kanal

Sistem menerapkan arsitektur **Multi-Kanal Berpasangan**:
* **Kanal Primer (Selalu Aktif):** In-App Notification (ikon lonceng) & Email SMTP.
* **Kanal Sekunder (Opsional per Tenant):** WhatsApp Gateway melalui Fonnte API dengan sistem antrean terproteksi anti-banned.

---

## 2. Pola Desain Adapter Notifikasi (Adapter Pattern)

Logika bisnis dibebaskan dari keterikatan pihak ketiga melalui interface `NotificationChannelInterface`:
* `DatabaseInAppChannel`: Menyimpan notifikasi ke basis data untuk ikon lonceng.
* `SmtpEmailChannel`: Pengiriman email HTML resmi.
* `FonnteWhatsAppChannel`: Pengiriman via Fonnte API v1.
* *Kesiapan Masa Depan:* Jika perusahaan beralih ke Meta WhatsApp Cloud API resmi, pengembang hanya perlu membuat kelas adapter baru tanpa mengubah kode modul bisnis.

---

## 3. Mesin Antrean & Mitigasi Anti-Banned Nomor WhatsApp

1. **Jeda Acak (Jitter Delay):** Antrean Redis otomatis memberikan jeda acak **5 hingga 15 detik** antar pengiriman pesan untuk menghindari deteksi lonjakan ritme mesin (*burst pattern*).
2. **Batas Kuota Harian (Throttling):** Dibatasi maksimal **500 pesan/nomor/hari**.
3. **Circuit Breaker:** Jika terjadi 5 kegagalan berturut-turut atau perangkat Fonnte terputus (*disconnected*), sistem otomatis mengalihkan seluruh pesan penting ke Email dan menampilkan indikator peringatan di dasbor admin.

---

## 4. Keamanan Slip Gaji via WhatsApp (UU PDP)

* **Larangan Angka Gaji:** Pesan WhatsApp tidak pernah memuat nominal uang.
* **Tautan Bertoken Sementara (TTL 72 Jam):** Pesan hanya berisi tautan bertoken unik.
* **Wajib PIN 6-Angka Rahasia Mandiri:** Membuka tautan mewajibkan input PIN rahasia 6 angka yang disetel karyawan sendiri, dengan batas 3 kali salah sebelum akun terkunci selama 15 menit.

---

## 5. Autentikasi Inbound Webhook Fonnte yang Valid

> [!IMPORTANT]
> Berdasarkan dokumentasi teknis API Fonnte, sistem **tidak mengandalkan header `X-Fonnte-Signature`** karena header tersebut tidak disediakan secara standar oleh Fonnte.

Sistem mengamankan webhook Fonnte melalui dua lapis proteksi:
1. **URL Secret Token Acak:** URL webhook dibuat unik per tenant, misal:  
   `POST https://hris.perusahaan.co.id/webhook/fonnte/{tenant_webhook_secret}`  
   Nilai token adalah string acak 64 karakter yang disimpan di `company_settings`.
2. **Validasi Skema Payload:** Backend memvalidasi struktur JSON masuk (keberadaan field `target`, `status`, dan `device`).

---

## 6. Kriteria Penerimaan Fitur (Acceptance Criteria)

### Skenario: Penerimaan Webhook DLR Fonnte yang Sah
```gherkin
Given Sistem mengirimkan pesan WhatsApp slip gaji kepada karyawan
And Fonnte memanggil URL webhook /webhook/fonnte/a8f9b2c3d4e5... dengan payload status "delivered"
When Request tiba di server backend
Then Sistem memverifikasi token secret URL valid
And Memperbarui status pada tabel notification_logs menjadi "delivered"
And Mencatat waktu penerimaan pesan secara akurat
```

---

## 7. Pertanyaan Terbuka & Keputusan Lanjutan ⚠️

1. **Nomor Pengirim Terpisah:** Apakah tenant ingin menggunakan 1 nomor WhatsApp untuk seluruh kebutuhan, atau memisahkan nomor WhatsApp khusus Operasional Absensi dan nomor khusus Notifikasi Payroll/Manajemen?
2. **Jam Malam Pengiriman Notifikasi (Quiet Hours):** Apakah notifikasi non-kritis (pengumuman, ultah, shift besok) wajib ditahan dan baru dikirim pada jam kerja normal (misal antara 07:00 – 20:00) agar tidak mengganggu istirahat karyawan?
