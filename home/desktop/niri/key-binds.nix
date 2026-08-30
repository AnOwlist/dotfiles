{
  lib,
  pkgs,
  recordScreen,
}:
let
  inherit (lib) getExe getExe';
in
{
  "Mod+Shift+Slash".action.show-hotkey-overlay = { };

  "Mod+Return".action.spawn = getExe pkgs.kitty;
  "Mod+D".action.spawn = getExe pkgs.fuzzel;
  "Mod+T".action.spawn = getExe pkgs.wleave;
  "Mod+B".action.spawn = [
    (getExe' pkgs.procps "pkill")
    "-SIGUSR1"
    "waybar"
  ];

  "Mod+C".action.close-window = { };
  "Mod+W".action.toggle-column-tabbed-display = { };
  "Mod+V".action.switch-focus-between-floating-and-tiling = { };
  "Mod+Shift+V".action.toggle-window-floating = { };
  "Mod+R".action.switch-preset-column-width = { };
  "Mod+E".action.switch-preset-window-height = { };
  "Mod+Shift+E".action.reset-window-height = { };
  "Mod+F".action.maximize-column = { };
  "Mod+G".action.fullscreen-window = { };
  "Mod+Comma".action.consume-window-into-column = { };
  "Mod+Period".action.expel-window-from-column = { };

  "Mod+Left".action.focus-column-or-monitor-left = { };
  "Mod+Down".action.focus-window-or-workspace-down = { };
  "Mod+Up".action.focus-window-or-workspace-up = { };
  "Mod+Right".action.focus-column-or-monitor-right = { };
  "Mod+H".action.focus-column-or-monitor-left = { };
  "Mod+J".action.focus-window-or-workspace-down = { };
  "Mod+K".action.focus-window-or-workspace-up = { };
  "Mod+L".action.focus-column-or-monitor-right = { };

  "Mod+Shift+Left".action.move-column-left-or-to-monitor-left = { };
  "Mod+Shift+Down".action.move-window-down-or-to-workspace-down = { };
  "Mod+Shift+Up".action.move-window-up-or-to-workspace-up = { };
  "Mod+Shift+Right".action.move-column-right-or-to-monitor-right = { };
  "Mod+Shift+H".action.move-column-left-or-to-monitor-left = { };
  "Mod+Shift+J".action.move-window-down-or-to-workspace-down = { };
  "Mod+Shift+K".action.move-window-up-or-to-workspace-up = { };
  "Mod+Shift+L".action.move-column-right-or-to-monitor-right = { };

  "Mod+Ctrl+Left".action.consume-or-expel-window-left = { };
  "Mod+Ctrl+Right".action.consume-or-expel-window-right = { };
  "Mod+Ctrl+H".action.consume-or-expel-window-left = { };
  "Mod+Ctrl+L".action.consume-or-expel-window-right = { };

  "Mod+WheelScrollDown" = {
    cooldown-ms = 150;
    action.focus-workspace-down = { };
  };
  "Mod+WheelScrollUp" = {
    cooldown-ms = 150;
    action.focus-workspace-up = { };
  };
  "Mod+Ctrl+WheelScrollDown" = {
    cooldown-ms = 150;
    action.move-column-to-workspace-down = { };
  };
  "Mod+Ctrl+WheelScrollUp" = {
    cooldown-ms = 150;
    action.move-column-to-workspace-up = { };
  };

  "Mod+WheelScrollRight".action.focus-column-right = { };
  "Mod+WheelScrollLeft".action.focus-column-left = { };
  "Mod+Ctrl+WheelScrollRight".action.move-column-right = { };
  "Mod+Ctrl+WheelScrollLeft".action.move-column-left = { };

  "Mod+Shift+WheelScrollDown".action.focus-column-right = { };
  "Mod+Shift+WheelScrollUp".action.focus-column-left = { };
  "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = { };
  "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = { };

  "Mod+1".action.focus-workspace = 1;
  "Mod+2".action.focus-workspace = 2;
  "Mod+3".action.focus-workspace = 3;
  "Mod+4".action.focus-workspace = 4;
  "Mod+5".action.focus-workspace = 5;
  "Mod+6".action.focus-workspace = 6;
  "Mod+7".action.focus-workspace = 7;
  "Mod+8".action.focus-workspace = 8;
  "Mod+9".action.focus-workspace = 9;
  "Mod+Shift+1".action.move-column-to-workspace = [
    { focus = false; }
    1
  ];
  "Mod+Shift+2".action.move-column-to-workspace = [
    { focus = false; }
    2
  ];
  "Mod+Shift+3".action.move-column-to-workspace = [
    { focus = false; }
    3
  ];
  "Mod+Shift+4".action.move-column-to-workspace = [
    { focus = false; }
    4
  ];
  "Mod+Shift+5".action.move-column-to-workspace = [
    { focus = false; }
    5
  ];
  "Mod+Shift+6".action.move-column-to-workspace = [
    { focus = false; }
    6
  ];
  "Mod+Shift+7".action.move-column-to-workspace = [
    { focus = false; }
    7
  ];
  "Mod+Shift+8".action.move-column-to-workspace = [
    { focus = false; }
    8
  ];
  "Mod+Shift+9".action.move-column-to-workspace = [
    { focus = false; }
    9
  ];

  "Mod+Alt+Left".action.set-window-width = "-10%";
  "Mod+Alt+Right".action.set-window-width = "+10%";
  "Mod+Alt+H".action.set-window-width = "-10%";
  "Mod+Alt+L".action.set-window-width = "+10%";

  "Mod+Alt+Up".action.set-window-height = "-10%";
  "Mod+Alt+Down".action.set-window-height = "+10%";
  "Mod+Alt+K".action.set-window-height = "-10%";
  "Mod+Alt+J".action.set-window-height = "+10%";

  "Print".action.screenshot = { };
  "Ctrl+Print".action.screenshot-screen = {
    write-to-disk = false;
  };
  "Alt+Print".action.screenshot-window = {
    write-to-disk = false;
  };
  "Mod+S".action.spawn = getExe recordScreen;

  "XF86AudioRaiseVolume" = {
    allow-when-locked = true;
    action.spawn = [
      (getExe' pkgs.wireplumber "wpctl")
      "set-volume"
      "@DEFAULT_AUDIO_SINK@"
      "0.05+"
    ];
  };
  "XF86AudioLowerVolume" = {
    allow-when-locked = true;
    action.spawn = [
      (getExe' pkgs.wireplumber "wpctl")
      "set-volume"
      "@DEFAULT_AUDIO_SINK@"
      "0.05-"
    ];
  };
  "XF86MonBrightnessUp" = {
    allow-when-locked = true;
    action.spawn = [
      (getExe pkgs.brightnessctl)
      "set"
      "5%+"
    ];
  };
  "XF86MonBrightnessDown" = {
    allow-when-locked = true;
    action.spawn = [
      (getExe pkgs.brightnessctl)
      "set"
      "5%-"
    ];
  };
  "XF86AudioMute" = {
    allow-when-locked = true;
    action.spawn = [
      (getExe' pkgs.wireplumber "wpctl")
      "set-mute"
      "@DEFAULT_AUDIO_SINK@"
      "toggle"
    ];
  };
  "XF86AudioMicMute" = {
    allow-when-locked = true;
    action.spawn = [
      (getExe' pkgs.wireplumber "wpctl")
      "set-mute"
      "@DEFAULT_AUDIO_SOURCE@"
      "toggle"
    ];
  };
}
