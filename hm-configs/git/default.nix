{ pkgs, repoDir, ... }:

{
  home.packages = with pkgs; [
    ghq
    delta
  ];

  programs = {
    git = {
      enable = true;
      settings = {
        user.name = "joo";
        user.email = "yukota.yuki@hotmail.com";
        alias.lg = "log --graph --decorate --abbrev-commit --format=format:'%C(blue)%h%C(reset) - %C(green)(%ar)%C(reset)%C(yellow)%d%C(reset)\n  %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'";
        ghq.root = "${repoDir}";
        core.pager = "delta";
        interactive.diffFilter = "delta --color-only";
        add.interactive.useBuiltin = false;
        delta = {
          navigate = true;
          light = false;
          side-by-side = true;
        };
        merge.conflictstyle = "diff3";
        diff.colorMoved = "default";
      };
      ignores = [
        ".envrc"
        ".DS_Store"
      ];
    };

    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
        aliases = {
          co = "pr checkout";
        };
      };
    };

    lazygit = {
      enable = true;
      settings = {
        gui = {
          language = "ja";
          showIcons = true;
        };
        os = {
          editCommand = "nvim";
        };
      };
    };
  };
}
