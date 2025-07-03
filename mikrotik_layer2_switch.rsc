# MikroTik RB3011 - Complete Layer 2 Switch Configuration
# Copy paste ทั้งหมดหลังจาก Reset Configuration

# =============================================
# STEP 1: Basic System Setup
# =============================================
/system identity
set name=MikroTik-Office-Switch

/system clock
set time-zone-name=Asia/Bangkok

# =============================================
# STEP 2: Create Main Bridge for VLAN Switching
# =============================================
/interface bridge
add name=bridge-main comment="Main VLAN Switch Bridge" vlan-filtering=yes

# =============================================
# STEP 3: Configure Ethernet Ports
# =============================================
/interface ethernet
set ether1 comment="Trunk from Reyee Switch - VLANs 10,20,30,40"
set ether2 comment="CCTV Switch - Access VLAN 40 + Tagged VLAN 20"
set ether3 comment="UniFi AP Primary - Trunk VLANs 10,20,30"
set ether4 comment="UniFi AP Secondary - Trunk VLANs 10,20,30"
set ether5 comment="Office Device - Access VLAN 20"
set ether6 comment="Office Device - Access VLAN 20"
set ether7 comment="Office Device - Access VLAN 20"
set ether8 comment="Management PC - Access VLAN 20"
set ether9 comment="Spare Port"
set ether10 comment="Spare Port"

# =============================================
# STEP 4: Add Ports to Bridge
# =============================================
/interface bridge port
add bridge=bridge-main interface=ether1 comment="Trunk from Reyee"
add bridge=bridge-main interface=ether2 comment="CCTV + Office Switch"
add bridge=bridge-main interface=ether3 comment="UniFi AP Primary"
add bridge=bridge-main interface=ether4 comment="UniFi AP Secondary"
add bridge=bridge-main interface=ether5 comment="Office Device" pvid=20
add bridge=bridge-main interface=ether6 comment="Office Device" pvid=20
add bridge=bridge-main interface=ether7 comment="Office Device" pvid=20
add bridge=bridge-main interface=ether8 comment="Management PC" pvid=20
add bridge=bridge-main interface=ether9 comment="Spare Port" pvid=20 disabled=yes
add bridge=bridge-main interface=ether10 comment="Spare Port" pvid=20 disabled=yes

# =============================================
# STEP 5: Configure VLAN on Bridge
# =============================================
/interface bridge vlan
add bridge=bridge-main tagged=ether1,ether3,ether4 vlan-ids=10 comment="HomeNet"
add bridge=bridge-main tagged=ether1,ether2,ether3,ether4 untagged=ether5,ether6,ether7,ether8,ether10 vlan-ids=20 comment="OfficeNet"
add bridge=bridge-main tagged=ether1,ether3,ether4 vlan-ids=30 comment="GuestWiFi"
add bridge=bridge-main tagged=ether1,ether2 vlan-ids=40 comment="CCTV"

# =============================================
# STEP 6: Enable VLAN Filtering
# =============================================
/interface bridge
set bridge-main vlan-filtering=yes

# =============================================
# STEP 7: Management IP Configuration
# =============================================
/ip address
add address=192.168.20.253/24 interface=bridge-main comment="Management IP - VLAN 20"

# =============================================
# STEP 8: Default Route to Reyee Router
# =============================================
/ip route
add dst-address=0.0.0.0/0 gateway=192.168.20.1 comment="Default via Reyee Router"

# =============================================
# STEP 9: DNS Configuration
# =============================================
/ip dns
set servers=192.168.20.1,8.8.8.8,1.1.1.1 allow-remote-requests=yes

# =============================================
# STEP 10: Service Configuration
# =============================================
/ip service
set ftp disabled=yes
set telnet disabled=yes
set ssh port=2222
set www port=8080
set api disabled=yes
set api-ssl disabled=yes

# =============================================
# STEP 11: Interface Lists (for Management)
# =============================================
/interface list
add name=TRUNK comment="Trunk Ports"
add name=ACCESS comment="Access Ports"
add name=MGMT comment="Management Ports"

/interface list member
add interface=ether1 list=TRUNK
add interface=ether2 list=TRUNK
add interface=ether3 list=TRUNK
add interface=ether4 list=TRUNK
add interface=ether5 list=ACCESS
add interface=ether6 list=ACCESS
add interface=ether7 list=ACCESS
add interface=ether8 list=MGMT
add interface=ether9 list=ACCESS
add interface=ether10 list=ACCESS

# =============================================
# STEP 12: Security Settings
# =============================================
/ip neighbor discovery-settings
set discover-interface-list=MGMT

# =============================================
# STEP 13: Logging Configuration
# =============================================
/system logging
add topics=system,info
add topics=interface,info
add topics=bridge,info

# =============================================
# STEP 14: SNMP (Optional - for Monitoring)
# =============================================
/snmp
set enabled=yes contact="Network Admin" location="Office"

# =============================================
# CONFIGURATION COMPLETE
# =============================================
