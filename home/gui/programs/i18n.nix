{ pkgs, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-skk
        karukan-im-gpu
      ];
    };
  };

  home.file.".local/share/karukan-im/dict.bin".source = "${
    pkgs.fetchzip {
      url = "https://github.com/togatoga/karukan/releases/download/v0.1.0/dict.tgz";
      hash = "sha256-gWUZH3FQfuksslb/AqUvBU0OVFe9DMg0+8SpGHlASqA=";
      stripRoot = false;
    }
  }/dict.bin";
}
