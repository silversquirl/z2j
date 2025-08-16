{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    zig.inputs.nixpkgs.follows = "nixpkgs";
    zls.inputs.nixpkgs.follows = "nixpkgs";

    zig.url = "github:silversquirl/zig-flake";
    zls.url = "github:zigtools/zls";
  };

  outputs = inputs: let
    forAllSystems = f: builtins.mapAttrs (system: f) inputs.nixpkgs.legacyPackages;
  in {
    devShells = forAllSystems (pkgs: let
      zig = inputs.zig.packages.${pkgs.system}.nightly;
      zls = inputs.zls.packages.${pkgs.system}.zls;
    in {
      default = pkgs.mkShellNoCC {
        packages = [zig zls];
      };
    });

    packages = forAllSystems (pkgs: {
      default = pkgs.stdenvNoCC.mkDerivation {
        pname = "z2j";
        version = "0.1.0";
        src = with pkgs.lib.fileset;
          toSource {
            root = ./.;
            fileset = fileFilter (f: f.hasExt "zig") ./.;
          };

        zigDefaultFlags = [
          "--global-cache-dir"
          ".zig-cache"
          "--color"
          "off"

          "-Dtarget=${pkgs.system}"
          "-Dcpu=baseline"
        ];
        zigBuildFlags = ["--release=safe"];
        zigTestFlags = [];

        nativeBuildInputs = [inputs.zig.packages.${pkgs.system}.nightly];
        buildPhase = ''
          runHook preBuild
          zig build --prefix "$out" \
            $zigDefaultFlags "''${zigDefaultFlagsArray[@]}" \
            $zigBuildFlags "''${zigBuildFlagsArray[@]}" \
            install
          runHook postBuild
        '';

        checkPhase = ''
          runHook preCheck
          zig build --prefix "$out" \
            $zigDefaultFlags "''${zigDefaultFlagsArray[@]}" \
            $zigTestFlags "''${zigTestFlagsArray[@]}" \
            test
          runHook postCheck
        '';
      };
    });
  };
}
