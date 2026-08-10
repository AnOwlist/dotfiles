{ pkgs, ... }:
{
  imports = [
    ./git.nix
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
