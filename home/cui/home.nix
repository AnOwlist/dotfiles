{ pkgs, ... }:
{

  imports = [
    ./programs
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

    sessionVariables = {
      RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
    };
  };
}
