from ubuntu:16.10
env DEBIAN_FRONTEND=noninteractive

# X11 and xvnc
run apt-get update -yq && apt-get upgrade -yq
run apt-get -yq install x11vnc xvfb
add xorg.conf /etc/X11/xorg.conf
add xinitrc /root/.xinitrc
run chmod +x /root/.xinitrc

# install tools
run apt-get -yq install git emacs zsh chromium-browser build-essential golang-go npm jq wget

# create a user
run useradd ian
run mkdir -p /home/ian
run cp /root/.xinitrc /home/ian/.xinitrc
run chown ian:ian /home/ian/.xinitrc
run chmod +x /home/ian/.xinitrc
run chown ian:ian /home/ian

# set up spacemacs
user ian
workdir /home/ian
env SHELL=/usr/bin/zsh
add spacemacs_template /home/ian/.spacemacs
run git clone https://github.com/syl20bnr/spacemacs /home/ian/.emacs.d
run emacs --batch /dev/null --load /home/ian/.emacs.d/init.el # this preloads emacs stuff

cmd x11vnc -create -nopw -forever -noxdamage -nowf
