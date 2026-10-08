{ pkgs, ... }:
let
  nord2 = "#434C5E";

  # シェルの FZF_DEFAULT_OPTS（高さ 40%）を上書きし、全画面で開く標準の zoxide プラグイン（Z）に揃える。
  fzfHeight = "--height=100%";
  # プレビューと ctrl-/ の切り替えは zsh の FZF_CTRL_T_OPTS / FZF_ALT_C_OPTS に揃える。
  fzfPreviewToggle = "--bind 'ctrl-/:change-preview-window(down|hidden|)'";

  # z の標準動作（yazi 同梱の fzf プラグイン）は fzf の高さを外から渡せないため、同じ動きのスクリプトに置き換える。
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
  # fzf の reload から呼ぶ。VS Code の全体検索に合わせ、プロンプトが regex> のとき以外は固定文字列で検索する。
  # --smart-case だと localV のような camelCase の一部で LocalVideoStream に当たらないため、常に大文字小文字を無視する。
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
    # 空の入力で全ファイルを走査しないよう、起動直後は候補を空にする。
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
    # ここでは ouch.yazi が呼ぶ ouch 本体と、I で Markdown を整形して開く glow だけを足す。
    extraPackages = with pkgs; [
      ouch
      glow
    ];

    plugins = {
      inherit (pkgs.yaziPlugins)
        git
        smart-enter
        full-border
        ouch
        vcs-files
        githead
        diff
        ;
    };

    # UI の色は基本的に端末の 16 色に任せ、端末側の配色（Ghostty と nvim は nord）に追従させる。
    # star の多い nord の flavor が無いので flavor は使わない。
    theme =
      let
        # white は yazi では明るい白の 15 番（Ghostty の nord では #eceff4）。
        # 背景は 16 色だと black（#3b4252）では暗く 8 番（#596377）では明るすぎるため、nord2 を直接指定する。
        band = {
          fg = "white";
          bg = nord2;
        };
      in
      {
        mgr = {
          # 親の列が無いので、カレントディレクトリをヘッダーの帯で目立たせる。
          cwd = band // {
            bold = true;
          };
          # コードプレビューは bat（hm-configs/utils/display_filter.nix の theme = gruvbox-dark）に揃える。
          # rev は bat が submodule で固定しているコミットと同じにする。
          syntect_theme = "${
            pkgs.fetchFromGitHub {
              owner = "subnut";
              repo = "gruvbox-tmTheme";
              rev = "40503472826e51d87666e548a0634c4f1d74938c";
              hash = "sha256-Jip1Hd0sRhhPnO+xnA4buVd9Zu93Tr9OBJrsITG6ayQ=";
            }
          }/gruvbox-dark.tmTheme";
        };
        # ステータスバーのサイズ（左下）とパーセント（右下）は mode の alt で描かれる。
        # モードの区別は main の色で付くので、alt は 3 モードとも同じにする。
        mode = {
          normal_alt = band;
          select_alt = band;
          unset_alt = band;
        };
      };

    initLua = ''
      require("git"):setup()
      require("full-border"):setup()
      -- ヘッダーのパスの帯の右（order 2000）に、git のブランチと変更状況を出す。
      require("githead"):setup()

      -- 親の列を消した 2 列表示（ratio[1] == 0）のまま、境界線のドラッグで一覧とプレビューの幅を変えられるようにする。
      -- 標準の Rail:drag は親の列の幅を最低 1 にするため、ドラッグすると 3 列になって表示が崩れる。
      local rail_drag = Rail.drag
      function Rail:drag(event)
        if rt.mgr.ratio[1] ~= 0 or event.type ~= "legacy" then
          return rail_drag(self, event)
        end
        -- 一覧の左端の線（rail-left）は、2 列表示では動かさない。
        if self._id ~= "rail-right" then
          return
        end
        local c = self._chunks
        local x = math.max(event.x, c[2].x + 2)
        local preview = math.max(1, c[3].right - x)
        local current = math.max(1, c[2].w + c[3].w - preview)
        local r = rt.mgr.ratio
        if r[2] ~= current or r[3] ~= preview then
          rt.mgr.ratio = { 0, current, preview }
          ui.render()
        end
      end

      -- どのマシンの yazi かを見分けるため、ヘッダーの左に user@host を出す。
      -- 続く標準の cwd（order 1000）も帯でつなぐ。帯の色は theme の mgr.cwd で指定する。
      Header:children_add(function()
        local main, sep = th.mode.normal_main, th.status.sep_left
        return ui.Line {
          ui.Span(sep.open):fg(main:bg()):bg(App.bg()),
          ui.Span(" " .. ya.user_name() .. "@" .. ya.host_name() .. " "):style(main),
          ui.Span(sep.close):fg(main:bg()):bg(th.mgr.cwd:bg()),
          ui.Span(" "):style(th.mgr.cwd),
        }
      end, 500, Header.LEFT)
      Header:children_add(function()
        return ui.Line {
          ui.Span(" "):style(th.mgr.cwd),
          ui.Span(th.status.sep_left.close):fg(th.mgr.cwd:bg()):bg(App.bg()),
        }
      end, 1500, Header.LEFT)

      -- ステータスバーの左に symlink のリンク先を出す。home-manager が置く設定ファイルは nix store への symlink なので、実体を確かめられる。
      Status:children_add(function(self)
        local h = self._current.hovered
        if h and h.link_to then
          return " -> " .. tostring(h.link_to)
        end
        return ""
      end, 3300, Status.LEFT)

      -- nix store のファイルは更新日時が 1（1970 年）に揃えられていて意味がないため、1 以下は出さない。
      Status:children_add(function(self)
        local h = self._current.hovered
        local time = h and math.floor(h.cha.mtime or 0) or 0
        if time <= 1 then
          return ""
        end
        return ui.Line { ui.Span(os.date("%Y-%m-%d %H:%M", time)):fg("blue"), " " }
      end, 500, Status.RIGHT)
    '';

    settings = {
      # 親の列を消す（標準は [ 1, 4, 3 ]）。親へは h で戻れる。
      mgr.ratio = [
        0
        1
        2
      ];
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
        # キーは yazi 標準・yazi.nvim・既存の割り当てと重ならないものを選ぶ。README の例の g c（標準の ~/.config へ移動）と
        # <C-d>（標準の半ページ下へ）はぶつかるため使わない。
        {
          # キーは ranger の「ページャーで開く」に合わせて i にする。
          # bat 標準の less は 1 画面に収まると即終了して一瞬で戻るため、less を明示する。
          # less は標準では画面を下から描き、短いファイルが下に寄るため、-c で上から描かせる。
          on = "i";
          run = "shell --block -- if [ -f %h ]; then bat --paging=always --pager 'less -Rc' %h; fi";
          desc = "Open the hovered file in bat with less";
        }
        {
          # glow 標準のスタイルには gruvbox が無いため、glamour の dark スタイルの色を
          # コードプレビューと同じ gruvbox-dark.tmTheme の Markdown 用の色に置き換えたスタイルを渡す。
          # コードブロックの中は glamour が使う chroma の gruvbox スタイルに任せる。
          # glow 標準のページャー（less -r）も短いファイルが下に寄るため、PAGER で -c を付ける。
          on = "I";
          run = "shell --block -- case %h in *.md|*.markdown) PAGER='less -Rc' glow -p -s=${./glamour-gruvbox.json} %h ;; esac";
          desc = "Open the hovered Markdown rendered by glow with less";
        }
        {
          on = [
            "g"
            "s"
          ];
          run = "plugin vcs-files";
          desc = "Show Git file changes";
        }
        {
          on = "C";
          run = "plugin diff";
          desc = "Diff the selected with the hovered file";
        }
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
          # nvim の ,f（yazi.nvim）で開いた yazi を同じキーで閉じる。$NVIM は nvim の子プロセスにだけ設定される。
          # && で書くと単体起動時に終了コード 1 になり、yazi のタスク一覧に Failed が残るため || で書く。
          run = ''shell -- [ -z "$NVIM" ] || ya emit quit'';
          desc = "Close yazi.nvim (same key as ,f in nvim)";
        }
      ];
    };
  };
}
