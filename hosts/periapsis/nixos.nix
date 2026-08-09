{
  inputs,
  pkgs,
  config,
  ...
}:
let
  username = "anowlist";
  hostname = "periapsis";
  hashedPassword = "$6$CA/1ptx4zRUe....$.HTD.apejf/k6OPuCxOafZMehUMcuVMuNeFpR7WdH5prfXnLYX7gNPkZZkLhroPOSc52Njq/55T2.3eRPKL8J0";
in
{
  imports = [
    ./hardware-configuration.nix
    ../modules/base.nix
    ../modules/container.nix
    ../modules/desktop

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${username} = import ./home-manager.nix { inherit username; };
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

  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "input"
    ];
    inherit hashedPassword;
  };

  networking = {
    hostName = hostname;
    nftables.enable = true;
  };

  nix.settings.trusted-users = [
    "root"
    username
  ];

  console.keyMap = "jp106";

  services = {
    xserver.xkb = {
      layout = "jp";
      model = "jp106";
    };
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
    thermald.enable = true;
    logind.settings.Login.HandleLidSwitch = "ignore";

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
