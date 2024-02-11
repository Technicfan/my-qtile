#!/bin/bash

dmenu="dmenu -i -l 20 -nb #133912 -nf #87a757 -sb #87a757 -sf #133912 -fn 'JetBrains:bold:pixelsize=14'"
dmenu_width=" -z 300 -p"
locker="i3lock-fancy-dualmonitor"

case $1 in
"kill")
    dmenu_width=" -z 960 -p"

    selected="$(ps --user "$USER" -F | $dmenu $dmenu_width "Kill process:" | awk '{print $2" "$11}')"

    if [[ -n $selected && $selected != "PID CMD" ]]
    then
        answer="$(echo -e "No\nYes" | $dmenu $dmenu_width  "Kill $selected?")"

        if [[ $answer == "Yes" ]]
        then
            kill -9 "${selected%% *}"
            exit 0
        else
            exit 1
        fi
    fi
    ;;
"output-switcher")
    dmenu_width=" -z 400 -p"

    get_default_sink() {
        pactl --format=json info | jq -r .default_sink_name
    }

    get_all_sinks() {
        pactl --format=json list short sinks \
            | current=$(get_default_sink) jq -r '.[] | if .name == env.current then .state="* " else .state="" end | .state + .name'
    }

    choice=$(printf '%s\n' "$(get_all_sinks)" | sort | $dmenu $dmenu_width 'Sink:') || exit 1

    if [ "$choice" ]
    then
        if [[ "${choice}" == "* $(get_default_sink)" ]]
        then
        exit 0
        fi
        pactl set-default-sink "${choice}"
    else
        exit 0
    fi
    ;;
"logout")
    declare -a options=(
        "Lock"
        "Logout"
        "Reboot"
        "Shutdown"
        "Suspend"
    )

    choice=$(printf '%s\n' "${options[@]}" | $dmenu $dmenu_width 'Power menu:')

    case $choice in
    "Lock")
        ${locker}
        ;;
    "Logout")
        if [[ "$(echo -e "No\nYes" | $dmenu $dmenu_width "${choice}?")" == "Yes" ]]
        then
            pkill -KILL -u $USER
        else
            exit 1
        fi
        ;;
    "Reboot")
        if [[ "$(echo -e "No\nYes" | $dmenu $dmenu_width "${choice}?")" == "Yes" ]]
        then
            systemctl reboot
        else
            exit 0
        fi
        ;;
    "Shutdown")
        if [[ "$(echo -e "No\nYes" | $dmenu $dmenu_width "${choice}?")" == "Yes" ]]
        then
            systemctl poweroff
        else
            exit 0
        fi
        ;;
    "Suspend")
        if [[ "$(echo -e "No\nYes" | $dmenu $dmenu_width "${choice}?")" == "Yes" ]]
        then
            systemctl suspend
        else
            exit 0
        fi
        ;;
    *)
        exit 0
    esac
    ;;
# own
"monitor")
    declare -a options=(
        "Monitor 1"
        "Both Monitors"
        "Mirror"
        "Off"
    )

    choice=$(printf '%s\n' "${options[@]}" | $dmenu $dmenu_width 'Monitors:')

    case $choice in
    "Monitor 1")
        ~/.config/qtile/scripts/screens.sh one
        ;;
    "Both Monitors")
        ~/.config/qtile/scripts/screens.sh two
        ;;
    "Mirror")
        xrandr --output DP-4 --auto --output HDMI-0 --auto --same-as DP-4
        ;;
    "Off")
        xrandr --output HDMI-0 --off --output DP-4 --off
        ;;
    *)
        exit 0
    esac
    ;;
"ms-windows")
    declare -a options=(
        "-> Wine"
        "Windows 11"
        "Windows 7"
    )

    choice=$(printf '%s\n' "${options[@]}" | $dmenu $dmenu_width 'MS Windows:')

    case $choice in
    "Windows 11" | "Windows 7")
        if [[ "$(echo -e "No\nYes" | $dmenu $dmenu_width "Start ${choice} VM?")" == "Yes" ]]
        then
            virtualboxvm --startvm "$choice"
        else
            exit 0
        fi
        ;;
    "-> Wine")
        declare -a options=(
        "Delphi 7"
        )

        choice=$(printf '%s\n' "${options[@]}" | $dmenu $dmenu_width 'Run:')

        case $choice in
        "Delphi 7")
            wine "$HOME/.wine/drive_c/Program Files (x86)/Borland/Delphi7/Bin/delphi32.exe"
            ;;
        *)
            exit 0
        esac
        ;;
    *)
        exit 0
    esac
    ;;
*)
    exit 1
esac