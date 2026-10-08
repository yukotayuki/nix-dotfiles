# nix-dotfiles

Apple Silicon Mac・Ubuntu・NixOS 向けの個人 dotfiles。Nix（nix-darwin・NixOS・home-manager）で管理する。

## マシン

| マシン | ホスト名 | 構成 |
|------|------|------|
| Apple Silicon Mac 1台目 | kinako | nix-darwin + home-manager |
| Apple Silicon Mac 2台目 | mochi | home-manager + brew bundle |
| Ubuntu x86_64 | canele | home-manager |
| NixOS x86_64（laptop / VM） | uiro | NixOS + home-manager |

## 管理方針

| 対象 | 管理方法 |
|--------|---------|
| パッケージ全般 | home-manager / nix-darwin |
| システム設定 | nix-darwin（kinako） / NixOS（uiro） |
| GUI アプリ（mochi） | Brewfile（`brew bundle`） |
| Nix 自体 | Determinate Systems インストーラー |
| Homebrew 本体 | 手動インストール（macOS のみ） |

## セットアップ

### kinako（Apple Silicon Mac, nix-darwin）

```bash
# 1. Nix インストール（Determinate Systems）
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# 2. Homebrew インストール
# nix-darwin の homebrew モジュールは、Homebrew がすでに入っていることを前提とする
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

1. [NixOS ISO](https://nixos.org/download/) をダウンロードし、VM（または実機）にマウントして起動する
2. ディスクのパーティションを作成し、`/mnt` 以下にマウントする
3. ハードウェア設定を生成する

   ```bash
   nixos-generate-config --root /mnt
   ```

4. インストールする（最小構成のままでよい）

   ```bash
   nixos-install
   ```

5. 再起動し、インストールしたシステムに入る

#### 2. dotfiles 適用

初回起動後、次のコマンドで dotfiles を適用する。この時点では flakes が有効になっていないため、`--extra-experimental-features` で有効にする。

```bash
nix --extra-experimental-features "nix-command flakes" \
  run github:yukotayuki/nix-dotfiles#setup-uiro
```

setup-uiro は、dotfiles を `~/dotfiles` に clone してから `sudo nixos-rebuild switch --impure --flake ~/dotfiles#uiro` を実行する。uiro の構成は `/etc/nixos/hardware-configuration.nix` を読むため、`--impure` が要る。

> どのマシンの setup も、`~/dotfiles` がなければ SSH で clone し、SSH で clone できなければ HTTPS で clone する。
> HTTPS で clone した場合は、あとから `git remote set-url origin git@github.com:yukotayuki/nix-dotfiles.git` で SSH に切り替えられる。

## セットアップ後の任意手順

### Claude Code（CLI）

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

> GUI アプリの Claude は、kinako では `darwin-switch`、mochi では `brew bundle` で入る。
> CLI の Claude Code は更新頻度が高いため、Nix では管理しない。

## 日常的な操作

設定を変えたあとは、次のコマンドで適用する。`darwin-switch` と `hm-switch` は、zsh の関数として定義した短縮形である。

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
