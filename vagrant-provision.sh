#!/usr/bin/env bash

# This replaces the default Apache docroot of ScotchBox with Bedrock's webroot
sed -i 's/\([[:blank:]]*DocumentRoot\)[[:blank:]]*.*$/\1 \/var\/www\/web/g' /etc/apache2/sites-available/000-default.conf
sed -i 's/\([[:blank:]]*DocumentRoot\)[[:blank:]]*.*$/\1 \/var\/www\/web/g' /etc/apache2/sites-available/scotchbox.local.conf

# When web-server changes are finished - restart it
service apache2 restart
