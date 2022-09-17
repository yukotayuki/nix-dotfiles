{ config, pkgs, lib, dotDir, ... }:

let
  inherit (pkgs.stdenv) isDarwin isLinux;
  settings = {
    enable = true;
    extraConfig = ''
        set rtp^=${dotDir}/.config/nvim
        set rtp+=${dotDir}/.config/nvim/after
        source ${dotDir}/.config/nvim/init.vim
      '';
  };
in
{
  home.packages = with pkgs; [] ++ lib.lists.optionals isLinux [
    xclip
    neovim
    # rnix-lsp
    lua
    sumneko-lua-language-server
    # nodePackages.vim-language-server
    nodePackages.typescript-language-server
    tree-sitter
  ] ++ lib.lists.optionals isDarwin [
    reattach-to-user-namespace
  ];

  programs = {
    # neovim = settings;
  } // lib.attrsets.optionalAttrs isLinux {
    vim = settings;
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${dotDir}/hm-configs/vim/nvim";
  };
}
