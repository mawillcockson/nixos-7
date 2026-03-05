{ pkgs, ... }:
let user = "user"; in
{
  users.users = {
    "${user}" = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
      ];
    };
  };
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users = {
      "${user}" = {
        imports = [
          ../../home/${user}.nix
          ./aero/home.nix
        ];
        aero.enable = true;
        home.homeDirectory = "/home/${user}";
      };
    };
  };
}
