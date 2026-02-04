{
  device,
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  remminaDir = "${config.home.homeDirectory}/.local/share/remmina";
  applicationsDir = "${config.home.homeDirectory}/.local/share/applications";

  # Script to generate desktop entries for Remmina connections
  generateRemminaDesktopEntries = pkgs.writeShellScript "generate-remmina-desktop-entries" ''
    REMMINA_DIR="${remminaDir}"
    APPS_DIR="${applicationsDir}"

    # Create applications directory if it doesn't exist
    mkdir -p "$APPS_DIR"

    # Remove old remmina desktop entries
    rm -f "$APPS_DIR"/remmina-*.desktop

    # Exit if remmina directory doesn't exist
    [[ ! -d "$REMMINA_DIR" ]] && exit 0

    # Generate desktop entries for each .remmina file
    find "$REMMINA_DIR" -name "*.remmina" -type f | while read -r file; do
      # Extract connection details
      name=$(${pkgs.gnugrep}/bin/grep "^name=" "$file" | ${pkgs.coreutils}/bin/cut -d'=' -f2-)
      server=$(${pkgs.gnugrep}/bin/grep "^server=" "$file" | ${pkgs.coreutils}/bin/cut -d'=' -f2-)
      protocol=$(${pkgs.gnugrep}/bin/grep "^protocol=" "$file" | ${pkgs.coreutils}/bin/cut -d'=' -f2-)

      # Use filename as fallback if name is empty
      [[ -z "$name" ]] && name=$(${pkgs.coreutils}/bin/basename "$file" .remmina)
      [[ -z "$protocol" ]] && protocol="Unknown"

      # Generate desktop entry filename
      desktop_name=$(${pkgs.coreutils}/bin/basename "$file" .remmina | ${pkgs.gnused}/bin/sed 's/[^a-zA-Z0-9_-]/-/g')
      desktop_file="$APPS_DIR/remmina-$desktop_name.desktop"

      # Create desktop entry
      cat > "$desktop_file" <<EOF
    [Desktop Entry]
    Type=Application
    Name=Remmina - $name
    GenericName=$protocol Connection to $server
    Comment=Connect to $server via $protocol
    Exec=${pkgs.remmina}/bin/remmina -c "$file"
    Icon=org.remmina.Remmina
    Terminal=false
    Categories=Network;RemoteAccess;
    EOF
    done
  '';
in {
  services.remmina = {
    enable = device.is "ryu";
    systemdService.enable = true;
    addRdpMimeTypeAssoc = true;
  };

  # Activation script to generate desktop entries
  home.activation.generateRemminaDesktopEntries = mkIf (device.is "ryu") (
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      run ${generateRemminaDesktopEntries}
    ''
  );
}
