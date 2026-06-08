{
  inputs,
  pkgs,
  config,
  ...
}:
let
  username = "anowlist";
  hashedPassword = "$6$CA/1ptx4zRUe....$.HTD.apejf/k6OPuCxOafZMehUMcuVMuNeFpR7WdH5prfXnLYX7gNPkZZkLhroPOSc52Njq/55T2.3eRPKL8J0";
  hostname = "periapsis";
in
{
  imports = [
    ./hardware-configuration.nix
    (import ../nixos.nix username hashedPassword hostname)
    ../desktop

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users."${username}" = import ./home-manager.nix username;
        extraSpecialArgs = { inherit inputs; };
      };
    }
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    initrd.kernelModules = [ "joydev" ];
    tmp.useTmpfs = true;
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
      };
    };
  };

  networking = {
    nftables.enable = true;
    firewall = {
      enable = true;
    };
  };

  console.keyMap = "jp106";

  services = {
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
    thermald.enable = true;
    logind.settings.Login.HandleLidSwitch = "ignore";

    desktopManager.gnome.enable = true;
  };

  hardware.graphics = {
    enable = true;
  };

  programs = {
    niri.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
    };
  };

  virtualisation.waydroid.enable = true;

  system.stateVersion = "26.05";
}
