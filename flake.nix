{
  inputs = {
    zig2nix.url = "github:silversquirl/zig2nix";
  };

  outputs = {zig2nix, ...}: let
    flake-utils = zig2nix.inputs.flake-utils;
  in
    flake-utils.lib.eachDefaultSystem (system: let
      env = zig2nix.zig-env.${system} {zig = zig2nix.packages.${system}.zig-master;};
      src = with env.pkgs.lib.fileset;
        toSource {
          root = ./.;
          fileset = intersection (gitTracked ./.) (
            fileFilter (f: !f.hasExt "nix" && f.name != "flake.lock") ./.
          );
        };
    in rec {
      packages.default = env.package {
        inherit src;
        pname = "z2j";
        version = "0.1.0";
        doCheck = true;
      };

      apps = {
        z2j = {
          type = "app";
          program = "${packages.default}/bin/z2j";
        };
      };

      formatter = with env.pkgs;
        writeShellScriptBin "z2j-format" ''
          ${lib.getExe zig} fmt --ast-check "$@" .
          ${lib.getExe alejandra} --quiet "$@" .
        '';

      devShells.default = env.mkShell {name = "z2j";};
    });
}
