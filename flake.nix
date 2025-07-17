{
  inputs = {
    zig2nix.url = "github:silversquirl/zig2nix";
  };

  outputs = {zig2nix, ...}:
    zig2nix.inputs.flake-utils.lib.eachDefaultSystem (system: let
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
        name = "z2j";
      };

      apps = {
        z2j = {
          type = "app";
          program = packages.default + "/bin/z2j";
        };
      };

      devShells.default = env.mkShell {name = "z2j";};
    });
}
