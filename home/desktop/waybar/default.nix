{ lib, pkgs, ... }:
let
  coreutils = pkgs.coreutils;
  date = lib.getExe' coreutils "date";
  printf = lib.getExe' coreutils "printf";
  test = lib.getExe' coreutils "test";
  media = pkgs.writeShellApplication {
    name = "waybar-media";
    runtimeInputs = [ pkgs.playerctl ];
    text = builtins.readFile ./media.sh;
  };
in
{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      targets = [ "graphical-session.target" ];
    };
    style = builtins.readFile ./style.css;
    settings = [
      {
        position = "top";
        modules-left = [
          "custom/launcher"
          "temperature"
          "custom/media"
          "cava"
        ];
        modules-center = [ "custom/clock" ];
        modules-right = [
          "pulseaudio"
          "battery"
          "backlight"
          "memory"
          "cpu"
          "network"
          "custom/powermenu"
          "custom/wf-recorder"
          "tray"
        ];
        "custom/launcher" = {
          "format" = " ";
          "on-click" = "exec ${lib.getExe pkgs.wallpaper_random}";
          "tooltip" = false;
        };
        "temperature" = {
          "format" = " {temperatureC}°C";
        };
        "cava" = {
          framerate = 60;
          bars = 18;
          hide_on_silence = true;
          sleep_timer = 1;
          method = "pipewire";
          bar_delimiter = 0;
          format-icons = [
            "▁"
            "▁"
            "▂"
            "▃"
            "▄"
            "▅"
            "▆"
            "▇"
            "█"
          ];
        };
        "pulseaudio" = {
          "scroll-step" = 1;
          "format" = "{icon} {volume}%";
          "format-muted" = " Muted";
          "format-icons" = {
            "default" = [
              ""
              ""
              ""
              ""
            ];
          };
          "on-click" = "${lib.getExe pkgs.pamixer} -t";
          "tooltip" = false;
        };
        "battery" = {
          "interval" = 1;
          "states" = {
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{icon} {capacity}%";
          "format-charging" = "󰂄 {capacity}%";
          "format-plugged" = "󱟦 {capacity}%";
          "format-alt" = "{time} {icon}";
          "format-full" = "󰁹 {capacity}%";
          "format-icons" = [
            "󰁻"
            "󰁿"
            "󰂁"
          ];
        };
        "backlight" = {
          "format" = "󰖨 {percent}%";
        };
        "custom/clock" = {
          "exec" = "${date} '+%H:%M  %a %b %-d'";
          "interval" = 1;
          "tooltip" = false;
        };
        "memory" = {
          "interval" = 1;
          "format" = "󰍛 {percentage}%";
          "states" = {
            "warning" = 85;
          };
        };
        "cpu" = {
          "interval" = 1;
          "format" = "󰻠 {usage}%";
        };
        "custom/media" = {
          "max-length" = 100;
          "exec" = "${lib.getExe media} status";
          "on-click" = "${lib.getExe media} toggle";
          "tooltip" = false;
          "interval" = 1;
        };
        "network" = {
          "format-disconnected" = "󰯡 ";
          "format-ethernet" = "󰒢 ";
          "format-linked" = "󰖪 ";
          "format-wifi" = "󰖩 ";
          "interval" = 10;
          "tooltip" = false;
        };
        "custom/powermenu" = {
          "format" = "";
          "on-click" = lib.getExe pkgs.wleave;
          "tooltip" = false;
        };
        "custom/wf-recorder" = {
          "exec" = "${test} -e \"$XDG_RUNTIME_DIR/wf-recorder.pid\" && ${printf} '●'";
          "interval" = 1;
        };
        "tray" = {
          "icon-size" = 15;
          "spacing" = 5;
        };
      }
    ];
  };
}
