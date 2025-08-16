{
  inputs,
  device,
  ...
}: {
  imports = [
    # Import the hyprmonitors module
    inputs.hyprmonitors.homeManagerModules.hyprmonitors
  ];

  # Configure hyprmonitors service
  services.hyprmonitors = {
    enable = device.is "ryu";

    # Optional: customize host and port (defaults shown)
    host = "0.0.0.0";
    port = 3113;

    # Optional: set log level (default: "info")
    logLevel = "info";

    # Optional: add environment variables
    # environmentVariables = {
    #   # Example: if you need to set specific Hyprland instance
    #   # HYPRLAND_INSTANCE_SIGNATURE = "your-signature-here";
    # };

    # Optional: override the package (if you want to use a custom build)
    # package = pkgs.hyprmonitors;  # Uses default from module
  };
}
