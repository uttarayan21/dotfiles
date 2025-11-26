{...}: {
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "prohibit-password";
    pubKeyAuthentication = true;
  };
}
