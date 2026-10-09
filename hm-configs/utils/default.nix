{
  pkgs,
  lib,
  isNixOS,
  ...
}:

let
  inherit (pkgs.stdenv.hostPlatform) isLinux isDarwin;

in
{
  imports = [
    ./cheetsheet.nix
    ./display_filter.nix
    ./network.nix
    ./search.nix
    ./visualization.nix
  ];

  home.packages =
    with pkgs;
    [
      unzip
      hyperfine
      rsync
      minicom
      nixfmt
      smartmontools
    ]
    ++ lib.lists.optionals isLinux [
      binutils
    ]
    ++ lib.lists.optionals isDarwin [
      deno
      kubectl
      nim
      shellcheck
    ]
    ++ lib.lists.optionals isNixOS [
      gcc
      gnumake
    ];
}
