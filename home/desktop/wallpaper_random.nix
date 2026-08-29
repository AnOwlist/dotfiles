{
  config,
  lib,
  pkgs,
  ...
}:
let
  graphicalSessionTarget = "graphical-session.target";
  niriService = "niri.service";
  awwwDaemon = lib.getExe' pkgs.awww "awww-daemon";
  wallpaperRandom = lib.getExe pkgs.wallpaper_random;
  wallpaperDirectory = "${config.xdg.userDirs.pictures}/wallpapers";
  wallpaperDirectoryRelative = lib.removePrefix "${config.home.homeDirectory}/" wallpaperDirectory;
  wallpaperRandomCommand = "${wallpaperRandom} --dir ${lib.escapeShellArg wallpaperDirectory}";
  wallpaperInitial = pkgs.writeShellApplication {
    name = "wallpaper-initial";
    runtimeInputs = [
      pkgs.awww
      pkgs.coreutils
      pkgs.findutils
    ];
    text = ''
      wallpaper_dir=${lib.escapeShellArg wallpaperDirectory}
      mapfile -d $'\0' -t wallpapers < <(find "$wallpaper_dir" -type f -print0)

      if ((''${#wallpapers[@]} == 0)); then
        printf 'No wallpapers found in %s\n' "$wallpaper_dir" >&2
        exit 1
      fi

      wallpaper="''${wallpapers[RANDOM % ''${#wallpapers[@]}]}"
      outputs=()
      for _ in {1..50}; do
        query="$(awww query 2>/dev/null || true)"
        outputs=()
        if [[ -n "$query" ]]; then
          mapfile -t outputs < <(printf '%s\n' "$query" | while IFS= read -r line; do printf '%s\n' "''${line%%:*}"; done)
        fi
        ((''${#outputs[@]} > 0)) && break
        sleep 0.1
      done

      if ((''${#outputs[@]} == 0)); then
        printf 'No outputs returned by awww query\n' >&2
        exit 1
      fi

      for output in "''${outputs[@]}"; do
        awww img "$wallpaper" --transition-type none --outputs "$output"
      done
    '';
  };
in
{
  home.packages = with pkgs; [
    wallpaper_random
  ];

  home.file."${wallpaperDirectoryRelative}/.keep".text = "";

  systemd.user.services.awww-daemon = {
    Unit = {
      Description = "Awww wallpaper daemon";
      After = [ niriService ];
      Before = [ graphicalSessionTarget ];
      PartOf = [ graphicalSessionTarget ];
    };
    Service = {
      ExecStart = awwwDaemon;
      Restart = "on-failure";
    };
    Install.WantedBy = [ niriService ];
  };

  systemd.user.services.wallpaper-initial = {
    Unit = {
      Description = "Apply the initial wallpaper";
      Requires = [ "awww-daemon.service" ];
      After = [
        niriService
        "awww-daemon.service"
      ];
      Before = [ graphicalSessionTarget ];
      PartOf = [ graphicalSessionTarget ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = lib.getExe wallpaperInitial;
    };
    Install.WantedBy = [ niriService ];
  };

  systemd.user.services.wallpaper-changer = {
    Unit = {
      Description = "Change wallpaper randomly";
      Requires = [ "awww-daemon.service" ];
      After = [
        graphicalSessionTarget
        "awww-daemon.service"
      ];
      PartOf = [ graphicalSessionTarget ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = wallpaperRandomCommand;
    };
  };

  systemd.user.timers.wallpaper-changer = {
    Unit = {
      Description = "Change wallpaper randomly on an interval";
      After = [ graphicalSessionTarget ];
      PartOf = [ graphicalSessionTarget ];
    };
    Timer = {
      Unit = "wallpaper-changer.service";
      OnActiveSec = "5m";
      OnUnitActiveSec = "5m";
    };
    Install.WantedBy = [ graphicalSessionTarget ];
  };
}
