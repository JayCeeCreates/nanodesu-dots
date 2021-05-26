#! /bin/bash

CNT=1 #for bat indicator
CZ=1
CA=1
YI=1

# xset fp rehash &
# xset fp+ /home/zyal/.fonts &

hsetroot -solid '#000000' &
picom -f &
feh --bg-scale /usr/share/wallpapers/bg.png &
playerctld &
dunst &

export EDITOR=vim
export VISUAL=vim

GREET () {
	if [ $( date +%H ) -ge "6"  ] && [ $( date +%H ) -le "12" ] && [ "$CA" = 1 ]; then
		notify-send "Hello good morning!" "How are you today? Let's get this bread."
		CA=2
	fi
	if [ $( date +%H ) -ge "13"  ] && [ $( date +%H ) -le "18" ] && [ "$CA" = 1 ]; then
		notify-send "Good afternoon!" "This is your day. Don't waste it."
		CA=2
	fi
	if [ $( date +%H ) -ge "19"  ] && [ "$CA" = 1 ]; then
		notify-send "Good evening!" "Stay productive, even at night."
		CA=2
	fi
}

timex () {
	BATT=$( acpi -b | sed 's/.*[charging|unknown], \([0-9]*\)%.*/\1/gi' )
	STATUS=$( acpi -b | sed 's/.*: \([a-zA-Z]*\),.*/\1/gi' )
	 
	 
	if [[ "$BATT" -le "10" ]]; then
		batnot="\x06"
	fi
	 
	 
	if [ $BATT -le "30" ] && [ $BATT -gt 10 ]; then
		batnot="\x08"
	else 
		batnot="\x01"
	fi
	 
	if [ $STATUS == "Charging" ]; then
		batnot="\x03"
	fi
	battlev=$( acpi -b | awk '{ print $3$4 }' | tr -d ','| sed s/"Discharging"/"-"/g | sed s/"Charging"/"+"/g | sed s/"Full"/""/g )
	numtasks=$( wc -l TODO | egrep "[0-9]{1,}" -o)
	timef=$( date +"%R" )
	timecolor=$(echo -e "\x05 $timef")
	echo "$timecolor"
}

BCHECK () {
	BATT=$( acpi -b | sed 's/.*[charging|unknown], \([0-9]*\)%.*/\1/gi' )
	if [ "$BATT" -lt "100" ] && [ "$CNT" = "1" ]; then
		STATUS=$( acpi -b | sed 's/.*: \([a-zA-Z]*\),.*/\1/gi' )
		if [ $BATT -le "5" ] && [ $STATUS == 'Discharging' ]; then
			notify-send "Battery Critical (5%)" "Battery too low. Please charge it immediately."
			CNT=2
		fi
		else
			if [[ "$BATT" -ge "11" ]]; then
				CNT=1
			fi
	fi
	 
	if [ "$BATT" -le "15" ] && [ "$YI" = "1" ]; then
		notify-send -u critical "Battery Low (15%)" "Battery low. Please charge the battery."
		if [ "$BATT" -le "30" ]; then
			YI=2
		fi
	fi
}

while true; do
	BCHECK
	GREET
	sleep 3s
done &