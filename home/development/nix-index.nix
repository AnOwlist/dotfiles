{ inputs, lib, ... }:
{
  imports = [ inputs.nix-index-database.homeModules.nix-index ];
  programs = {
    nix-index = {
      enable = true;
      enableZshIntegration = lib.mkDefault false;
    };
    nix-index-database.comma.enable = true;
  };
}
