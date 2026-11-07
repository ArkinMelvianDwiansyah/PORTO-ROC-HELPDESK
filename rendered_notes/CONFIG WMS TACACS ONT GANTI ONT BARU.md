# CONFIG WMS TACACS ONT GANTI ONT BARU


---



## STUDY CASE 


**SN-LAMA : **
GPON: 172.25.109.143  ZTEGC4384905
GPON02-D5-TGU-3 Â» gpon_onu-1/3/15:23 = Config lama ada disini bisa di samakan 

**SN - BARU : **
GPON06-D5-UBU-3# ZTEGC4384905
GPON06-D5-UBU-3(172.25.207.80) : gpon-onu_1/7/11:29


---


DATEK LAMA : 

```JavaScript
GPON08-D5-UBU-3#show running-config-interface gpon_onu-1/3/15:23
!<if-intf>
interface gpon_onu-1/3/15:23
$
!</if-intf>
!<xpon>
interface gpon_onu-1/3/15:23
name I MADE HERWIN SAHADEWA |WMS LITE
tcont 1 name WMS profile UP-8192KB0
tcont 2 name VOIP profile UP-564KF5
gemport 1 name WMS tcont 1
gemport 2 name VOIP tcont 2
$
pon-onu-mng gpon_onu-1/3/15:23
service WMS gemport 1 vlan 4090
service VOIP gemport 2 vlan 500
vlan port wifi_0/1 mode hybrid def-vlan 4090
vlan port wifi_0/5 mode hybrid def-vlan 4090
voip protocol sip
voip-ip ipv4 mode dhcp vlan-profile batchVlan500 host 2
veip 1 port udp 8080 ipv4 host 2
tr069-mgmt 1 acs http://acs.telkom.net:9090/web/tr069 validate basic username CPE password CPE
ssid auth wep wifi_0/1 open-system encrypt disable
ssid auth wep wifi_0/5 open-system encrypt disable
ssid ctrl wifi_0/1 name Tebe_Family
ssid ctrl wifi_0/5 name Tebe_Family
$
!</xpon>
GPON08-D5-UBU-3#
```


**Cara konfigurasi:**

1. Hapus ONU dan OLT, lalu bersihkan konfigurasi yang masih tersisa pada ONT baru.
1. Cari contoh konfigurasi pada ONT terdekat yang menggunakan VLAN yang sama, lalu jadikan sebagai referensi.
1. Cari SSID di WPGEN dengan filter seperti *No Inet*, *No AP*, dan sejenisnya.
1. Sesuaikan konfigurasi agar sama dengan contoh.
1. Ubah SSID sesuai kebutuhan.
1. Jika muncul kasus baru seperti *WPERROR*, lanjutkan penyesuaian.
1. Sesuaikan GPON dan port pada website WPGEN.
1. Selesai.

Gambar penyesuaian di WPGEN

![Image: ](attachment:c24767ef-2ff0-4629-a48f-92c1c1260a58:image.png)


Sesuaikan dengan link ini 

[http://welcome2.wifi.id/wms/?gw_id=WAG-D5-SGR&client_mac=26:74:23:0e:4c:67&wlan=GPON06-D5-UBU-3](http://welcome2.wifi.id/wms/?gw_id=WAG-D5-SGR&client_mac=26:74:23:0e:4c:67&wlan=GPON06-D5-UBU-3) pon 7/11/29/1:4090:Tebe_Family&sessionid=0001FFFF78007E8A-69E09C55&redirect=http://connectivitycheck.gstatic.com/generate_204

HASIL : 

```JavaScript
GPON06-D5-UBU-3#show onu running config gpon-onu_1/7/11:29
pon-onu-mng gpon-onu_1/7/11:29
service WMS gemport 1 vlan 4090
service VOIP gemport 2 vlan 100
voip protocol sip
vlan port wifi_0/1 mode hybrid def-vlan 4090
veip 1 port udp 8080 host 2
tr069-mgmt 1 acs http://acs.telkom.net:9090/web/tr069 validate basic username CPE password CPE
ssid auth wep wifi_0/1 open-system
ssid ctrl wifi_0/1 name Tebe_Family
!
GPON06-D5-UBU-3#

GPON06-D5-UBU-3#show running-config interface gpon-onu_1/7/11:29
Building configuration...
interface gpon-onu_1/7/11:29
  tcont 1 name WMS profile UP-22528KB0
  tcont 2 name VOIP profile UP-1M
  gemport 1 name WMS tcont 1
  gemport 1 traffic-limit downstream DOWN-22528KB0 
  gemport 2 name VOIP tcont 2
  gemport 2 traffic-limit downstream DOWN-1M 
  service-port 1 vport 1 user-vlan 4090 vlan 4090 
  service-port 1 description WMS
  service-port 2 vport 2 user-vlan 100 vlan 588 
  service-port 2 description VOIP
  port-identification format WMS vport 1
  dhcpv4-l2-relay-agent enable vport 1
  dhcpv4-l2-relay-agent trust true replace vport 1
!
end
GPON06-D5-UBU-3#
```
