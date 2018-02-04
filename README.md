
# 自分用 Wordpress on Docker

同じ環境を作るのが面倒なのでまとめました。

## 概要

- Wordpress + MySQL + phpMyAdmin + busybox
- 設定は外部ファイル `.env` にまとめた
- プラグインのインストールを半自動化
- apache のログはローカルに書き出す

## インストール

```
# git clone git@github.com:sygnas/docker_wordpress.git
# cd docker
# docker-compose up
```

Wordpress コンテナが MySQL コンテナと接続して待機状態になったのを確認。
`[ctrl] + [c]` で一度終了させる（させなくても良い）。
Wordpress とプラグインのインストールのスクリプトを実行。

```
# ./install_plugins.sh
```

エラーでインストール出来なかったら諦めて手動でインストールする。

## 起動

```
// コンテナが一度ちゃんと起動した後なら
# docker-compose start
// ログも確認したいなら
# docker-compose up
// ログなんて見ないなら
# docker-compose up -d
```


## ディレクトリ構成

### /docker/.env

もろもろの設定。

### /docker/busybox

DB、アップロードファイル、テーマ、ログなどを保存。

| パス | 用途 |
| --- | --- |
| apache | apache のログ |
| mysql | MySQL の DB データ |
| phpmyadmin | セッションデータ |
| wordpress | テーマ、プラグイン、アップロードファイル |

### /docker/apache

apache の設定と、phpinfo() 用ファイル。

### /docker/mysql

MsSQL の初期データを投入するための SQL ファイルを置く。
ダンプをするには `mysqldump.sh` を実行。

### /docker/wordpress

- Dockerfile
  - Wordpress の Docker イメージをビルドするため
- wp-install.sh
  - プラグインインストールスクリプト
  - Wordpress コンテナの `/docker-entrypoint-initdb.d/` にコピーされる
- .env
  - 上記スクリプトの設定。コピー先も同じ

### /dist

テーマファイルを置く。
`wp-config/themes/my_theme` にマウントされる。

### /src

js とか css のソースなどを置く。

