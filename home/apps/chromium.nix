{pkgs, ...}: {
  programs.chromium = {
    enable = pkgs.stdenv.isLinux;
    extensions = [
      "ddkjiahejlhfcafbddmgiahcphecmpfh" # uBlock Origin Lite
      "aeblfdkhhhdcdjpifhhbdiojplfjncoa" # 1password
      "ldpochfccmkkmhdbclfhpagapcfdljkj" # Decentraleyes
      "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # Privacy Badger
      "lckanjgmijmafbedllaakclkaicjfmnk" # ClearURLs
      "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock
      "gebbhagfogifgggkldgodflihgfeippi" # Return YouTube Dislike
      "edibdbjcniadpccecjdfdjjppcpchdlm" # I still don't care about cookies
    ];
  };
}
