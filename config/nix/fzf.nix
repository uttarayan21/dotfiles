{ pkgs, ... }: {
    programs.fzf = {
        enable = true;
        package = pkgs.fzf;
        enableFishIntegration = true;
        enableShellIntegration = true;
    };
}
