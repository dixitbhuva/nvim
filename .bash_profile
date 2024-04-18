#
# ~/.bash_profile
#

# QT5 Fix -- custom
# not working
#export QT_QPA_PLATFORMTHEME="qt5ct" &
# Wayland Fix -- custom
#export QT_QPA_PLATFORM=wayland &
#export XDG_CURRENT_DESKTOP=dwl &

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Start Script -- custom
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
    exec dbus-launch --exit-with-session /usr/local/bin/dwl
    #exec /usr/local/bin/dwl
fi


