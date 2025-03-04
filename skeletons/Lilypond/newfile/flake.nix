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
      packages.default = pkgs.stdenvNoCC.mkDerivation {
        FONTCONFIG_FILE = pkgs.makeFontsConf {
          fontDirectories = [
            "${pkgs.lilypond}/share/lilypond/${pkgs.lilypond.version}/fonts/otf"
            # TODO: Ghostscript URW
            "${pkgs.gyre-fonts}/share/fonts/truetype"
            # "${pkgs.dejavu_fonts.passthru.minimal}/share/fonts/truetype"
            "${pkgs.dejavu_fonts}/share/fonts/truetype"
            "${pkgs.noto-fonts-cjk-serif}/share/fonts/opentype/noto-cjk"
          ];
        };

        buildPhase = ''
          mkdir --parent $out
          lilypond --include=./openlilylib --output=$out Enshrouded-Horizon.ly || :
        '';

        name = "lilypond-score";
        nativeBuildInputs = [
          pkgs.lilypond
        ];
        src = ./.;
      };

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
          pkgs.okular
        ];
      };
    });
}
