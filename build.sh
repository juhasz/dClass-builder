#!/bin/bash

if [[ `whoami` != 'root' ]]; then
  echo 'Run this script as root!' 1>&2
  exit 1
fi

# remove
apt-get -yq remove audacious                                                                           \
                   ace-of-penguins                                                                     \
                   audacious-plugins                                                                   \
                   libaudclient2                                                                       \
                   libaudcore1                                                                         \
                   transmission                                                                        \
                   transmission-gtk                                                                    \
                   guvcview                                                                            \
                   transmission-common                                                                 \
                   simple-scan                                                                         \
                   xpad                                                                                \
                   xfburn                                                                              \

# upgrade
apt-get -yq update
apt-get -yq upgrade

# quiet install needed :)
echo mysql-server-5.1 mysql-server/root_password        password root    | debconf-set-selections
echo mysql-server-5.1 mysql-server/root_password_again  password root    | debconf-set-selections
echo phpmyadmin       phpmyadmin/reconfigure-webserver  text     apache2 | debconf-set-selections
echo phpmyadmin       phpmyadmin/dbconfig-install       boolean  true    | debconf-set-selections
echo phpmyadmin       phpmyadmin/app-password-confirm   password root    | debconf-set-selections
echo phpmyadmin       phpmyadmin/mysql/admin-pass       password root    | debconf-set-selections
echo phpmyadmin       phpmyadmin/password-confirm       password root    | debconf-set-selections
echo phpmyadmin       phpmyadmin/setup-password         password root    | debconf-set-selections
echo phpmyadmin       phpmyadmin/mysql/app-pass         password root    | debconf-set-selections

# install
apt-get -yq install git                                                                                \
                    git-gui                                                                            \
                    git-completion                                                                     \
                    bind9                                                                              \
                    sysv-rc-conf                                                                       \
                    apache2                                                                            \
                    apache2-threaded-dev                                                               \
                    mysql-server                                                                       \
                    phpmyadmin                                                                         \
                    php5                                                                               \
                    php5-cli                                                                           \
                    php5-curl                                                                          \
                    php5-dev                                                                           \
                    php5-gd                                                                            \
                    php5-mysql                                                                         \
                    php5-sqlite                                                                        \
                    php5-xdebug                                                                        \
                    openssh-server                                                                     \
                    vim-gnome                                                                          \

# cleanup
apt-get -yq autoremove
apt-get -yq clean

exit 0
