{ lib, pkgs, ... }:
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
