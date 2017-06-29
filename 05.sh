#
#!/bin/bash
#Script mengunci akaun SSH/VPN
#Sunan | Explore Network Unlimited
#

read -p "Username Account going to be lock: " User
passwd -l $User

echo "==============================================="
echo "Sunan | Explore Network Unlimited"
echo "==============================================="
echo ""
