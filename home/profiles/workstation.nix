{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  nvim = inputs.nvf.packages."${pkgs.stdenv.hostPlatform.system}".default;
in
{
  imports = [
    ../shell
    ../terminal
    ../development
    ../desktop
  ];

  home.packages = with pkgs; [
    ripdrag
    wl-clipboard
    xdg-utils
  ];

  programs = {
    direnv.enableZshIntegration = true;

    fzf.enableZshIntegration = true;

    git.settings.credential = {
      "https://github.com".helper = "${lib.getExe pkgs.gh} auth git-credential";
      "https://gist.github.com".helper = "${lib.getExe pkgs.gh} auth git-credential";
    };

    kitty.extraConfig = ''
      scrollback_pager ${lib.getExe nvim} -c "setlocal autowriteall" -c "silent write! /tmp/kitty_scrollback_buffer | te ${lib.getExe' pkgs.coreutils "cat"} /tmp/kitty_scrollback_buffer - "
    '';
    kitty.shellIntegration.enableZshIntegration = true;

    yazi = {
      enableZshIntegration = true;
      shellWrapperName = "y";
      keymap.mgr.prepend_keymap = lib.mkAfter [
        {
          on = [ "<C-d>" ];
          run = "plugin drag";
          desc = "Drag Files";
        }
      ];
      plugins.drag = pkgs.yaziPlugins.drag;
    };

    nix-index.enableZshIntegration = true;

    zsh.zsh-abbr = {
      abbreviations = {
        drg = "ripdrag";
        lg = "lazygit";
        o = "xdg-open";
      };
      globalAbbreviations = {
        wlc = "wl-copy";
        wlp = "wl-paste";
      };
    };

    zsh.initContent = ''
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
    '';
  };
}
