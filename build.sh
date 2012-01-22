#!/bin/bash

if [[ `whoami` != 'root' ]]; then
  echo 'Run this script as root!' 1>&2
  exit 1
fi

# remove
apt-get -yq remove audacious           \
                   ace-of-penguins     \
                   audacious-plugins   \
                   libaudclient2       \
                   libaudcore1         \
                   transmission        \
                   transmission-gtk    \
                   guvcview            \
                   transmission-common \
                   simple-scan         \
                   xpad                \
                   xfburn              \

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
apt-get -yq install git                  \
                    git-core             \
                    git-gui              \
                    git-completion       \
                    curl                 \
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
                    filezilla            \

# cleanup
apt-get -yq autoremove
apt-get -yq clean

# configure bind/named
cp /etc/resolv.conf /etc/resolv.conf.bak
echo 'nameserver 127.0.0.1' > /etc/resolv.conf
cat /etc/resolv.conf.bak >> /etc/resolv.conf

echo -e "\nzone \"dev\" { type master; file \"/etc/bind/dev.zone\"; };\n" >> /etc/bind/named.conf.local
wget --no-check-certificate -O /etc/bind/dev.zone https://raw.github.com/juhasz/dClass-builder/master/dev.zone
sysv-rc-conf bind on

# configure apache
rm /etc/apache2/sites-availabe/default
wget --no-check-certificate -O /etc/apache2/sites-available/default https://raw.github.com/juhasz/dClass-builder/master/apache-default-site
a2enmod rewrite     \
        vhost_alias \

cp /etc/apache2/envvars /etc/apache2/envvars.bak
cat /etc/apache2/envvars.bak | sed -e 's/www-data/user/' > /etc/apache2/envvars
mkdir -p /var/www
chown -R user:user /var/www

# configure PHP
rm /etc/php5/conf.d/sqlite.ini

# restart services
service bind9 restart
service apache2 restart
service mysql restart

# set up drush and drush_make
wget -O /home/user/drush.zip http://ftp.drupal.org/files/projects/drush-7.x-4.5.zip
unzip -d /home/user /home/user/drush.zip
mkdir /home/user/.drush
wget -O /home/user/drush_make.zip http://ftp.drupal.org/files/projects/drush_make-6.x-2.3.zip
unzip -d /home/user/.drush /home/user/drush_make.zip
chown -R user:user /home/user/drush /home/user/.drush

# set user bin directory
mkdir /home/user/bin
chown -R user:user /home/user/bin
echo -e '\nexport PATH=~/bin:~/drush:$PATH\n' >> /home/user/.bashrc

# user configuration
echo "user ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers > /dev/null
cp /etc/lxdm/lxdm.conf /etc/lxdm/lxdm.conf.bak
cat /etc/lxdm/lxdm.conf.bak | sed -e 's/# autologin=dgod/autologin=user/' > /etc/lxdm/lxdm.conf

# reboot
reboot

exit 0
