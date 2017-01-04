from ubuntu:16.10
env DEBIAN_FRONTEND=noninteractive
run apt-get update -yq && apt-get upgrade -yq
run apt-get -yq install x11vnc xvfb
add xorg.conf /etc/X11/xorg.conf
add xinitrc /root/.xinitrc
run apt-get -yq install git emacs
run git clone https://github.com/syl20bnr/spacemacs /root/.emacs.d
add spacemacs_template /root/.spacemacs
env SHELL=/bin/bash
run emacs --batch /dev/null --load /root/.emacs.d/init.el
run chmod +x /root/.xinitrc
cmd x11vnc -create -nopw -forever -noxdamage -nowf
