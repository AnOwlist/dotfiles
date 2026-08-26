{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  nvim = inputs.nvf.packages."${pkgs.stdenv.hostPlatform.system}".default;
  nvimScrollbackCommand = ''${lib.getExe nvim} --cmd "set eventignore=FileType" +"nnoremap q ZQ" +"call nvim_open_term(0, {})" +"set nomodified nolist" +"$" -'';
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

    kitty = {
      shellIntegration.enableZshIntegration = true;
      extraConfig = ''
        scrollback_pager ${nvimScrollbackCommand}

        map ctrl+shift+h combine : goto_layout splits : launch --type=window --location=split --cwd=current --stdin-source=@screen_scrollback --stdin-add-formatting ${nvimScrollbackCommand}
      '';
    };

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
