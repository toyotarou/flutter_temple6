# flutter_temple6

訪問したお寺の情報・写真・位置情報を地図上で管理する Flutter 製のお寺訪問記録アプリです。
東京・千葉エリアの市区町村データ・電車・バス情報と連携し、次の参拝先の検索や所要時間の計算も行えます。

---

## 主な機能

### お寺情報の管理
- **お寺一覧** — 訪問日・名前・住所・最寄り駅・ご本尊・メモを一覧表示
- **市区町村別一覧** — 東京・千葉の市区町村でフィルタリングしたお寺リスト
- **お寺写真** — 写真一覧・拡大表示（ネットワーク画像キャッシュ対応）
- **お寺ルーレット** — 未訪問または再訪したいお寺をランダムにピックアップ

### 地図表示（OpenStreetMap）
- **市区町村別お寺マップ** — 地域を選択してお寺の位置をマップ上にプロット
- **日別訪問マップ** — 特定の日に訪問したお寺の移動ルートを地図で確認
- **自宅中心の訪問スポットマップ** — 自宅を起点に訪問済みスポットを地図表示

### 交通・アクセス情報
- **ルート表示** — 電車を利用したお寺へのアクセスルートを表示
- **バスルート表示** — バス経由のアクセス情報を表示
- **所要時間計算** — 出発地・条件を設定して目的のお寺までの所要時間を算出

---

## 技術スタック

| カテゴリ | 技術 |
|---|---|
| フレームワーク | [Flutter](https://flutter.dev/) (Dart SDK ^3.8.1) |
| 状態管理 | [Riverpod](https://riverpod.dev/) (hooks_riverpod / riverpod_annotation) |
| データ取得 | HTTP API（`http` パッケージ） |
| コード生成 | freezed / json_serializable / riverpod_generator / build_runner |
| 地図 | [flutter_map](https://pub.dev/packages/flutter_map) + [latlong2](https://pub.dev/packages/latlong2) (OpenStreetMap) |
| 画像 | [cached_network_image](https://pub.dev/packages/cached_network_image) + [flutter_cache_manager](https://pub.dev/packages/flutter_cache_manager) |
| 外部リンク | [url_launcher](https://pub.dev/packages/url_launcher) |
| アイコン | [font_awesome_flutter](https://pub.dev/packages/font_awesome_flutter) |

---

## 対応プラットフォーム

- Android
- iOS
- macOS
- Windows
- Linux

---

## データモデル一覧

| モデル | 概要 |
|---|---|
| `TempleModel` | お寺情報（訪問日・名前・住所・最寄り駅・ご本尊・緯度経度・写真リスト） |
| `TempleLatLngModel` | お寺の位置情報（緯度・経度） |
| `TempleListModel` | お寺グループ／リスト（巡礼コース等） |
| `TemplePhotoModel` | お寺の写真データ |
| `StationModel` | 駅情報 |
| `TokyoTrainModel` | 東京エリアの電車・路線情報 |
| `TrainModel` | 電車情報 |
| `MunicipalModel` | 市区町村データ（東京・千葉） |
| `BusTotalInfoModel` | バス経路・停留所情報 |
| `DupSpotModel` | 重複スポット管理 |

---

## プロジェクト構成

```
lib/
├── main.dart                  # エントリーポイント・全データ初期取得
├── controllers/               # Riverpodコントローラー・Mixin
├── models/                    # データモデル
├── data/                      # HTTP通信層（API呼び出し）
├── screens/
│   ├── home_screen.dart       # ホーム画面
│   ├── components/            # 各機能ダイアログ・アラート
│   │   ├── city_town_temple_list_alert.dart      # 市区町村別お寺一覧
│   │   ├── city_town_temple_map_alert.dart       # 市区町村別お寺マップ
│   │   ├── daily_temple_map_alert.dart           # 日別訪問マップ
│   │   ├── home_centered_visited_spot_map_alert.dart  # 自宅中心マップ
│   │   ├── pickup_temple_roulette_alert.dart     # お寺ルーレット
│   │   ├── required_time_calculate_setting_alert.dart # 所要時間計算
│   │   ├── route_display_alert.dart              # ルート表示
│   │   ├── bus_route_display_alert.dart          # バスルート表示
│   │   ├── temple_photo_list_alert.dart          # お寺写真一覧
│   │   └── temple_photo_display_alert.dart       # お寺写真表示
│   └── parts/                 # 共通UIパーツ
├── const/                     # 定数定義
├── extensions/                # 拡張メソッド
└── utility/                   # ユーティリティ
assets/
├── images/                    # 画像リソース
└── json/                      # 市区町村データ等のJSONファイル
```

---

## セットアップ

### 前提条件

- Flutter SDK (Dart ^3.8.1)
- お寺・駅・路線データを提供するバックエンド API サーバー

### インストール手順

```bash
# リポジトリをクローン
git clone https://github.com/toyotarou/flutter_temple6.git
cd flutter_temple6

# 依存パッケージをインストール
flutter pub get

# コード生成（Freezed / Riverpod）
dart run build_runner build --delete-conflicting-outputs

# アプリを実行
flutter run
```

---

## ライセンス

このプロジェクトはプライベートリポジトリです (`publish_to: 'none'`)。
