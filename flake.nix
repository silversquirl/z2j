{
  inputs = {
    nixpkgs.url = "nixpkgs";
    zig.url = "github:silversquirl/zig-flake";
    zls.url = "github:zigtools/zls/pull/2457/head";

    zig.inputs.nixpkgs.follows = "nixpkgs";
    zls.inputs.nixpkgs.follows = "nixpkgs";
    zls.inputs.zig.follows = "zig";
  };

  outputs = inputs: let
    forAllSystems = f:
      builtins.mapAttrs (system: pkgs:
        f {
          inherit pkgs;
          zig = inputs.zig.packages.${system}.zig_0_15_1;
          zls = inputs.zls.packages.${system}.default;
        })
      inputs.nixpkgs.legacyPackages;
  in {
    devShells = forAllSystems ({
      pkgs,
      zig,
      zls,
    }: {
      default = pkgs.mkShellNoCC {
        packages = [pkgs.bash zig zls];
      };
    });

    packages = forAllSystems ({zig, ...}: {
      default = zig.makePackage {
        pname = "z2j";
        version = "0.1.0";
        src = ./.;
        zigReleaseMode = "safe";
        zigDeps = null;
        doCheck = true;
      };
    });
  };
}
