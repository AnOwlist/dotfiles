{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./gpg.nix
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
