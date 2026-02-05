{...}: {
  services.pipewire = {
    enable = true;
    audio.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig = {
      pipewire = {
        "10-clock-rate" = {
          "context.properties" = {
            "default.clock.quantum" = 32;
            "default.clock.allowed-rates" = [44100 48000 88200 96000];
          };
        };
      };
    };
  };
}
