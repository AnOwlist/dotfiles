{
  programs.git = {
    enable = true;
    settings = {
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
