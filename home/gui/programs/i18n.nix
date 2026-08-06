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
      settings.inputMethod = {
        GroupOrder."0" = "Default";
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "jp";
          DefaultIM = "karukan";
        };
        "Groups/0/Items/0" = {
          Name = "keyboard-jp";
          Layout = null;
        };
        "Groups/0/Items/1" = {
          Name = "karukan";
          Layout = null;
        };
      };
    };
  };

  xdg.configFile.fcitx5 = {
    recursive = true;
    force = true;
  };

  home.file.".local/share/karukan-im/dict.bin".source = "${
    pkgs.fetchzip {
      url = "https://github.com/togatoga/karukan/releases/download/v0.1.0/dict.tgz";
      hash = "sha256-gWUZH3FQfuksslb/AqUvBU0OVFe9DMg0+8SpGHlASqA=";
      stripRoot = false;
    }
  }/dict.bin";

  home.file.".config/karukan-im/config.toml".text =
    "
    [conversion]
    live_conversion = true
    fullwidth_symbols = true
  ";
}
