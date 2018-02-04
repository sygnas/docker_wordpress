#!/bin/bash

# 設定を読む
. /docker-entrypoint-initdb.d/.env

if [ -d "/var/www/html/wp-content/plugins" ]; then

  # wp-cli を使って Wordpress をインストール
  sudo -u www-data -i -- wp core install --path=/var/www/html \
  --title=${WORDPRESS_TITLE} --admin_user=${WORDPRESS_ADMIN_ID} \
  --admin_password=${WORDPRESS_ADMIN_PASSWORD} \
  --admin_email=${WORDPRESS_ADMIN_EMAIL} --url=http://localhost/

  # 日本語環境に……ならない
  sudo -u www-data -i -- wp core language install ja --activate

  # プラグインをインストール
  sudo -u www-data -i -- wp plugin install jetpack-markdown --activate --path=/var/www/html
fi
