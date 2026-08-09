{
  config,
  pkgs,
  ...
}:

let
  promptColors = {
    success = "122";
    failure = "204";
  };
in
{
  home.packages = with pkgs; [
    any-nix-shell
    coreutils
    eza
    gnused
    ncurses
  ];

  programs = {
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        custom = "${config.xdg.configHome}/oh-my-zsh";
        theme = "refined-anowlist";
        plugins = [
          "git"
        ];
      };

      zsh-abbr = {
        enable = true;
        abbreviations = {
          ls = "eza --icons=auto";
          la = "eza --icons=auto -a";
          ll = "eza --icons=auto -lh";
          lla = "eza --icons=auto -lha";
          lt = "eza --icons=auto --tree --git-ignore --level=2";
          lta = "eza --icons=auto --tree -a --git-ignore --level=2";
          rm = "rm -rf";
          cp = "cp -r";
          c = "clear";
        };
      };

      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting = {
        enable = true;
        styles = {
          command = "fg=${promptColors.success}";
          builtin = "fg=${promptColors.success}";
          function = "fg=${promptColors.success}";
          alias = "fg=${promptColors.success}";
          hashed-command = "fg=${promptColors.success}";
          precommand = "fg=${promptColors.success}";
          unknown-token = "fg=${promptColors.failure}";
        };
      };

      initContent = ''
        bindkey '^ ' forward-word

        ${pkgs.any-nix-shell}/bin/any-nix-shell zsh | source /dev/stdin

        # zoxide itself is initialized by Home Manager; this is only a custom ZLE widget.
        zoxide_zi_insert() {
          local dir
          dir="$(zoxide query -i)" || return
          zle -U "$dir"
          zle reset-prompt
        }

        zle -N zoxide_zi_insert
        bindkey '^G' zoxide_zi_insert
      '';
    };
  };

  xdg.configFile."oh-my-zsh/themes/refined-anowlist.zsh-theme".source = ./refined-anowlist.zsh-theme;
}
