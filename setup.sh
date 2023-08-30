#! /bin/sh

set -x

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Install starship terminal
apt-get install curl
curl -sS https://starship.rs/install.sh | sh;

# Get Nerdfont & Normal font for DejaVu
mkdir DejaVuNerdFontMono && cd DejaVuNerdFontMono
array=($(<$SCRIPT_DIR/fonts-url.txt))
for url in "${array[@]}"
do
	curl -fLO $url
done

cd ..
mv ./DejaVuNerdFontMono/ /usr/local/share/fonts
