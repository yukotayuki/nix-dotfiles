# nix-dotfiles

Apple Silicon Mac および Ubuntu (Linux) 向けの個人 dotfiles。nix-darwin + home-manager で管理。

## 構成

| ツール | 管理方法 |
|--------|---------|
| パッケージ全般 | home-manager / nix-darwin |
| システム設定 | nix-darwin（macOS のみ） |
| Nix 自体 | Determinate Systems インストーラー |
| Homebrew 本体 | bootstrap.sh でインストール（macOS のみ） |

## セットアップ

新しいマシンでは以下の1コマンドで完結する。macOS / Ubuntu どちらでも同じコマンドで動作する。

```bash
curl -fsSL https://raw.githubusercontent.com/yukotayuki/nix-dotfiles/main/bootstrap.sh | sh
```

### macOS (Apple Silicon)

実行順序：

1. Nix インストール（Determinate Systems）
2. Homebrew インストール
3. dotfiles clone（`~/dotfiles`）
4. `darwin-rebuild switch` で全適用

### Ubuntu (Linux, x86_64)

実行順序：

1. Nix インストール（Determinate Systems）
2. dotfiles clone（`~/dotfiles`）
3. `home-manager switch` で全適用

> SSH キーが登録済みであれば SSH で clone し、未登録の場合は HTTPS にフォールバックする。
> HTTPS で clone した場合は後から `git remote set-url origin git@github.com:yukotayuki/nix-dotfiles.git` で変更できる。

## セットアップ後の任意手順

以下は用途に応じて手動でインストールする。

### Claude Code（CLI）

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

> GUI アプリの Claude は darwin-switch で自動インストールされる（macOS のみ）。
> CLI の Claude Code は更新頻度が高いため管理対象外としている。

## 日常的な操作

設定変更後は以下のエイリアスで適用する。

```bash
# macOS
darwin-switch   # sudo darwin-rebuild switch --flake "$DOTDIR#darwin@arm" の短縮形

# Ubuntu
nix run home-manager -- switch --flake "$DOTDIR#hm-ubuntu"
```
