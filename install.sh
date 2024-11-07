#!/bin/bash

# Function to check if a package is installed
package_installed() {
	dpkg -l "$1" &>/dev/null
}

# Step 1: Setup backports
echo -e "\n\e[1;33mSet up backports...\e[0m"
echo "deb http://deb.debian.org/debian bookworm-backports main" | sudo tee /etc/apt/sources.list.d/bookworm-backports.list >/dev/null
sudo apt update

# Step 2: Install incus if not already installed
echo -e "\n\e[1;33mInstall Incus...\e[0m"
if ! package_installed incus; then
	sudo apt install incus/bookworm-backports
	need_reboot=true
else
	echo "Incus is already installed."
	need_reboot=false
fi

echo -e "\n\e[1;33mSetup user...\e[0m"
CURRENT_USER=$(whoami)

sudo adduser "$CURRENT_USER" incus-admin

# Step 3: setup menu
mkdir -p /home/$USER/.local/share/applications
mkdir -p /home/$USER/.local/share/desktop-directories
mkdir -p /home/$USER/.config/menus
mkdir -p /home/$USER/.config/inculs-manager
mkdir -p /home/$USER/.config/inculs-manager/configs

sudo cp -r /etc/inculs-manager/launcher-config/desktop-directories /home/$USER/.local/share/
sudo cp /etc/inculs-manager/launcher-config/xfce-applications.menu /home/$USER/.config/menus

read -n 1 -s -r -p ""

git clone https://github.com/AlessandroMIlani/incul-manager -b dev
dpkg-deb --root-owner-group --build incul-manager
sudo apt install ./incul-manager.deb --fix-broken
rm incul-manager.deb


if [ "$need_reboot" = true ]; then
	echo -e "\n\e[1;33mIncul needs restart. This action requires confirmation. Press any key to continue...\e[0m"
	echo "Restarting the computer..."
	sudo reboot now
else
	echo "No need to reboot."
fi

echo -e "\n\e[1;32mInstallation complete!\e[0m"
