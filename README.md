# 🌐 PORTO-ROC-HELPDESK
### **WiFi.id Notes & Standard Operating Procedures (SOP) Interactive Knowledge Base**
> *Dokumentasi Teknis dan Panduan Pemecahan Masalah (Troubleshooting) Operasional Jaringan WiFi.id / WiFi Managed Service (WMS Lite & WMS Reguler) — ROC Regional 5 & CCAN Witel.*

---

## 📖 Ringkasan Proyek
**PORTO-ROC-HELPDESK** adalah portal dokumentasi operasional dan portofolio interaktif berbasis Single-Page Application (SPA) modern yang menyajikan standarisasi penanganan gangguan (*troubleshooting*), konfigurasi perangkat (*provisioning*), rekapitulasi data (*reconciliation*), dan penelusuran paket data end-to-end (*packet tracing*) dari level Access Point pelanggan hingga Core BRAS Gateway.

Sistem dirancang dengan arsitektur **Clean Monochrome Aesthetic** (Zinc-950 Dark Theme) yang responsif, dilengkapi fitur pencarian instan (*Ctrl+K Search Modal*), *Lightbox Image Viewer*, *One-Click Code Snippet Copy*, dan *Floating Glossary Drawer* untuk 25+ istilah jaringan telekomunikasi.

---

## 📂 Struktur Direktori Repositori

```text
PORTO-ROC-HELPDESK/
├── assets/                  # Seluruh aset visual (130+ gambar diagram, tangkapan layar CLI, topologi)
│   └── images/
├── data/                    # Database raw JSON Notion & dump chunk (all_blocks, image_map, chunks)
│   ├── all_blocks.json
│   ├── all_blocks_complete.json
│   ├── image_map.json
│   └── chunks/
├── docs/                    # Dokumentasi lengkap & modul catatan SOP dalam format Markdown
│   ├── FULL_WIFI_ID_NOTES.md
│   ├── modules/             # 23 modul SOP format Markdown individual
│   └── archive_prd/         # Arsip dokumen referensi
├── scripts/                 # Seluruh skrip otomatisasi pipeline & web generator PowerShell
│   ├── generate_tabbed_site.ps1
│   ├── e2e_tracing_content.html
│   └── ...                  # Skrip crawling, parsing, dan verifikasi
├── .gitignore               # Konfigurasi pengabaian file sampah & dump sementara
├── index.html               # Main Interactive Single-Page Application (Entry Point Utama)
└── README.md                # Dokumentasi Portofolio Repositori
```

---

## 🗺️ Struktur & Daftar Modul Operasional

| Modul | Nama Modul | Cakupan Teknis & Topik Pembahasan |
| :---: | :--- | :--- |
| **01** | **Tracing E2E & Solved** | **9-Hop Packet Flow Pipeline** (AP &rarr; ONT &rarr; GPON &rarr; Metro Akses &rarr; Metro Uplink &rarr; WAC &rarr; WAG &rarr; AAA/WPGEN &rarr; PE/BRAS), korelasi Serial Number AP vs Tagged VLAN, serta **CCNA/CCNP Engineering Blueprint**. |
| **02** | **Topologi Jaringan** | Arsitektur perbedaan WMS Lite (CPE Integrated VLAN 4090) vs WMS Reguler (Enterprise AP CAPWAP Tunnel WLC Cisco 5508/8540), diagram interkoneksi, dan direktori akses portal operasional. |
| **03** | **Tiketing WiFi.id** | Klasifikasi tiket gangguan (*Reactive AP Mati / LOSS* vs *Reactive Service Logic*), verifikasi nomor Nossa di Insera, dan format eskalasi order gangguan ke tim CCAN Witel. |
| **04** | **SOP Ganti AP (WLC)** | Prosedur penggantian fisik unit Access Point Cisco Aironet/Catalyst, pencarian IP WAC & IP NAT via Telegram Bot APEHBOT, trik bypass login WISM Mozilla Firefox frameset, dan mapping AP-Group di WPGEN. |
| **05** | **WP-Error & Captive** | Solusi kegagalan redirect halaman login `welcome2.wifi.id`: Kasus 1 (ACS Security Type Open System), Kasus 2 (Location-ID / SSID Mismatch), Kasus 3 (URL Parameter), dan perbaikan status DHCP Port Locating silang merah (X) Option 82. |
| **06** | **GPON & ONT Config** | Skrip CLI TACACS OLT ZTE C300/C320 (VLAN 4090 WMS, VLAN 500 VOIP, TCONT, GEMPORT), identifikasi SN ONT induk via Smarthub, prosedur Buka Isolir (Bukis) di WPGEN, dan penggantian password SSID. |
| **07** | **Rekonsiliasi Mojang** | Panduan pengolahan rekapitulasi data harian AP gangguan menggunakan Microsoft Excel: formula VLOOKUP Sugar Report H-1 terhadap Master Inventory Prabac, pembersihan string witel, dan upload ke Web Mojang ROC5. |
| **08** | **Network Tracing CLI** | Pencarian data teknis AP via APEHBOT, trace MAC Address di Cisco WAC (`show mac address-table`, `show ip arp`, `show interfaces`), identifikasi downlink port Metro Ethernet, serta pembuatan profile WLAN SSID di WLC. |
| **09** | **Quick Notes & Tips** | Optimasi pemilihan kanal radio RF (2.4 GHz 20/40 MHz & 5 GHz 80 MHz via ACS I-Booster), mitigasi gangguan AP intermitten/flapping, otomasi RSA Key server, resend email kredensial akun, dan standarisasi arsitektur WiFi 6. |

---

## ⚡ Fitur Utama Interaktif
1. **Interactive Single-Page Application (SPA)**: Perpindahan antar modul tanpa reload halaman (*zero latency tab switching*).
2. **Interactive 9-Hop Pipeline**: Visualisasi alur paket data dari fisik AP ke Internet Core dengan badge status protokol dan indikator hop-by-hop.
3. **Floating Glosarium Jaringan (Drawer)**: Kamus interaktif 25+ istilah jaringan (CAPWAP, Option 82, TR-069, GEMPORT, VSI, WISPr, CoA, BNG) dengan animasi slide-out lambat dan filter pencarian real-time.
4. **Ctrl+K Quick Search**: Modal pencarian terintegrasi untuk mencari perintah CLI, studi kasus gangguan, atau istilah teknis dengan navigasi keyboard (`ESC` to close).
5. **High-Res Lightbox Viewer**: Klik gambar topologi atau tangkapan layar CLI untuk memperbesar resolusi tinggi dengan tombol unduh langsung.
6. **1-Click Code Copy**: Seluruh skrip konfigurasi CLI (OLT ZTE, Cisco WLC, Huawei Metro) dapat disalin langsung dengan tombol salin otomatis.

---

## 🛠️ Tech Stack & Arsitektur Kode
- **Markup & Presentation**: Semantic HTML5, Tailwind CSS (via CDN JIT), Font Inter & JetBrains Mono.
- **Client Logic**: Vanilla JavaScript ES6+ (Zero external npm framework dependencies, murni client-side rendering).
- **Data Source**: Diekstrak dan dirender dari repositori dokumentasi Notion operasional resmi dengan pipeline PowerShell (`scripts/generate_tabbed_site.ps1`).

---

## 🚀 Cara Menjalankan Proyek Secara Lokal
Karena proyek ini bersifat murni statis, tidak memerlukan Node.js atau instalasi server khusus:
1. Clone repositori:
   ```bash
   git clone https://github.com/ArkinMelvianDwiansyah/PORTO-ROC-HELPDESK.git
   cd PORTO-ROC-HELPDESK
   ```
2. Buka file `index.html` langsung di browser favorit Anda (Google Chrome, Mozilla Firefox, Microsoft Edge):
   ```bash
   start index.html
   ```
   *Atau gunakan Live Server / VS Code Live Preview jika diinginkan.*

---

## 🔒 Catatan Keamanan
> *Seluruh data kredensial sensitif, password production, dan IP publik telah disanitasi atau diganti dengan format demonstrasi portofolio sesuai kaidah keamanan informasi operasional.*

---
**Author / Maintainer:** Arkin Melvian Dwiansyah  
*ROC Regional 5 • Operations & Helpdesk*
