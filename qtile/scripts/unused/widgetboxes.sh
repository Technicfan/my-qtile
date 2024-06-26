#!/bin/sh

check()
{
    local exit=$(awk -F " = " '/'$1'/ {print $2}' ~/.config/qtile/states/states.ini)

    if [[ $exit = 1 || $exit = 0 ]]
    then
        return $exit
    else
        exit 1
    fi
}

shown()
{
    if check $1
    then
        sed -i "s/$1 = .*/$1 = 1/g" ~/.config/qtile/states/states.ini
    fi
}

hidden()
{
    if ! check $1
    then
        sed -i "s/$1 = .*/$1 = 0/g" ~/.config/qtile/states/states.ini
    fi
}

case $1 in
"mpris")
    case $2 in
    "toggle")
        if check tray
        then
            qtile cmd-obj -o widget mpris -f toggle
        fi
        
        if check $1
        then
            shown $1
        else
            hidden $1
        fi
        ;;
    "show")
        if check tray
        then
            qtile cmd-obj -o widget mpris -f open
        fi
        shown $1
        ;;
    "hide")
        if check tray
        then
            qtile cmd-obj -o widget mpris -f close
        fi
        hidden $1
        ;;
    "restore")
        if ! check $1
        then
            qtile cmd-obj -o widget mpris -f open
        fi
        ;;
    "shown")
        shown $1
        ;;
    "hidden")
        hidden $1
        ;;
    *)
        exit 1
    esac
    ;;
"tray")
    case $2 in
    "toggle")
        if ! check mpris
        then
            qtile cmd-obj -o widget mpris -f toggle &
        fi

        qtile cmd-obj -o widget tray -f toggle
        if check $1
        then
            shown $1
        else
            hidden $1
        fi
        ;;
    "shown")
        shown $1
        ;;
    "hidden")
        hidden $1
        ;;
    *)
        exit 1
    esac
    ;;
*)
    exit 1
esac