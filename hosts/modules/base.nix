{ lib, ... }:
{
  time.timeZone = "Asia/Tokyo";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod.enable = false;
  };

  security.rtkit.enable = true;

  programs = {
    zsh.enable = true;
    nix-ld.enable = true;
  };

  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };

  nix.settings = {
    auto-optimise-store = true;
    keep-outputs = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = lib.mkForce [
      "https://cache.nixos.org?priority=10"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = lib.mkForce [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
