#
#!/bin/bash
#Script Delete Account SSH & VPN
#
read -p "Username Account going to be delete: " Nama
userdel -r $Nama
echo "==============================================="
echo "DOCTYPE | Explore Network Unlimited"
echo "==============================================="
echo ""
