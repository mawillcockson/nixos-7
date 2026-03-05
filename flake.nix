{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # The `follows` keyword in inputs is used for inheritance.
    # Here, `inputs.nixpkgs` of is kept consistent with the
    # `inputs.nixpkgs` of the current flake,
    # to avoid problems caused by different versions of nixpkgs.
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    aerothemeplasma = {
      url = "github:rustussy/aerothemeplasma";
      flake = false;
    };
    aero-libplasma = {
      url = "github:rustussy/aeroshell-libplasma";
      flake = false;
    };
    aero-workspace = {
      url = "github:rustussy/aeroshell-workspace";
      flake = false;
    };
    aero-kwin = {
      url = "github:rustussy/aeroshell-kwin-components";
      flake = false;
    };
    aero-smod = {
      url = "github:rustussy/aeroshell-smod";
      flake = false;
    };
    uac-polkit-agent = {
      url = "github:rustussy/uac-polkit-agent";
      flake = false;
    };
    plymouth-vista = {
      url = "github:rustussy/plymouth-vista";
      flake = false;
    };
  };
  outputs = inputs @ {
    nixpkgs,
    home-manager,
    plasma-manager,
    ...
  }: let
    specialArgs = {inherit inputs;};
    homeManagerOptions = {
      home-manager.extraSpecialArgs = specialArgs;
      home-manager.sharedModules = [plasma-manager.homeModules.plasma-manager];
    };
  in {
    nixosConfigurations.nixos-7 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      inherit specialArgs;
      modules = [
        home-manager.nixosModules.home-manager
        ./systems/nixos-7/configuration.nix
        homeManagerOptions
      ];
    };
    devShells.x86_64-linux.default = nixpkgs.devShells.x86_64-linux.default.overrideAttrs (
      _: previousAttrs: {
        nativeBuildInputs =
          previousAttrs.nativeBuildInputs
          ++ [
            nixpkgs.legacyPackages.x86_64-linux.nixos-rebuild
          ];
      }
    );
  };
}
