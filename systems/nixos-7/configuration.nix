{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ../../modules/nixos
    ./hardware-configuration.nix
  ];

  time.timeZone = "Etc/UTC";

  boot = {
    loader.systemd-boot.enable = true;
    loader.systemd-boot.consoleMode = lib.mkDefault "max";
    loader.efi.canTouchEfiVariables = true;
  };

  fileSystems."/swap".options = [ "noatime" ];

  networking.hostName = "nixos-7";

  services.aero = { 
    wayland.enable = true;
    plymouth.delay = 5;
  };

  hardware.bluetooth.enable = true;
}
