from ubuntu:16.10
env DEBIAN_FRONTEND=noninteractive
env USER=ian

run apt-get update -yq && apt-get upgrade -yq &&\
    apt-get -yq install x11vnc xvfb git tar emacs chromium-browser build-essential wget

# X11 and xvnc setup
add xinitrc /root/.xinitrc
run chmod +x /root/.xinitrc

# create a user
run useradd "ian" &&\
    mkdir -p /home/"ian" &&\
    cp /root/.xinitrc /home/"ian"/.xinitrc &&\
    chown "ian":"ian" /home/"ian"/.xinitrc &&\
    chmod +x /home/"ian"/.xinitrc &&\
    chown "ian":"ian" /home/"ian"

# switch to user
user "ian"
workdir /home/"ian"

# set up spacemacs
env SHELL=/bin/bash
add spacemacs_template /home/"ian"/.spacemacs
run git clone https://github.com/syl20bnr/spacemacs /home/"ian"/.emacs.d &&\
    emacs --batch /dev/null --load /home/"ian"/.emacs.d/init.el # this preloads emacs stuff

# install fonts
workdir /tmp
run wget -qO- https://github.com/adobe-fonts/source-code-pro/archive/2.030R-ro/1.050R-it.tar.gz | tar xz -C .
workdir source-code-pro-2.030R-ro-1.050R-it
run mkdir ~/.fonts &&\
    cp OTF/* ~/.fonts &&\
    fc-cache -v -f
workdir /home/"ian"

# start x11vnc + xorg
add xorg.conf /etc/X11/xorg.conf
env X11VNC_CREATE_GEOM=1920x1080
cmd x11vnc -create -nopw -forever -noxdamage -nowf -input KMBCF
