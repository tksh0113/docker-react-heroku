# docker-react-heroku
Template for react application with docker and heroku

## docker
```
$ docker-compose up --build
```

## heroku
#### アカウントの作成
https://jp.heroku.com/

#### CLIのインストール
https://devcenter.heroku.com/articles/heroku-cli

```
$ heroku -v
heroku/7.60.1 darwin-x64 node-v14.19.0
```

#### ログイン
```
$ heroku login
$ heroku container:login
```

#### アプリケーション作成
```
$ heroku apps:create <your_original_app_name>
```

#### 各種アドオン
物によってはクレジットカード登録が必要。MySQLなど。
```
$ heroku addons:add cleardb
```

#### 環境変数
```
$ heroku config:set KEY=VALUE
```

### Deploy with heroku.yml
- Dockerを利用しないパターンと同じコマンドでデプロイできる。 
- Procfileではなくheroku.ymlを書く。
- heroku側でheroku.ymlに従ってビルドする。

#### デプロイ
```
$ heroku stack:set container
$ git push heroku main 

(ブランチ指定) $ git push heroku feature/abc:main
```

### Deploy with Resistory
- heroku側のRegistoryにイメージをPUSHして、それを元にデプロイできる。
- M1 Macでビルドしたイメージだと動作しなかったので頑張る必要がある。

#### デプロイ
```
$ heroku container:push web
$ heroku container:release web
```

任意の名前ではなくwebである必要がある。 [(参考)](https://devcenter.heroku.com/articles/container-registry-and-runtime#building-and-pushing-image-s)
``` 
heroku container:push <process-type> 
```


#### M1 Macでビルドした時のエラーと経緯

``` 
$ heroku logs --tail
2022-04-08T23:09:24.123921+00:00 heroku[router]: at=error code=H10 desc="App crashed" method=GET

エラーログはある。
```

``` 
$ heroku ps:scale web=1
Scaling dynos... done, now running web at 1:Free

解決せず。
``` 

``` 
$ heroku run console
Running console on ⬢ your_app_name ... up, run.1238 (Free)
Error: Exec format error

ここでエラーを確認できた。
``` 

#### heroku & docker で Error: Exec format error
調べると同じ問題に遭遇した方がいらっしゃっり、M1 Mac起因だと気づくことができた。
- https://zenn.dev/daku10/articles/m1-heroku-container-trouble-exec-format-error
- https://medium.com/geekculture/deploy-to-heroku-from-a-macbook-m1-heroku-cli-or-githubactions-868bc3a50935

Registoryを利用することを断念して、heroku側にビルドしてもらえれば上手くいくのでは？と仮説の元、heroku.ymlをpushする方式に変更することでデプロイ成功


