# PRD 12 — SPESIFIKASI API & KONTRAK DATA
**Versi:** 1.1.0  
**Tanggal:** 2 Oktober 2026  
**Status:** Disetujui (Telah Direvisi: Protokol HTTP/AJAX Livewire, Rate-Limiting PIN & URL Secret Webhook)  
**Rujukan Dokumen:** [`00_INDEX.md`](file:///d:/ARKIN/tes%20aim/docs/prd/00_INDEX.md), [`02_ARSITEKTUR_DAN_TECH_STACK.md`](file:///d:/ARKIN/tes%20aim/docs/prd/02_ARSITEKTUR_DAN_TECH_STACK.md), [`06_MODUL_ABSENSI_PWA_SHIFT_ANTI_FRAUD.md`](file:///d:/ARKIN/tes%20aim/docs/prd/06_MODUL_ABSENSI_PWA_SHIFT_ANTI_FRAUD.md)

---

## 1. Arsitektur Komunikasi Data & Klarifikasi Protokol

1. **Livewire 3 Component Actions (Web Desktop Admin):**
   * Beroperasi murni melalui **standar HTTP/AJAX (XHR POST)** dengan perlindungan CSRF token bawaan Laravel.
   * **Tidak mewajibkan koneksi WebSocket/WSS**, sehingga tidak membebani arsitektur server dengan service websocket terpisah (kecuali jika modul chat internal real-time ditambahkan via Laravel Reverb di Fase 3).
2. **REST API Internal (PWA Mobile ESS & Webhook):**
   * Beroperasi melalui protokol HTTPS RESTful JSON standar, diotentikasi menggunakan Laravel Sanctum Bearer Token.

---

## 2. Standar Struktur Respons REST API

### 2.1 Format Respons Sukses (HTTP 200 / 201)
```json
{
  "success": true,
  "status_code": 200,
  "message": "Absensi masuk berhasil dicatat.",
  "data": {
    "attendance_id": 1054,
    "employee_name": "Rian Pratama",
    "clock_in_time": "2026-10-02T07:54:12+07:00",
    "status": "on_time",
    "branch_name": "Kantor Pusat Jakarta"
  },
  "meta": {
    "server_time": "2026-10-02T07:54:12+07:00",
    "timezone": "Asia/Jakarta"
  }
}
```

### 2.2 Format Respons Kesalahan (HTTP 4xx / 5xx — RFC 7807)
```json
{
  "success": false,
  "status_code": 422,
  "error_code": "OUT_OF_GEOFENCE_RADIUS",
  "message": "Posisi Anda berada di luar area kantor yang ditentukan.",
  "errors": {
    "distance": ["Jarak Anda 185 meter dari titik kantor (maksimal 100 meter)."]
  }
}
```

---

## 3. Spesifikasi Endpoint REST Internal PWA

### 3.1 Autentikasi & Pengikatan Perangkat (Device Binding)
* **Endpoint:** `POST /api/v1/auth/login-pwa`
* **Payload Request:**
  ```json
  {
    "identity": "081234567890",
    "password": "PasswordRahasia123!",
    "device_fingerprint": "a7b9c4...client_hash...",
    "device_name": "Samsung Galaxy A54 (Android 14)"
  }
  ```
* **Respons:** Sanctum Token `Bearer ...`. Jika `device_fingerprint` tidak cocok dengan perangkat terikat, mengembalikan HTTP 403 `DEVICE_MISMATCH_ERROR`.

---

### 3.2 Pencatatan Kehadiran Masuk (Clock-In)
* **Endpoint:** `POST /api/v1/attendance/clock-in`
* **Header:** `Authorization: Bearer <TOKEN>`, `Content-Type: multipart/form-data`
* **Parameter:**
  * `photo`: File JPEG (maksimal 2MB, tangkapan live kamera).
  * `latitude`: DECIMAL (`-6.17539240`).
  * `longitude`: DECIMAL (`106.82715280`).
  * `accuracy`: FLOAT (dalam meter).
  * `work_mode`: ENUM (`wfo`, `wfh`, `business_trip`).
  * `device_fingerprint`: STRING.

---

### 3.3 Sinkronisasi Absensi Offline (Offline Batch Sync)
* **Endpoint:** `POST /api/v1/attendance/offline-sync`
* **Header:** `Authorization: Bearer <TOKEN>`
* **Payload Request:**
  ```json
  {
    "batch_items": [
      {
        "local_recorded_at": "2026-10-02T08:05:00+07:00",
        "action_type": "clock_in",
        "latitude": -6.175392,
        "longitude": 106.827152,
        "accuracy": 15.0,
        "photo_base64": "data:image/jpeg;base64,...",
        "client_hash": "sha256_checksum"
      }
    ]
  }
  ```

---

### 3.4 Validasi Token Tautan Slip Gaji WhatsApp (Dengan Rate-Limiting & Lockout)
* **Endpoint:** `POST /api/v1/payslip/verify-token`
* **Keamanan Tambahan:**
  * Dibatasi oleh middleware rate-limit: maksimal 3 kali salah percobaan per IP/Token per 15 menit.
  * Percobaan salah ke-3 memicu status `locked_out` selama 15 menit.
* **Payload Request:**
  ```json
  {
    "token": "8f9a2b7c4d1e2f3a4b5c6d7e8f9a0b1c",
    "pin": "123456"
  }
  ```
* **Respons Berhasil:** File stream PDF slip gaji ber-password.
* **Respons Gagal:** HTTP 401 `{"success": false, "message": "PIN salah. Sisa percobaan: 1."}`.

---

## 4. Inbound Webhook Fonnte (Status Delivery WhatsApp)

* **Endpoint:** `POST /webhook/fonnte/{secret_token}`
* **Deskripsi:** Menerima status pengiriman pesan dari gateway Fonnte (sent, delivered, failed).
* **Autentikasi:** Mencocokkan `{secret_token}` di URL dengan konfigurasi token webhook tenant di database.
* **Payload dari Fonnte:**
  ```json
  {
    "id": "fonnte_msg_984712",
    "target": "6281234567890",
    "message": "Halo Budi...",
    "status": "delivered",
    "timestamp": 1727863200
  }
  ```
* **Tindakan:** Memperbarui baris `notification_logs`. Jika status `failed`, otomatis memicu antrean failover ke email.

---

## 5. Pertanyaan Terbuka & Keputusan Lanjutan ⚠️

1. **Penyimpanan Foto Selfie Absensi:** Apakah foto selfie disimpan di penyimpanan lokal VPS (`/storage/app/public/selfies`) atau langsung diunggah ke Object Storage eksternal (seperti MinIO / AWS S3 / Cloudflare R2) untuk menghemat kapasitas hard disk VPS?
2. **Kebutuhan API Publik Pihak Ketiga:** Apakah sistem di masa depan perlu menyediakan API key publik untuk integrasi dengan sistem ERP eksternal (SAP / Accurate)?
