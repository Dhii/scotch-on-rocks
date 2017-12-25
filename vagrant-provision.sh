#!/usr/bin/env bash

# https://github.com/oerdnj/deb.sury.org/issues/56
sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

# https://github.com/scotch-io/scotch-box/issues/275
sudo rm /etc/apt/sources.list.d/ondrej-php5-5_6-trusty.list

# Update sources
sudo apt-get update

# Install extra packages
sudo apt-get install -y \
    php-curl \
    php7.0-xml \
    php7.0-xmlrpc

# https://github.com/scotch-io/scotch-box/issues/311#issuecomment-353892680
sudo apt-get upgrade -y

# This replaces the default Apache docroot of ScotchBox with Bedrock's webroot
sed -i 's/\([[:blank:]]*DocumentRoot\)[[:blank:]]*.*$/\1 \/var\/www\/web/g' /etc/apache2/sites-available/000-default.conf
sed -i 's/\([[:blank:]]*DocumentRoot\)[[:blank:]]*.*$/\1 \/var\/www\/web/g' /etc/apache2/sites-available/scotchbox.local.conf

# When web-server changes are finished - restart it
service apache2 restart

# Bundler
# https://github.com/scotch-io/scotch-box/issues/209#issuecomment-237508116
~vagrant/.rbenv/shims/gem install bundler

# Install gems
(cd /var/www && ~vagrant/.rbenv/shims/bundle install)

# Update PHP dependencies
(cd /var/www && composer update)
