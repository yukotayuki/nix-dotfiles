# nix-dotfiles

## 環境

| マシン | ホスト名 | 構成 | flake ターゲット |
|--------|---------|------|----------------|
| Apple Silicon Mac 1台目 | kinako | nix-darwin + home-manager | `darwinConfigurations.kinako` |
| Apple Silicon Mac 2台目 | mochi | home-manager + brew bundle | `homeConfigurations.mochi` |
| Ubuntu x86_64 | canele | home-manager | `homeConfigurations.canele` |
| NixOS x86_64（laptop / VM） | uiro | NixOS + home-manager | `nixosConfigurations.uiro` |

- dotfiles の配置場所: `~/dotfiles`

## 管理方針

### Nix で管理するもの
- パッケージ全般（home-manager / nix-darwin）
- Homebrew で入れるパッケージの宣言（nix-darwin の homebrew モジュール経由、kinako のみ）
- システム設定（kinako は nix-darwin、uiro は NixOS）

### Nix の外で管理するもの（意図的）
| ツール | 方法 | 理由 |
|--------|------|------|
| Nix 自体 | Determinate Systems インストーラー | Nix を入れる最初の手順で、Nix 自身では管理できないため |
| Homebrew 本体 | 手動インストール（macOS のみ） | nix-darwin は Homebrew がすでに入っていることを前提とするため |
| Claude Code | curl インストール（手動） | 更新頻度が高く、Nix で管理する手間に見合わないため |
| gcloud | Brewfile（`brew bundle`、mochi のみ） | nixpkgs の更新が追いつかないため |
| mcp-toolbox | Brewfile（`brew bundle`、mochi のみ） | nixpkgs 未収録のため |
| GUI アプリ（mochi） | Brewfile（`brew bundle`） | home-manager だけの構成で、nix-darwin の homebrew モジュールを使えないため |

### Homebrew の cleanup 設定
`homebrew.onActivation.cleanup = "zap"` に設定済み（kinako のみ）。
宣言にないパッケージは、次の `darwin-switch` で自動的に削除される。
cask は `zap` により設定やキャッシュなどの関連データごと消えるので、手動で `brew install` したものは必ず宣言に追加する。

## セットアップ

### 初回セットアップ（`nix run` で適用）

```bash
# kinako（Apple Silicon Mac, nix-darwin）
# 事前に Nix と Homebrew を手動インストールしてから実行
nix run github:yukotayuki/nix-dotfiles#setup-kinako

# mochi（Apple Silicon Mac, home-manager のみ）
# 事前に Nix と Homebrew を手動インストールしてから実行
nix run github:yukotayuki/nix-dotfiles#setup-mochi

# canele（Ubuntu x86_64）
# 事前に Nix を手動インストールしてから実行
nix run github:yukotayuki/nix-dotfiles#setup-canele

# uiro（NixOS x86_64）
# NixOS のインストール後、flakes がまだ有効でないため experimental-features を明示して実行
nix --extra-experimental-features "nix-command flakes" run github:yukotayuki/nix-dotfiles#setup-uiro
```

各 setup（flake の app）の内容：
- `setup-kinako`: dotfiles clone → `nix run nix-darwin -- switch --flake .#kinako`
- `setup-mochi`: dotfiles clone → `home-manager switch` → `brew bundle`
- `setup-canele`: dotfiles clone → `home-manager switch`
- `setup-uiro`: dotfiles clone → `sudo nixos-rebuild switch --impure --flake .#uiro`（`/etc/nixos/hardware-configuration.nix` を読むため `--impure` が要る）

## 日常的な操作（設定変更後の適用）

```bash
# kinako（nix-darwin）
darwin-switch      # sudo darwin-rebuild switch --flake "$DOTDIR#kinako" の短縮形

# mochi（home-manager のみ）
hm-switch          # home-manager switch --flake "$DOTDIR#mochi" の短縮形

# canele（Ubuntu）
nix run home-manager -- switch --flake "$DOTDIR#canele"

# uiro（NixOS）
sudo nixos-rebuild switch --impure --flake "$DOTDIR#uiro"
```

Nix のファイル（`*.nix`、`flake.nix`、`flake.lock`）を変更した場合は、PR を作る前に必ず対象マシンで switch して動作を確認する。

## 参考リンク
- Nix インストーラー: https://github.com/DeterminateSystems/nix-installer
- Homebrew インストーラー: https://github.com/Homebrew/install
- nix-darwin homebrew モジュール（Homebrew を前提とする旨の記述あり）: https://nix-darwin.github.io/nix-darwin/manual/
