{
  inputs = {
    zig2nix.url = "github:Cloudef/zig2nix";
  };

  outputs = {
    flake-utils,
    zig2nix,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      # Temporary, until zig2nix CI is fixed
      zig = env.pkgs.callPackage (import (zig2nix + /src/zig/bin.nix)) {
        inherit (env) zigHook;
        release = import ./zig_release.nix;
      };

      env = zig2nix.zig-env.${system} {inherit zig;};
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
