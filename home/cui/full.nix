{ pkgs, ... }:
{
  imports = [
    ./minimal.nix
    ./programs/full.nix
    ./themes
  ];

  home = {
    packages = with pkgs; [
      cachix
      gh
      mold-unwrapped
      nodejs
      tdf
      unar
      uv
    ];
  };
}
