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
      # List the base dictionary first. A list replaces the default order, so
      # keep the user custom dictionary and every built-in here; new built-ins
      # have to be added by hand.
      dictionaries = [
        "custom",
        "kanaemi-base.tsv",
        "kanaemi-2026.tsv",
        "kanaemi-games.tsv",
        "kanaemi-it.tsv",
        "kanaemi-place.tsv",
        "kanaemi-science.tsv",
        "kanaemi-symbol.tsv",
        "builtin:date",
        "builtin:time",
        "builtin:year",
        "builtin:number",
        "builtin:random",
      ]

      [romaji]
      tables = ["full-width", "hepburn", "kunrei", "input-aids", "z-symbols", "azik", "azik-custom.tsv", "half-width-digits.tsv"]

      # Ctrl+K commits katakana; F7 keeps doing the same from the defaults.
      [keys.reading]
      "ctrl+k" = "@commit-katakana"

      [keys.candidates]
      "ctrl+k" = "@commit-katakana"

      # Leave Ctrl+A to applications when nothing is being composed, so GUI
      # apps can select all instead of receiving Home from the default remap.
      [keys.application.linux]
      "ctrl+a" = "@none"
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
    "kanaemi/dictionaries/kanaemi-2026.tsv".source = "${inputs.kanaemi-dict}/dictionaries/2026.tsv";
    "kanaemi/dictionaries/kanaemi-games.tsv".source = "${inputs.kanaemi-dict}/dictionaries/games.tsv";
    "kanaemi/dictionaries/kanaemi-it.tsv".source = "${inputs.kanaemi-dict}/dictionaries/it.tsv";
    "kanaemi/dictionaries/kanaemi-place.tsv".source = "${inputs.kanaemi-dict}/dictionaries/place.tsv";
    "kanaemi/dictionaries/kanaemi-science.tsv".source =
      "${inputs.kanaemi-dict}/dictionaries/science.tsv";
    "kanaemi/dictionaries/kanaemi-symbol.tsv".source = "${inputs.kanaemi-dict}/dictionaries/symbol.tsv";
    "kanaemi/dictionaries/LICENSE".source = "${inputs.kanaemi-dict}/dictionaries/LICENSE";
    "kanaemi/dictionaries/notices" = {
      source = "${inputs.kanaemi-dict}/notices";
      recursive = true;
    };
    "kanaemi/ranking.model".source = "${inputs.kanaemi-dict}/dictionaries/base.model";
  };
}
