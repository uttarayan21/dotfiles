{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellApplication
      {
        name = "hotedit";
        # description = "Edit files from nix store by replacing them with a local copy";
        text = ''
          if [ "$#" -eq 0 ]; then
            echo "No arguments provided."
            exit 1
          elif [ "$#" -gt 1 ]; then
            echo "More than 1 argument provided."
            exit 1
          fi


          if [ -L "$1" ]; then
            echo "The file is a symbolic link."
            mv "$1" "$1.bak"
            cp "$1.bak" "$1"
            chmod +rw "$1"
          else
            echo "The file is not a symbolic link."
            exit 1
          fi
          exec $EDITOR "$1"
        '';
      })
  ];
}
