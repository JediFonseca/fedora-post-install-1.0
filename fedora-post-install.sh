#!/bin/bash

#########################################################
###CREATING WORK FOLDER AND REMOVING UNWANTED PACKAGES###
#########################################################
mkdir /home/"$USER"/Downloads/fedorapostinstall
cd /home/"$USER"/Downloads/fedorapostinstall

sudo dnf remove rhythmbox cheese libreoffice-base gnome-maps gnome-weather gnome-videos gnome-contacts libreoffice-calc libreoffice-draw libreoffice-impress libreoffice-writer -y

########################################
###INSTALLLING NEW PACKAGES AND REPOS###
########################################
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf install lutris steam mscore-fonts gparted audacity-freeworld kdenlive inkscape VirtualBox devedeng soundkonverter gimp tilix git WoeUSB CPUFreqUtility wget zsh powerline-fonts neofetch paper-icon-theme pavucontrol breeze-cursor-theme gnome-tweaks chrome-gnome-shell python3-pip python3-setuptools python3-libs telegram-desktop ffmpeg ffmpegthumbnailer tumbler flatpak snapd wine wine-fonts mesa-vulkan-drivers vulkan-tools vlc zenity -y

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo ln -s /var/lib/snapd/snap /snap

python3 -m pip install --user pipx
~/.local/bin/pipx ensurepath

sudo wget https://balena.io/etcher/static/etcher-rpm.repo -O /etc/yum.repos.d/etcher-rpm.repo
sudo dnf install -y balena-etcher-electron

mkdir /home/"$USER"/Downloads/fedorapostinstall/softmakeroffice
cd /home/"$USER"/Downloads/fedorapostinstall/softmakeroffice
wget https://www.softmaker.net/down/softmaker-office-2018-968.x86_64.rpm
sudo dnf localinstall /home/"$USER"/Downloads/softmakeroffice/*.rpm -y

flatpak install flathub org.hydrogenmusic.Hydrogen -y
flatpak install flathub com.spotify.Client -y

######################
###THEMES AND FONTS###
######################
mkdir /home/"$USER"/.local/share/icons
mkdir /home/"$USER"/.icons
mkdir /home/"$USER"/.themes
mkdir /home/"$USER"/.fonts

cp -r /usr/share/icons/breeze_cursors /home/"$USER"/.local/share/icons
cp -r /usr/share/icons/breeze_cursors /home/"$USER"/.icons

mkdir /home/"$USER"/Downloads/fedorapostinstall/fonts
cd /home/"$USER"/Downloads/fonts
wget https://assets.ubuntu.com/v1/0cef8205-ubuntu-font-family-0.83.zip
unzip *.zip
cp /home/"$USER"/Downloads/fonts/ubuntu-font-family-0.83/*.ttf /home/"$USER"/.fonts


zenity --question --text=Do you wish to install Warsaw?
if [[ $? == 0 ]] ; then
   mkdir /home/"$USER"/Downloads/fedorapostinstall/warsaw
   cd /home/"$USER"/Downloads/fedorapostinstall/warsaw
   git clone
   cd
   source warsaw.sh
   
else
   echo "Skipping warsaw..."
fi

##########################
###CLEANING UP THE MESS###
##########################
sudo rm -r /home/"$USER"/Downloads/fedorapostinstall
sudo dnf autoremove -y

zenity --info --title="Fedora Post Install 1.0 - Warning" --text="We'll now install 'Oh My Zshell'...\n\nOnce the installation is complete please DO NOT close the terminal. Type 'exit', press 'Enter', wait for the 'Installation Complete' notification and then you may close it.\n\nIn order to install 'protontricks' close and re-open the Terminal, then run 'pipx install protontricks'.\n\nAfter you see the 'Installation Complete' notification, please reboot your system."  --width=600 --height=100

#############################
###INSTALLING OH MY ZSHELL###
#############################
sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
sudo sed -i 's/bash/zsh/g' /etc/passwd
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' /home/"$USER"/.zshrc

zenity --info --title="Fedora Post Install 1.0" --text="Installation complete." --width=200 --height=100
