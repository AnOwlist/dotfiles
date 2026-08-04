{ pkgs, ... }:

let
  promptColors = {
    success = "122";
    failure = "204";
    directory = "105";
    metadata = "8";
    duration = "143";
  };
in
{
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "refined";
      plugins = [
        "git"
        "ssh-agent"
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
        lg = "lazygit";
        rusti = "evcxr";
        drg = "ripdrag";
        o = "xdg-open";
      };
      globalAbbreviations = {
        wlc = "wl-copy";
        wlp = "wl-paste";
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
      eval "$(zoxide init zsh)"

      bindkey '^ ' forward-word

      # Keep refined's prompt information alongside any-nix-shell's precmd.
      PROMPT="%(?.%F{${promptColors.success}}.%F{${promptColors.failure}})❯%f "
      repo_information() {
        echo "%F{${promptColors.directory}}''${vcs_info_msg_0_%%/.} %F{${promptColors.metadata}}$vcs_info_msg_1_`git_dirty` $vcs_info_msg_2_%f"
      }
      refined_precmd() {
        setopt localoptions nopromptsubst
        vcs_info
        print -P "\\n$(repo_information) %F{${promptColors.duration}}$(cmd_exec_time)%f"
        unset cmd_timestamp
      }
      any-nix-shell zsh --info-right | sed 's/precmd () {/&\n  refined_precmd/' | source /dev/stdin
      functions[_any_nix_shell_precmd]=$functions[precmd]
      precmd() {
        _any_nix_shell_precmd
        local promptColor="%F{${promptColors.success}}"
        RPROMPT="''${RPROMPT//$'\e[1;32m'/$promptColor}"
      }

      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

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
}
