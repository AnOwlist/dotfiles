{ pkgs, ... }:
{
  imports = [
    ./fonts.nix
  ];

  security.pam.services.hyprlock = { };

  services = {
    blueman.enable = true;

    desktopManager.gnome.enable = true;

    displayManager.defaultSession = "niri";
    xserver.enable = true;

    displayManager.gdm = {
      enable = true;
      autoSuspend = false;
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
    };
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    uinput.enable = true;
  };

  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="input", TAG+="uaccess"
  '';

  programs.dconf.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    baobab # disk usage analyzer
    cheese # photo booth
    epiphany # web browser
    gedit # text editor
    orca # screen reader
    simple-scan # document scanner
    yelp # help viewer
    file-roller # archive manager
    geary # email client
    seahorse # password manager

    gnome-calculator
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-contacts
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    gnome-weather
  ];

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = [ "gnome" ];
    };

    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
    ];
  };
}
