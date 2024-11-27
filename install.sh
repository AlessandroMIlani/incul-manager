#!/bin/bash

# Function to check if a package is installed
package_installed() {
	dpkg -l "$1" &>/dev/null
}

need_reboot=false
# Check if the system is Debian 12 with XFCE
if ! grep -q "Debian GNU/Linux 12" /etc/os-release; then
    echo "This script is intended for Debian 12."
    exit 1
fi

if ! echo "$XDG_CURRENT_DESKTOP" | grep -qE "XFCE|KDE"; then
    echo "This script is Compatible only with XFCE and KDE."
    exit 1
fi

git clone -b personal-main https://github.com/AlessandroMIlani/incul-manager.git 


if ! package_installed incus; then
    # Step 1: Setup backports
    echo -e "\n\e[1;33mSet up backports...\e[0m"
    echo "deb http://deb.debian.org/debian bookworm-backports main" | sudo tee /etc/apt/sources.list.d/bookworm-backports.list >/dev/null
    sudo apt update
    
    # Step 2: Install incus
    echo -e "\n\e[1;33mInstall Incus...\e[0m"
    sudo apt install incus/bookworm-backports

    need_reboot=true
fi

sudo apt install python3-netifaces xpra python3-cups python3-opencv python3-gi-cairo xfce4-notifyd

dpkg --build incul-manager
sudo dpkg -i incul-manager.deb


echo -e "\n\e[1;33mSetup user...\e[0m"
CURRENT_USER=$(whoami)

sudo adduser "$CURRENT_USER" incus-admin

# Step 3: setup menu
mkdir -p /home/$USER/.local/share/applications
mkdir -p /home/$USER/.local/share/desktop-directories
mkdir -p /home/$USER/.config/menus
mkdir -p /home/$USER/.config/incul-manager

ssh-keygen -t rsa -b 4096 -C "$CURRENT_USER@incus-containers" -f "/home/$USER/.ssh/incul-id_rsa" -N ""
echo "ssh-add /home/$USER/.ssh/incul-id_rsa > /dev/null 2>&1" >> /home/$USER/.bashrc 

sudo cp -r /etc/inculs-manager/launcher-config/desktop-directories /home/$USER/.local/share/
sudo cp -a /etc/inculs-manager/launcher-config/. /home/$USER/.config/menus/

if $need_reboot; then
    echo -e "\n\e[1;33mIncul-manager dependence needs restart for work correctly. Press any key to confirm the reboot...\e[0m"

    read -n 1 -s -r -p ""

    echo "Restarting the computer..."

    sudo reboot now
else
    echo -e "\n\e[1;33mIncul-manager installed successfully.\e[0m"
fi 
