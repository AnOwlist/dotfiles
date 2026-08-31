{ username }:
{
  pkgs,
  ...
}:
{
  imports = [
    ../../home/profiles/workstation.nix
  ];

  programs = {
    home-manager.enable = true;

    niri.settings = {
      input.keyboard.xkb = {
        layout = "jp";
        model = "jp106";
      };
      outputs."eDP-1".scale = 1;
    };

    git.settings.user = {
      name = "AnOwlist";
      email = "anowlist.bf@gmail.com";
      signingKey = "5AC8742EC2197F6E65D5EB948484F7AC71FCF252!";
    };
  };

  my.desktop.hyprlock.iconDirectory = "pictures/hyprlock/icon";

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "26.05";

    packages = with pkgs; [
      nvtopPackages.intel
      btop
    ];

    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "zen-beta";
      TERMINAL = "kitty";
    };
  };
}
