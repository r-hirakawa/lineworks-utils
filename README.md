# lineworks-utils
LINE WORKS API を実行するシェルスクリプトのユーティリティ

- アクセストークンの発行
- BOT にリッチメニューを作成（画像アップロード＆画像の紐づけ）
- BOT のリッチメニューの一覧
- BOT のリッチメニューの削除



## 0. 動作環境

動作環境は以下のとおり

- MacBook Pro（13-inch, M1, 2020）
- macOS 13.2.1



利用しているコマンドラインツールは以下のとおり

- curl 7.86.0 (x86_64-apple-darwin22.0)
- [jq 1.6](https://jqlang.github.io/jq/)
- openssl 3.1.1（Homebrew でインストール：[openssl@3](https://formulae.brew.sh/formula/openssl@3)）



## 1. シェルスクリプトの環境設定

本リポジトリを clone 後、シェルスクリプトを利用するには、以下の環境設定が必要

### 1.1. 環境変数

`.env` ファイルに必要な環境変数を設定する

#### API（アプリ）

[LINE WORKS Developer Console](https://dev.worksmobile.com/) で登録したアプリから情報を取得する

- `CLIENT_ID`
- `CLIENT_SECRET`

[LINE WORKS Developer Console](https://dev.worksmobile.com/) で登録したアプリに対して WOFF アプリを登録する

- `WOFF_APP_LABEL_<NO>` … 表示名（任意の文字列）
- `WOFF_APP_URL_<NO>` … 登録した WOFF アプリの URL

[LINE WORKS Developer Console](https://dev.worksmobile.com/) で登録したアプリに対して Service Account を発行する

- `SERVICE_ACCOUNT_ID`

#### BOT

[LINE WORKS Developer Console](https://dev.worksmobile.com/) で登録した BOT から情報を取得する

- `BOT_ID`

※ 登録した BOT を LINE WORKS 上で利用するには、[LINE WORKS Admin](https://admin.worksmobile.com/) で「Bot 追加」し、使用権限に利用者を登録してから、公開設定を「ON」に変更する必要がある



### 1.2. 秘密鍵ファイルのダウンロード

[LINE WORKS Developer Console](https://dev.worksmobile.com/) で登録したアプリに対して Service Account を発行後、Private Key を発行してダウンロードし、`private.key` というファイル名で保存する



### 1.3. シェルスクリプトの実行権限を設定

`chmod +x *.sh`



## 1. アクセストークンを生成する

以下のシェルスクリプトを実行すると `.credential` ファイルにアクセストークンが保存され、LINE WORKS API を利用するシェルスクリプトが実行可能になる

`./create_accesstoken.sh`



## 2. BOT にリッチメニューを作成（画像アップロード＆画像の紐づけ）

### 2.1. リッチメニューの作成

以下のシェルスクリプトを実行すると、BOT にリッチメニューを作成し、作成したリッチメニュー情報を `richmenus.txt` に保存する

`create_richmenu.sh`



### 2.2. リッチメニュー画像のアップロード

[Canva](https://www.canva.com/) などのサービスでリッチメニュー画像を作成して、シェルスクリプトと同じディレクトリに保存し、`upload_richmenu_image.sh` の `RICHMENU_IMAGE` 変数に画像ファイル名を設定する

```
RICHMENU_IMAGE=richmenu.png
```



シェルスクリプトを実行すると、画像ファイルが LINE WORKS にアップロードされ、アップロードした画像の識別情報を `uploaded.txt` に保存する

`./upload_richmenu_image.sh` 



### 2.3. リッチメニューに画像を紐付ける

`set_richmenu_image.sh` を開き、以下の変数を設定する

- `RICHMENU_ID` 変数に `2.1` で出力された `richmenus.txt` の `richmenuId` を設定
- `FILE_ID` 変数に `2.2` で出力された `uploaded.txt` の `fileId` を設定



シェルスクリプトを実行すると、リッチメニューに画像が紐づけられる

`./set_richmenu_image.sh`



### 2.4. 作成したリッチメニューを既定値に設定

`set_default_richmenu.sh` を開き、以下の変数を設定する

- `RICHMENU_ID` 変数に `2.1` で出力された `richmenus.txt` の `richmenuId` を設定



シェルスクリプトを実行すると、リッチメニューが既定値に設定される

`./set_default_richmenu.sh` 





---

以上。
