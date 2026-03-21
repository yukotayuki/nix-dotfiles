# nix-dotfiles

## 環境
- マシン: Apple Silicon Mac (aarch64-darwin)
- flake の darwin ターゲット: `darwin@arm`
- dotfiles の配置場所: `~/dotfiles`

## 管理方針

### nix で管理するもの
- パッケージ全般（home-manager / nix-darwin）
- Homebrew 自体のパッケージ管理（nix-darwin の homebrew モジュール経由）
- システム設定（nix-darwin）

### nix の外で管理するもの（意図的）
| ツール | 方法 | 理由 |
|--------|------|------|
| Nix 自体 | Determinate Systems インストーラー | bootstrap の起点なので仕方ない |
| Homebrew 本体 | bootstrap.sh でインストール | nix-darwin は Homebrew がすでに入っていることを前提とするため |
| Claude Code | curl インストール（手動） | 更新頻度が高く nix 管理のコストが見合わない |
| gcloud | Homebrew 経由 | nixpkgs の更新が追いつかないため |

### Homebrew の cleanup 設定
`homebrew.onActivation.cleanup` は最初は `"none"` のままにしておく。
`"zap"` にすると宣言にない既存パッケージが全部消えるので注意。

## bootstrap.sh
リポジトリルートに置いてある。新しい Mac へのセットアップはこの1行で完結する予定：

```bash
curl -fsSL https://raw.githubusercontent.com/yukotayuki/nix-dotfiles/main/bootstrap.sh | sh
```

実行順序：
1. Nix インストール（Determinate Systems）
2. Homebrew インストール
3. dotfiles clone（`~/dotfiles` へ）
4. `darwin-rebuild switch` で全適用

どこから実行しても動く（カレントディレクトリに依存しない）。

## 改善したいこと
- [ ] パッケージの追加・整理
- [ ] home-manager の設定改善
- [ ] nix-darwin のシステム設定
- [ ] flake.nix の構造改善
- [ ] vim / tmux / zsh 設定のリファクタリング

## 参考リンク
- Nix インストーラー: https://github.com/DeterminateSystems/nix-installer
- Homebrew インストーラー: https://github.com/Homebrew/install
- nix-darwin homebrew モジュール（Homebrew を前提とする旨の記述あり）: https://nix-darwin.github.io/nix-darwin/manual/
