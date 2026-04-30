{inputs, ...}: let
  inherit (inputs.self) devices;
  game = "65.109.106.125";
  chibi = "51.79.165.197";
in {
  # Records that are not associated with a single service live here.
  # Service-specific records are colocated with their service module.
  networking.domains.subDomains = {
    # Apex extras (MX + SPF). A is inherited from baseDomain.
    "darksailor.dev" = {
      mx.data = [
        {
          preference = 10;
          exchange = "in1-smtp.messagingengine.com";
        }
        {
          preference = 20;
          exchange = "in2-smtp.messagingengine.com";
        }
      ];
      txt.data = "v=spf1 include:spf.messagingengine.com -all";
    };

    # Wildcards.
    "*.darksailor.dev" = {};
    "*.ryu.darksailor.dev".a.data = devices.ryu.tailscaleIp;
    "*.tsuba.darksailor.dev".a.data = devices.tsuba.tailscaleIp;

    # Host records (Tailscale).
    "ryu.darksailor.dev".a.data = devices.ryu.tailscaleIp;
    "tako.darksailor.dev".a.data = devices.tako.tailscaleIp;
    "tsuba.darksailor.dev".a.data = devices.tsuba.tailscaleIp;

    # External hosts (no service file).
    "chibi.darksailor.dev".a.data = chibi;
    "game.darksailor.dev".a.data = game;

    # Records without a corresponding service module in this repo.
    "console.darksailor.dev" = {};
    "langfuse.darksailor.dev" = {};
    "mc.darksailor.dev" = {};
    "notes.darksailor.dev" = {};
    "sh.darksailor.dev" = {};
    "www.darksailor.dev" = {};

    # DKIM CNAMEs (no inherited A/AAAA).
    "fm1._domainkey.darksailor.dev" = {
      a.data = null;
      cname.data = "fm1.darksailor.dev.dkim.fmhosted.com";
    };
    "fm2._domainkey.darksailor.dev" = {
      a.data = null;
      cname.data = "fm2.darksailor.dev.dkim.fmhosted.com";
    };
    "fm3._domainkey.darksailor.dev" = {
      a.data = null;
      cname.data = "fm3.darksailor.dev.dkim.fmhosted.com";
    };

    # Auth/policy TXT records (no inherited A).
    "_atproto.darksailor.dev" = {
      a.data = null;
      txt.data = "did=did:plc:tllyvpa5oxw6fwwhkj3kv6dr";
    };
    "_dmarc.darksailor.dev" = {
      a.data = null;
      txt.data = "v=DMARC1; p=reject; rua=mailto:dmarc@darksailor.dev; adkim=s; aspf=s";
    };
  };
}
