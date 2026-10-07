# nix-dotfiles

Apple Silicon Mac・Ubuntu・NixOS 向けの個人 dotfiles。nix-darwin + home-manager で管理。

## 端末

| 端末 | 名前 | 構成 |
|------|------|------|
| Apple Silicon Mac 1台目 | kinako | nix-darwin + home-manager |
| Apple Silicon Mac 2台目 | mochi | home-manager + brew bundle |
| Ubuntu x86_64 | canele | home-manager |
| NixOS x86_64（laptop / VM） | uiro | nixos + home-manager |

## 管理方針

| ツール | 管理方法 |
|--------|---------|
| パッケージ全般 | home-manager / nix-darwin |
| システム設定 | nix-darwin（kinako のみ） / NixOS configuration（uiro） |
| GUI アプリ（mochi） | Brewfile（`brew bundle`） |
| Nix 自体 | Determinate Systems インストーラー |
| Homebrew 本体 | 手動インストール（macOS のみ） |

## セットアップ

### kinako（Apple Silicon Mac, nix-darwin）

```bash
# 1. Nix インストール（Determinate Systems）
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# 2. Homebrew インストール
# nix-darwin の homebrew モジュールは Homebrew が既に入っていることを前提とする
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 3. dotfiles 適用
nix run github:yukotayuki/nix-dotfiles#setup-kinako
```

### mochi（Apple Silicon Mac, home-manager のみ）

```bash
# 1. Nix インストール（同上）

# 2. Homebrew インストール（同上）

# 3. dotfiles 適用（home-manager switch + brew bundle）
nix run github:yukotayuki/nix-dotfiles#setup-mochi
```

### canele（Ubuntu x86_64）

```bash
# 1. Nix インストール（同上）

# 2. dotfiles 適用
nix run github:yukotayuki/nix-dotfiles#setup-canele
```

### uiro（NixOS x86_64、VM を含む）

#### 1. NixOS インストール

1. [NixOS ISO](https://nixos.org/download/) をダウンロードして VM（または実機）にマウントし起動
2. ディスクのパーティション作成・マウント（`/mnt` 以下）
3. ハードウェア設定を生成

   ```bash
   nixos-generate-config --root /mnt
   ```

4. インストール実行（最小構成のまま OK）

   ```bash
   nixos-install
   ```

5. 再起動し、インストール済みシステムに入る

#### 2. dotfiles 適用

初回起動後、以下のワンライナーで dotfiles を適用する。  
flakes がまだ有効でないため `--extra-experimental-features` を明示する。

```bash
nix --extra-experimental-features "nix-command flakes" \
  run github:yukotayuki/nix-dotfiles#setup-uiro
```

setup-uiro の内容：
- dotfiles を `~/dotfiles` に clone
- `sudo nixos-rebuild switch --flake ~/dotfiles#uiro`

> SSH キーが登録済みであれば SSH で clone し、未登録の場合は HTTPS にフォールバックする。
> HTTPS で clone した場合は後から `git remote set-url origin git@github.com:yukotayuki/nix-dotfiles.git` で変更できる。

## セットアップ後の任意手順

### Claude Code（CLI）

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

> GUI アプリの Claude は darwin-switch（kinako）で自動インストールされる。
> CLI の Claude Code は更新頻度が高いため管理対象外としている。

## 日常的な操作

設定変更後は以下のエイリアスで適用する。

```bash
# kinako（nix-darwin）
darwin-switch      # sudo darwin-rebuild switch --flake "$DOTDIR#kinako" の短縮形

# mochi（home-manager のみ）
hm-switch          # home-manager switch --flake "$DOTDIR#mochi" の短縮形

# canele（Ubuntu）
nix run home-manager -- switch --flake "$DOTDIR#canele"

# uiro（NixOS）
sudo nixos-rebuild switch --flake "$DOTDIR#uiro"
```
