{ ... }:
{
  programs.lazygit = {
    enable = true;
    enableZshIntegration = true;
    settings.git.overrideGpg = true;
  };
}
