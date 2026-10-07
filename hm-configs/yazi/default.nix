{ pkgs, ... }:
let
  # s / S の標準動作（入力を確定してから yazi に結果を並べる）を、fzf でリアルタイムに絞り込みとプレビューを行う形に置き換える。
  # プレビューと ctrl-/ の切り替えは zsh の FZF_CTRL_T_OPTS に揃える。選んだファイルは yazi でカーソルを合わせる。
  fzfFind = pkgs.writeShellApplication {
    name = "yazi-fzf-find";
    runtimeInputs = with pkgs; [
      fd
      fzf
      bat
    ];
    text = ''
      sel=$(fd --type f --hidden --exclude .git \
        | fzf --preview 'bat -n --color=always {}' \
          --bind 'ctrl-/:change-preview-window(down|hidden|)') || exit 0
      ya emit reveal "$PWD/$sel"
    '';
  };
  fzfGrep = pkgs.writeShellApplication {
    name = "yazi-fzf-grep";
    runtimeInputs = with pkgs; [
      ripgrep
      fzf
      bat
    ];
    # 入力のたびに rg を再実行する。空の入力で全ファイルを走査しないよう、起動直後は候補を空にする。
    text = ''
      rg_cmd="rg --column --line-number --no-heading --color=always --smart-case --hidden --glob '!.git'"
      sel=$(: | fzf --ansi --disabled \
        --bind "change:reload:sleep 0.1; $rg_cmd {q} || true" \
        --delimiter : \
        --preview 'bat -n --color=always --highlight-line {2} {1}' \
        --preview-window '+{2}/2' \
        --bind 'ctrl-/:change-preview-window(down|hidden|)') || exit 0
      ya emit reveal "$PWD/''${sel%%:*}"
    '';
  };
in
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    # q で終了したときだけ cwd を移す。Q で終了した場合は移動しない（yazi 標準の動作）。
    shellWrapperName = "y";
    # nixpkgs の yazi ラッパーは poppler / ffmpeg / imagemagick / jq / fd / rg / fzf / zoxide を同梱しているため、
    # ここでは ouch.yazi が呼ぶ ouch 本体だけを足す。
    extraPackages = [ pkgs.ouch ];

    plugins = {
      inherit (pkgs.yaziPlugins)
        git
        smart-enter
        full-border
        ouch
        ;
    };

    initLua = ''
      require("git"):setup()
      require("full-border"):setup()
    '';

    settings = {
      plugin = {
        prepend_fetchers = [
          {
            url = "*";
            run = "git";
            group = "git";
          }
          {
            url = "*/";
            run = "git";
            group = "git";
          }
        ];
        prepend_previewers = [
          {
            mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
            run = "ouch";
          }
        ];
      };
      opener.extract = [
        {
          run = "ouch d -y %s";
          desc = "Extract here with ouch";
        }
      ];
    };

    keymap = {
      mgr.prepend_keymap = [
        {
          on = "l";
          run = "plugin smart-enter";
          desc = "Enter the child directory, or open the file";
        }
        {
          on = "s";
          run = "shell --block -- ${fzfFind}/bin/yazi-fzf-find";
          desc = "Search files by name via fd + fzf";
        }
        {
          on = "S";
          run = "shell --block -- ${fzfGrep}/bin/yazi-fzf-grep";
          desc = "Search files by content via ripgrep + fzf";
        }
        {
          on = [
            "g"
            "r"
          ];
          # zsh の fzf-cd-git-repository と同じく、fzf には相対パスを表示して cd 先で ghq root を付ける。
          run = ''shell --block -- sel="$(ghq list | fzf)" && ya emit cd "$(ghq root)/$sel"'';
          desc = "Jump to a ghq repository via fzf";
        }
        {
          on = [
            "g"
            "i"
          ];
          run = "shell --block -- lazygit";
          desc = "Open lazygit";
        }
        {
          on = [
            ","
            "f"
          ];
          # nvim の ,f（yazi.nvim）で開いた yazi を同じキーで閉じる。
          # nvim の子プロセスにだけ設定される $NVIM で判定し、単体起動の yazi では何もしない。
          run = ''shell -- [ -n "$NVIM" ] && ya emit quit'';
          desc = "Close yazi.nvim (same key as ,f in nvim)";
        }
      ];
    };
  };
}
