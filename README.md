# OkaSync

## やりたいこと

Sonyの電子ペーパーで論文を読むのに、WebDAVを使っている。電子ペーパーとWebDAVの間の同期は電子ペーパーは良きようにやってくれるようなのだが、論文はMacでも読むので、WebDAVとMacの同期もしたい。FinderはWebDAVビューアーとしては無能なので、ローカルにディレクトリをつくり、それと同期する。ローカルといいつつ、Dropbox上なので、Macを通して他のデバイスとも同期していることになる。  
ということを既存の`rsync`などでやろうとしたら、コンフリクトしたときの処理がなくて不満だった。Dropboxはやってくれるので、WebDAVとDropboxが同期してくれればいいだけの話なのだが。というわけで、自分でつくろうとしてる。

## 現状

```
├── OkaSync.rb          :メインのやつ
├── OkaSync.xcodeproj   :Xcodeのやつ
├── README.md           :このファイル
└── include
    ├── fileIO.rb       :jsonの管理ファイルをいじるためのもの
    ├── initialize.rb   :初期設定をする
    └── synchronize.rb  :同期のところ
```

## To do and issues

- How to treat when a file is removed is not yet considered.
- If two same names exist but one is a directory and the other is not, then error occurs


## 注意
ファイルが消えたり上書きされても責任持てません。

