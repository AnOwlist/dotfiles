{ lib, ... }:
{
  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = lib.mkDefault false;
      nix-direnv.enable = true;
    };
  };
}
