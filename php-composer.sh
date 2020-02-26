#!/bin/bash


php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');"
php composer-setup.php
mv composer.phar /usr/local/bin/composer
rm -fr ./composer-setup.php

composer config -g repo.packagist composer https://packagist.phpcomposer.com
