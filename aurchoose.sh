#!/bin/bash
PS3='Choose an AUR helper [1-2]: '
aur=("yay" "paru")
select choice in "${aur[@]}"; do
    case $choice in
        "yay")
            echo "Installing $choice..."
            sudo pacman -S base-devel git --noconfirm --needed > ./tmp/pacmanlog
            cd tmp
            git clone https://aur.archlinux.org/$choice-git $choice && cd $choice
            makepkg -si --noconfirm --needed
            cd .. & cd ..
	        echo "$choice has been installed."
	        exit
            ;;
        "paru")
            echo "Installing $choice..."
            sudo pacman -S base-devel git --noconfirm --needed > ./tmp/pacmanlog
            cd tmp
            git clone https://aur.archlinux.org/$choice-git $choice && cd $choice
            makepkg -si --noconfirm --needed
            cd .. & cd ..
	        echo "$choice has been installed."
	        exit
            ;;
        *) echo "Invalid option $REPLY" && sleep 2;;
    esac
done
