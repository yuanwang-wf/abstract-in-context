{ compiler ? "ghc8102" }:

let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };

  gitignore = pkgs.nix-gitignore.gitignoreSourcePure [ ./.gitignore ];

  myHaskellPackages = pkgs.haskell.packages.${compiler}.override {
    overrides = hself: hsuper: {
      "abstract-in-context" =
        hself.callCabal2nix "abstract-in-context" (gitignore ./.) { };
    };
  };

  shell = myHaskellPackages.shellFor {
    packages = p: [ p."abstract-in-context" ];
    buildInputs = [
      pkgs.haskellPackages.cabal-install
      pkgs.haskellPackages.ghcid
      pkgs.haskellPackages.ormolu
      pkgs.haskellPackages.hlint
      pkgs.niv
      pkgs.nixpkgs-fmt
    ];
    withHoogle = true;
  };

  exe = pkgs.haskell.lib.justStaticExecutables
    (myHaskellPackages."abstract-in-context");

  docker = pkgs.dockerTools.buildImage {
    name = "abstract-in-context";
    config.Cmd = [ "${exe}/bin/abstract-in-context" ];
  };
in {
  inherit shell;
  inherit exe;
  inherit myHaskellPackages;
  "abstract-in-context" = myHaskellPackages."abstract-in-context";
}
