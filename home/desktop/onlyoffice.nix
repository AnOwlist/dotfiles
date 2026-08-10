{
  config,
  lib,
  pkgs,
  ...
}:

let
  install = lib.getExe' pkgs.coreutils "install";
  cjkFonts = pkgs.noto-fonts-cjk-sans-static;
in
{
  home.packages = [
    pkgs.onlyoffice-desktopeditors
  ];

  # OnlyOffice 9.1.0 ignores system fonts and Home Manager symlinks.
  home.activation.onlyofficeFonts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${install} -Dm444 \
      ${cjkFonts}/share/fonts/opentype/noto-cjk/NotoSansCJK-Regular.ttc \
      "${config.xdg.dataHome}/fonts/NotoSansCJK-Regular.ttc"
    ${install} -Dm444 \
      ${cjkFonts}/share/fonts/opentype/noto-cjk/NotoSansCJK-Bold.ttc \
      "${config.xdg.dataHome}/fonts/NotoSansCJK-Bold.ttc"
  '';
}
