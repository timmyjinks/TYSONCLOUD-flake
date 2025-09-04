{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./fstab-configuration.nix
    ./tailscale.nix
    ./traefik.nix
    ./docker.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  networking.hostName = "TYSONCLOUD";
  networking.networkmanager.enable = true;
  networking.nameservers = [ "192.168.50.24" ];

  time.timeZone = "America/Denver";

  users.users.timmy = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker"];
  };

  users.users.traefik.extraGroups = [ "docker" ];

  environment.systemPackages = with pkgs; [ vim tmux go python3 python3Packages.pip git xfsprogs fastfetch ];

  services.fail2ban.enable = true;

  services.endlessh = {
    enable = true;
    port = 22;
    openFirewall = true;
  };

  services.openssh = {
    enable = true;
    ports = [ 5432 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "timmy" ];
    };
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
  };

  system.stateVersion = "25.05";
}
