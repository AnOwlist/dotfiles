inputs: {
  nixosConfigurations = {
    periapsis = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [ ./periapsis/nixos.nix ];
    };
  };
}
