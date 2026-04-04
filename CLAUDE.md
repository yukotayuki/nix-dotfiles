# nix-dotfiles

## 環境

| マシン | ホスト名 | 構成 | flake ターゲット |
|--------|---------|------|----------------|
| Apple Silicon Mac 1台目 | kinako | nix-darwin + home-manager | `darwinConfigurations.kinako` |
| Apple Silicon Mac 2台目 | mochi | home-manager + brew bundle | `homeConfigurations.mochi` |
| Ubuntu x86_64 (Linux) | canele | home-manager | `homeConfigurations.canele` |

- dotfiles の配置場所: `~/dotfiles`

## 管理方針

### nix で管理するもの
- パッケージ全般（home-manager / nix-darwin）
- Homebrew 自体のパッケージ管理（nix-darwin の homebrew モジュール経由、kinako のみ）
- システム設定（nix-darwin、kinako のみ）

### nix の外で管理するもの（意図的）
| ツール | 方法 | 理由 |
|--------|------|------|
| Nix 自体 | Determinate Systems インストーラー | bootstrap の起点なので仕方ない |
| Homebrew 本体 | 手動インストール（macOS のみ） | nix-darwin は Homebrew がすでに入っていることを前提とするため |
| Claude Code | curl インストール（手動） | 更新頻度が高く nix 管理のコストが見合わない |
| gcloud | Homebrew 経由 | nixpkgs の更新が追いつかないため |
| GUI アプリ（mochi） | Brewfile（`brew bundle`） | home-manager のみ構成のため darwin homebrew モジュールが使えない |

### Homebrew の cleanup 設定
`homebrew.onActivation.cleanup = "uninstall"` に設定済み（kinako のみ）。
宣言から外したパッケージは次回 `darwin-switch` 時に自動削除される。
`"zap"` にすると宣言にない既存パッケージが全部消えるので注意。

## セットアップ

### 初回セットアップ（`nix run` で一発適用）

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
```

各 setup app の内容：
- `setup-kinako`: dotfiles clone → `nix run nix-darwin -- switch --flake .#kinako`
- `setup-mochi`: dotfiles clone → `home-manager switch` → `brew bundle`
- `setup-canele`: dotfiles clone → `home-manager switch`

## 日常的な操作（設定変更後の適用）

```bash
# kinako（nix-darwin）
darwin-switch      # sudo darwin-rebuild switch --flake "$DOTDIR#kinako" の短縮形

# mochi（home-manager のみ）
hm-switch          # home-manager switch --flake "$DOTDIR#mochi" の短縮形

# canele（Ubuntu）
nix run home-manager -- switch --flake "$DOTDIR#canele"
```

nix ファイル（`*.nix`, `flake.nix`, `flake.lock`）を変更した場合、PR 作成前に必ず対象マシンで switch して動作確認する。

## 参考リンク
- Nix インストーラー: https://github.com/DeterminateSystems/nix-installer
- Homebrew インストーラー: https://github.com/Homebrew/install
- nix-darwin homebrew モジュール（Homebrew を前提とする旨の記述あり）: https://nix-darwin.github.io/nix-darwin/manual/
