{ pkgs, machine, ...}:

{
  environment = {
    loginShell = "${pkgs.zsh}/bin/zsh";
    shells = [ pkgs.zsh ];
  };

  # homebrew = {
  #   enable = true;
  #   brews = [
  #     "mas"
  #   ];
  # };

  networking = {
    computerName = machine;
    hostName = machine;
    localHostName = machine;
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  services.nix-daemon.enable = true;

  programs.zsh.enable = true;
}
