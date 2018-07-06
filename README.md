
# 自分用 Wordpress on Docker

同じ環境を作るのが面倒なのでまとめました。

## 概要

- Wordpress + MySQL + phpMyAdmin + busybox
- 設定は外部ファイル `.env` にまとめた
- プラグインのインストールを半自動化
- apache のログはローカルに書き出す

## インストール① Docker コンテナ

記事中ではインストール先を `my-docker/` と仮定する。

### リポジトリのクローン

```
$ mkdir my-docker
$ cd my-docker/
$ git clone git@github.com:sygnas/docker_wordpress.git
```

### 設定ファイルの変更

`my-docker/docker_wordpress/docker/.env` を編集して、Wordpress イメージや、コンテナ名、テーマファイル名の設定など行う。

```
# コンテナ接頭辞
CONTAINER_PREFIX=wp-sygnas

# Wordpress の image
WORDPRESS_IMAGE_VERSION=4.7.1-php5.6-apache
#WORDPRESS_IMAGE_VERSION=4.7.1-php7.1-apache

# Wordpress の wp-theme/ 内に dist/ をマウントする時の名前
MY_THEME_FOLDER=my_theme
```

### コンテナの構築

`.env` を編集したら docker-compose でコンテナを構築する。

```
$ cd docker
$ docker-compose up
```

Wordpress コンテナが MySQL コンテナと接続して待機状態になったのを確認。ブラウザで `http://localhost/` を開く。Wordpress のインストール画面になっていたらここまでは成功。

`[ctrl] + [c]` で一度終了させる。

## インストール② Wordpress のインストール

### Wordpressの設定

`my-docker/docker_wordpress/docker/wordpress/.env` を編集して、Wordpress アカウントの設定を行う。

```
# Wordpress の adminユーザー名、パスワード、メール、タイトル
WORDPRESS_ADMIN_ID=admin
WORDPRESS_ADMIN_PASSWORD=admin
WORDPRESS_ADMIN_EMAIL=***@***.jp
WORDPRESS_TITLE=test
```

### プラグインの設定

`my-docker/docker_wordpress/docker/wordpress/wp-install.sh` を編集して、必要なプラグインを追加する。

下記のスクリプトでは `jetpack-markdown` をインストールして、有効にしている。

```
# プラグインをインストール
sudo -u www-data -i -- wp plugin install jetpack-markdown --activate --path=/var/www/html
```

### Wordpress 及び、プラグインのインストール

Wordpress のコンテナが起動していないと動かない（っぽい、よくわからない）ので、別窓で

```
$ docker-compose up
```

をしてから、下記を実行。

```
$ ./install_plugins.sh
```

もしエラーでインストール出来なかったら諦めて、 Wordpress 管理パネルから手動でインストールする。

`http://localhost/` を開いて Wordpress が起動していたら（ブログトップページが見えていたら）成功。

管理画面は `http://localhost/wp-admin/` から。


## 起動

```
// コンテナが一度ちゃんと起動した後なら
$ docker-compose start
// ログも確認したいなら
$ docker-compose up
// ログなんて見ないなら
$ docker-compose up -d
```


## ディレクトリ構成

### docker_wordpress/docker/.env

もろもろの設定。

### docker_wordpress/docker/busybox

DB、アップロードファイル、テーマ、ログなどを保存。

| パス | 用途 |
| --- | --- |
| apache | apache のログ |
| mysql | MySQL の DB データ |
| phpmyadmin | セッションデータ |
| wordpress | テーマ、プラグイン、アップロードファイル |

### docker_wordpress/docker/apache

apache の設定と、phpinfo() 用ファイル。

### docker_wordpress/docker/mysql

MsSQL の初期データを投入するための SQL ファイルを置く。
ダンプをするには `mysqldump.sh` を実行。

### docker_wordpress/docker/wordpress

- Dockerfile
  - Wordpress の Docker イメージをビルドするため
- wp-install.sh
  - プラグインインストールスクリプト
  - Wordpress コンテナの `/docker-entrypoint-initdb.d/` にコピーされる
- .env
  - 上記スクリプトの設定。コピー先も同じ

### docker_wordpress/dist

テーマファイルを置く。
`wp-config/themes/my_theme` にマウントされる。

`my_theme` の名前を変更するには、`my-docker/docker_wordpress/docker/.env` を編集する。

### docker_wordpress/src

js とか css のソースなどを置く。

