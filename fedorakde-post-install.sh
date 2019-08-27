#!/bin/bash

while true; do
    read -p "This script may take a lot of time depending on your connection. From time to time you may be asked to type your password and confirm some actions. Do you wish to continue? (y/n):" yn
    case $yn in
        [Yy]* ) echo "Starting up the engines..."; break;;
        [Nn]* ) echo "Quitting..."; exit;;
        * ) echo "-Please answer with 'y' for Yes or 'n' for No and then press 'Enter'.";;
    esac
done

#########################################################
###CREATING WORK FOLDER AND REMOVING UNWANTED PACKAGES###
#########################################################
mkdir /home/"$USER"/Downloads/fedorapostinstall
cd /home/"$USER"/Downloads/fedorapostinstall

sudo dnf remove akregator kget kmail calligra-core grantlee-editor kontact korganizer kf5-ktnef kaddressbook kolourpaint ktorrent konversation krdc krfb falkon kpat kmahjongg kmines k3b juk dragon krusader -y

########################################
###INSTALLLING NEW PACKAGES AND REPOS###
########################################
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg -y
sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo -y

sudo dnf install obs-studio xed dssi-calf-plugins lv2-calf-plugins ladspa-calf-plugins calf ladspa-fil-plugins lv2-swh-plugins ladspa-tap-plugins lv2-synthv1 synthv1 zynaddsubfx zynaddsubfx-common zynaddsubfx-dssi zynaddsubfx-lv2 zynaddsubfx-vst yoshimi amsynth amsynth-data dssi-amsynth-plugin lv2-amsynth-plugin vst-amsynth-plugin ardour5 qjackctl catfish transmission sublime-text lutris steam mscore-fonts gparted audacity kdenlive inkscape VirtualBox devedeng soundkonverter gimp tilix git WoeUSB CPUFreqUtility wget zsh powerline-fonts neofetch pavucontrol python3-pip python3-setuptools python3-libs telegram-desktop ffmpeg ffmpegthumbnailer tumbler flatpak snapd wine wine-fonts mesa-vulkan-drivers vulkan-tools winetricks vlc zenity unrar -y

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo ln -s /var/lib/snapd/snap /snap
sudo su
echo -e "@realtime - rtprio 99\n@realtime - memlock unlimited" > /etc/security/limits.d/99-realtime.conf
exit
sudo groupadd realtime
sudo usermod -a -G realtime "$USER"

python3 -m pip install --user pipx
~/.local/bin/pipx ensurepath

sudo wget https://balena.io/etcher/static/etcher-rpm.repo -O /etc/yum.repos.d/etcher-rpm.repo
sudo dnf install -y balena-etcher-electron

mkdir /home/"$USER"/Downloads/fedorapostinstall/4k
mkdir .appimage_source
mkdir .appimage_source/4kvideodownloader
cd /home/"$USER"/Downloads/fedorapostinstall/4k
wget https://dl.4kdownload.com/app/4kvideodownloader_4.8.2_amd64.tar.bz2?source=website
mv 4kvideodownloader_4.8.2_amd64.tar.bz2\?source=website 4kvideodownloader_4.8.2_amd64.tar.bz2
tar -xjvf 4kvideodownloader_4.8.2_amd64.tar.bz2
mv 4kvideodownloader /home/jedifonseca/.appimage_source/4kvideodownloader

mkdir /home/"$USER"/Downloads/fedorapostinstall/softmakeroffice
cd /home/"$USER"/Downloads/fedorapostinstall/softmakeroffice
wget https://www.softmaker.net/down/softmaker-office-2018-968.x86_64.rpm
sudo dnf localinstall /home/"$USER"/Downloads/fedorapostinstall/softmakeroffice/*.rpm -y

flatpak install flathub org.hydrogenmusic.Hydrogen -y
flatpak install flathub com.spotify.Client -y

###########
###FONTS###
###########
mkdir /home/"$USER"/.fonts

mkdir /home/"$USER"/Downloads/fedorapostinstall/fonts
cd /home/"$USER"/Downloads/fedorapostinstall/fonts
wget https://assets.ubuntu.com/v1/0cef8205-ubuntu-font-family-0.83.zip
unzip *.zip
cp /home/"$USER"/Downloads/fedorapostinstall/fonts/ubuntu-font-family-0.83/*.ttf /home/"$USER"/.fonts


zenity --question --title="Fedora Post Install 1.0" --text="Do you wish to install Warsaw?" --width=600 --height=100
if [[ $? == 0 ]] ; then
   mkdir /home/"$USER"/Downloads/fedorapostinstall/warsaw
   cd /home/"$USER"/Downloads/fedorapostinstall/warsaw
   sudo dnf install nss-tools
   wget https://cloud.gastecnologia.com.br/gas/diagnostico/warsaw_setup_64.rpm
   sudo dnf localinstall warsaw_setup_64.rpm -y
   
else
   echo "Skipping warsaw..."
fi

##########################
###CLEANING UP THE MESS###
##########################
zenity --question --title="Fedora Post Install 1.0" --text="Do you want to remove the work folder '/home/user/Downloads/fedrapostinstall'?" --width=600 --height=100
if [[ $? == 0 ]] ; then
   cd /home/"$USER"/Downloads
   sudo rm -r /home/"$USER"/Downloads/fedorapostinstall
   
else
   echo "'/home/user/Downloads/fedorapostinstall' is untouched."
fi

sudo dnf autoremove -y

zenity --info --title="Fedora Post Install 1.0 - Warning" --text="We'll now install 'Oh My Zshell'...\n\nOnce the installation is complete please DO NOT close the terminal. Type 'exit', press 'Enter', wait for the 'Installation Complete' notification and then you may close it.\n\nIn order to install 'protontricks' close and re-open the Terminal, then run 'pipx install protontricks'.\n\nAfter you see the 'Installation Complete' notification, please reboot your system."  --width=600 --height=100

#############################
###INSTALLING OH MY ZSHELL###
#############################
sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
sudo sed -i 's/bash/zsh/g' /etc/passwd
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/g' /home/"$USER"/.zshrc

zenity --info --title="Fedora Post Install 1.0" --text="Installation complete." --width=200 --height=100
