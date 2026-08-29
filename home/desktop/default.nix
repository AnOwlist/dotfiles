{ config, pkgs, ... }:
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
    ./waybar
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
    wireplumber
  ];

  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

  xdg = {
    userDirs = {
      enable = true;
      createDirectories = false;
      setSessionVariables = false;

      desktop = null;
      documents = "${config.home.homeDirectory}/documents";
      download = "${config.home.homeDirectory}/downloads";
      music = null;
      pictures = "${config.home.homeDirectory}/pictures";
      projects = "${config.home.homeDirectory}/projects";
      publicShare = "${config.home.homeDirectory}/public";
      templates = null;
      videos = "${config.home.homeDirectory}/videos";
    };

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
  };
}
