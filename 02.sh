#
#!/bin/bash
#Script cipta akaun SSH/VPN
#Sunan | Explore Network Unlimited
#

read -p " Username : " userName
read -p " Password : " passWord
read -p " Expired [Days]: " expDate

IP=`dig +short myip.opendns.com @resolver1.opendns.com`
useradd -e `date -d "$expDate days" +"%Y-%m-%d"` -s /bin/false -M $User
passWord="$(chage -l $userName | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$passWord\n$passWord\n"|passwd $userName &> /dev/null

echo "==============================================="
echo "Register | Buat Akaun Pelanggan"
echo "==============================================="
echo -e " IP Address: $IP" 
echo -e " Port OpenSSH: 22, 2020"
echo -e " Port Dropbear: 443, 4343"
echo -e " Squid: 8080, 3128"
echo -e " Config OpenVPN: http://$IP/client.ovpn"
echo -e " Username: $userName"
echo -e " Password: $passWord"
echo -e " Expired Days: $expDate"
echo "==============================================="
echo "Sunan | Explore Network Unlimited"
echo "==============================================="
echo ""
