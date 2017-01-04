from ubuntu:16.10
env DEBIAN_FRONTEND=noninteractive
env USER=ian

run apt-get update -yq && apt-get upgrade -yq &&\
    apt-get -yq install x11vnc xvfb git tar emacs zsh chromium-browser build-essential golang-go npm jq wget

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

# switch to user
user "$USER"
workdir /home/"$USER"

# set up spacemacs
env SHELL=/usr/bin/zsh
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
workdir /home/"$USER"

add xorg.conf /etc/X11/xorg.conf
# start x11vnc + xorg
cmd x11vnc -create -nopw -forever -noxdamage -nowf -input KMBCF
