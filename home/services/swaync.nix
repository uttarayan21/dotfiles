{...}: {
  services.swaync = {
    enable = true;
    settings = {
      notification-inline-replies = true;
      cssPriority = "user";
    };
  };
  xdg.configFile = {
    "swaync/style.css".text = ''
      .floating-notifications {
          background: rgba(0, 0, 0, 0.3);
      }
    '';
  };
}
