{ pkgs, repoDir, ... }:

{
  home.packages = with pkgs; [
    ghq
  ];

  programs = {
    git = {
      enable = true;
      settings = {
        user.name = "joo";
        user.email = "yukota.yuki@hotmail.com";
        alias.lg = "log --graph --decorate --abbrev-commit --format=format:'%C(blue)%h%C(reset) - %C(green)(%ar)%C(reset)%C(yellow)%d%C(reset)\n  %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'";
        ghq.root = "${repoDir}";
        merge = {
          tool = "nvimdiff";
          conflictstyle = "zdiff3";
        };
        diff.colorMoved = "default";
      };
      ignores = [
        ".envrc"
        ".DS_Store"
      ];
    };

    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        navigate = true;
        light = false;
        side-by-side = true;
      };
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
