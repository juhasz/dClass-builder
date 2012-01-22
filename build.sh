#!/bin/bash

# remove
apt-get -yq remove audacious             \
                   ace-of-penguins       \
                   audacious-plugins     \
                   libaudclient2         \
                   libaudcore1

apt-get -yq autoremove
apt-get -yq clean

# upgrade
apt-get -yq update
apt-get -yq upgrade

# install
apt-get -yq install git                  \
                    git-gui              \
                    git-completion       \
                    bind9                \
                    sysv-rc-conf         \
                    apache2              \
                    apache2-threaded-dev \
                    mysql-server         \
                    phpmyadmin           \
                    php5                 \
                    php5-cli             \
                    php5-curl            \
                    php5-dev             \
                    php5-gd              \
                    php5-mysql           \
                    php5-sqlite          \
                    php5-xdebug          \
                    openssh-server       \
                    vim-gnome            \

exit 0
