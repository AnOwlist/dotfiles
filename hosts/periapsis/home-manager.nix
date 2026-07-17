username:
{
  pkgs,
  ...
}:
{
  imports = [
    ../../home/gui/home.nix
    ../../home/cui/full.nix
  ];

  programs = {
    home-manager.enable = true;

    niri.settings = {
      input.keyboard.xkb.layout = "jp";
      outputs."eDP-1".scale = 1;
    };

    git.settings.user = {
      name = "AnOwlist";
      email = "anowlist.bf@gmail.com";
    };
  };

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
