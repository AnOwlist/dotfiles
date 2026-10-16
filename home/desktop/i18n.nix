{ inputs, pkgs, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = [
        inputs.kanaemi.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
      settings = {
        # Always-on IME: clear the default toggle hotkeys and activate on start.
        globalOptions = {
          Hotkey = {
            TriggerKeys = "";
            ActivateKeys = "";
            DeactivateKeys = "";
            AltTriggerKeys = "";
            EnumerateGroupForwardKeys = "";
            EnumerateGroupBackwardKeys = "";
          };
          Behavior.ActiveByDefault = true;
        };
        inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "jp";
            DefaultIM = "kanaemi";
          };
          "Groups/0/Items/0" = {
            Name = "keyboard-jp";
            Layout = null;
          };
          "Groups/0/Items/1" = {
            Name = "kanaemi";
            Layout = null;
          };
        };
      };
    };
  };

  xdg.configFile = {
    # The Fcitx module supplies the source; recursive linking keeps runtime files.
    fcitx5 = {
      recursive = true;
      force = true;
    };
    "kanaemi/config.toml".text = ''
      [romaji]
      tables = ["full-width", "hepburn", "kunrei", "input-aids", "z-symbols", "azik", "azik-custom.tsv", "half-width-digits.tsv"]
    '';
    "kanaemi/romaji/azik-custom.tsv".text = ''
      l	っ
    '';
    "kanaemi/romaji/half-width-digits.tsv".text = ''
      0	0
      1	1
      2	2
      3	3
      4	4
      5	5
      6	6
      7	7
      8	8
      9	9
    '';
    "kanaemi/dictionaries/kanaemi-base.tsv".source = "${inputs.kanaemi-dict}/dictionaries/base.tsv";
    "kanaemi/dictionaries/kanaemi-base.tsv.sources.txt".source =
      "${inputs.kanaemi-dict}/dictionaries/base.tsv.sources.txt";
    "kanaemi/dictionaries/kanaemi-base.model.sources.txt".source =
      "${inputs.kanaemi-dict}/dictionaries/base.model.sources.txt";
    "kanaemi/dictionaries/LICENSE".source = "${inputs.kanaemi-dict}/dictionaries/LICENSE";
    "kanaemi/dictionaries/notices" = {
      source = "${inputs.kanaemi-dict}/notices";
      recursive = true;
    };
    "kanaemi/ranking.model".source = "${inputs.kanaemi-dict}/dictionaries/base.model";
  };
}
