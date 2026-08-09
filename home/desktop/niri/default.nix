{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  recordScreen = pkgs.writeShellApplication {
    name = "record-screen";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.wf-recorder
      pkgs.wf-recorder-toggle
    ];
    text = ''
      exec wf-recorder-toggle -f "$HOME/videos/wf-recorder/$(date +%F-%H-%M-%S).mp4"
    '';
  };
in
{
  imports = [ inputs.niri-flake.homeModules.niri ];

  home.packages = with pkgs; [
    recordScreen
    xwayland-satellite
  ];

  home.file."videos/wf-recorder/.keep".text = "";

  programs.niri.package = pkgs.niri;

  programs.niri.settings = {
    binds = import ./key-binds.nix { inherit lib pkgs recordScreen; };
    input = {
      focus-follows-mouse = {
        enable = true;
        max-scroll-amount = "10%";
      };
      warp-mouse-to-focus.enable = true;
      touchpad.dwt = true;
    };
    prefer-no-csd = true;
    hotkey-overlay.skip-at-startup = true;
    cursor.theme = "Bibata-Modern-Classic";
    cursor.hide-after-inactive-ms = 1000;
    layout = {
      default-column-width.proportion = 0.5;
      focus-ring = {
        active.gradient = {
          angle = 45;
          from = "#08f";
          to = "#0f8";
          in' = "oklab";
          relative-to = "workspace-view";
        };
      };
    };
    window-rules = [
      {
        clip-to-geometry = true;
        geometry-corner-radius = {
          top-left = 8.0;
          top-right = 8.0;
          bottom-left = 8.0;
          bottom-right = 8.0;
        };
      }
    ];
  };
}
