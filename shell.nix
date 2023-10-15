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

let
  goEnv = pkgs.mkGoEnv { pwd = ./.; };
in
pkgs.mkShell {
  packages = [
    goEnv
    pkgs.gomod2nix
    pkgs.niv
    pkgs.git 
    pkgs.gnumake 
    pkgs.cudaPackages.cuda_cudart
    pkgs.cudaPackages.libcublas
    pkgs.cmake
  ];
}
