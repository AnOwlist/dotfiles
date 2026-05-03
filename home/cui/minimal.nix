{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ ./programs/minimal.nix ];

  home.packages =
    (with pkgs; [
      curl
      bat
      git
      lazygit
      unzip
      wget
      eza
      zoxide
      ripgrep
      typst
      any-nix-shell
      cachix
    ])
    ++ [ inputs.nvf.packages."${pkgs.stdenv.hostPlatform.system}".default ];
}
