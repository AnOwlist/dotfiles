{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        ignore_empty_input = true;
        hide_cursor = true;
      };

      background = [
        {
          path = "~/wallpapers/nix-wallpaper-nineish-catppuccin-macchiato-alt.png";
        }
      ];

      input-field = [
        {
          size = "300, 50";
          position = "0, -100";

          outline_thickness = 1;
          inner_color = "rgba(0, 0, 0, 0.2)";
          outer_color = "rgba(0, 0, 0, 0)";
          font_color = "rgba(122, 162, 247, 0.9)";

          # fade_on_empty = false;
          placeholder_text = "";
          fail_text = "<i>$FAIL</i>";

          dots_spacing = 0.2;
          dots_center = true;
        }
      ];

      label = [
        {
          text = "$TIME";
          position = "0, 150";
          font_size = 100;

          color = "rgba(220, 220, 255, 0.6)";
          font_family = "JetBrainsMono Nerd Font ExtraBold";

          valign = "center";
          halign = "center";
        }

        {
          text = "cmd[update:1000] echo \"$(date +'%Y-%m-%d')\" ";
          position = "0, 50";
          font_size = 25;

          color = "rgba(212, 212, 255, 0.8)";
          font_family = "JetBrainsMono Nerd Font Bold";

          valign = "center";
          halign = "center";
        }

        {
          text = "cmd[update:1000] echo \"$(date +'%A')\" ";
          position = "0, 0";
          font_size = 20;

          color = "rgba(212, 212, 255, 0.8)";
          font_family = "JetBrainsMono Nerd Font Bold";

          valign = "center";
          halign = "center";
        }
      ];
    };
  };
}
