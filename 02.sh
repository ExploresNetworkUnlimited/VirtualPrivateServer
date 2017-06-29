#
#!/bin/bash
#Script cipta akaun SSH/VPN
#Sunan | Explore Network Unlimited
#

read -p " Username : " User
read -p " Password : " Pass
read -p " Expired  (Days ): " Expday

IP=`dig +short myip.opendns.com @resolver1.opendns.com`
useradd -e `date -d "$Expday days" +"%Y-%m-%d"` -s /bin/false -M $User
Exp="$(chage -l $User | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $User &> /dev/null

echo "==============================================="
echo "Register | Buat Akaun Pelanggan"
echo "==============================================="
echo -e " IP Address: $IP" 
echo -e " Port OpenSSH: 22"
echo -e " Port Dropbear: 443"
echo -e " Squid: 8080"
echo -e " Config OpenVPN: http://$IP/client.ovpn"
echo -e " Username: $User"
echo -e " Password: $Pass"
echo -e " Expired Days: $Exp"
echo "==============================================="
echo "Sunan | Explore Network Unlimited"
echo "==============================================="
echo ""
