#!/bin/bash

if [[ $EUID -ne 0 ]]; then

  mkdir tmp
  echo "Installing build essentials..."
  sleep 2
  sudo apt install build-essential libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf xutils-dev libtool automake libxcb-xrm-dev git gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libx11-xcb-dev libxcb-image0-dev libjpeg-dev libxcb-util-dev cmake cmake-data libxcb-ewmh-dev python3-xcbgen xcb-proto libasound2-dev libmpdclient-dev libiw-dev libcurl4-openssl-dev libpulse-dev libjsoncpp-dev pciutils python3-sphinxcontrib.apidoc -y

  echo "Finished installing build essentials."
  sleep 3
  echo "Checking if X is installed..."
  sleep 2
  if dpkg -l | grep -i xorg > /dev/null ; then
    echo "X is installed. Skipping..."
  else
    echo "Installing X..."
    sleep 1
    sudo apt install xorg -y
    echo "X has been installed."
  fi
  sleep 3

  echo "Detecting video driver..."
  sleep 2
  if lspci -v | grep -i 'intel.*hd' > /dev/null ; then
    if dpkg -l | grep -i xserver-xorg-video-intel > /dev/null ; then
      echo "xserver-xorg-video-intel is installed. Skipping..."
    else
      echo "Installing xserver-xorg-video-intel..."
      sleep 1
      sudo apt install xserver-xorg-video-intel -y
      echo "xserver-xorg-video-intel has been installed."
    fi
  elif lspci -v | grep -i amd > /dev/null ; then
    if dpkg -l | grep -i xserver-xorg-video-amdgpu > /dev/null ; then
      echo "xserver-xorg-video-amdgpu is installed. Skipping..."
    else
      echo "Installing xserver-xorg-video-amdgpu..."
      sleep 1
      sudo apt install xserver-xorg-video-amdgpu -y
      echo "xserver-xorg-video-amdgpu has been installed."
    fi
  elif lspci -v | grep -i vmware > /dev/null ; then
    if dpkg -l | grep -i xf86-video-vmware > /dev/null ; then
      echo "xserver-xorg-video-vmware is installed. Skipping..."
    else
      echo "Installing xserver-xorg-video-vmware..."
      sleep 1
      sudo apt install xserver-xorg-video-vmware -y
      echo "xserver-xorg-video-vmware has been installed."
    fi
  else
	  echo "None detected. Skipping..."
  fi
  sleep 3

  echo "Ricing your system..."
  sleep 2
  cd tmp
  
  sudo add-apt-repository ppa:hsheth2/ppa -y
  sudo add-apt-repository ppa:ubuntu-mozilla-daily/ppa -y
  sudo add-apt-repository ppa:regolith-linux/stable -y
  sudo apt update
  sudo apt install i3-gaps i3blocks i3status cava dunst notification-daemon libnotify-bin htop kitty pcmanfm gvfs neofetch feh hsetroot compton alsa-utils pulseaudio pulseaudio-utils acpi rofi xarchiver unzip zip unrar-free p7zip lxappearance playerctl fonts-noto-cjk firefox-trunk xss-lock bc zsh zsh-autosuggestions zsh-syntax-highlighting fonts-cantarell -y

  git clone https://github.com/Raymo111/i3lock-color.git
  cd i3lock-color
  ./install-i3lock-color.sh
  cd ..

  git clone https://github.com/pavanjadhaw/betterlockscreen
  cd betterlockscreen
  sudo cp betterlockscreen /usr/bin
  cd ..

  sudo ln -s /usr/include/jsoncpp/json/ /usr/include/json
  git clone https://github.com/jaagr/polybar.git
  cd polybar && ./build.sh
  cd ..

  mkdir nerd-fonts
  cd nerd-fonts
  wget https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/patched-fonts/Noto/Sans/complete/Noto%20Sans%20Regular%20Nerd%20Font%20Complete.ttf
  sudo cp './Noto Sans Regular Nerd Font Complete.ttf' /usr/share/fonts
  fc-cache -f
  cd ..

  git clone https://gitlab.com/wavexx/acpilight.git
  cd acpilight
  sudo make install
  cd ..
  
  cd ..

  sudo rm -rf /usr/lib/systemd/system/betterlockscreen@.service

  echo "A display manager is often recommended in case you install another window manager or a desktop environment. You can choose not to install a display manager and use startx."
  bash -c ./dmchoose-debian.sh
  sleep 3
  
  echo "Copying files..."
  sleep 2
  cp -r {.cache,.config,.icons,.mozilla,.themes,.zshrc,.gtkrc-2.0} $HOME/
  mkdir -p ~/.config/compton
  cp .config/picom/picom.conf ~/.config/compton/compton.conf
  mv .mozilla/firefox .mozilla/firefox-trunk
  sudo mkdir -p /usr/share/wallpapers
  sudo cp './resources/bg.png' /usr/share/wallpapers/
  sudo cp './resources/fetch.png' /usr/src/source.png
  sudo bash -c 'cp ./.zshrc-root ~/.zshrc'
  echo "Finished copying files."
  sleep 3

  echo "Finishing touches..."
  sleep 2
  mkdir -p $HOME/.cache/i3lock
  sudo chsh $USER -s /bin/zsh
  sudo groupadd video
  sudo usermod -aG video $USER
  sudo sed -i "/session-wrapper=/etc/lightdm/Xsession/c\ " /etc/lightdm/lightdm.conf

  echo "Cleaning up..."
  sleep 2
  rm -rf tmp
  sudo apt autoclean
  sudo apt clean
  echo "[SUCCESS] Rice has been installed. If you encounter an error along the installation, open an issue at https://github.com/JayCeeCreates/nanodesu-dots/issues."
  exit 1
else
  echo 'Running in root. Ignoring...'
  exit 1
fi
