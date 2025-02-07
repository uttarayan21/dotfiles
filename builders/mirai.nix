{
  hostName = "sh.darksailor.dev";
  sshUser = "remotebuilder";
  system = "x86_64-linux";
  protocol = "ssh-ng";
  supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
}
