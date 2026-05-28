# タスク管理アプリ 設計書

就活ポートフォリオ用 — Rails × Slim × Hotwire × Docker

## 1. アプリ概要

期限・優先度・カテゴリ管理ができるタスク管理Webアプリ。Rails フルスタック構成（Hotwire）で実装し、就活ポートフォリオとして活用する。

## 2. 技術構成

| レイヤー | 技術 |
|----------|------|
| 言語 | Ruby 4.0.1 |
| フレームワーク | Ruby on Rails 8.1（フルスタック） |
| フロントエンド | Slim + Hotwire（Turbo + Stimulus） |
| アセットパイプライン | Propshaft + Importmap |
| データベース | PostgreSQL 15 |
| 認証 | Devise |
| 開発環境 | Docker / Docker Compose |
| デプロイ | Render（無料プラン） |

## 3. 機能一覧

### 認証

- ユーザー登録（メールアドレス・パスワード）
- ログイン / ログアウト
- 自分のタスクのみ閲覧・操作できる

### タスク管理（CRUD）

- タスクの作成・編集・削除
- タスクの完了 / 未完了の切り替え（ページリロードなし）

### タスク属性

| 属性 | 型 | 備考 |
|------|----|------|
| タイトル | string | 必須 |
| 説明 | text | 任意 |
| 期限日 | date | |
| 優先度 | enum | 高 / 中 / 低 |
| ステータス | enum | 未完了 / 完了 |
| カテゴリ | belongs_to | 任意 |

### 一覧・フィルタ

- 優先度でフィルタ
- 期限日でソート（昇順・降順）
- 期限切れタスクを色分け表示（赤）

### ダッシュボード

- 全タスク数・完了数・完了率
- 今日が期限のタスク一覧
- 期限切れタスク一覧

## 4. データモデル

### users テーブル

| カラム | 型 | 備考 |
|--------|----|------|
| id | integer | PK |
| email | string | NOT NULL, UNIQUE |
| encrypted_password | string | NOT NULL |
| reset_password_token | string | UNIQUE |
| reset_password_sent_at | datetime | |
| remember_created_at | datetime | |
| created_at | datetime | NOT NULL |
| updated_at | datetime | NOT NULL |

### categories テーブル

| カラム | 型 | 備考 |
|--------|----|------|
| id | integer | PK |
| user_id | integer | FK（users）NOT NULL |
| name | string | NOT NULL |
| color | string | デフォルト: #808080 |
| created_at | datetime | NOT NULL |
| updated_at | datetime | NOT NULL |

### tasks テーブル

| カラム | 型 | 備考 |
|--------|----|------|
| id | integer | PK |
| user_id | integer | FK（users）NOT NULL |
| category_id | integer | FK（categories）任意 |
| title | string | NOT NULL |
| description | text | |
| due_date | date | |
| priority | integer | 0:低 / 1:中 / 2:高（enum） |
| status | integer | 0:未完了 / 1:完了（enum） |
| created_at | datetime | NOT NULL |
| updated_at | datetime | NOT NULL |

## 5. ルーティング設計

```ruby
Rails.application.routes.draw do
  devise_for :users
  root "dashboard#index"

  resources :categories
  resources :tasks do
    member do
      patch :toggle_status  # 完了/未完了の切り替え
    end
  end
end
```

## 6. 画面構成

| パス | 画面 |
|------|------|
| / | ダッシュボード（ログイン後） |
| /users/sign_in | ログイン画面 |
| /users/sign_up | ユーザー登録画面 |
| /tasks | タスク一覧 |
| /tasks/new | タスク作成 |
| /tasks/:id/edit | タスク編集 |
| /categories | カテゴリ管理 |

## 7. Hotwire の使いどころ

| 機能 | 使う技術 | 効果 |
|------|----------|------|
| 完了/未完了の切り替え | Turbo Stream | ページリロードなしで更新 |
| タスク削除 | Turbo Stream | 一覧からスムーズに消える |
| フィルタ・ソート | Turbo Frame | 一覧部分だけ差し替え |

## 8. Docker Compose 構成

```yaml
services:
  db:
    image: postgres:15
  web:
    build:
      context: .
      dockerfile: Dockerfile.dev
    command: bash -c "rm -f tmp/pids/server.pid && bundle exec rails s -b '0.0.0.0'"
    volumes:
      - .:/rails
    ports:
      - "3000:3000"
    depends_on:
      - db
```

## 9. 今後追加したい機能

- タイトル検索
- カテゴリの色分け表示
- LINE Messaging API 連携（期限リマインダー通知）

## 10. 1ヶ月スケジュール

| 週 | やること |
|----|----------|
| Week 1 | Docker環境構築・Railsセットアップ・Devise認証・DBマイグレーション |
| Week 2 | タスクCRUD実装・カテゴリ機能・一覧/作成/編集/削除画面・基本的なCSS |
| Week 3 | Hotwire導入・フィルタ/ソート・期限切れ色分け・ダッシュボード |
| Week 4 | Renderデプロイ・README整備・動作確認・面接トーク準備 |

## 11. GitHub README に書くこと

1. アプリの概要・使い方（スクリーンショット必須）
2. 技術スタックとその選定理由
3. 工夫した点・難しかった点（Hotwireで実現したUXなど）
4. 今後追加したい機能
5. ローカル起動手順（`docker compose up` で動くようにする）

## 12. 面接トーク例

「自分が実際に使いたくて作りました。Ruby 4.0 + Rails 8.1 のフルスタック構成で、
Hotwire（Turbo + Stimulus）を使ってページリロードなしでタスクの完了切り替えや
フィルタリングができるようにしました。カテゴリ機能でタスクを分類でき、
Docker で開発環境を整え、Render にデプロイして実際に動く状態にしています。
今後は LINE Messaging API と連携したリマインダー通知機能を追加予定です。」
