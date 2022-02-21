# DockerでLaravel環境

## Install
### Step 1 Git クローンでリポジトリを入手
```git clone https://github.com/candypopbeat/docker-laravel```

### Step 2 各種バージョン指定など細かく設定変更したいなら設定ファイルを編集

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

### Step 3 Docker ビルド～スタートまで

```docker-compose up```

- Dockerが入っていない場合は先にインストールしておく
- Dockerが起動していないと上記コマンドでエラーがでるかもしれない

### Step 4 ビルドされた Docker コンテナの起動テスト
- コンテナ名を調べる

  ```docker ps```

- コンテナに入る

  ```docker container exec -it {コンテナ名} bash```

- 現在地が下記になれば成功

  ```/var/www/html```

### Step 5 Laravel 初期設定

- コンテナに入った状態で行うこと
- コンポーザーを使ってライブラリをインストールする
  - 15分～30分かかったりします

    ```composer install```

- .envファイルを設置する

  ```cp .env.example .env```

- .envに APP_KEY を入力する

  ```php artisan key:generate```

- ブラウザからアクセスして確認する

  ```http://localhost:8080```

- 権限エラー（パーミッションエラー）が発生したら下記で解決するかも

  ```
  chmod -R 777 storage
  chmod -R 777 bootstrap
  ```

## データベースの設定

- .env の DB 設定を書き換える
  - docker-compose.yml に設定している内容

  ```
  DB_HOST={docker-compose.ymlのコンテナ名にもなるmysqlの設定名で、変更していなければ「mysql」}
  DB_DATABASE={変更していなければ「sample」}
  DB_USERNAME={変更していなければ「user」}
  DB_PASSWORD={変更していなければ「password」}
  ```

- マイグレーションを行う

  ```php artisan migrate```

## データベースの確認

### データベースクライアントソフトなどで下記のように接続する

- docker-compose.yml に設定している内容
  ```
  Host: 127.0.0.1
  Port: 3307
  User: {user}
  Password: {password}
  ```

- 「sample」というデータベースの中に「samples」というテーブルがあれば、Docker ビルドで

  ```/config/mysql/initdb.d/init.sql```

  が実行されていてビルド時にデータベースを構築することも成功しているので、「init.sql」も利用できる
- 「sample」というデータベースはテストなので削除する

## メール設定

- .env を調整する

```
MAIL_HOST={mail}
MAIL_PORT=1025
MAIL_FROM_ADDRESS={info@change.me}
```

- MAIL_HOST は docker-compose.yml に設定している内容
- MAIL_FROM_ADDRESS は .env で自由に書換可能

## メール確認

- Laravel の tinker を使ってメール送信テスト
  - コンテナに入ってから行う

  ```
  php artisan tinker
  Mail::raw('test mail',function($message){$message->to('test@example.com')->subject('test');});
  ```

- mailhog UI にアクセスし受信確認をする

  ```http://localhost:8025/```

## Laravel の再インストール
- 下記の中を空にする

  ```/var/www/html```

- コンポーザーを使って Laravel をインストールする

  ```composer create-project laravel/laravel ./```

## Laravel を削除する

### 下記の中を空にする

  ```/var/www/html```

### ドキュメントルートを変更する

- apache2.conf の調整

  ```DocumentRoot /var/www/html/public```

  を

  ```DocumentRoot /var/www/html```

  にする

- 000-default.conf の調整

  ```DocumentRoot /var/www/html/public```

  を

  ```DocumentRoot /var/www/html```

  にする

### Docker を再ビルドする
```docker-compose down```

```docker-compose build```

```docker-compose up```

### 確認する
- ドキュメントルートとなった /var/www/html になにかファイルを置く
- ブラウザからアクセスする

  ```http://localhost:8080```
