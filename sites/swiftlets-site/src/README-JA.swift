import Swiftlets

@main
struct ReadmeJA: SwiftletMain {
    @Cookie("lang", default: "ja") var language: String?
    
    var title = "Swiftlets - Swiftウェブフレームワーク"
    var meta = [
        "description": "SwiftとSwiftUIライクな構文でモダンなウェブアプリケーションを構築",
        "viewport": "width=device-width, initial-scale=1.0"
    ]
    
    var body: some HTMLElement {
        Fragment {
            readmeStyles()
            navigation()
            mainContent()
            footer()
            languageScript()
        }
    }
    
    @HTMLBuilder
    func readmeStyles() -> some HTMLElement {
        Style("""
        body { 
            margin: 0; 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Hiragino Sans', 'Hiragino Kaku Gothic ProN', 'Meiryo', sans-serif;
            color: #1a202c;
            line-height: 1.8;
            background: #ffffff;
        }
        
        /* Navigation */
        .readme-nav {
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(10px);
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            position: sticky;
            top: 0;
            z-index: 100;
            padding: 1rem 0;
        }
        
        .nav-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 1rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .nav-brand {
            font-size: 1.5rem;
            font-weight: 700;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-decoration: none;
        }
        
        .nav-links {
            display: flex;
            gap: 2rem;
            align-items: center;
        }
        
        .nav-links a {
            color: #4a5568;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s;
        }
        
        .nav-links a:hover {
            color: #667eea;
        }
        
        /* Language Switcher */
        .lang-switcher {
            position: relative;
            display: inline-block;
            margin-left: 20px;
        }
        
        .lang-button {
            background: white;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            padding: 0.5rem 1rem;
            font-size: 0.875rem;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.2s;
        }
        
        .lang-button:hover {
            border-color: #667eea;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .lang-flag {
            font-size: 1.25rem;
        }
        
        .lang-dropdown {
            position: absolute;
            top: 100%;
            right: 0;
            margin-top: 0.5rem;
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            min-width: 150px;
            display: none;
            z-index: 1000;
        }
        
        .lang-dropdown.show {
            display: block;
        }
        
        .lang-option {
            padding: 0.75rem 1rem;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            transition: background 0.2s;
            text-decoration: none;
            color: #1a202c;
        }
        
        .lang-option:hover {
            background: #f7fafc;
        }
        
        /* Main Content */
        .readme-container {
            max-width: 900px;
            margin: 0 auto;
            padding: 3rem 2rem;
        }
        
        .readme-header {
            text-align: center;
            margin-bottom: 3rem;
        }
        
        .readme-title {
            font-size: 3rem;
            font-weight: 800;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin: 0 0 1rem 0;
        }
        
        .readme-subtitle {
            font-size: 1.5rem;
            color: #4a5568;
            margin: 0;
        }
        
        .badges {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin: 2rem 0;
        }
        
        .badge {
            display: inline-block;
        }
        
        .badge img {
            height: 20px;
        }
        
        /* Sections */
        .readme-section {
            margin: 3rem 0;
        }
        
        .readme-section h2 {
            font-size: 2rem;
            font-weight: 700;
            color: #1a202c;
            margin: 0 0 1rem 0;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #e2e8f0;
        }
        
        .readme-section h3 {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2d3748;
            margin: 2rem 0 1rem 0;
        }
        
        /* Warning Box */
        .warning-box {
            background: #fef3c7;
            border-left: 4px solid #f59e0b;
            padding: 1.5rem;
            border-radius: 8px;
            margin: 2rem 0;
        }
        
        .warning-box strong {
            color: #92400e;
        }
        
        /* Features */
        .features-list {
            list-style: none;
            padding: 0;
            margin: 1rem 0;
        }
        
        .features-list li {
            padding: 0.75rem 0;
            border-bottom: 1px solid #f1f5f9;
        }
        
        .features-list li:last-child {
            border-bottom: none;
        }
        
        .features-list strong {
            color: #667eea;
        }
        
        /* Code Blocks */
        .code-block {
            background: #1a202c;
            color: #e2e8f0;
            padding: 1.5rem;
            border-radius: 8px;
            font-family: 'SF Mono', Monaco, Consolas, monospace;
            font-size: 0.9rem;
            line-height: 1.6;
            overflow-x: auto;
            margin: 1rem 0;
        }
        
        /* Links */
        .readme-section a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s;
        }
        
        .readme-section a:hover {
            color: #764ba2;
            text-decoration: underline;
        }
        
        /* Footer */
        .readme-footer {
            background: #f7fafc;
            padding: 3rem 0;
            border-top: 1px solid #e2e8f0;
            margin-top: 5rem;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .readme-title { font-size: 2rem; }
            .readme-subtitle { font-size: 1.25rem; }
            .nav-links { gap: 1rem; font-size: 0.9rem; }
            .lang-text { display: none; }
        }
        """)
    }
    
    @HTMLBuilder
    func navigation() -> some HTMLElement {
        Nav {
            Div {
                Link(href: "/", "Swiftlets")
                    .class("nav-brand")
                Div {
                    Link(href: "/docs", "ドキュメント")
                    Link(href: "/showcase", "ショーケース")
                    Link(href: "/about", "Swiftletsについて")
                    Link(href: "https://github.com/codelynx/swiftlets", "GitHub")
                        .attribute("target", "_blank")
                    
                    // Language Switcher
                    Div {
                        Button {
                            Span("🌐")
                                .class("lang-flag")
                            Span("日本語")
                                .class("lang-text")
                            Span("▼")
                                .style("font-size", "0.75rem")
                                .style("margin-left", "0.25rem")
                        }
                        .class("lang-button")
                        .attribute("onclick", "toggleLanguageDropdown(event)")
                        
                        Div {
                            Link(href: "/") {
                                Span("🇬🇧")
                                    .class("lang-flag")
                                Span("English")
                            }
                            .class("lang-option")
                            .attribute("onclick", "setLanguage('en')")
                            
                            Link(href: "/README-JA") {
                                Span("🇯🇵")
                                    .class("lang-flag")
                                Span("日本語")
                            }
                            .class("lang-option")
                            .attribute("onclick", "setLanguage('ja')")
                        }
                        .class("lang-dropdown")
                        .id("langDropdown")
                    }
                    .class("lang-switcher")
                }
                .class("nav-links")
            }
            .class("nav-content")
        }
        .class("readme-nav")
    }
    
    @HTMLBuilder
    func mainContent() -> some HTMLElement {
        Div {
            header()
            warningSection()
            whatIsSection()
            featuresSection()
            gettingStartedSection()
            architectureSection()
            moreInfoSection()
        }
        .class("readme-container")
    }
    
    @HTMLBuilder
    func header() -> some HTMLElement {
        Div {
            H1("Swiftlets 🚀")
                .class("readme-title")
            P("ファイルベースルーティングと宣言的HTML生成を実現する、モダンなSwiftウェブフレームワーク")
                .class("readme-subtitle")
            
            Div {
                Link(href: "https://swift.org") {
                    Img(src: "https://img.shields.io/badge/Swift-6.0+-orange.svg", alt: "Swift")
                }
                .class("badge")
                Link(href: "https://swift.org") {
                    Img(src: "https://img.shields.io/badge/Platform-macOS%20|%20Linux-lightgray.svg", alt: "Platform")
                }
                .class("badge")
                Link(href: "LICENSE") {
                    Img(src: "https://img.shields.io/badge/License-MIT-blue.svg", alt: "License")
                }
                .class("badge")
            }
            .class("badges")
        }
        .class("readme-header")
    }
    
    @HTMLBuilder
    func warningSection() -> some HTMLElement {
        Div {
            P {
                Strong("開発状況: ")
                Text("Swiftletsは現在アクティブに開発中で、")
                Strong("本番環境での使用はまだ推奨されません。")
                Text("APIは変更される可能性があり、一部の機能は未完成です。Swiftによるウェブ開発の未来を一緒に作っていくため、皆様のフィードバックやコントリビューションをお待ちしています！")
            }
        }
        .class("warning-box")
    }
    
    @HTMLBuilder
    func whatIsSection() -> some HTMLElement {
        Section {
            H2("Swiftletsとは？")
            P("Swiftletsは、シンプルなファイルベースルーティングとタイプセーフなHTML生成を特徴とする、軽量なSwiftウェブフレームワークです。モダンなウェブフレームワークからインスピレーションを得ながら、各ルートを独立した実行可能モジュールとして扱うという、ユニークなアプローチを採用しています。")
        }
        .class("readme-section")
    }
    
    @HTMLBuilder
    func featuresSection() -> some HTMLElement {
        Section {
            H2("✨ 主な機能")
            UL {
                LI {
                    Strong("🗂 ファイルベースルーティング")
                    Text(" - ファイル構造がそのままルートになる直感的な設計（.webbinファイル）")
                }
                LI {
                    Strong("🏗 宣言的HTML DSL")
                    Text(" - SwiftUIライクな構文で、タイプセーフにHTMLを生成")
                }
                LI {
                    Strong("🎯 SwiftUIスタイルAPI")
                    Text(" - @Query、@Cookie、@Environmentなどのプロパティラッパーで簡単にデータアクセス")
                }
                LI {
                    Strong("🔧 ゼロコンフィグ")
                    Text(" - 複雑なルーティングテーブルや設定ファイルは一切不要")
                }
                LI {
                    Strong("🔒 セキュリティ重視")
                    Text(" - ソースファイルをウェブルート外に配置し、MD5による整合性チェックを実施")
                }
                LI {
                    Strong("♻️ ホットリロード")
                    Text(" - 開発中はファイルを保存するだけで自動的にコンパイル・リロード")
                }
                LI {
                    Strong("🌍 クロスプラットフォーム")
                    Text(" - macOS（Intel/Apple Silicon）とLinux（x86_64/ARM64）に対応")
                }
                LI {
                    Strong("📚 充実したドキュメント")
                    Text(" - インタラクティブなサンプルとトラブルシューティングガイドを備えた最新のドキュメントサイト")
                }
            }
            .class("features-list")
        }
        .class("readme-section")
    }
    
    @HTMLBuilder
    func gettingStartedSection() -> some HTMLElement {
        Section {
            H2("🚀 はじめに")
            P("Swiftletsは数分で始められます。このガイドでは、インストールから最初のプロジェクト作成まで、基本的な使い方を説明します。")
            
            H3("1. クローンとビルド")
            P("まず、Swift（5.7以降）がインストールされていることを確認してから、リポジトリをクローンしてサーバーをビルドしましょう：")
            
            Pre {
                Code("""
# リポジトリをクローン
git clone https://github.com/codelynx/swiftlets.git
cd swiftlets

# サーバーをビルド（初回セットアップ）
./build-server
""")
            }
            .class("code-block")
            
            H3("2. ショーケースサイトを試してみる")
            P("まずは、Swiftletsで何ができるか実際に見てみましょう！リポジトリには、ドキュメントとコンポーネントのショーケースを含む完全なサンプルサイトが含まれています。もちろん、これもSwiftletsで作られています。")
            
            Pre {
                Code("""
# サイトをビルド
./build-site sites/swiftlets-site

# サイトを実行
./run-site sites/swiftlets-site

# またはビルドと実行を組み合わせて
./run-site sites/swiftlets-site --build
""")
            }
            .class("code-block")
            
            P {
                Text("http://localhost:8080 にアクセスして、以下のページをご覧ください：")
            }
            
            UL {
                LI {
                    Strong("/")
                    Text(" - SwiftUIスタイルAPIで作られたモダンなランディングページ")
                }
                LI {
                    Strong("/showcase")
                    Text(" - すべてのHTMLコンポーネントの動作デモ")
                }
                LI {
                    Strong("/docs")
                    Text(" - レスポンシブデザインの包括的なドキュメント")
                }
                LI {
                    Strong("/docs/troubleshooting")
                    Text(" - 新機能！インタラクティブなトラブルシューティングガイド")
                }
                LI {
                    Strong("/about")
                    Text(" - Swiftletsの設計思想とアーキテクチャの解説")
                }
            }
        }
        .class("readme-section")
    }
    
    @HTMLBuilder
    func architectureSection() -> some HTMLElement {
        Section {
            H2("🏗 アーキテクチャの理解")
            P("Swiftletsは、各ルートがスタンドアロンの実行可能ファイルであるユニークなアーキテクチャを使用します：")
            
            Pre {
                Code("""
sites/swiftlets-site/
├── src/              # Swiftソースファイル
│   ├── index.swift   # ホームページルート
│   ├── about.swift   # Aboutページルート
│   └── docs/
│       └── index.swift  # ドキュメントインデックスルート
├── web/              # 静的ファイル + .webbinマーカー
│   ├── styles/       # CSSファイル
│   ├── *.webbin      # ルートマーカー（生成される）
│   └── images/       # 静的アセット
└── bin/              # コンパイルされた実行可能ファイル（生成される）
    ├── index         # / の実行可能ファイル
    ├── about         # /about の実行可能ファイル
    └── docs/
        └── index     # /docs の実行可能ファイル
""")
            }
            .class("code-block")
            
            P("主要な概念：")
            UL {
                LI {
                    Strong("ファイルベースルーティング:")
                    Text(" ファイル構造がルートを定義")
                }
                LI {
                    Strong("独立した実行可能ファイル:")
                    Text(" 各ルートは独自のバイナリにコンパイル")
                }
                LI {
                    Strong("Makefileは不要:")
                    Text(" build-siteスクリプトがすべてを処理")
                }
                LI {
                    Strong("ホットリロード対応:")
                    Text(" サーバーを再起動せずに実行可能ファイルを再構築可能")
                }
            }
        }
        .class("readme-section")
    }
    
    @HTMLBuilder
    func moreInfoSection() -> some HTMLElement {
        Section {
            H2("📚 詳細情報")
            P {
                Text("詳細なドキュメント、例、貢献ガイドラインについては、")
                Link(href: "https://github.com/codelynx/swiftlets", "GitHubリポジトリ")
                Text("をご覧ください。")
            }
            
            P {
                Text("ライブドキュメントは ")
                Link(href: "/docs", "こちら")
                Text(" で確認できます。")
            }
        }
        .class("readme-section")
    }
    
    @HTMLBuilder
    func footer() -> some HTMLElement {
        Footer {
            Container(maxWidth: .large) {
                HStack {
                    P("© 2025 Swiftlets Project")
                        .style("margin", "0")
                        .style("color", "#718096")
                    Spacer()
                    HStack(spacing: 24) {
                        Link(href: "https://github.com/codelynx/swiftlets", "GitHub")
                        Link(href: "/docs", "ドキュメント")
                        Link(href: "/showcase", "例")
                    }
                    .style("color", "#4a5568")
                }
                .style("align-items", "center")
            }
        }
        .class("readme-footer")
    }
    
    @HTMLBuilder
    func languageScript() -> some HTMLElement {
        Script("""
        function toggleLanguageDropdown(event) {
            event.preventDefault();
            const dropdown = document.getElementById('langDropdown');
            dropdown.classList.toggle('show');
            
            // Close dropdown when clicking outside
            document.addEventListener('click', function closeDropdown(e) {
                if (!e.target.closest('.lang-switcher')) {
                    dropdown.classList.remove('show');
                    document.removeEventListener('click', closeDropdown);
                }
            });
        }
        
        function setLanguage(lang) {
            // Set cookie
            document.cookie = `lang=${lang}; path=/; max-age=31536000`;
            
            // Redirect to appropriate page
            if (lang === 'en') {
                window.location.href = '/';
            } else {
                window.location.reload();
            }
        }
        """)
    }
}