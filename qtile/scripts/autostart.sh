#!/bin/bash

function run {
  if ! pgrep -x $(basename $1 | head -c 15) 1>/dev/null;
  then
    $@&
  fi
}

#Set your native resolution IF it does not exist in xrandr
#More info in the script
#run $HOME/.config/qtile/scripts/set-screen-resolution-in-virtualbox.sh

#Find out your monitor name with xrandr or arandr (save and you get this line)
#xrandr --output VGA-1 --primary --mode 1360x768 --pos 0x0 --rotate normal
#xrandr --output DP2 --primary --mode 1920x1080 --rate 60.00 --output LVDS1 --off &
#xrandr --output LVDS1 --mode 1366x768 --output DP3 --mode 1920x1080 --right-of LVDS1
#xrandr --output HDMI2 --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output VIRTUAL1 --off
#autorandr horizontal

#change your keyboard if you need it
#setxkbmap -layout de

keybLayout=$(setxkbmap -v | awk -F "+" '/symbols/ {print $2}')

#Some ways to set your wallpaper besides variety or nitrogen
feh --bg-fill "/home/technicfan/.config/qtile/wallpapers/Arcolinux-text-dark-rounded-1080p.png" &

#starting utility applications at boot time
run nm-applet &
#run pamac-tray &
run xfce4-power-manager &
#numlockx on &
blueman-applet &
picom &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/usr/lib/xfce4/notifyd/xfce4-notifyd &
/usr/lib/kdeconnectd &
polychromatic-tray-applet &
nextcloud &
caffeine &

input-remapper-control --command autoload &
polychromatic-cli -o spectrum &
polychromatic-cli -o brightness -p 50 &
polychromatic-cli --dpi 2600 &

.config/qtile/scripts/mouse.sh &
