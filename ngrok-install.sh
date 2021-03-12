#!/bin/bash

info()  { echo -e "\\033[1;32m[INFO]\\033[0m  $*"; }
fatal() { echo -e "\\033[1;31m[FATAL]\\033[0m  $*"; exit 1 ; }


#arch
arch=$(uname -m)
ngrok=$(command -v ngrok)

banner() {
clear
echo -e """\033[1;32m

███▄    █   ▄████  ██▀███   ▒█████   ██ ▄█▀
 ██ ▀█   █  ██▒ ▀█▒▓██ ▒ ██▒▒██▒  ██▒ ██▄█▒
▓██  ▀█ ██▒▒██░▄▄▄░▓██ ░▄█ ▒▒██░  ██▒▓███▄░
▓██▒  ▐▌██▒░▓█  ██▓▒██▀▀█▄  ▒██   ██░▓██ █▄
▒██░   ▓██░░▒▓███▀▒░██▓ ▒██▒░ ████▓▒░▒██▒ █▄
░ ▒░   ▒ ▒  ░▒   ▒ ░ ▒▓ ░▒▓░░ ▒░▒░▒░ ▒ ▒▒ ▓▒
░ ░░   ░ ▒░  ░   ░   ░▒ ░ ▒░  ░ ▒ ▒░ ░ ░▒ ▒░
   ░   ░ ░ ░ ░   ░   ░░   ░ ░ ░ ░ ▒  ░ ░░ ░
         ░       ░    ░         ░ ░  ░  ░

\033[00m
"""
sleep 3
}


check() {
if [ "$ngrok" == "/usr/bin/ngrok" ] ; then
  info "Ngrok ya instalado..."
  sleep 3
else
  info "Ngrok no está instalado. Instalando..."
  ngrok_install
fi
}



menu() {
banner
printf "\e[1;93m\e[0m\e[1;92mEscoge una opción\e[0m \e[1;93m\e[0m\n"
printf "\n"
printf "\e[1;93m\e[0m\e[1;92m===============================================================\e[0m \e[1;93m\e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;93m Kali (PC,Userland,Rootless)\e[0m   \e[1;92m[\e[0m\e[1;77m02\e[0m\e[1;92m]\e[0m\e[1;93m Termux\e[0m    \e[1;92m[\e[0m\e[1;77m99\e[0m\e[1;92m]\e[0m\e[1;93m Salir\n"
printf "\e[1;93m\e[0m\e[1;92m===============================================================\e[0m \e[1;93m\e[0m\n"

read -p $'\n\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Escoja una de las opciones: \e[0m\en' option

if [[ $option == 1 || $option == 01 ]]; then
banner
check
elif [[ $option == 2 || $option == 02 ]]; then
banner
ngrok_install
elif [[ $option == 99 ]]; then
echo -e "\033[92m[•] \033[93m\nBye!\n"
sleep 1
exit 1
else
printf "\e[1;93m [!] Opcion invalida!\e[0m\n"
sleep 3
menu
fi
}


end() {
banner
echo -e "\033[92m[•] \033[93m\nFinalizado exitosamente!...\n"
echo -e "\033[92m[•] \033[93mEjecuta un comando:"
printf "\e[1;93m\e[0m\e[1;92m========================================\e[0m \e[1;93m\e[0m\n"
echo -e "\033[92m[•] \033[93m        ngrok http 8080"
echo -e "\033[92m[•] \033[93m        ngrok tcp 5010"
printf "\e[1;93m\e[0m\e[1;92m========================================\e[0m \e[1;93m\e[0m\n\n"
sleep 2
}


install_linux() {
  info "Detectando distro linux..."

  Distro=''
  if [ -f /etc/os-release ] ; then
    DISTRO_ID=$(grep ^ID= /etc/os-release | cut -d= -f2-)
    if [ "${DISTRO_ID}" = 'kali' ] ; then
      Distro='Kali'
    elif [ "${DISTRO_ID}" = 'debian' ] ; then
      Distro='Debian'
    elif [ "${DISTRO_ID}" = 'arch' ] || [ "${DISTRO_ID}" = 'archarm' ] ; then
      Distro='Arch'
    elif [ "${DISTRO_ID}" = 'parrot' ] ; then
      Distro="Parrot"
    elif [ "${DISTRO_ID}" = "ubuntu" ] ; then
      Distro="Ubuntu"
  else
    Distro="Termux"
    fi
  fi
  readonly Distro
  sleep 2
  info "Distro Linux: ${Distro}"
  sleep 2
  neofetch --ascii_distro $Distro
  echo
  info "Instalando en ${Distro} paquetes necesarios..."
  sleep 3
  if [ "${Distro}" = "Debian" ] || [ "${Distro}" = "Kali" ] || [ "${Distro}" = "Ubuntu" ] || [ "${Distro}" = "Parrot" ] ; then
#    sudo apt-get update && sudo apt-get upgrade -y
    sudo apt-get install curl git wget net-tools unzip nano -y
    clear
  elif [ "${Distro}" = "Termux" ]; then
    pkg update && pkg upgrade
    pkg install -y unzip curl wget nano
    clear
  elif [ "${Distro}" = "Arch" ]; then
    pacman -Syu # Update System...
    pacman -S curl git wget unzip #dependences
    clear
  fi
}


ngrok_install() {

if [ "${Distro}" = "Debian" ] || [ "${Distro}" = "Kali" ] || [ "${Distro}" = "Ubuntu" ] || [ "${Distro}" = "Parrot" ] ; then
    ngrok-kali
elif [ "${Distro}" = "Termux" ]  ; then
    ngrok-t
else
    fatal "Instalación de ngrok en ${Distro} aún no soportada :/"
fi
}

ngrok-kali() {
if [ $arch == 'aarch64' ] ; then
clear
info "Instalando ngrok en ${Distro}...\\033[0m"
sleep 5
wget "https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm64.tgz"
tar -xvzf  "ngrok-stable-linux-arm64.tgz"
rm ngrok-stable-linux-arm64.tgz
chmod 777 ngrok
cp ngrok /usr/bin/
sleep 5
echo -e "\033[92m[•] \033[93mEscribe tu authtoken de ngrok y pulsa ENTER... "
read -r token
$token
sleep 1
clear
info "Ngrok Listo!... "
sleep 2
end
elif [ $arch == 'arm' ] ; then
info "Instalando ngrok en ${Distro}...\\033[0m"
sleep 5
unzip depen/ngrok-stable-linux-arm.zip
chmod 777 ngrok
cp ngrok /usr/bin/
sleep 5
echo -e "\033[92m[•] \033[93mEscribe tu authtoken de ngrok y pulsa ENTER... "
read -r token
$token
sleep 1
clear
info "Ngrok Listo!... "
sleep 2
end
elif [ $arch == 'x86_64' ] ; then
info "Instalando ngrok en ${Distro}...\\033[0m"
sleep 5
wget "https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip"
unzip ngrok-stable-linux-amd64.zip
rm ngrok-stable-linux-amd64.zip
chmod 777 ngrok
cp ngrok /usr/bin/
sleep 5
echo -e "\033[92m[•] \033[93mEscribe tu authtoken de ngrok y pulsa ENTER... "
read -r token
$token
sleep 1
clear
info "Ngrok Listo!... "
sleep 2
end
elif [ $arch == 'i686' ] ; then
info "Instalando ngrok en ${Distro}...\\033[0m"
sleep 5
wget "https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-386.zip"
unzip ngrok-stable-linux-386.zip
rm ngrok-stable-linux-386.zip
chmod 777 ngrok
cp ngrok /usr/bin/
sleep 5
echo -e "\033[92m[•] \033[93mEscribe tu authtoken de ngrok y pulsa ENTER... "
read -r token
$token
sleep 1
info "Ngrok Listo!... "
sleep 2
end
else
echo -e "\033[92m[•] \033[93mNgrok no soportado :/"
fi
}

ngrok-t() {
if [ $arch == 'aarch64' ] ; then
clear
info "Instalando ngrok en ${Distro}...\\033[0m"
sleep 5
wget "https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm64.tgz"
tar -xvzf  "ngrok-stable-linux-arm64.tgz"
rm ngrok-stable-linux-arm64.tgz
chmod 777 ngrok
cp ngrok $PREFIX/bin/
sleep 5
echo -e "\033[92m[•] \033[93mEscribe tu authtoken de ngrok y pulsa ENTER... "
read -r token
$token
sleep 1
clear
info "Ngrok Listo!... "
sleep 2
end
elif [ $arch == 'arm' ] ; then
info "Instalando ngrok en ${Distro}...\\033[0m"
sleep 5
unzip depen/ngrok-stable-linux-arm.zip
chmod 777 ngrok
cp ngrok $PREFIX/bin/
sleep 5
echo -e "\033[92m[•] \033[93mEscribe tu authtoken de ngrok y pulsa ENTER... "
read -r token
$token
sleep 1
clear
info "Ngrok Listo!... "
sleep 2
end
fi
}


menu
