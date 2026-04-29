{ pkgs, ... }:
{

  imports = [
    ./programs
    ./themes
  ];

  home.packages = with pkgs; [
    dunst
    pavucontrol
    xdg-utils
    tokyonight-gtk-theme
    playerctl
    pamixer
    brightnessctl
    wl-clipboard
    nautilus
    wallpaper_random
    dragon-drop
    slurp
    prismlauncher
    discord
    wf-recorder
    wf-recorder-toggle
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "Tokyonight-Dark";
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "zen-beta.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/about" = "zen-beta.desktop";
      "x-scheme-handler/unknown" = "zen-beta.desktop";
    };
  };

  xdg.portal = {
    enable = true;
    config = {
      common.default = [ "gtk" ];
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };

  systemd.user.services.wallpaper-changer = {
    Unit.Description = "change wallpaper random";
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.wallpaper_random}/bin/wallpaper_random";
    };
  };

  systemd.user.timers.wallpaper-changer = {
    Unit = {
      Description = "change wallpaper random";
      Requires = [ "wallpaper-changer.service" ];
    };
    Timer = {
      Unit = "wallpaper-changer.service";
      OnBootSec = "5m";
      OnUnitActiveSec = "5m";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
