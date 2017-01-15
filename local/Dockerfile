from ubuntu:16.10
env DEBIAN_FRONTEND=noninteractive
env USER=ian

run apt-get update -yq && apt-get upgrade -yq &&\
    apt-get -yq install x11vnc xvfb git tar emacs firefox obconf \
      dbus build-essential mate wget software-properties-common &&\
      apt-get -yq dist-upgrade

# X11 and xvnc setup
add xinitrc /root/.xinitrc
run chmod +x /root/.xinitrc

# create a user
run useradd "$USER" &&\
    mkdir -p /home/"$USER" &&\
    cp /root/.xinitrc /home/"$USER"/.xinitrc &&\
    chown "$USER":"$USER" /home/"$USER"/.xinitrc &&\
    chmod +x /home/"$USER"/.xinitrc &&\
    chown "$USER":"$USER" /home/"$USER"

# run custom scripts (as root)
add custom/sudo-custom.sh sudo-custom.sh
run ./sudo-custom.sh

# switch to user
user "$USER"
workdir /home/"$USER"

# set up spacemacs
env SHELL=/bin/bash
add spacemacs_template /home/"$USER"/.spacemacs
run git clone https://github.com/syl20bnr/spacemacs /home/"$USER"/.emacs.d &&\
    emacs --batch /dev/null --load /home/"$USER"/.emacs.d/init.el # this preloads emacs stuff

# install fonts
workdir /tmp
run wget -qO- https://github.com/adobe-fonts/source-code-pro/archive/2.030R-ro/1.050R-it.tar.gz | tar xz -C .
workdir source-code-pro-2.030R-ro-1.050R-it
run mkdir ~/.fonts &&\
    cp OTF/* ~/.fonts &&\
    fc-cache -v -f

# run custom scripts (as user)
add custom/custom.sh custom.sh
run ./custom.sh

# start x11vnc + xorg
add xorg.conf /etc/X11/xorg.conf
workdir /home/"$USER"
env X11VNC_CREATE_GEOM=1920x1080
cmd x11vnc -create -nopw -forever -noxdamage -nowf -input KMBCF
