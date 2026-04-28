username:
{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.zen-browser.homeModules.beta
    ../../home/gui/home.nix
    ../../home/cui/home.nix
    ../../home/cui/minimal.nix
  ];

  programs = {
    home-manager.enable = true;

    niri.settings = {
      input.keyboard.xkb.layout = "jp";
      outputs."eDP-1".scale = 1;
      binds = {
        "Mod+U".action.focus-workspace-down = { };
        "Mod+I".action.focus-workspace-up = { };
      };
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
