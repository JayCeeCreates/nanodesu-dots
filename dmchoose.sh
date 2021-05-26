#!/bin/bash
PS3='Choose a display manager [1-4]: '
dm=("LightDM" "GDM" "SDDM" "startx")
select choice in "${dm[@]}"; do
    case $choice in
        "LightDM")
            echo "Installing $choice..."
	    sleep 1
	    yay -S lightdm lightdm-slick-greeter --noconfirm --needed
	    sudo cp ./lightdm.conf /etc/lightdm/lightdm.conf
	    sudo systemctl enable lightdm
	    echo "$choice has been installed. A reboot may be required."
	    exit
            ;;
        "GDM")
	    echo "Installing $choice..."
	    sleep 1
	    sudo pacman -S gdm --noconfirm --needed
	    sudo systemctl enable gdm
	    echo "$choice has been installed. A reboot may be required."
	    exit
            ;;
        "SDDM")
	    echo "Installing $choice..."
	    sleep 1
	    sudo pacman -S sddm --noconfirm --needed
	    sudo systemctl enable sddm
	    echo "$choice has been installed. A reboot may be required."
	    exit
            ;;
	"startx")
	    echo "Initializing $choice..."
	    sleep 1
	    sudo pacman -S xorg-xinit --noconfirm --needed
	    echo 'exec i3' > $HOME/.xinitrc
	    echo "Xinit has been installed. You may now use startx."
	    exit
	    ;;
        *) echo "Invalid option $REPLY" && sleep 2;;
    esac
done
