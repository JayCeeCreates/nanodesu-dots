#!/bin/bash
PS3='Choose a display manager [1-4]: '
dm=("LightDM" "GDM" "SDDM" "startx")
select choice in "${dm[@]}"; do
    case $choice in
        "LightDM")
            echo "Installing $choice..."
			sleep 1
			sudo apt install lightdm slick-greeter -y
			sudo cp ./lightdm.conf /etc/lightdm/lightdm.conf
			sudo sed -i "/greeter-session=lightdm-slick-greeter/c\greeter-session=slick-greeter" /etc/lightdm/lightdm.conf
			sudo systemctl enable lightdm
			echo "$choice has been installed. A reboot may be required."
			exit
            ;;
        "GDM")
			echo "Installing $choice..."
			sleep 1
			sudo apt install gdm -y
			sudo systemctl enable gdm3
			echo "$choice has been installed. A reboot may be required."
			exit
            ;;
        "SDDM")
			echo "Installing $choice..."
			sleep 1
			sudo apt install sddm -y
			sudo systemctl enable sddm
			echo "$choice has been installed. A reboot may be required."
			exit
            ;;
		"startx")
			echo "Initializing $choice..."
			sleep 1
			sudo apt install xinit -y
			echo 'exec i3' > $HOME/.xinitrc
			echo "Xinit has been installed. You may now use startx."
			exit
			;;
        *) echo "Invalid option $REPLY" && sleep 2;;
    esac
done
