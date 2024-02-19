{ device, ... }: { programs.firefox = { enable = device.isLinux; }; }
