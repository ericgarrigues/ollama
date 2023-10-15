{ pkgs ? (
    let
      sources = import ./nix/sources.nix;
    in
    import sources.nixpkgs {
      overlays = [
        (import "${sources.gomod2nix}/overlay.nix")
      ];
    }
  )
}:

pkgs.buildGoApplication {
  pname = "ollama";
  version = "0.1.3";
  pwd = ./.;
  src = ./.;
  modules = ./gomod2nix.toml;

  buildInputs = with pkgs; [
    cudaPackages.cuda_cudart
    cudaPackages.libcublas
  ];

  nativeBuildInputs = with pkgs; [
    git 
    gnumake 
    cudaPackages.cuda_cudart
    cudaPackages.libcublas
    cudaPackages.cudatoolkit
    cmake
    go
  ];

  #propagatedNativeBuildInputs = with pkgs; [
  #  git 
  #  gnumake 
  #  cudaPackages.cuda_cudart
  #  cudaPackages.libcublas
  #  cudaPackages.cudatoolkit
  #  cmake
  #];

  patches = [
   ./patch-no-copy-cuda-runtime.patch
  ];

  buildPhase = ''
    go generate ./...
    go build .
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    cp ollama "$out/bin"
    chmod 0755 "$out/bin/ollama"
  '';

}
