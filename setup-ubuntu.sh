#! /usr/bin/env bash +x

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Install starship terminal
sudo apt-get install curl
curl -sS https://starship.rs/install.sh | sh
echo "eval \"$(starship init bash)\"" >> ~/.bashrc

# Get Nerdfont & Normal font for DejaVu
TTF_URLS=($(<$SCRIPT_DIR/fonts-url.txt))
FONT_DIR=DejaVuSansMNerdFontMono
for url in "${TTF_URLS[@]}"
do
	curl -fLO $url
done
mkdir -p /usr/local/share/fonts/${FONT_DIR}
sudo mv -f ./DejaVuSansMNerdFontMono* /usr/local/share/fonts/${FONT_DIR}

FONT_NAME=$(fc-scan --format "%{fullname[$(( $(sed -E 's/^(.*)en.*/\1/;s/[^,]//g' <<<"$(fc-scan --format "%{fullnamelang}\n" /usr/local/share/fonts/${FONT_DIR}/${FONT_DIR}-Regular.ttf)" | wc -c) -1 ))]}\n" /usr/local/share/fonts/${FONT_DIR}/${FONT_DIR}-Regular.ttf)

# Set font for Ubuntu console
CONSOLE_PROFILE_UUID=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \') 
sudo apt-get install dbus-x11
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${CONSOLE_PROFILE_UUID}/ use-system-font false
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${CONSOLE_PROFILE_UUID}/ use-theme-colors false
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${CONSOLE_PROFILE_UUID}/ background-color '#303030'
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${CONSOLE_PROFILE_UUID}/ palette "['rgb(23,20,33)', 'rgb(192,28,40)', 'rgb(38,162,105)', 'rgb(162,115,76)', 'rgb(18,72,139)', 'rgb(163,71,186)', 'rgb(42,161,179)', 'rgb(208,207,204)', 'rgb(94,92,100)', 'rgb(246,97,81)', 'rgb(51,209,122)', 'rgb(233,173,12)', 'rgb(42,123,222)', 'rgb(192,97,203)', 'rgb(51,199,222)', 'rgb(255,255,255)']"
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${CONSOLE_PROFILE_UUID}/ background-transparency-percent 20
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${CONSOLE_PROFILE_UUID}/ font "${FONT_NAME} 16"

# Apply config file for starship
cd $SCRIPT_DIR
mkdir -p $HOME/.config
/usr/bin/cp "./starship.toml" "$HOME/.config"
