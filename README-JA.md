# Swiftlets 🚀

> ファイルベースルーティングと宣言的HTML生成を実現する、モダンなSwiftウェブフレームワーク

[![Swift](https://img.shields.io/badge/Swift-6.0+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-macOS%20|%20Linux-lightgray.svg)](https://swift.org)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

> [!WARNING]
> **開発状況**: Swiftletsは現在アクティブに開発中で、**本番環境での使用はまだ推奨されません**。APIは変更される可能性があり、一部の機能は未完成です。Swiftによるウェブ開発の未来を一緒に作っていくため、皆様のフィードバックやコントリビューションをお待ちしています！

### 🎉 最新情報（2025年1月）

- **ドキュメントサイトの全面リニューアル** - SwiftUIスタイルAPIを採用し、レスポンシブでモダンなデザインに刷新
- **インタラクティブなトラブルシューティングガイド** - よくある問題を解決するための総合的なウェブベースのガイドを追加
- **充実したサンプル集** - 各ページに500行以上のCSS、アニメーション、ホバーエフェクトを実装したショーケースサイト
- **階層型共有コンポーネントシステム** - コンポーネントの自動検出と再利用を可能にする新機能

## Swiftletsとは？

Swiftletsは、シンプルなファイルベースルーティングとタイプセーフなHTML生成を特徴とする、軽量なSwiftウェブフレームワークです。モダンなウェブフレームワークからインスピレーションを得ながら、各ルートを独立した実行可能モジュールとして扱うという、ユニークなアプローチを採用しています。

### ✨ 主な機能

- **🗂 ファイルベースルーティング** - ファイル構造がそのままルートになる直感的な設計（`.webbin`ファイル）
- **🏗 宣言的HTML DSL** - SwiftUIライクな構文で、タイプセーフにHTMLを生成
- **🎯 SwiftUIスタイルAPI** - `@Query`、`@Cookie`、`@Environment`などのプロパティラッパーで簡単にデータアクセス
- **🔧 ゼロコンフィグ** - 複雑なルーティングテーブルや設定ファイルは一切不要
- **🔒 セキュリティ重視** - ソースファイルをウェブルート外に配置し、MD5による整合性チェックを実施
- **♻️ ホットリロード** - 開発中はファイルを保存するだけで自動的にコンパイル・リロード
- **🌍 クロスプラットフォーム** - macOS（Intel/Apple Silicon）とLinux（x86_64/ARM64）に対応
- **📚 充実したドキュメント** - インタラクティブなサンプルとトラブルシューティングガイドを備えた最新のドキュメントサイト

## 🚀 はじめに

Swiftletsは数分で始められます。このガイドでは、インストールから最初のプロジェクト作成まで、基本的な使い方を説明します。

### 1. クローンとビルド

まず、Swift（5.7以降）がインストールされていることを確認してから、リポジトリをクローンしてサーバーをビルドしましょう：

```bash
# リポジトリをクローン
git clone https://github.com/codelynx/swiftlets.git
cd swiftlets

# サーバーをビルド（初回セットアップ）
./build-server
```

サーバーバイナリがビルドされ、プラットフォームに応じたディレクトリ（例：`bin/darwin/arm64/`）に配置されます。

### 2. ショーケースサイトを試してみる

まずは、Swiftletsで何ができるか実際に見てみましょう！リポジトリには、ドキュメントとコンポーネントのショーケースを含む完全なサンプルサイトが含まれています。もちろん、これもSwiftletsで作られています。

サンプルサイトのビルドと実行：

```bash
# サイトをビルド
./build-site sites/swiftlets-site

# サイトを実行
./run-site sites/swiftlets-site

# またはビルドと実行を組み合わせて
./run-site sites/swiftlets-site --build
```

`http://localhost:8080`にアクセスして、以下のページをご覧ください：
- **`/`** - SwiftUIスタイルAPIで作られたモダンなランディングページ
- **`/showcase`** - すべてのHTMLコンポーネントの動作デモ
- **`/docs`** - レスポンシブデザインの包括的なドキュメント
- **`/docs/troubleshooting`** - 新機能！インタラクティブなトラブルシューティングガイド
- **`/about`** - Swiftletsの設計思想とアーキテクチャの解説
- **ソースコード** - `sites/swiftlets-site/src/`で実装方法を確認できます

> 💡 **ヒント**: このドキュメントサイト自体もSwiftletsで構築されています！ソースコードを見て、実際の使い方を学んでみてください。

### 3. アーキテクチャを理解する

Swiftletsは、各ルートを独立した実行可能ファイルとして扱うユニークなアーキテクチャを採用しています：

```
sites/swiftlets-site/
├── src/              # Swift source files
│   ├── index.swift   # Homepage route
│   ├── about.swift   # About page route
│   └── docs/
│       └── index.swift  # Docs index route
├── web/              # Static files + .webbin markers
│   ├── styles/       # CSS files
│   ├── *.webbin      # Route markers (generated)
│   └── images/       # Static assets
└── bin/              # Compiled executables (generated)
    ├── index         # Executable for /
    ├── about         # Executable for /about
    └── docs/
        └── index     # Executable for /docs
```

主要なコンセプト：
- **ファイルベースルーティング:** ファイル構造がそのままURLルートになります
- **独立した実行可能ファイル:** 各ルートが独自のバイナリとしてコンパイルされます
- **設定不要:** build-siteスクリプトがすべてを自動的に処理します
- **ホットリロード対応:** サーバーを再起動することなく、変更を即座に反映できます

### 4. サイトの操作方法

ビルドスクリプトを使えば、どのサイトでも簡単に操作できます：

```bash
# サイトをビルド（インクリメンタル - 変更されたファイルのみ）
./build-site path/to/site

# すべてのファイルを強制的に再ビルド
./build-site path/to/site --force

# ビルドアーティファクトをクリーン
./build-site path/to/site --clean

# サイトを実行
./run-site path/to/site

# カスタムポートで実行
./run-site path/to/site --port 3000

# 1つのコマンドでビルドと実行
./run-site path/to/site --build
```

> 💡 **ヒント**: スクリプトはプラットフォーム（macOS/Linux）とアーキテクチャ（x86_64/arm64）を自動検出します。

### 次のステップ

- **[最新のドキュメント](http://localhost:8080/docs)** - 刷新されたドキュメントをチェック
- **[コンポーネントショーケース](http://localhost:8080/showcase)** - 利用可能なすべてのコンポーネントを確認
- **[トラブルシューティングガイド](http://localhost:8080/docs/troubleshooting)** - よくある問題と解決方法
- **[ソースコード](https://github.com/codelynx/swiftlets/tree/main/sites/swiftlets-site)** - 実際の実装例を参考に
- **[HTML DSLガイド](http://localhost:8080/docs/concepts/html-dsl)** - SwiftUIライクな構文を習得

## 📝 最初のページの作成

### 従来のアプローチ

Swiftlets HTML DSLでシンプルなページを作ってみましょう：

```swift
// src/index.swift
import Foundation
import Swiftlets

@main
struct HomePage {
    static func main() async throws {
        // Parse the request from stdin
        let request = try JSONDecoder().decode(Request.self, from: FileHandle.standardInput.readDataToEndOfFile())
        
        let html = Html {
            Head {
                Title("Welcome to Swiftlets!")
                Meta(name: "viewport", content: "width=device-width, initial-scale=1.0")
            }
            Body {
                Container(maxWidth: .large) {
                    VStack(spacing: 40) {
                        H1("Hello, Swiftlets! 👋")
                            .style("text-align", "center")
                            .style("margin-top", "3rem")
                        
                        P("Build modern web apps with Swift")
                            .style("font-size", "1.25rem")
                            .style("text-align", "center")
                            .style("color", "#6c757d")
                        
                        HStack(spacing: 20) {
                            Link(href: "/docs/getting-started", "Get Started")
                                .class("btn btn-primary")
                            Link(href: "/showcase", "See Examples")
                                .class("btn btn-outline-secondary")
                        }
                        .style("justify-content", "center")
                    }
                }
                .style("padding", "3rem 0")
            }
        }
        
        let response = Response(
            status: 200,
            headers: ["Content-Type": "text/html; charset=utf-8"],
            body: html.render()
        )
        
        print(try JSONEncoder().encode(response).base64EncodedString())
    }
}
```

### SwiftUIスタイルアプローチ（新機能！）

SwiftUIにインスパイアされた新しいAPIを使えば、プロパティラッパーでより簡潔に書けます：

```swift
// src/index.swift
import Swiftlets

@main
struct HomePage: SwiftletMain {
    @Query("name") var userName: String?
    @Cookie("theme") var theme: String?
    
    var title = "Welcome to Swiftlets!"
    var meta = ["viewport": "width=device-width, initial-scale=1.0"]
    
    var body: some HTMLElement {
        Container(maxWidth: .large) {
            VStack(spacing: 40) {
                H1("Hello, \(userName ?? "Swiftlets")! 👋")
                    .style("text-align", "center")
                    .style("margin-top", "3rem")
                
                P("Build modern web apps with Swift")
                    .style("font-size", "1.25rem")
                    .style("text-align", "center")
                    .style("color", theme == "dark" ? "#adb5bd" : "#6c757d")
                
                HStack(spacing: 20) {
                    Link(href: "/docs/getting-started", "Get Started")
                        .class("btn btn-primary")
                    Link(href: "/showcase", "See Examples")
                        .class("btn btn-outline-secondary")
                }
                .style("justify-content", "center")
            }
        }
        .style("padding", "3rem 0")
    }
}
```

ページをビルドして確認：

```bash
# プロジェクトディレクトリから
./build-site my-site
./run-site my-site

# ブラウザで http://localhost:8080/ にアクセス
```

## 📂 プロジェクト構造

```
my-site/
├── src/                    # Swift source files
│   ├── index.swift         # Home page (/)
│   ├── about.swift         # About page (/about)
│   └── api/
│       └── users.swift     # API endpoint (/api/users)
├── web/                    # Public web root
│   ├── *.webbin           # Route markers (generated)
│   ├── styles/            # CSS files
│   ├── scripts/           # JavaScript files
│   └── images/            # Static assets
├── bin/                    # Compiled executables (generated)
└── Components.swift       # Shared components (optional)
```

## 🎯 コアコンセプト

### ファイルベースルーティング

ファイル構造が自動的にルートを定義：

- `src/index.swift` → `/`
- `src/about.swift` → `/about`
- `src/blog/index.swift` → `/blog`
- `src/blog/post.swift` → `/blog/post`
- `src/api/users.json.swift` → `/api/users.json`

### HTML DSL

SwiftのタイプセーフティでHTMLを構築：

```swift
VStack(alignment: .center, spacing: .large) {
    H1("Welcome")
        .id("hero-title")
        .classes("display-1")
    
    ForEach(posts) { post in
        Article {
            H2(post.title)
            Paragraph(post.excerpt)
            Link("Read more", href: "/blog/\(post.slug)")
        }
        .classes("mb-4")
    }
}
```

### リクエスト/レスポンス処理

プロパティラッパーを使って、動的なリクエストを簡単に処理できます：

```swift
import Swiftlets

@main
struct APIHandler: SwiftletMain {
    @Query("limit", default: "10") var limit: String?
    @Query("offset", default: "0") var offset: String?
    @JSONBody<UserFilter>() var filter: UserFilter?
    
    var title = "User API"
    
    var body: ResponseBuilder {
        let users = fetchUsers(
            limit: Int(limit ?? "10") ?? 10,
            offset: Int(offset ?? "0") ?? 0,
            filter: filter
        )
        
        return ResponseWith {
            Pre(try! JSONEncoder().encode(users).string())
        }
        .contentType("application/json")
        .header("X-Total-Count", value: "\(users.count)")
    }
}
```

クッキーとフォームデータの処理例：

```swift
@main
struct LoginHandler: SwiftletMain {
    @FormValue("username") var username: String?
    @FormValue("password") var password: String?
    @Cookie("session") var existingSession: String?
    
    var title = "Login"
    
    var body: ResponseBuilder {
        // Check existing session
        if let session = existingSession, validateSession(session) {
            return ResponseWith {
                Div { H1("Already logged in!") }
            }
        }
        
        // Process login
        if let user = username, let pass = password {
            if authenticate(user, pass) {
                let sessionId = createSession(for: user)
                return ResponseWith {
                    Div { H1("Welcome, \(user)!") }
                }
                .cookie("session", value: sessionId, httpOnly: true)
            }
        }
        
        // Show login form
        return ResponseWith {
            Form(action: "/login", method: "POST") {
                Input(type: "text", name: "username", placeholder: "Username")
                Input(type: "password", name: "password", placeholder: "Password")
                Button("Login", type: "submit")
            }
        }
    }
}
```

## 🌍 プラットフォームサポート

### macOS
- **要件**: macOS 13+、Swift 6.0+
- **アーキテクチャ**: Intel (x86_64) と Apple Silicon (arm64)

### Linux
- **ディストリビューション**: Ubuntu 22.04 LTS+
- **アーキテクチャ**: x86_64 と ARM64
- **Swift**: [swift.org](https://swift.org)から5.10+

### クロスプラットフォーム対応

すべてのビルドスクリプトはmacOSとLinuxで同様に動作します。プラットフォーム固有の注意事項は[Ubuntuスクリプティングの問題](docs/ubuntu-scripting-issue.md)をご覧ください。

```bash
# 現在のプラットフォーム用にビルド
./build-server

# Ubuntuの前提条件をチェック
./check-ubuntu-prerequisites.sh

# サーバーを実行
./run-server.sh
```

## 📚 ドキュメント

インタラクティブなドキュメントは[ショーケースサイト](http://localhost:8080/docs)でご覧いただけます。また、以下のリファレンスも参考にしてください：

### コアドキュメント
- [**CLIリファレンス**](docs/CLI.md) - 完全なCLIドキュメント
- [**ルーティングガイド**](docs/ROUTING.md) - 高度なルーティングパターン
- [**設定**](docs/CONFIGURATION.md) - サーバー設定
- [**アーキテクチャ**](docs/swiftlet-architecture.md) - Swiftletsの仕組み

### SwiftUIスタイルAPI（新機能！）
- [**SwiftUI API実装**](docs/SWIFTUI-API-IMPLEMENTATION.md) - 例を含む完全なガイド
- [**SwiftUI APIリファレンス**](docs/SWIFTUI-API-REFERENCE.md) - すべてのプロパティラッパーとプロトコル

### HTML DSL
- [**HTML DSLリファレンス**](docs/html-elements-reference.md) - すべてのHTMLコンポーネント
- [**SDK配布**](docs/sdk-distribution-plan.md) - 将来のSDKパッケージング計画

## 🧪 例とショーケース

### 🌟 公式ドキュメント＆ショーケースサイト

Swiftletsを学ぶ最も効果的な方法は、SwiftUIスタイルAPIとレスポンシブデザインで構築された包括的なドキュメントとショーケースサイトを実際に触ってみることです：

```bash
# ドキュメントサイトのクイックスタート
./build-site sites/swiftlets-site
./run-site sites/swiftlets-site
```

サイトの内容：
- **最新のドキュメント** - モダンなCSSとアニメーションを使った8つのドキュメントページ
- **コンポーネントギャラリー** - すべてのHTML要素の動作例とコードスニペット
- **レイアウトデモ** - HStack、VStack、Grid、レスポンシブレイアウトの実装例
- **モディファイアプレイグラウンド** - スタイリングとカスタマイズのサンプル
- **インタラクティブなトラブルシューティング** - よくある問題を解決する総合ガイド
- **Aboutセクション** - 設計思想、アーキテクチャ、今後のロードマップ

### その他の例

- [**テストサイト**](sites/tests/) - フレームワーク開発用のテストサイト
- [**テンプレート**](templates/) - クイックスタート用のプロジェクトテンプレート

### 任意の例を実行

```bash
# 特定のサイトをビルドして実行
./build-site sites/swiftlets-site
./run-site sites/swiftlets-site

# または1つのコマンドでビルドと実行
./run-site sites/swiftlets-site --build
```

## 📁 プロジェクト構造

```
swiftlets/
├── Sources/           # フレームワークとサーバーのソースコード
├── bin/{os}/{arch}/   # プラットフォーム固有のバイナリ
├── sites/             # 例とテストサイト
├── templates/         # プロジェクトテンプレート
├── tools/             # ビルドとパッケージングツール
└── docs/              # ドキュメント
```

詳細は[プロジェクト構造](docs/PROJECT-STRUCTURE.md)を参照してください。

## 🤝 コントリビューション

皆様のコントリビューションを歓迎します！詳細は[貢献ガイド](CONTRIBUTING.md)をご覧ください。

```bash
# テストを実行
make test

# コードスタイルをチェック
make lint

# ドキュメントをビルド
make docs
```

## 🗺 ロードマップ

今後の開発計画については[詳細なロードマップ](docs/roadmap.md)をご覧ください。

## 📄 ライセンス

SwiftletsはMITライセンスの下でリリースされています。詳細は[LICENSE](LICENSE)を参照してください。

## 🔧 トラブルシューティング

### インタラクティブなトラブルシューティングガイド

ドキュメントサイトを起動後、`http://localhost:8080/docs/troubleshooting`で総合的なトラブルシューティングガイドをご利用いただけます。以下の内容をカバーしています：

- **Expression Too Complex**エラーの解決方法
- **ビルドタイムアウト**の対処法
- **プロパティラッパー**の正しい構文
- **よくあるビルドエラー**とその解決策
- **FAQ**セクションでよくある質問への回答

### よくある問題と対処法

- **ビルドがハングまたはタイムアウトする場合**: 複雑なHTMLを小さな`@HTMLBuilder`関数に分割してください
- **Linuxで1つのファイルしかビルドされない場合**: 既知のbashループの問題です。詳細は[Ubuntuスクリプティングの問題](docs/ubuntu-scripting-issue.md)を参照
- **MD5コマンドが見つからない場合**: スクリプトがmacOS（md5）とLinux（md5sum）の違いを自動的に処理します
- **ビルドエラーが発生する場合**: `--verbose`フラグで詳細情報を確認：`./build-site sites/your-site --verbose`

さらに詳しい情報：
- ウェブガイド: `http://localhost:8080/docs/troubleshooting`（サイト起動後）
- ドキュメント: [複雑な式のトラブルシューティング](docs/troubleshooting-complex-expressions.md)

## 🙏 謝辞

- Paul Hudson氏の[Ignite](https://github.com/twostraws/Ignite)フレームワークにインスパイアされました
- Swiftへの愛を込めて、Swiftで構築されています

---

<p align="center">
  <a href="https://github.com/codelynx/swiftlets">GitHub</a>
</p>