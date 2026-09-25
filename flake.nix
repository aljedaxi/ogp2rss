{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    janet-nix = {
      url = "github:turnerdev/janet-nix?ref=a2329660ee80f09d5a95491bfd4d98e988b32319";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, self, flake-utils, janet-nix, ... }: let
      supportedSystems =  ["aarch64-linux" "i686-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin"];
      forAllSystems = f:
        nixpkgs.lib.genAttrs supportedSystems (system: f system);
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
  in {
      packages = forAllSystems (system: {
      my-new-program = janet-nix.legacyPackages.${system}.mkJanet {
        name = "ogp2rss";
        src = ./.;
        quickbin = "ogp2rss/init.janet";
      };
      });

      defaultPackage =
        forAllSystems (system: self.packages.${system}.my-new-program);

      devShell = forAllSystems (system:
        with nixpkgsFor.${system};
        mkShell {
          packages = [ janet jpm ];
          buildInputs = [ janet ];
          shellHook = ''
            # localize jpm dependency paths
            export JANET_PATH="$PWD/.jpm"
            export JANET_TREE="$JANET_PATH/jpm_tree"
            export JANET_LIBPATH="${pkgs.janet}/lib"
            export JANET_HEADERPATH="${pkgs.janet}/include/janet"
            export JANET_BUILDPATH="$JANET_PATH/build"
            export PATH="$PATH:$JANET_TREE/bin"
            mkdir -p "$JANET_TREE"
            mkdir -p "$JANET_BUILDPATH"
          '';
        });
  };
}
