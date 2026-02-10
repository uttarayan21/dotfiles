{...}: {
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      excalidraw = {
        image = "excalidraw/excalidraw:latest";
        ports = ["127.0.0.1:5959:80"];
        volumes = [];
      };
    };
  };
  services.caddy.virtualHosts."draw.darksailor.dev".extraConfig = ''
    reverse_proxy localhost:5959
  '';
  # services.authelia = {
  #   instances.darksailor = {
  #     settings = {
  #       access_control = {
  #         rules = [
  #           {
  #             domain = "draw.darksailor.dev";
  #             policy = "one_factor";
  #           }
  #         ];
  #       };
  #     };
  #   };
  # };
}
