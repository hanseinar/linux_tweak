#!/bin/bash
# Liste over nødvendige verktøy:
sudo apt install wget curl git dpkg jq software-properties-common libglib2.0-bin intel-microcode -y


# Gjør det kjørbart ved å kjøre: 
# chmod +x linux_tweak.sh.
# Kjør skriptet med: ./linux_tweak.sh.


clear
echo "################################################################"
echo "#                                                              #"
echo "#        Fjerner programmer, manualer og dokumentasjon         #"
echo "#                                                              #"
echo "################################################################"

# Manuals and documentation
sudo apt-get purge --autoremove man-db -y
sudo rm -rf /usr/share/man/*
sudo rm -rf /usr/share/doc/*


# LibreOffice
sudo apt purge libreoffice* -y

# GIMP (bilderedigeringsprogram)
sudo apt purge gimp -y

# VLC (media player)
# sudo apt purge vlc -y

# Thunderbird (e-postklient)
sudo apt purge thunderbird -y

# Rhythmbox (musikkspiller)
sudo apt purge rhythmbox -y

# Transmission (BitTorrent-klient)
sudo apt purge transmission-gtk -y

# Cheese (webkamera-program)
# sudo apt purge cheese -y

# Games (forhåndsinstallerte spill på noen distroer)
sudo apt purge gnome-games -y

# InkScape (vektorgrafikk-program)
sudo apt purge inkscape -y

# OBS Studio (streaming og opptaksprogram)
sudo apt purge obs-studio -y


# clear
echo "################################################################"
echo "#                                                              #"
echo "#        Installerer programmer                                #"
echo "#                                                              #"
echo "################################################################"


# Installerer Notepadqq
echo "Vil du installere Notepadqq? (y/n)"
read -p "> " choice
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    echo "Installerer Notepadqq..."
    sudo add-apt-repository ppa:notepadqq-team/notepadqq -y
    sudo apt update
    sudo apt install notepadqq -y
else
    echo "Hopper over Notepadqq"
fi


# Installerer Google Chrome
echo "Vil du installere Chrome? (y/n)"
read -p "> " choice
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    echo "Installerer Google Chrome..."
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo chown _apt: google-chrome-stable_current_amd64.deb
    sudo apt install ./google-chrome-stable_current_amd64.deb -y
    rm google-chrome-stable_current_amd64.deb
else
    echo "Hopper over Chrome"
fi


# Installerer Flameshot
echo "Installerer Flameshot..."
sudo apt install flameshot -y

# Setter Flameshot til å starte ved oppstart
mkdir -p ~/.config/autostart
# Må stå uten innhykk
cat > ~/.config/autostart/flameshot.desktop <<EOF
[Desktop Entry]
Type=Application
Exec=flameshot
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=Flameshot
Name=Flameshot
Comment[en_US]=Screenshot tool
Comment=Screenshot tool
EOF

# Installerer ZeroTier ved hjelp av deres installasjonsskript
echo "Vil du installere ZeroTier? (y/n)"
read -p "> " choice
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    echo "Installerer ZeroTier..."
    curl -s https://install.zerotier.com | sudo bash
else
    echo "Hopper over ZeroTier"
fi



# Installerer RustDesk
echo "Vil du installere RustDesk? (y/n)"
read -p "> " choice
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    echo "Installerer RustDesk..."
    sudo apt install jq
    wget https://github.com/rustdesk/rustdesk/releases/download/1.2.2/rustdesk-1.2.2-x86_64.deb
    sudo apt install ./rustdesk-1.2.2-x86_64.deb -y
    rm rustdesk-1.2.2-x86_64.deb
else
    echo "Hopper over RustDesk"
fi

# clear
echo "################################################################"
echo "#                                                              #"
echo "#        Endrer utseende                                       #"
echo "#                                                              #"
echo "################################################################"
echo "Vil du endrer utseende? (y/n)"
read -p "> " choice
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    # Endrer utseende
    # Installerer Adapta-Nokto tema
    echo "Installerer Adapta-Nokto tema..."
    sudo add-apt-repository ppa:tista/adapta -y
    sudo apt update
    sudo apt install adapta-gtk-theme -y

    # Endrer temaer til Adapta-Nokto via `gsettings`. Dette endrer temaet for den nåværende brukeren.
    echo "Setter Adapta-Nokto som standard tema..."
    settings set org.cinnamon.desktop.interface gtk-theme 'Adapta-Nokto'
    gsettings set org.cinnamon.desktop.wm.preferences theme 'Adapta-Nokto'
    gsettings set org.cinnamon.theme name 'Adapta-Nokto'
    
    # Installerer en muspeker som ligner på Windows
    echo "Installerer Windows-lignende muspeker..."
    sudo apt install dmz-cursor-theme -y
    gsettings set org.cinnamon.desktop.interface cursor-theme 'DMZ-White'
    
    # Setter ikontemaet til Mint-Y-Sand
    echo "Setter ikontemaet til Mint-Y-Sand..."
    gsettings set org.cinnamon.desktop.interface icon-theme 'Mint-Y-Sand'       
    # Endre ikon er ferdig!
    
    echo "Endrer visning og evt andre tweeks"
    # Endrer visning og evt andre tweeks
    # Setter standardvisning for kataloger til listevisning i Nemo
    gsettings set org.nemo.preferences default-folder-viewer 'list-view'
    echo "Standardvisningen for kataloger er nå satt til listevisning."
    # Endrer visning og evt andre tweeks ferdig!
else
    echo "Hopper over utseende"
fi



# clear
echo "################################################################"
echo "#                                                              #"
echo "#        Rydder opp i OS'et                                    #"
echo "#                                                              #"
echo "################################################################"
# Fjerner gamle versjoner av installerte pakker
sudo apt autoremove

# Renser lokal lagringsplass for pakkefiler
sudo apt clean

# Fjerner gamle Linux-kjerner (IKKE fjern den som er i bruk)
dpkg --list | grep linux-image | awk '{ print $2 }' | sort -V | sed -n '/'`uname -r`'/q;p' | xargs sudo apt purge -y

# Installerer og bruker deborphan for å finne og fjerne foreldreløse pakker
sudo apt install deborphan
sudo deborphan | xargs sudo apt purge -y

# Fjerner gamle konfigurasjonsfiler for pakker som har blitt fjernet
dpkg --list | grep '^rc' | awk '{ print $2 }' | xargs sudo apt purge -y

# Fjerner cache-filer for den nåværende brukeren
rm -rf ~/.cache/*

# Tømmer søppelbøtten for den nåværende brukeren
echo "Tømmer søppelbøtten..."
rm -rf ~/.local/share/Trash/files/*


echo "Kjører delen to ganger da det er vanskelig å rydde alt første gangen"
# Kjører deler to ganger da det er vanskelig å rydde alt første gangen
sudo apt update
# Fjerner gamle versjoner av installerte pakker
sudo apt autoremove

# Renser lokal lagringsplass for pakkefiler
sudo apt clean

# Fjerner gamle Linux-kjerner (IKKE fjern den som er i bruk)
dpkg --list | grep linux-image | awk '{ print $2 }' | sort -V | sed -n '/'`uname -r`'/q;p' | xargs sudo apt purge -y

# Installerer og bruker deborphan for å finne og fjerne foreldreløse pakker
sudo apt install deborphan
sudo deborphan | xargs sudo apt purge -y

# Fjerner gamle konfigurasjonsfiler for pakker som har blitt fjernet
dpkg --list | grep '^rc' | awk '{ print $2 }' | xargs sudo apt purge -y

# Fjerner cache-filer for den nåværende brukeren
rm -rf ~/.cache/*

# Tømmer søppelbøtten for den nåværende brukeren
echo "Tømmer søppelbøtten..."
rm -rf ~/.local/share/Trash/files/*

echo "Tweaking av Linux Mint er ferdig. Du vil kanskje starte datamaskinen på nytt."


#clear
echo "################################################################"
echo "#                                                              #"
echo "#        Skifte kernel og installere lyddriver for C771        #"
echo "#                                                              #"
echo "################################################################"
# Fortsett med kloning dersom git er tilgjengelig. kjører lyddriver for C771 maskiner svar ja eller nei
echo "Vil du klone sklnau8825max-on-linux fra GitHub? (y/n)"
read -p "> " choice
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    # Kode for å klone GitHub-repositoriet og gå inn i mappen
    sudo apt install git -y
    echo "Kloner sklnau8825max-on-linux..."
    git clone https://github.com/PiotrZPL/sklnau8825max-on-linux.git
    cd sklnau8825max-on-linux
    sudo ./script.sh
else
    echo "Hopper over kloning av sklnau8825max-on-linux."
fi
