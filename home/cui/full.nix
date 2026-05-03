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
      gemini-cli
      codex
      uv
      nodejs
      unar
    ];
  };
}
