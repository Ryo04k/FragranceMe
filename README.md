# FragranceMe
サービスURL：https://fragranceme.onrender.com/

![alt text](app/assets/images/ogp_03.jpg)
<br>

**【ゲストユーザー】** <br>
Email：fragranceme@gmail.com<br>
Password：password<br>

# サービス概要

フレグランスショップを簡単に検索できるサービスです。

- 具体的な機能：
  - キーワードや検索条件からショップを検索できます。
  - GoogleMapから現在地周辺のショップを視覚的に探すことができます。
  - 香りタイプ診断を使うことで、ユーザーにぴったりの香りを提案します。
  - ログインすることでショップのお気に入り、口コミ投稿ができます。
    <br><br>

# このサービスへの思い・作りたい理由

私自身、「お香」や「香水」といったフレグランス商品が好きで、<br>
出かける際やリラックスしたい時など日常的に香りを楽しんでいることからアプリのテーマを決めました。<br><br>
しかし、ブランドやお店の情報を知らなければ、新しい商品に出会うことは難しく、香りの種類も豊富なため、<br>
自分に合う商品を見つけることは大変だと感じています。<br><br>
また、フレグランスは実際に香りを確かめたいため、多くの人が直接店舗に足を運ぶ必要があります。<br>
そこで、このサービスを通じて、誰もが簡単に「お店選び」や「自分にぴったりの香り」と出会うキッカケを作ることで、多くの人に香りの魅力を届けられるサービスにしたいと考えています。
<br><br>

# サービスの利用イメージ


| <center>一覧から探す</center> | <center>現在地から探す</center> |
| ---- | ---- |
| [![Image from Gyazo](https://i.gyazo.com/8e1a8ecfbbb6be1e4d65a79ade18c99b.gif)](https://i.gyazo.com/8e1a8ecfbbb6be1e4d65a79ade18c99b.gif) | [![Image](https://github.com/user-attachments/assets/586c6608-cfc1-4ab5-b81c-5d9816a50c55)](https://github.com/user-attachments/assets/586c6608-cfc1-4ab5-b81c-5d9816a50c55) |
| ショップ名・地域から検索することができます。<br>また、評価・口コミでのソートやオリジナル香水ショップのフィルタリングができます。 | GoogleMapから登録されているショップを探すことができます。<br>同時に現在地から2kmのショップをリストで表示します。 |

| <center>ショップ詳細</center> | <center>お気に入り</center> |
| ---- | ---- |
| [![Image](https://github.com/user-attachments/assets/49dad28a-89ac-478b-8bc9-06b54dd9903b)](https://github.com/user-attachments/assets/49dad28a-89ac-478b-8bc9-06b54dd9903b) | [![Image from Gyazo](https://i.gyazo.com/c29fe20143e7c765db958fd8cf4483e7.gif)](https://i.gyazo.com/c29fe20143e7c765db958fd8cf4483e7.gif) |
| 店内画像・営業時間・口コミなど基本情報を確認できます。<br>ページ下部のGoogleMapから経路検索ができます。 | 気になったショップをお気に入りに登録できます。<br>登録したショップは一覧から確認することができます。 |


| <center>香りタイプ診断</center> | <center>マイページ</center> |
| ---- | ---- |
| [![Image from Gyazo](https://i.gyazo.com/0e96214ff0a3c0cd37f0be0bd2aade41.gif)](https://i.gyazo.com/0e96214ff0a3c0cd37f0be0bd2aade41.gif) | [![Image from Gyazo](https://i.gyazo.com/728bd01023492edc334b6d4598877852.gif)](https://i.gyazo.com/728bd01023492edc334b6d4598877852.gif) |
| 質問に対して回答することで、ユーザーにぴったりの香りと好きな香りの傾向を知ることができます。 | ユーザープロフィールの編集と最新の診断結果をいつでも確認することができます。 |

<br><br>

# 機能一覧

- Google認証によるユーザー登録・ログイン機能
- 一覧から探す
  - フリーワード（地域・ショップ名）
  - 評価・口コミによるソート機能
  - オリジナル香水が作れるショップのフィルタリング
- 現在地から探す
  - GoogleMapにショップを表示
  - 現在地から2kmのショップをリストで表示
- ショップ詳細
  - 店名
  - 店舗画像
  - 営業時間
  - 電話番号
  - 営業時間
  - 公式サイト
  - 住所
  - GoogleMapによる経路検索
- 口コミの投稿
  - 削除
- ショップのお気に入り
- マイページ
  - プロフィール編集
  - 診断結果を表示
- 香りタイプ診断
  - 未ログイン時に診断した場合、アカウント登録・ログインすると診断結果を保存
  - 診断結果をシェア
- OGP

<br><br>

# 使用技術（暫定）

| カテゴリ       | 技術                                                                                 |
| -------------- | ------------------------------------------------------------------------------------ |
| フロントエンド | TailwindCSS / daisyUI / Hotwire                                                      |
| バックエンド   | Ruby 3.2.3 / Rails 7.1.3                                                             |
| データベース   | PostgreSQL                                                                           |
| 開発環境       | Docker                                                                               |
| インフラ       | Render                                                                    |
| API            | Google Maps JavaScript API / Google Places API / Google Geolocation API |
| VCS            | GitHub                                                                               |
| CI/CD          | GitHub Actions                                                                       |

<br><br>

## 画面遷移図

https://www.figma.com/design/5tT3d0kSZ9hs80GaPYPuLP/FragranceMe?node-id=0-1&t=0sUjoPGsrGRMsRZa-1
<br><br>

## ER 図

[詳細はこちら](https://dbdiagram.io/d/6712172c97a66db9a36ee694)
