{pkgs, ...}: let
  mkScript = scriptFile: deps: (pkgs.writeShellApplication {
    runtimeInputs = deps;
    name = builtins.baseNameOf scriptFile;
    text = builtins.readFile scriptFile;
  });
in {
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
    (
      pkgs.writeShellApplication {
        name = "git-install-prepare-commit-msg";
        text = ''
          cp ${../scripts/prepare-commit-msg} .git/hooks/prepare-commit-msg
        '';
      }
    )
    (mkScript ../scripts/yt-dlp.sh (with pkgs; [yt-dlp]))
    (mkScript ../scripts/autossh.sh (with pkgs; [autossh openssh]))
  ];
}
