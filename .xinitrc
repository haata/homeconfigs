#!/bin/sh
#
# ~/.xinitrc
#

#export GTK_IM_MODULE='uim'
#export QT_IM_MODULE='uim'
#uim-xim &
#export XMODIFIERS=@im='uim'
# Executed by startx (run your window manager from here)

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice

{
sleep 3
setxkbmap us -variant colemak
sleep 2
xset r 66
#xmodmap ~/.Xmodmap
xmodmap ~/.xmodmap-QuadMas
} &

exec awesome

