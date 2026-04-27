{...}: {
  programs.ccache = {
    enable = true;
    packageNames = ["orca-slicer" "opencv" "onnxruntime" "obs-studio" "llama-cpp"];
  };
}
