# --------------
# 補完関連の設定
# --------------

## 補完候補を一覧表示
setopt auto_list

## Tabで補完候補の移動
setopt auto_menu

## 補完候補を詰めて表示
setopt list_packed

## 補完候補のファイル種別を表示
setopt list_types

## オプションの = 以降も補完
setopt magic_equal_subst

## cdの省略
setopt auto_cd

## dotfilesにリポジトリ名で移動
## → cdの補完にも表示されるの無効
# cdpath=(.. ~ $DOTDIR)

## cdの履歴を自動でpush
setopt auto_pushd


# --------------
# cdr関連の設定
# --------------
setopt AUTO_PUSHD # cdしたら自動でディレクトリスタックする
setopt pushd_ignore_dups # 同じディレクトリは追加しない


# --------------
# 履歴関連の設定
# --------------

# 実行時間も保存
setopt extended_history

# 同時に起動したzshの間でヒストリを共有
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリを呼び出してから実行する間に一旦編集できる
setopt hist_verify

#余分なスペースを削除してヒストリに記録
setopt hist_reduce_blanks

# histryコマンドは残さない
setopt hist_save_no_dups

# 古い履歴を削除する必要がある場合、重複しているものから削除
setopt hist_expire_dups_first

# 補完時にヒストリを自動的に展開
setopt hist_expand

# 履歴をインクリメンタルに追加
setopt inc_append_history


# --------------
# それ以外の設定
# --------------

# スペルチェック
# setopt correct

# ビープ音を無効
setopt no_beep
setopt no_hist_beep
setopt no_list_beep

setopt prompt_subst
