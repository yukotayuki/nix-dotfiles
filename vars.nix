{
  username = "joo";
  homeDirectoryPrefix = pkgs: if pkgs.stdenv.hostPlatform.isDarwin then "/Users" else "/home";
}
