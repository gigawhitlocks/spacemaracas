from ubuntu:16.10
env DEBIAN_FRONTEND=noninteractive
run apt-get update -yq && apt-get upgrade -yq
run apt-get -yq install x11vnc xvfb mate
add xorg.conf /etc/X11/xorg.conf
add xinitrc /root/.xinitrc
run chmod +x /root/.xinitrc
cmd x11vnc -create -nopw -forever -noxdamage -nowf
