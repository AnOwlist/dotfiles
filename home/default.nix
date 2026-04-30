inputs:
let
  mkHome =
    {
      system,
      username,
      modules,
    }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          inputs.nur-yadokani.overlays.nur
        ];
      };
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = { inherit inputs; };
      inherit pkgs;
      modules = [
        {
          imports = modules;
          nix.package = pkgs.nix;
          home = {
            inherit username;
            homeDirectory = "/home/${username}";
            stateVersion = "26.05";
            sessionVariables.EDITOR = "nvim";
          };
        }
      ];
    };
in
{
  home-cli-minimal = mkHome {
    system = "x86_64-linux";
    username = "kani";
    modules = [ ./cui/minimal.nix ];
  };
  home-cli-full = mkHome {
    system = "x86_64-linux";
    username = "kani";
    modules = [
      ./cui/minimal.nix
      ./cui/home.nix
    ];
  };
  home-gui = mkHome {
    system = "x86_64-linux";
    username = "kani";
    modules = [
      ./cui/minimal.nix
      ./cui/home.nix
      ./gui/home.nix
    ];
  };
}
