{
  description = "Flake for building and working with Lilypond";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    lmi.url = "github:niveK77pur/lilypond-midi-input";
    naersk.url = "github:nix-community/naersk";
  };

  outputs = {
    self,
    nixpkgs,
    utils,
    lmi,
    naersk,
  }:
    utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      naersk' = pkgs.callPackage naersk {};
    in {
      devShell = pkgs.mkShell {
        packages = [
          # working with lilypond
          pkgs.lilypond
          pkgs.python311Packages.python-ly

          # handy tools
          pkgs.neovim-remote
          pkgs.timidity
          lmi.defaultPackage.${system}
          (naersk'.buildPackage {
            src = pkgs.fetchFromGitLab {
              owner = "dajoha";
              repo = "midiplay";
              rev = "f0e13a7872ba914772e3d3208333dc6c72c0c37c";
              hash = "sha256-Q6iTx2QUDk/VZb76sWguLT2LhdprjHaWCqxiMmiGZFM=";
            };
            nativeBuildInputs = with pkgs; [pkg-config alsa-lib ncurses];
          })

          # viewers
          pkgs.zathura
          pkgs.kdePackages.okular
        ];
      };
    });
}
