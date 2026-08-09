{ pkgs, ... }:
{
  imports = [
    ./cava.nix
    ./fzf.nix
    ./lazygit.nix
    ./qalculate.nix
    ./yazi.nix
  ];

  home.packages = with pkgs; [
    unar
  ];
}
