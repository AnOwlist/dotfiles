{ lib, pkgs, ... }:
let
  # Open files in $EDITOR with the direnv environment of their project.
  # `direnv exec` itself walks up from the given directory, so no manual
  # search for the nearest .envrc is needed.
  yaziEdit = pkgs.writeShellApplication {
    name = "yazi-edit";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.direnv
    ];
    text = ''
      target=''${1:-.}
      if [ -d "$target" ]; then
        dir=$(realpath -- "$target")
      else
        dir=$(dirname -- "$(realpath -m -- "$target")")
      fi

      editor=''${EDITOR:-nvim}

      # Without any .envrc, `direnv exec` runs the command unchanged.
      if direnv exec "$dir" true >/dev/null 2>&1; then
        exec direnv exec "$dir" "$editor" "$@"
      fi

      printf 'yazi-edit: no usable direnv environment for %s\n' "$dir" >&2
      printf 'yazi-edit: opening without it (run "direnv allow" in %s to enable)\n' "$dir" >&2
      exec "$editor" "$@"
    '';
  };
in
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = lib.mkDefault false;

    settings = {
      opener.pdf = [
        {
          run = "${lib.getExe pkgs.tdf} %s";
          block = true;
          desc = "PDF viewer";
          for = "unix";
        }
      ];

      opener.edit = [
        {
          run = "${lib.getExe yaziEdit} %s";
          block = true;
          desc = "Edit (direnv)";
          for = "unix";
        }
      ];

      open.prepend_rules = [
        {
          mime = "application/pdf";
          use = "pdf";
        }
      ];
    };

    keymap = {
      mgr.prepend_keymap = [
        {
          on = "f";
          run = "plugin jump-to-char";
          desc = "Jump to char";
        }
        {
          on = "F";
          run = "plugin smart-filter";
          desc = "Smart filter";
        }
      ];
    };

    plugins = {
      inherit (pkgs.yaziPlugins)
        jump-to-char
        smart-filter
        ;
    };
  };

  home.packages = [ pkgs.tdf ];
}
