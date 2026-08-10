{ pkgs, ... }:
let
  tomlFormat = pkgs.formats.toml { };
  karukanDictionary = pkgs.fetchzip {
    url = "https://github.com/togatoga/karukan/releases/download/v0.1.0/dict.tgz";
    hash = "sha256-gWUZH3FQfuksslb/AqUvBU0OVFe9DMg0+8SpGHlASqA=";
    stripRoot = false;
  };
in
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

  # The Fcitx module supplies the source; recursive linking keeps runtime files.
  xdg.configFile.fcitx5 = {
    recursive = true;
    force = true;
  };

  xdg.dataFile."karukan-im/dict.bin".source = "${karukanDictionary}/dict.bin";

  xdg.configFile."karukan-im/config.toml".source = tomlFormat.generate "karukan-im-config.toml" {
    conversion = {
      live_conversion = true;
      fullwidth_symbols = true;
    };
  };
}
