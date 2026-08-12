{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.desktop.hyprlock;
  coldWhite = "rgba(220, 225, 255, 0.95)";
  shadowColor = "rgba(0, 0, 0, 0.45)";
  userNameCommand = lib.getExe' pkgs.coreutils "id";
  hostNameCommand = lib.getExe' pkgs.hostname "hostname";
  iconSync =
    if cfg.iconDirectory == null then
      ''
        icon_link="$HOME/.local/share/hyprlock/user-icon"

        if [[ -L "$icon_link" ]]; then
          rm -f "$icon_link"
        elif [[ -e "$icon_link" ]]; then
          printf '%s\n' "hyprlock icon target exists and is not a symbolic link" >&2
          exit 1
        fi
      ''
    else
      ''
        icon_directory="$HOME"/${lib.escapeShellArg cfg.iconDirectory}
        icon_link="$HOME/.local/share/hyprlock/user-icon"
        icon_candidates=()

        mkdir -p "$icon_directory" "$(dirname "$icon_link")"

        shopt -s dotglob nullglob
        for candidate in "$icon_directory"/*; do
          [[ -f "$candidate" ]] || continue

          case "$(file -L --mime-type -b -- "$candidate")" in
            image/png | image/jpeg | image/bmp | image/webp | image/svg | image/svg+xml)
              icon_candidates+=("$candidate")
              ;;
          esac
        done
        shopt -u dotglob nullglob

        icon_count=''${#icon_candidates[@]}
        if (( icon_count > 1 )); then
          printf '%s\n' "multiple hyprlock icons found; starting without an icon" >&2
          icon_candidates=()
          icon_count=0
        fi

        if (( icon_count == 0 )); then
          if [[ -L "$icon_link" ]]; then
            rm -f "$icon_link"
          elif [[ -e "$icon_link" ]]; then
            printf '%s\n' "hyprlock icon target exists and is not a symbolic link" >&2
            exit 1
          fi
        else
          if [[ -e "$icon_link" && ! -L "$icon_link" ]]; then
            printf '%s\n' "hyprlock icon target exists and is not a symbolic link" >&2
            exit 1
          fi

          ln -sfn "''${icon_candidates[0]}" "$icon_link"
        fi
      '';
  hyprlockWrapper = pkgs.writeShellApplication {
    name = "hyprlock-wrapper";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.file
      pkgs.hyprlock
    ];
    text = ''
      ${iconSync}

      exec hyprlock "$@"
    '';
  };
  batteryStatus = pkgs.writeShellScript "hyprlock-battery-status" ''
    shopt -s nullglob

    for battery in /sys/class/power_supply/BAT*; do
      if [[ -r "$battery/capacity" ]]; then
        read -r capacity < "$battery/capacity"
        [[ "$capacity" =~ ^[0-9]+$ ]] || continue

        status="Unknown"
        if [[ -r "$battery/status" ]]; then
          read -r status < "$battery/status"
        fi

        case "$status" in
          Charging)
            icon="󰂄"
            ;;
          Full)
            icon="󰁹"
            ;;
          *)
            if ((capacity >= 90)); then
              icon="󰂂"
            elif ((capacity >= 80)); then
              icon="󰂁"
            elif ((capacity >= 70)); then
              icon="󰂀"
            elif ((capacity >= 60)); then
              icon="󰁿"
            elif ((capacity >= 50)); then
              icon="󰁾"
            elif ((capacity >= 40)); then
              icon="󰁽"
            elif ((capacity >= 30)); then
              icon="󰁼"
            elif ((capacity >= 20)); then
              icon="󰁻"
            elif ((capacity >= 10)); then
              icon="󰁺"
            else
              icon="󰂃"
            fi
            ;;
        esac

        printf '%s %s%%\n' "$icon" "$capacity"
        exit 0
      fi
    done
  '';
  userAndHost = pkgs.writeShellScript "hyprlock-user-and-host" ''
    printf '%s@%s\n' "$(${userNameCommand} -un)" "$(${hostNameCommand})"
  '';
in
{
  options.my.desktop.hyprlock.iconDirectory = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    example = "pictures/hyprlock/icon";
    description = ''
      Directory containing the Hyprlock user icon, relative to the user's
      home directory. When null, no external user icon is used.
    '';
  };

  config = {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          ignore_empty_input = true;
          hide_cursor = true;
        };

        background = [
          {
            path = "screenshot";
            blur_passes = 3;
            blur_size = 8;
            brightness = 0.9;
          }
        ];

        image = lib.optional (cfg.iconDirectory != null) {
          path = "~/.local/share/hyprlock/user-icon";
          size = 100;
          rounding = -1;
          border_size = 3;
          border_color = coldWhite;
          position = "0, -180";

          valign = "center";
          halign = "center";
        };

        input-field = [
          {
            size = "300, 50";
            position = "0, -330";

            outline_thickness = 1;
            inner_color = "rgba(0, 0, 0, 0.3)";
            outer_color = "rgba(0, 0, 0, 0)";
            font_color = "rgba(100, 100, 240, 0.8)";

            # fade_on_empty = false;
            placeholder_text = "";
            fail_text = "<i>$FAIL</i>";

            dots_spacing = 0.2;
            dots_center = true;
          }
        ];

        label = [
          {
            text = "cmd[update:1000] ${batteryStatus}";
            position = "-30, -25";
            font_size = 18;

            color = coldWhite;
            font_family = "JetBrainsMono Nerd Font Bold";
            shadow_passes = 1;
            shadow_size = 2;
            shadow_color = shadowColor;
            shadow_boost = 1.0;

            valign = "top";
            halign = "right";
          }

          {
            text = "cmd[update:1000] echo \"$(date +'%A, %B %-d')\" ";
            position = "0, 300";
            font_size = 25;

            color = coldWhite;
            font_family = "JetBrainsMono Nerd Font ExtraBold";
            shadow_passes = 1;
            shadow_size = 2;
            shadow_color = shadowColor;
            shadow_boost = 1.0;

            valign = "center";
            halign = "center";
          }

          {
            text = "$TIME";
            position = "0, 200";
            font_size = 100;

            color = coldWhite;
            font_family = "JetBrainsMono Nerd Font ExtraBold";
            shadow_passes = 1;
            shadow_size = 3;
            shadow_color = shadowColor;
            shadow_boost = 1.0;

            valign = "center";
            halign = "center";
          }

          {
            text = "cmd[update:60000] ${userAndHost}";
            position = "0, -270";
            font_size = 18;

            color = coldWhite;
            font_family = "FiraCode Nerd Font ExtraBold";
            shadow_passes = 1;
            shadow_size = 2;
            shadow_color = shadowColor;
            shadow_boost = 1.0;

            valign = "center";
            halign = "center";
          }
        ];
      };
    };

    home.packages = [ hyprlockWrapper ];
  };
}
