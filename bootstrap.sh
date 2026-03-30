#!/usr/bin/env bash
# ==============================================================================
# bootstrap.sh — nix-dotfiles セットアップスクリプト
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/yukotayuki/nix-dotfiles/main/bootstrap.sh \
#     | sh -s -- <target>
#
# Targets:
#   darwin@arm      Apple Silicon Mac（nix-darwin + home-manager）
#   hm-darwin@arm   Apple Silicon Mac（home-manager のみ + brew bundle）
#   hm-ubuntu       Ubuntu x86_64（home-manager のみ）
# ==============================================================================
set -euo pipefail

# ------------------------------------------------------------------------------
# 設定（変更が必要な場合はここだけ触る）
# ------------------------------------------------------------------------------
GITHUB_REPO="yukotayuki/nix-dotfiles"
DOTFILES_DIR="$HOME/dotfiles"

# ------------------------------------------------------------------------------
# ヘルパー
# ------------------------------------------------------------------------------
info() { echo "$(tput bold)$(tput setaf 4)➜$(tput sgr0)  $*"; }
success() { echo "$(tput bold)$(tput setaf 2)✓$(tput sgr0)  $*"; }
warn() { echo "$(tput bold)$(tput setaf 3)!$(tput sgr0)  $*"; }
die() {
  echo "$(tput bold)$(tput setaf 1)✗$(tput sgr0)  $*" >&2
  exit 1
}

# ------------------------------------------------------------------------------
# ターゲット指定（必須）
# ------------------------------------------------------------------------------
TARGET="${1:-}"
if [ -z "$TARGET" ]; then
  die "ターゲットを指定してください。
Usage: bootstrap.sh <target>
Targets:
  darwin@arm      Apple Silicon Mac（nix-darwin + home-manager）
  hm-darwin@arm   Apple Silicon Mac（home-manager のみ + brew bundle）
  hm-ubuntu       Ubuntu x86_64（home-manager のみ）"
fi

case "$TARGET" in
  darwin@arm)
    IS_DARWIN=true
    USE_DARWIN_REBUILD=true
    USE_BREW_BUNDLE=false
    ;;
  hm-darwin@arm)
    IS_DARWIN=true
    USE_DARWIN_REBUILD=false
    USE_BREW_BUNDLE=true
    ;;
  hm-ubuntu)
    IS_DARWIN=false
    USE_DARWIN_REBUILD=false
    USE_BREW_BUNDLE=false
    ;;
  *)
    die "未知のターゲットです: $TARGET
Targets: darwin@arm | hm-darwin@arm | hm-ubuntu"
    ;;
esac

# ------------------------------------------------------------------------------
# Step 1: Nix インストール（Determinate Systems）
# ------------------------------------------------------------------------------
if command -v nix &>/dev/null; then
  success "Nix は既にインストール済みです ($(nix --version))"
else
  info "Nix をインストールします（Determinate Systems インストーラー）..."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix \
    | sh -s -- install --no-confirm

  # 現在のシェルセッションで nix を使えるようにする
  if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    # shellcheck disable=SC1091
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  else
    die "Nix インストール後、nix-daemon.sh が見つかりません。シェルを再起動してから再実行してください"
  fi
  success "Nix インストール完了"
fi

# ------------------------------------------------------------------------------
# Step 2: Homebrew インストール（macOS のみ）
# nix-darwin の homebrew モジュールは Homebrew が既に入っていることを前提とする
# https://nix-darwin.github.io/nix-darwin/manual/ (homebrew.enable の説明参照)
# Linux では Homebrew は不要のためスキップする。
# ------------------------------------------------------------------------------
if $IS_DARWIN; then
  if command -v brew &>/dev/null; then
    success "Homebrew は既にインストール済みです ($(brew --version | head -1))"
  else
    info "Homebrew をインストールします..."
    /bin/bash -c "$(curl --proto '=https' --tlsv1.2 -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Apple Silicon の場合、brew を PATH に通す
    if [ -f /opt/homebrew/bin/brew ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    success "Homebrew インストール完了"
  fi
fi

# ------------------------------------------------------------------------------
# Step 3: dotfiles clone
# ------------------------------------------------------------------------------
if [ -d "$DOTFILES_DIR/.git" ]; then
  success "dotfiles は既にクローン済みです ($DOTFILES_DIR)"
  info "最新の変更を pull します..."
  git -C "$DOTFILES_DIR" pull --ff-only || warn "pull に失敗しました（ローカルに変更がある可能性）。スキップします"
else
  info "dotfiles をクローンします..."
  clone_repo() {
    local git_cmd="$1"
    info "SSH でクローンを試みます..."
    if $git_cmd clone "git@github.com:$GITHUB_REPO.git" "$DOTFILES_DIR" 2>/dev/null; then
      return 0
    fi
    warn "SSH に失敗しました。HTTPS にフォールバックします..."
    $git_cmd clone "https://github.com/$GITHUB_REPO" "$DOTFILES_DIR"
  }

  if command -v git &>/dev/null; then
    clone_repo git
  else
    nix shell nixpkgs#git --command bash -c "
      git clone 'git@github.com:$GITHUB_REPO.git' '$DOTFILES_DIR' 2>/dev/null \
        || git clone 'https://github.com/$GITHUB_REPO' '$DOTFILES_DIR'
    "
  fi
  success "dotfiles クローン完了 → $DOTFILES_DIR"
fi

# ------------------------------------------------------------------------------
# Step 4: 設定を適用
# darwin@arm:    nix-darwin switch
# hm-darwin@arm: home-manager switch
# hm-ubuntu:     home-manager switch
# ------------------------------------------------------------------------------
cd "$DOTFILES_DIR"

if $USE_DARWIN_REBUILD; then
  info "nix-darwin を適用します（初回は時間がかかります）..."
  nix run nix-darwin -- switch --flake ".#${TARGET}"
else
  info "home-manager を適用します（初回は時間がかかります）..."
  # standalone home-manager では home.backupFileExtension が使えないため、
  # -b オプションで既存ファイルを .bak へ退避する
  nix run home-manager -- switch --flake ".#${TARGET}" -b bak
fi

# ------------------------------------------------------------------------------
# Step 5: Brewfile 適用（hm-darwin@arm のみ）
# ------------------------------------------------------------------------------
if $USE_BREW_BUNDLE; then
  info "Brewfile を適用します..."
  brew bundle --file "$DOTFILES_DIR/Brewfile"
  success "Brewfile 適用完了"
fi

# ------------------------------------------------------------------------------
# 完了
# ------------------------------------------------------------------------------
echo ""
success "セットアップ完了！"
warn "シェルを再起動してください: exec \$SHELL"
