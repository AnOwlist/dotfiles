{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./nix.nix
    ./zsh
  ];

  home.packages = with pkgs; [
    bat
    curl
    ripgrep
    unzip
    wget
  ];
}
