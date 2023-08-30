#! /bin/sh

set -x

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Install starship terminal
apt-get install curl
curl -sS https://starship.rs/install.sh | sh
echo "eval \"$(starship init bash)\"" >> ~/.bashrc

# Get Nerdfont & Normal font for DejaVu
mkdir DejaVuNerdFontMono && cd DejaVuNerdFontMono
TTF_URLS=($(<$SCRIPT_DIR/fonts-url.txt))
for url in "${TTF_URLS[@]}"
do
	curl -fLO $url
done

cd ..
mv ./DejaVuNerdFontMono/ /usr/local/share/fonts

FONT_NAME=$(fc-scan --format "%{fullname[$(( $(sed -E 's/^(.*)en.*/\1/;s/[^,]//g' <<<"$(fc-scan --format "%{fullnamelang}\n" /usr/share/fonts/truetype/abyssinica/AbyssinicaSIL-Regular.ttf)" | wc -c) -1 ))]}\n" /usr/local/share/fonts/)

# Set font for Ubuntu console
CONSOLE_PROFILE_UUID=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \') 
gsetting set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${CONSOLE_PROFILE_UUID}/ use-system-font false
gsetting set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${CONSOLE_PROFILE_UUID}/ font 'DejaVuSansM Nerd Font Mono 16'

# Apply config file for starship
cd $SCRIPT_DIR
mkdir -p ~/.config
mv ./starship.toml ~/.config/starship.toml
