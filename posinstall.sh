#!/usr/bin/env bash
# variables
ppa_lutris="ppa:lutris-team/lutris"

url_wine_key="https://dl.winehq.org/wine-builds/winehq.key"
url_ppa_wine="https://dl.winehq.org/wine-builds/ubuntu/"
url_rstudio="https://download1.rstudio.org/desktop/bionic/amd64/rstudio-1.3.1093-amd64.deb"
url_onlyoffice="https://download.onlyoffice.com/install/desktop/editors/linux/old/onlyoffice-desktopeditors_amd64.deb?_ga=2.172857315.1532461283.1603720995-364841503.1600905442"
url_flatpak_stremio="https://dl.strem.io/shell-linux/v4.4.116/Stremio+4.4.116.flatpak"
url_appimage_clipgrap="https://download.clipgrab.org/ClipGrab-3.8.14-x86_64.AppImage"

url_icon_clipgrab="https://upload.wikimedia.org/wikipedia/commons/7/72/Clipgrab-logo-ikonoa.png"

dir_dowloads="$HOME/Downloads/programs"
dir_app="$HOME/.apps"
dir_desktop="$HOME.local/share/applications/"

# apt's list
to_install=(
  snapd
  r-base
  telegram-desktop
  virtualbox
  lutris
  synaptic
  pip3
  nodejs
  npm
  easytag
  obs-studio
  libclang-dev
  flatpak
)

###################################################################################################
# Remove lock apt
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

# Add architecture 32 bits for wine
sudo dpkg --add-architecture i386

# Add repositories
sudo apt-add-repository "$ppa_lutris" -y
wget -nc "$url_wine_key"
sudo apt-key add winehq.key
sudo apt-add-repository "deb $url_wine_key focal main" -y

# Updating repositories
sudo apt update -y

# Install wine
sudo apt install --install-recommends winehq-stable

# Install all apt
for name in ${to_install[@]} 
do
    sudo apt install "$name" -y
done

# Dowloads packages .deb
mkdir "$dir_dowloads"
cd $dir_dowloads
wget "$url_rstudio"
wget "$url_onlyoffice"
wget "$url_flatpak_stremio"
wget "$url_appimage_clipgrap"
wget "$url_icon_clipgrab"

# Install all packages .deb
sudo dpkg -i *.deb
cd

# Install Stremio
sudo flatpak install Stremio+4.4.116.flatpak

# Install nativefier
sudo npm install nativefier -g

# Install jupyter-notebook
sudo pip install notebook

# Install spotify
sudo snap install spotify

###################################################################################################
# Create and copy AppImages
mkdir "$dir_app"
cp $dir_dowloads/ClipGrab-3.8.14-x86_64.AppImage $dir_app
cp $dir_dowloads/Clipgrab-logo-ikonoa.png $dir_app

# Install web app to whatsapp
cd $dir_app
sudo nativefier --name "WhatsApp" "https://web.whatsapp.com/"
cd


# Create directory to .desktop
if [ -d "$HOME/.local/share/applications/" ] 
then
    echo "Exist directory." 
else
    mkdir "$HOME/.local/share/applications/"
fi


# Executables
exec_clipgrab="$HOME/.apps/ClipGrab-3.8.14-x86_64.AppImage"
chmod +x $HOME/.apps/ClipGrab-3.8.14-x86_64.AppImage
exec_whatsapp="$HOME/.apps/WhatsApp-linux-x64/WhatsApp"
chmod +x $HOME/.apps/WhatsApp-linux-x64/WhatsApp

# Icon 
icon_clipgrab="$HOME/.apps/Clipgrab-logo-ikonoa.png"
icon_whatsapp="$HOME/.apps/WhatsApp-linux-x64/resources/app/icon.png"

# Edit .desktop files
echo "[Desktop Entry]
Comment=
Exec=$exec_clipgrab
Icon=$icon_clipgrab
Name=ClipGrab
NoDisplay=false
Path[$e]=
StartupNotify=true
Terminal=0
TerminalOptions=
Type=Application" > "$HOME/.local/share/applications/ClipGrab.desktop"

echo "[Desktop Entry]
Comment=
Exec=$exec_whatsapp
Icon=$icon_whatsapp
Name=WhatsApp
NoDisplay=false
Path[$e]=
StartupNotify=true
Terminal=0
TerminalOptions=
Type=Application" > "$HOME/.local/share/applications/WhatsApp.desktop"


###################################################################################################
# Update and upgrade
sudo apt update && sudo apt dist-upgrade -y
flatpak update
sudo apt autoclean
sudo apt autoremove -y
