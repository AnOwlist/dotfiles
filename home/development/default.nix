{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./direnv.nix
    ./nh.nix
    ./nix-index.nix
  ];

  home.packages =
    (with pkgs; [
      cachix
      gh
      jq
      mold-unwrapped
      nodejs
      uv
    ])
    ++ [ inputs.nvf.packages."${pkgs.stdenv.hostPlatform.system}".default ];
}
