## 【JPRC】 japan-rewards-coin
Rewardに設計よりユーザーフレンドリーさを高め、自治体と企業の手数料負荷を減らす日本円のステーブルコイン

## ステーブルコインや決済手段通貨で特に解決したい課題

1. ステーブルコインに関しては近年日本での法整備は整い、様々な事例がでて来つつあるが、海外（例えば米国）のアドレスへの移転時に現地の事情に左右される可能性がある

2. 決済手段としては銀行のAPI呼び出しによるシステムや既存の電子マネー決済に比べメリットが少なくBtoBの送金には使用用途があるがtoCの用途として広がりが弱い

3. 昨今、ステーブルコインではなく電子マネー決済や地域の決済サービスで決済も乱立しており、各社各自治体がマーケ費用の中から還元施策を行なっているが、セキュリティのリスクやアプリの乱立、書類による申請による手間等煩わしさもあり、商店側には手数料の負荷もかかっている

## 解決のためのJPRCのアイデア


### １：日本国内での安全で効率的な送金と資金利用を促進

**初期は日本国内各地域利用に閉じる**

日本国内でのノード運用が約束されたJapan Open Chain内での発行・運用を行う送信時に位置情報や店舗のワンタイム情報を付与することで、国内にいることを証明する

**初期はホワイトリスト形式のパーミッションド型から始める**

パーミッションレス型のステーブルコインには法規制が複雑に絡むので、PoCとしてはパーミッションドで地域限定の取り組みから始める


### ２：エンタメ性のあるお得な送金機能の提供で利用を促進

**還元キャンペーンシステムを簡単に組み込める機能を提供**

各自治体や企業でマーケ費や復興費として還元している仕組みを通貨自体に組み込むサイロ化した決済システムと通貨を統合する事で自治体もユーザーにもメリットをもたらす

**ジャックポット機能を通じて利用者にエンタメ性とインセンティブ提供**

電子マネーの成功事例を参考に、送金時に一定の確率で全額無料等のキャンペーンを行えれるロジックを組み込む

### ３：所持保有自体のインセンティブを提供

**一定以上の保有に優待をつけ、ステーキング機能を実装する**

ウォレットのUXや煩雑さから、ステーブルコインは保有自体にハードルがあるので、保有自体にインセンティブを提供する。ステーキング報酬の付与と、保有自体の優待サービスを提供する発行者は裏付け金の運用益から一部をユーザーに還元する



## how to work
Run a local network in the first terminal:

```
yarn chain
```

This command starts a local Ethereum network using Hardhat. The network runs on your local machine and can be used for testing and development. You can customize the network configuration in hardhat.config.ts.

On a second terminal, deploy the test contract:

```
yarn deploy
```

This command deploys a test smart contract to the local network. The contract is located in packages/hardhat/contracts and can be modified to suit your needs. The yarn deploy command uses the deploy script located in packages/hardhat/deploy to deploy the contract to the network. You can also customize the deploy script.

On a third terminal, start your NextJS app:

```
yarn start
```

Visit your app on: http://localhost:3000. You can interact with your smart contract using the Debug Contracts page. 