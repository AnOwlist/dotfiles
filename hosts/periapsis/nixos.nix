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
  # %% is udev's escape for a literal % (not Nix syntax).
  backlightClampRule = ''SUBSYSTEM=="backlight", KERNEL=="amdgpu_bl1", ENV{ID_BACKLIGHT_CLAMP}="10%%"'';
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
        backupFileExtension = "hm-backup";
        users.${username} = import ./home-manager.nix { inherit username; };
        extraSpecialArgs = { inherit inputs; };
      };
    }
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    initrd = {
      kernelModules = [ "joydev" ];
      services.udev.rules = backlightClampRule;
    };
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
      "uinput"
    ];
    inherit hashedPassword;
  };

  networking = {
    hostName = hostname;
    nftables.enable = true;
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      inputs.nur-yadokani.overlays.nur
      inputs.niri-flake.overlays.niri
    ];
  };
  nix.settings = {
    trusted-users = [
      "root"
      username
    ];
    extra-substituters = [
      "https://yadokani389.cachix.org"
      "https://oxalica.cachix.org"
      "https://kanaemi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "yadokani389.cachix.org-1:xHw9jijQFNDKlNprHbQpXX6cVOUO4m/n2lBfx6Bq4jg="
      "oxalica.cachix.org-1:h0iRBw6tQD8+51ZvnNEBPbwLR58UD7klauDBWzBdugQ="
      "kanaemi.cachix.org-1:TIkDbHQ6HmPzHQBXdOVhLSTff2LiCWJOJhKdIUWC238="
    ];
  };

  console.keyMap = "jp106";

  services = {
    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint ];
    };
    xserver.xkb = {
      layout = "jp";
      model = "jp106";
    };
    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
    thermald.enable = true;
    logind.settings.Login = {
      HandleLidSwitch = "lock";
      HandleLidSwitchDocked = "lock";
    };
    udev.extraRules = backlightClampRule;
  };

  hardware.graphics = {
    enable = true;
  };

  programs = {
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
