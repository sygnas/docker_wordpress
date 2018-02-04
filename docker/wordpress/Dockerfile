
ARG WORDPRESS_IMAGE_VERSION


FROM wordpress:${WORDPRESS_IMAGE_VERSION}

# 必要なツール郡をインストール
RUN apt-get update
RUN apt-get -y install wget unzip sudo

# wp cli をインストール
RUN curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar --output /tmp/wp-cli.phar
RUN chmod +x /tmp/wp-cli.phar
RUN mv /tmp/wp-cli.phar /usr/local/bin/wp

# wp-cli を使うスクリプトをコピー
COPY .env /docker-entrypoint-initdb.d/.env
COPY wp-install.sh /docker-entrypoint-initdb.d/wp-install.sh
RUN chmod +x /docker-entrypoint-initdb.d/wp-install.sh

# wp-cli が使うキャッシュディレクトリを用意しておく
RUN mkdir -p /var/www/.wp-cli/cache
RUN chmod -vR 777 /var/www/.wp-cli

# wp-cli を実行するユーザーのシェルを指定
RUN chsh -s /bin/bash www-data
