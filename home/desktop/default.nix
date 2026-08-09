{ pkgs, ... }:
{
  imports = [
    ./dunst.nix
    ./flameshot.nix
    ./fuzzel.nix
    ./hyprlock.nix
    ./i18n.nix
    ./kitty.nix
    ./libskk
    ./niri
    ./obs-studio.nix
    ./onlyoffice.nix
    ./theme.nix
    ./wallpaper_random.nix
    ./waybar.nix
    ./wleave.nix
    ./xremap.nix
    ./zen-browser.nix
  ];

  home.packages = with pkgs; [
    brightnessctl
    coreutils
    nautilus
    pamixer
    pavucontrol
    playerctl
    prismlauncher
    procps
    slurp
    systemd
    wf-recorder
    wf-recorder-toggle
    wireplumber
  ];

  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

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
      config.common.default = [ "gnome" ];
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    };
  };
}
