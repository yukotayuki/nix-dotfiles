# nix-dotfiles

Apple Silicon Mac および Ubuntu (Linux) 向けの個人 dotfiles。nix-darwin + home-manager で管理。

## 構成

| ツール | 管理方法 |
|--------|---------|
| パッケージ全般 | home-manager / nix-darwin |
| システム設定 | nix-darwin（1台目 Mac のみ） |
| GUI アプリ（2台目 Mac） | Brewfile（`brew bundle`） |
| Nix 自体 | Determinate Systems インストーラー |
| Homebrew 本体 | bootstrap.sh でインストール（macOS のみ） |

## セットアップ

ターゲットを引数で指定して実行する。

```bash
# 1台目 Mac（nix-darwin + home-manager）
curl -fsSL https://raw.githubusercontent.com/yukotayuki/nix-dotfiles/main/bootstrap.sh | sh -s -- darwin@arm

# 2台目 Mac（home-manager のみ + brew bundle）
curl -fsSL https://raw.githubusercontent.com/yukotayuki/nix-dotfiles/main/bootstrap.sh | sh -s -- hm-darwin@arm

# Ubuntu (x86_64)
curl -fsSL https://raw.githubusercontent.com/yukotayuki/nix-dotfiles/main/bootstrap.sh | sh -s -- hm-ubuntu
```

### darwin@arm（1台目 Mac）

1. Nix インストール（Determinate Systems）
2. Homebrew インストール
3. dotfiles clone（`~/dotfiles`）
4. `darwin-rebuild switch` で全適用

### hm-darwin@arm（2台目 Mac）

1. Nix インストール（Determinate Systems）
2. Homebrew インストール
3. dotfiles clone（`~/dotfiles`）
4. `home-manager switch` で全適用
5. `brew bundle` で GUI アプリを適用（`Brewfile`）

### hm-ubuntu（Ubuntu）

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

> GUI アプリの Claude は Brewfile（2台目 Mac）または darwin-switch（1台目 Mac）で自動インストールされる。
> CLI の Claude Code は更新頻度が高いため管理対象外としている。

## 日常的な操作

設定変更後は以下のエイリアスで適用する。

```bash
# 1台目 Mac（nix-darwin）
darwin-switch      # sudo darwin-rebuild switch --flake "$DOTDIR#darwin@arm" の短縮形

# 2台目 Mac（home-manager のみ）
hm-darwin-switch   # home-manager switch --flake "$DOTDIR#hm-darwin@arm" の短縮形

# Ubuntu
nix run home-manager -- switch --flake "$DOTDIR#hm-ubuntu"
```
