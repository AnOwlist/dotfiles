{ config, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      gpg = {
        format = "openpgp";
        program = "${config.programs.gpg.package}/bin/gpg";
      };
      commit.gpgSign = true;
      tag.gpgSign = true;

      init.defaultBranch = "main";

      pull = {
        rebase = true;
        autostash = true;
      };
      rebase.autostash = true;
      merge.conflictstyle = "diff3";
    };
  };
}
