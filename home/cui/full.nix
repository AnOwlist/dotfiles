{ pkgs, ... }:
{
  imports = [
    ./minimal.nix
    ./programs/full.nix
    ./themes
  ];

  home = {
    packages = with pkgs; [
      gh
      mold-unwrapped
      uv
      nodejs
      unar
      cachix
    ];
  };
}
