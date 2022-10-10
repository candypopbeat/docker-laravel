# DockerでLaravel環境構築

## Install
<br>

### Git クローンでリポジトリを入手
```bash
git clone https://github.com/candypopbeat/docker-laravel
```
<br>

### 各種バージョン指定など細かく設定変更したいなら設定ファイルを編集

- 全体
  - docker-compose.yml
- MySQL（データベース）
  - config/mysql/Dockerfile
  - config/mysql/my.cnf
- PHPとApache（サーバー）
  - config/php/apache2.conf
  - config/php/Dockerfile
  - config/php/php.ini
  - config/php/sites/000-default.conf
<br><br>

### Docker ビルド～スタートまで

```bash
docker-compose up
```

- Dockerが入っていない場合は先にインストールしておく
- Dockerが起動していないと上記コマンドでエラーがでる
<br><br>

---
<br>

## ビルドされた Docker コンテナの起動テスト
<br>

### コンテナ名を調べる
```bash
docker ps
```
<br>

### コンテナに入る
```bash
docker container exec -it {コンテナ名} bash
```
<br>

### 現在地が下記になれば成功
```bash
/var/www/html
```
<br>

---
<br>

## Laravel プロジェクト作成（コンテナ内で行う）
<br>

### publicディレクトリ（/var/www/html/public）を削除する

```bash
rm -rf public
```

- Laravelをインストールするにはhtmlディレクトリが空でなければならないため
- Apache構築の際のドキュメントルート設定にpublicディレクトリが存在していなければならないため、初期に存在している  
<br>

### コンポーザーを使ってLaravelをインストールする  
15～30分かかったりします
```bash
# バージョン指定なしで最新版となる
composer create-project laravel/laravel --prefer-dist ./

# バージョン指定あり
composer create-project laravel/laravel:^8.0 ./
composer create-project "laravel/laravel=9.*" ./
```
<br>

### .envファイルを下記のように編集する
```diff
- APP_NAME=Laravel
+ APP_NAME={任意のプロジェクト名}

- DB_HOST=127.0.0.1
- DB_DATABASE=laravel
- DB_USERNAME=root
- DB_PASSWORD=
+ DB_HOST=mysql # docker-compose.ymlより
+ DB_DATABASE=sample # デフォルトで存在しているDB、変更してもOK
+ DB_USERNAME=root # docker-compose.ymlより
+ DB_PASSWORD=root # docker-compose.ymlより

- MAIL_HOST=mailhog
+ MAIL_HOST=mail
```
<br>

### コンテナを再起動する
コンソールで起動中コンテナをキャンセルして、もう一度すぐに起動させる

```bash
docker-compose up
```
<br>

### ブラウザからアクセスして表示確認をする

```bash
http://localhost:8080 # docker-compose.ymlで指定しているポート
```
<br>

### 権限エラー（パーミッションエラー）が発生したら下記で解決するかも

```bash
chmod -R 777 storage && chmod -R 777 bootstrap
```
<br>

### artisanコマンドでマイグレーションを行う
```
php artisan migrate
```
<br>

---
<br>

## 日本語モードにするために、config/app.php を下記のように編集する

```diff
- 'timezone' => 'UTC',
+ 'timezone' => 'Asia/Tokyo',

- 'locale' => 'en',
+ 'locale' => 'ja',

- 'faker_locale' => 'en_US',
+ 'faker_locale' => 'ja_JP',

```
<br><br>

# メール確認

## Laravel の tinker を使ってメール送信テスト
コンテナに入ってから行う

```bash
php artisan tinker
Mail::raw('test mail',function($message){$message->to('test@example.com')->subject('test');});
```
<br>

## mailhog UI にアクセスし受信確認をする

```bash
http://localhost:8025/
```
<br><br>

# Laravel の再インストール

## 下記の中を空にする
```bash
/var/www/html
```
<br>

## コンポーザーを使って Laravel をインストールする
```bash
# バージョン指定なしで最新版となる
composer create-project laravel/laravel --prefer-dist ./

# バージョン指定あり
composer create-project laravel/laravel:^8.0 ./
composer create-project "laravel/laravel=9.*" ./
```
<br><br>

# Laravel を削除する

## 下記の中を空にする
```bash
/var/www/html
```
<br>

## ドキュメントルートを変更する

### apache2.conf の調整
```diff
- DocumentRoot /var/www/html/public
+ DocumentRoot /var/www/html
```

## 000-default.conf の調整
```diff
- DocumentRoot /var/www/html/public
+ DocumentRoot /var/www/html
```
<br>

## Docker を再ビルドする
```
docker-compose down
```

```
docker-compose build
```

```
docker-compose up
```
<br>

## 確認する

### ドキュメントルートとなった /var/www/html になにかファイルを置いて、ブラウザからアクセスする

```bash
http://localhost:8080
```
<br><br>

# クライアントソフトでデータベースの確認

## データベース操作するクライアントソフトをインストール

### いくつか存在するが、下記がおすすめ

- DBeaver
  - https://dbeaver.io/download/
- TablePlus
  - https://tableplus.com/

## クライアントソフトの設定を下記のようにしてリモート接続する

### docker-compose.yml に設定している内容

```bash
Host: localhost
Port: 3307 # docker-compose.ymlより
User: root # docker-compose.ymlより
Password: root # docker-compose.ymlより
```
<br>

## 「sample」というデータベースの中に「samples」というテーブルがあれば、Docker ビルドで
```
/config/mysql/initdb.d/init.sql
```
が実行されていてビルド時にデータベースを構築することも成功しているので、「init.sql」も利用できる
「sample」というデータベースはテストなので削除しても構わない
<br><br>

# CLI でデータベース操作

## mysql コンテナ内に入って mysql コンソール状態にする

下記コマンドを実行  
パスワードを求められるので、そのユーザーのものを入力する
```
docker exec -it {コンテナ名} mysql -u {ユーザー名} -p
```
<br><br>

# MySQLコマンド

#### データベース一覧表示
```
show databases;
```

#### データベース選択
```
use {データベース名};
```

#### テーブル一覧表示
```
show tables;
```

#### テーブル構造確認
```
desc {テーブル名};
```
<br><br>

# Docker コマンド
<br>

## コンテナに入る
```
docker container exec -it docker-rails-web-1 bash
```

## コンテナ起動・作成
```
docker-compose up
```

## コンテナ停止
```
docker-compose stop
```

## コンテナ・イメージ構築
```
docker-compose build
```

## コンテナ削除
```
docker-compose down
```

## コンテナ・イメージ・ボリューム削除
```
docker-compose down --rmi all --volumes --remove-orphans
```

## 未使用イメージ一括削除
```
docker image prune -a
```
<br><br>

# npm が使えなかったら

## node と npm を消す
```bash
rm -rf /usr/local/bin/npm /usr/local/share/man/man1/node* ~/.npm
rm -rf /usr/local/lib/node*
rm -rf /usr/local/bin/node*
rm -rf /usr/local/include/node*

apt-get purge nodejs npm
apt autoremove
```
<br>

## node と npm をインストールする
```bash
curl -sL https://deb.nodesource.com/setup_lts.x | bash - # LTS
curl -sL https://deb.nodesource.com/setup_18.x | bash - # バージョン指定
apt install -y nodejs
```
