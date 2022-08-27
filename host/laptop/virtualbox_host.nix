{ config, lib, pkgs, modulesPath, ... }:

{
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  # users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];
  users.extraGroups.vboxusers.members = [ "joo" ];
}
