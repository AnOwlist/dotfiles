{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = [
    pkgs.onlyoffice-desktopeditors
  ];

  home.activation.onlyofficeFonts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p "${config.xdg.dataHome}/fonts"
    cp -f \
      ${pkgs.noto-fonts-cjk-sans}/share/fonts/opentype/noto-cjk/NotoSansCJK-VF.otf.ttc \
      "${config.xdg.dataHome}/fonts/"
  '';
}
