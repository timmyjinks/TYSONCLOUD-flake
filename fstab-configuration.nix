{ ... }:
{
  fileSystems."/var/lib/docker" = 
  {
    device = "/dev/sdb";
    fsType = "xfs";
    options = [ "defaults" "pquota" ];
  };
}
