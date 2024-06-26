#!/bin/sh

check()
{
    # had to use full path because it needs to be run by root for sddm xscreen config
    echo $(awk -F " = " '/screen_state/ {print $2}' /home/technicfan/.config/qtile/states/states.ini)
}

set_state()
{
    if ! [[ $(check) = $1 ]]
    then
        sed -i "s/screen_state = .*/screen_state = $1/g" ~/.config/qtile/states/states.ini
    fi
}

wallpaper()
{
    feh --bg-fill "$(echo ~)/.config/qtile/wallpapers/firefox.png"
}

one()
{
    xrandr --output HDMI-0 --off --output DP-4 --auto
}

two()
{
    xrandr --output HDMI-0 --auto --output DP-4 --off
}

both()
{
    xrandr --output DP-4 --auto --output HDMI-0 --auto --right-of DP-4
}

mirror()
{
    xrandr --output DP-4 --auto --output HDMI-0 --auto --same-as DP-4
}


main()
{
    case $1 in
    "one")
        $1
        set_state 1
        ;;
    "two")
        $1
        set_state 2
        ;;
    "both")
        $1
        wallpaper
        set_state 3
        ;;
    "mirror")
        $1
        set_state 4
        ;;
    "off")
        xrandr --output HDMI-0 --off --output DP-4 --off
        ;;
    "restore")
        case $(check) in
        "1")
            one
            ;;
        "2")
            two
            ;;
        "3")
            both
            ;;
        "4")
            mirror
        esac
        ;;
    "wallpaper")
        if [ -z $2 ]
        then
            wallpaper
        else
            feh --bg-fill $2
        fi
        ;;
    *)
        exit 1
    esac
}

main $1 $2