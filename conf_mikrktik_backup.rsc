# 2025-06-18 18:36:01 by RouterOS 7.19.1
# software id = KFVX-1BE0
#
# model = RB3011UiAS
# serial number = 8EED097B5E0D
/interface bridge
add comment="UniFi AP1 Trunk Bridge" dhcp-snooping=yes name=bridge-ap1
add comment="CCTV VLAN 40 Bridge" name=bridge-vlan40
/interface ethernet
set [ find default-name=ether1 ] comment="Trunk from Reyee Switch - VLANs 10,20,30,40"
set [ find default-name=ether2 ] comment="CCTV Switch - Access VLAN 40 (Untagged)"
set [ find default-name=ether3 ] comment="UniFi AC LR - Trunk Bridge VLANs 10,20,30"
set [ find default-name=ether4 ] comment="UniFi AP Secondary - Trunk VLANs 10,20,30"
set [ find default-name=ether5 ] comment="Office Device - Access VLAN 20"
set [ find default-name=ether6 ] comment="Office Device - Access VLAN 20"
set [ find default-name=ether7 ] comment="Office Device - Access VLAN 20"
set [ find default-name=ether8 ] comment="Management PC - Access VLAN 20"
set [ find default-name=ether9 ] comment="Spare Port"
set [ find default-name=ether10 ] comment="Spare Port"
/interface vlan
add comment="CCTV Switch - VLAN 40" interface=ether2 name=ether2-vlan40 vlan-id=40
add comment="AP1 - HomeNet" interface=ether3 name=ether3-vlan10 vlan-id=10
add comment="AP1 - OfficeNet" interface=ether3 name=ether3-vlan20 vlan-id=20
add comment="AP1 - GuestWiFi" interface=ether3 name=ether3-vlan30 vlan-id=30
add comment="AP2 - HomeNet" interface=ether4 name=ether4-vlan10 vlan-id=10
add comment="AP2 - OfficeNet" interface=ether4 name=ether4-vlan20 vlan-id=20
add comment="AP2 - GuestWiFi" interface=ether4 name=ether4-vlan30 vlan-id=30
add comment="HomeNet - 192.168.10.0/24" interface=ether1 name=vlan10-home vlan-id=10
add comment="OfficeNet - 192.168.20.0/24" interface=ether1 name=vlan20-office vlan-id=20
add comment="GuestWiFi - 192.168.30.0/24" interface=ether1 name=vlan30-guest vlan-id=30
add comment="CCTV Network - 192.168.40.0/24" interface=ether1 name=vlan40-cctv vlan-id=40
/interface list
add comment="All VLAN interfaces" name=VLAN
add comment="Local interfaces" name=LOCAL
/ip pool
add name=pool-vlan10 ranges=192.168.10.100-192.168.10.200
add name=pool-vlan20 ranges=192.168.20.100-192.168.20.200
add name=pool-vlan30 ranges=192.168.30.100-192.168.30.200
add name=pool-all ranges=192.168.20.50-192.168.20.200
/ip dhcp-server
add address-pool=pool-all interface=bridge-ap1 name=dhcp-main
/port
set 0 name=serial0
/interface bridge port
add bridge=bridge-vlan40 comment="CCTV Switch Access Port" interface=ether2
add bridge=bridge-vlan40 comment="VLAN 40 Interface" interface=vlan40-cctv
add bridge=bridge-ap1 comment="HomeNet to AP1" interface=vlan10-home
add bridge=bridge-ap1 comment="OfficeNet to AP1" interface=vlan20-office
add bridge=bridge-ap1 comment="GuestWiFi to AP1" interface=vlan30-guest
add bridge=bridge-ap1 interface=ether3 pvid=20
add bridge=bridge-ap1 interface=ether1
/ip neighbor discovery-settings
set discover-interface-list=!dynamic
/interface bridge vlan
add bridge=bridge-ap1 tagged=ether1,ether3 vlan-ids=10
add bridge=bridge-ap1 tagged=ether1,ether3 vlan-ids=20
add bridge=bridge-ap1 tagged=ether1,ether3 vlan-ids=30
add bridge=bridge-vlan40 tagged=ether1,ether3 vlan-ids=10
add bridge=bridge-vlan40 tagged=ether1,ether3 vlan-ids=20
add bridge=bridge-vlan40 tagged=ether1,ether3 vlan-ids=30
/interface list member
add interface=vlan10-home list=VLAN
add interface=vlan20-office list=VLAN
add interface=vlan30-guest list=VLAN
add interface=vlan40-cctv list=VLAN
add interface=ether8 list=LOCAL
/ip address
add address=192.168.10.254/24 comment="HomeNet Gateway" interface=vlan10-home network=192.168.10.0
add address=192.168.20.254/24 comment="OfficeNet Gateway" interface=vlan20-office network=192.168.20.0
add address=192.168.30.254/24 comment="GuestWiFi Gateway" interface=vlan30-guest network=192.168.30.0
add address=192.168.40.254/24 comment="CCTV Gateway" interface=vlan40-cctv network=192.168.40.0
add address=192.168.20.253/24 comment="Management Port - VLAN 20" interface=ether8 network=192.168.20.0
/ip dhcp-server network
add address=192.168.10.0/24 dns-server=8.8.8.8,1.1.1.1 gateway=192.168.10.254
add address=192.168.20.0/24 dns-server=8.8.8.8,1.1.1.1 gateway=192.168.20.254
add address=192.168.30.0/24 dns-server=8.8.8.8,1.1.1.1 gateway=192.168.30.254
/ip dns
set allow-remote-requests=yes servers=8.8.8.8,1.1.1.1,192.168.20.1
/ip firewall address-list
add address=192.168.10.0/24 comment="Home Network" list=HomeNet
add address=192.168.20.0/24 comment="Office Network" list=OfficeNet
add address=192.168.30.0/24 comment="Guest Network" list=GuestNet
add address=192.168.40.0/24 comment="CCTV Network" list=CCTVNet
add address=192.168.0.0/16 comment="All Local Networks" list=AllLocal
/ip firewall filter
add action=accept chain=forward comment="Allow internet access" dst-address=!192.168.0.0/16 src-address=192.168.0.0/16
add action=accept chain=forward comment="HomeNet Full Access" src-address-list=HomeNet
add action=accept chain=forward comment="Allow established/related" connection-state=established,related
add action=accept chain=input comment="Allow HomeNet to router" src-address-list=HomeNet
add action=accept chain=input comment="Allow OfficeNet to router" src-address-list=OfficeNet
add action=drop chain=input comment="Block Guest to router" src-address-list=GuestNet
add action=accept chain=input comment="Allow established to router" connection-state=established,related
add action=accept chain=forward comment="Allow UniFi Management" dst-port=8080,8443,8843,8880,6789,27017 protocol=tcp
add action=accept chain=forward comment="Allow UniFi Discovery" dst-port=3478,10001 protocol=udp
/ip firewall nat
add action=masquerade chain=srcnat comment="NAT HomeNet" out-interface=bridge-ap1 src-address=192.168.10.0/24
add action=masquerade chain=srcnat comment="NAT OfficeNet" out-interface=bridge-ap1 src-address=192.168.20.0/24
add action=masquerade chain=srcnat comment="NAT GuestNet" out-interface=bridge-ap1 src-address=192.168.30.0/24
/ip route
add comment="Default via Reyee OfficeNet" distance=1 dst-address=0.0.0.0/0 gateway=192.168.20.1
add comment="Backup via Reyee HomeNet" distance=2 dst-address=0.0.0.0/0 gateway=192.168.10.1
/ip service
set ftp disabled=yes
set telnet disabled=yes
set ssh port=2222
set www port=8080
set api disabled=yes
set api-ssl disabled=yes
/system clock
set time-zone-name=Asia/Bangkok
/system identity
set name=MikroTik-Office-RB3011
/system logging
add topics=dhcp
