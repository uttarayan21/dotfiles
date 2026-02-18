{...}: {
  programs.ccache = {
    enable = true;
    packageNames = ["ollama" "orca-slicer" "opencv" "onnxruntime" "obs-studio" "llama-cpp"];
  };
}
