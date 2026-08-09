{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./nix.nix
    ./zsh.nix
  ];

  home.packages = with pkgs; [
    bat
    curl
    ripgrep
    unzip
    wget
  ];
}
