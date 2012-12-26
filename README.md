# Usage

## Example

ローカルの JSON ファイルを引数として渡す

`jsonpp ~/Documents/foo/sample.json`

URL を引数として渡し、キーでソートする。URL が https だと失敗します。 curl -k を使ってください。

`jsonpp --sort-numeric http://localhost:4567/sample.json`

cURL を使ってサーバ上の JSON を取得後、パイプで渡す

`curl http://localhost:4567/sample.json | jsonpp --sort`

Pretty-Print したものを Sublime Text 2.app で開く

`jsonpp ~/foo/sample.json | open -f -a "Sublime Text 2.app"`

## Options

### version

`jsonpp --version`

`jsonpp -v`

### help

`jsonpp --help`

`jsonpp -h`

### sort

キー名をソートして出力（compare:）

`jsonpp --sort /foo/bar/buzz.json`

### sort-numeric

キー名が数字の場合、数字として評価しソートして出力（NSNumericSearch）

`jsonpp --sort-numeric /foo/bar/buzz.json`

### output

ファイル書き出し。読み込み元と同じ場所を指定した場合には上書き。

`jsonpp -o ~/foo/bar/buzz.json ~/foo/bar/buzz.json`

`jsonpp --output twitter_search.json "http://search.twitter.com/search.json?lang=ja&rpp=20&q=%23iPhone"`

# Download

[jsonpp_installer](http://cyan-stivy.net/wordpress/wp-content/jsonpp_installer_v1_0_0.pkg)