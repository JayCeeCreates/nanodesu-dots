#!/bin/bash

if [[ $EUID -ne 0 ]]; then

  mkdir tmp

  sudo cp './pacman.conf' '/etc/pacman.conf'
  echo "Checking if yay is installed..."
  sleep 2
  if pacman -Qs yay > /dev/null ; then
    echo "yay is installed. Skipping..."
  else
    echo "Installing yay..."
    sleep 1
    sudo pacman -Sy base-devel git --noconfirm --needed
    cd tmp
    git clone https://aur.archlinux.org/yay-git yay && cd yay
    makepkg -si --noconfirm --needed
    sudo pacman -Rns go
    cd ..
    cd ..
    echo "yay has been installed."
  fi
  sleep 3

  echo "Checking if X is installed..."
  sleep 2
  if pacman -Qs xorg > /dev/null ; then
    echo "X is installed. Skipping..."
  else
    echo "Installing X..."
    sleep 1
    sudo pacman -S xorg --noconfirm --needed
    sudo pacman -Rns xorg-xbacklight > ./tmp/pacmanlog
    echo "X has been installed."
  fi
  sleep 3

  echo "Detecting video driver..."
  sleep 2
  if lspci -v | grep -i 'intel.*hd' > /dev/null ; then
	  echo "Installing xf86-video-intel..."
	  sleep 1
	  sudo pacman -S xf86-video-intel --noconfirm --needed
	  echo "xf86-video-intel has been installed."
  elif lspci -v | grep -i amd > /dev/null ; then
	  echo "Installing xf86-video-amdgpu..."
	  sleep 1
	  sudo pacman -S xf86-video-amdgpu --noconfirm --needed
	  echo "xf86-video-amdgpu has been installed."
  else
	  echo "None detected. Skipping..."
  fi
  sleep 3

  echo "Ricing your system..."
  sleep 2
  yay -S i3 polybar-git betterlockscreen-git cava-git dunst notification-daemon htop kitty pcmanfm gvfs neofetch feh hsetroot picom polybar-git alsa-utils pulseaudio pulseaudio-alsa acpi acpilight rofi xarchiver unzip zip unrar p7zip nerd-fonts-noto-sans-regular-complete gnu-free-fonts lxappearance adwaita-icon-theme playerctl noto-fonts-cjk firefox-nightly xss-lock bc zsh zsh-autosuggestions zsh-syntax-highlighting --needed
  sudo rm -rf /usr/lib/systemd/system/betterlockscreen@.service

  echo "A display manager is often recommended in case you install another window manager or a desktop environment. You can choose not to install a display manager and use startx."
  exec ./dmchoose.sh
  sleep 3
  
  echo "Copying files..."
  cp -rv {.config,.icons,.mozilla,.themes,.zshrc,.gtkrc-2.0} $HOME/
  sudo mkdir -p /usr/share/wallpapers
  sudo cp -v './resources/bg.png' /usr/share/wallpapers/
  cp -v './resources/fetch.png' '$HOME/.config/neofetch/source.png'
  sudo bash -c 'cp ./.zshrc-root ~/.zshrc'
  echo "Finished copying files."
  sleep 3

  echo "Finishing touches..."
  sleep 2
  mkdir -p $HOME/.cache/i3lock
  betterlockscreen -u './resources/lock.jpg'
  sudo chsh $USER -s /bin/zsh
  sudo groupadd video
  sudo usermod -aG video $USER

  echo "Cleaning up..."
  sleep 2
  rm -rf tmp
  echo "[SUCCESS] Rice has been installed. If you encounter an error along the installation, open an issue at https://github.com/JayCeeCreates/nanodesu-dots/issues."
  exit 1
else
  echo 'Running in root. Ignoring...'
  exit 1
fi
