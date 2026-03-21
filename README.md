# nix-dotfiles

Apple Silicon Mac 向けの個人 dotfiles。nix-darwin + home-manager で管理。

## 構成

| ツール | 管理方法 |
|--------|---------|
| パッケージ全般 | home-manager / nix-darwin |
| システム設定 | nix-darwin |
| Nix 自体 | Determinate Systems インストーラー |
| Homebrew 本体 | bootstrap.sh でインストール |

## セットアップ

新しい Mac では以下の1コマンドで完結する。

```bash
curl -fsSL https://raw.githubusercontent.com/yukotayuki/nix-dotfiles/main/bootstrap.sh | sh
```

実行順序：

1. Nix インストール（Determinate Systems）
2. Homebrew インストール
3. dotfiles clone（`~/dotfiles`）
4. `darwin-rebuild switch` で全適用

> SSH キーが登録済みであれば SSH で clone し、未登録の場合は HTTPS にフォールバックする。
> HTTPS で clone した場合は後から `git remote set-url origin git@github.com:yukotayuki/nix-dotfiles.git` で変更できる。

## セットアップ後の任意手順

以下は用途に応じて手動でインストールする。

### Claude Code（CLI）

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

> GUI アプリの Claude は darwin-switch で自動インストールされる。
> CLI の Claude Code のみ更新頻度が高いため管理対象外としている。

## 日常的な操作

設定変更後は以下のエイリアスで適用する。

```bash
darwin-switch   # sudo darwin-rebuild switch --flake "$DOTDIR#darwin@arm" の短縮形
```
