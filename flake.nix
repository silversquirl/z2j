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
      apps.default = {
        type = "app";
        program = "${pkgs.zig}/bin/zig";
      };
    });
}
