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
      gsfonts = pkgs.callPackage ( #  {{{
        # Adapted from AUR: https://aur.archlinux.org/packages/gsfonts-emojiless
        {
          lib,
          stdenvNoCC,
          fetchFromGitHub,
        }:
          stdenvNoCC.mkDerivation rec {
            name = "gsfonts";
            version = "3c0ba3b5687632dfc66526544a4e811fe0ec0cd9";
            src = fetchFromGitHub {
              repo = "urw-base35-fonts";
              owner = "ArtifexSoftware";
              rev = version;
              sha256 = "sha256-WD5q5ajG2F5aIZJB8tJL0X+YsL++ysIBrBKgq0ROrIY=";
            };
            preInstall = "mkdir -p $out";
            installPhase = ''
              runHook preInstall

              install -Dt "$out/usr/share/fonts/gsfonts" -m644 fonts/*.otf
              install -Dt "$out/usr/share/metainfo" -m644 appstream/*.xml

              install -d "$out"/etc/fonts/conf.{avail,d}
              for _f in fontconfig/*.conf; do
                _fn="$out/etc/fonts/conf.avail/69-''${_f##*/}"
                install -m644 ''${_f} "''${_fn}"
                ln -srt "$out/etc/fonts/conf.d" "''${_fn}"
              done

              runHook postInstall
            '';
            meta = {
              description = "(URW)++ Core Font Set [Level 2] without characters listed as emoji, in order not to override color fonts";
              license = lib.licenses.agpl3Only;
            };
          }
      ) {}; #  }}}
      #  {{{
      lilypond-build-module = {
        stdenvNoCC,
        lib,
        lilypond,
        makeRelease ? false,
        makeFontsConf,
        gsfonts,
      }:
        stdenvNoCC.mkDerivation rec {
          name = "NAME";
          src = self;
          # Provide URW fonts to the build
          FONTCONFIG_FILE = makeFontsConf {
            fontDirectories = [gsfonts];
          };
          buildPhase = ''
            runHook preBuild
            ${lilypond}/bin/lilypond \
              -I ./openlilylib \
              ${lib.optionalString makeRelease "-dno-point-and-click"} \
              ${name}.ly
            runHook postBuild
          '';
          installPhase = ''
            runHook preInstall
            mkdir -p $out
            shopt -s extglob
            cp -a ${name}.!(ly) $out/
            runHook postInstall
          '';
        }; #  }}}
    in {
      packages = {
        default = pkgs.callPackage lilypond-build-module {
          inherit gsfonts;
        };
        release = pkgs.callPackage lilypond-build-module {
          makeRelease = true;
          inherit gsfonts;
        };
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
          pkgs.kdePackages.okular
        ];
      };
    });
}
# vim: fdm=marker

