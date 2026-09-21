{
  config,
  lib,
  pkgs,
  ...
}:
let
  hyprlockWrapper = "${config.home.profileDirectory}/bin/hyprlock-wrapper";
  startHyprlock = pkgs.writeShellApplication {
    name = "start-hyprlock";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.procps
    ];
    text = ''
      if pgrep -u "$(id -u)" -x hyprlock >/dev/null; then
        exit 0
      fi

      ${lib.escapeShellArg hyprlockWrapper} &

      for _ in {1..100}; do
        if pgrep -u "$(id -u)" -x hyprlock >/dev/null; then
          exit 0
        fi
        sleep 0.1
      done

      printf '%s\n' "hyprlock did not start" >&2
      exit 1
    '';
  };
  lockCommand = lib.getExe startHyprlock;
  niri = lib.getExe pkgs.niri;
  powerOffMonitors = "${niri} msg action power-off-monitors";
  powerOnMonitors = "${niri} msg action power-on-monitors";
in
{
  services.swayidle = {
    enable = true;
    extraArgs = [ "-w" ];
    systemdTargets = [ "graphical-session.target" ];

    timeouts = [
      {
        timeout = 300;
        command = lockCommand;
      }
      {
        timeout = 600;
        command = powerOffMonitors;
        resumeCommand = powerOnMonitors;
      }
    ];

    events = {
      lock = lockCommand;
      "before-sleep" = lockCommand;
      "after-resume" = powerOnMonitors;
    };
  };
}
