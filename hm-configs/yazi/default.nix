{ pkgs, ... }:
let
  # yazi 内の fzf は、シェルの FZF_DEFAULT_OPTS（高さ 40%）を引き継いだうえで全画面に揃える。
  # 標準の zoxide プラグイン（Z）が全画面で開くため、それに合わせる。
  fzfHeight = "--height=100%";
  # プレビューと ctrl-/ の切り替えは zsh の FZF_CTRL_T_OPTS / FZF_ALT_C_OPTS に揃える。
  fzfPreviewToggle = "--bind 'ctrl-/:change-preview-window(down|hidden|)'";

  # z の標準動作（yazi 同梱の fzf プラグイン）は fzf の高さを外から渡せないため、同じ動きのスクリプトに置き換える。
  # ディレクトリを選んだら移動し、ファイルを選んだらカーソルを合わせる。
  fzfJump = pkgs.writeShellApplication {
    name = "yazi-fzf-jump";
    runtimeInputs = with pkgs; [
      fd
      fzf
      bat
      tree
    ];
    text = ''
      sel=$(fd --hidden --exclude .git \
        | fzf ${fzfHeight} ${fzfPreviewToggle} \
          --preview '[ -d {} ] && tree -C {} | head -200 || bat -n --color=always {}') || exit 0
      if [ -d "$sel" ]; then
        ya emit cd "$PWD/$sel"
      else
        ya emit reveal "$PWD/$sel"
      fi
    '';
  };
  # s / S の標準動作（入力を確定してから yazi に結果を並べる）を、fzf でリアルタイムに絞り込みとプレビューを行う形に置き換える。
  # 選んだファイルは yazi でカーソルを合わせる。
  fzfFind = pkgs.writeShellApplication {
    name = "yazi-fzf-find";
    runtimeInputs = with pkgs; [
      fd
      fzf
      bat
    ];
    text = ''
      sel=$(fd --type f --hidden --exclude .git \
        | fzf ${fzfHeight} ${fzfPreviewToggle} \
          --preview 'bat -n --color=always {}') || exit 0
      ya emit reveal "$PWD/$sel"
    '';
  };
  # fzf の reload から呼ぶ rg。VS Code の全体検索に合わせ、既定は文字列として検索し、プロンプトが regex> のときだけ正規表現として扱う。
  # --smart-case だと検索語に大文字が 1 つでも入ると区別が有効になり、camelCase の一部（例: localV）で LocalVideoStream に当たらないため、常に大文字小文字を無視する。
  rgSearch = pkgs.writeShellApplication {
    name = "yazi-rg-search";
    runtimeInputs = [ pkgs.ripgrep ];
    text = ''
      query=''${1:-}
      [ -z "$query" ] && exit 0
      args=(--column --line-number --no-heading --color=always --ignore-case --hidden --glob '!.git')
      case "''${FZF_PROMPT:-}" in
        regex*) ;;
        *) args+=(--fixed-strings) ;;
      esac
      rg "''${args[@]}" -- "$query" || true
    '';
  };
  fzfGrep = pkgs.writeShellApplication {
    name = "yazi-fzf-grep";
    runtimeInputs = with pkgs; [
      rgSearch
      fzf
      bat
    ];
    # 入力のたびに rg を再実行する。空の入力で全ファイルを走査しないよう、起動直後は候補を空にする。
    # ctrl-r でプロンプトを text> / regex> と切り替え、同じ検索語で検索し直す。
    text = ''
      # $FZF_PROMPT は fzf が transform の実行時に展開するため、ここではシングルクォートのまま渡す。
      # shellcheck disable=SC2016
      sel=$(: | fzf ${fzfHeight} ${fzfPreviewToggle} --ansi --disabled \
        --prompt 'text> ' \
        --header 'ctrl-r: text / regex' \
        --bind 'change:reload:sleep 0.1; yazi-rg-search {q}' \
        --bind 'ctrl-r:transform:[ "$FZF_PROMPT" = "text> " ] && echo "change-prompt(regex> )+reload(yazi-rg-search {q})" || echo "change-prompt(text> )+reload(yazi-rg-search {q})"' \
        --delimiter : \
        --preview 'bat -n --color=always --highlight-line {2} {1}' \
        --preview-window '+{2}/2') || exit 0
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

    # UI の色は yazi 標準のまま端末の 16 色に任せる。Ghostty（theme = nord）でも nvim（nord.nvim）でも nord で表示され、
    # 端末側の配色を変えたときにも追従するため。star の多い nord の flavor が無いので flavor は使わない。
    # コードプレビューのシンタックスハイライトだけは 16 色に従わないため、Nord の公式 Sublime Text テーマの tmTheme を指定する。
    # 取得元は bat が Nord テーマとして submodule で固定しているリポジトリとコミットに揃える。
    theme.mgr.syntect_theme = "${
      pkgs.fetchFromGitHub {
        owner = "crabique";
        repo = "Nord-plist";
        rev = "bf92a9e4457dc2f97efebc59bbeac95933ec6515";
        hash = "sha256-7aGPOtfugFA/tjVyhO87ymHbbeKmzHRHtlV6nIenzw8=";
      }
    }/Nord.tmTheme";

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
          on = "z";
          run = "shell --block -- ${fzfJump}/bin/yazi-fzf-jump";
          desc = "Jump to a file/directory via fd + fzf";
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
          # fzf を Esc で閉じたときも終了コード 0 で終わるよう if で包む（0 以外だと yazi のタスク一覧に Failed が残る）。
          run = ''shell --block -- if sel="$(ghq list | fzf ${fzfHeight})"; then ya emit cd "$(ghq root)/$sel"; fi'';
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
          # && で書くと単体起動時に終了コード 1 になり、yazi のタスク一覧に Failed が残るため || で書く。
          run = ''shell -- [ -z "$NVIM" ] || ya emit quit'';
          desc = "Close yazi.nvim (same key as ,f in nvim)";
        }
      ];
    };
  };
}
