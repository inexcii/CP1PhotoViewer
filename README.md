### 課題
オンラインフォートサービス[flickr](https://www.flickr.com/)を利用して実装したフォートビューワの中に、ユーザが選択した一枚フォートの内容に関してユーザが見なくてもアプリが自動で解析してくれる

### 解決
画像認識サービス「Imagga」を利用して実現できた

### アピールポイント
- CocoaPodsを利用してthird-party ライブラリを組み込む
- API通信は`Alamofire`で、画像の非同期処理は`AlamofireImage`で、JSONハンドリングは`SwiftyJSON`というライブラリを利用すること
- 画像認識はオンラインサービス[Imagga](https://imagga.com/)を利用すること
- (開発者に便利)後で書き換える可能性があるAPIキーや認証トークンなどの秘密情報について、アプリが審査されずに該当情報を更新できるような仕組み(`Firebase`の[Remote Config](https://firebase.google.com/docs/remote-config/?hl=ja)機能利用)を入れてあること
