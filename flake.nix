{
  inputs = {
    zig.url = "github:mitchellh/zig-overlay";
    zls.url = "github:zigtools/zls";
    # zls.inputs.zig-overlay.follows = "zig";
  };

  outputs = inputs:
    inputs.zig.inputs.flake-utils.lib.eachDefaultSystem (system: let
      overlay = final: prev: {
        zig = inputs.zig.packages.${prev.system}.master;
        zls = inputs.zls.packages.${prev.system}.zls;
      };

      pkgs = import inputs.zig.inputs.nixpkgs {
        inherit system;
        overlays = [overlay];
      };

      # Shim to make zls work with latest nightly zig
      zig-shim = pkgs.writeShellScriptBin "zig" ''
        if [[ "$1" == "env" ]]; then
          ${pkgs.zig}/bin/zig "$@" | z2j
          exit
        fi
        exec ${pkgs.zig}/bin/zig "$@"
      '';
    in {
      devShells.default = pkgs.mkShellNoCC {
        packages = with pkgs; [zig-shim zls];
      };

      packages.default = pkgs.stdenvNoCC.mkDerivation {
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

          "-Dtarget=${system}"
          "-Dcpu=baseline"
        ];
        zigBuildFlags = ["--release=safe"];
        zigTestFlags = [];

        nativeBuildInputs = [pkgs.zig];
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
    })
    // {
      overlays.default = final: prev: {
        z2j = inputs.self.packages.${prev.system}.default;
      };
    };
}
