{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ ./programs/minimal.nix ];

  home.packages =
    (with pkgs; [
      any-nix-shell
      bat
      curl
      eza
      git
      lazygit
      ripgrep
      unzip
      wget
      zoxide
    ])
    ++ [ inputs.nvf.packages."${pkgs.stdenv.hostPlatform.system}".default ];
}
