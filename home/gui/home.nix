{ pkgs, ... }:
{
  imports = [
    ./programs
    ./themes
  ];

  home.packages = with pkgs; [
    brightnessctl
    dunst
    nautilus
    pamixer
    pavucontrol
    playerctl
    prismlauncher
    ripdrag
    slurp
    wf-recorder
    wf-recorder-toggle
    wl-clipboard
    xdg-utils
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "zen-beta.desktop";
        "x-scheme-handler/http" = "zen-beta.desktop";
        "x-scheme-handler/https" = "zen-beta.desktop";
        "x-scheme-handler/about" = "zen-beta.desktop";
        "x-scheme-handler/unknown" = "zen-beta.desktop";
      };
    };

    portal = {
      enable = true;
      config = {
        common.default = [ "gnome" ];
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
      ];
    };
  };
}
