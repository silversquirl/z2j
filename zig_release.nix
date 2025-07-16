# Temporary, until zig2nix CI is fixed
{
  version = "0.15.0-dev.1034+bd97b6618";
  date = "2025-07-12";
  docs = "https://ziglang.org/documentation/master/";
  stdDocs = "https://ziglang.org/documentation/master/std/";

  src = {
    tarball = "https://ziglang.org/builds/zig-0.15.0-dev.1034+bd97b6618.tar.xz";
    shasum = "f32185bfa243c8f707e7ed996ddeec218570461bfea64513c69e1f5dc53c86aa";
    size = 21356556;
  };

  bootstrap = {
    tarball = "https://ziglang.org/builds/zig-bootstrap-0.15.0-dev.1034+bd97b6618.tar.xz";
    shasum = "96ea4575ca837affd10eca539dd5dc3c3fe9f080bb18c309c11e65659076f72d";
    size = 52725664;
  };

  x86_64-darwin = {
    tarball = "https://ziglang.org/builds/zig-x86_64-macos-0.15.0-dev.1034+bd97b6618.tar.xz";
    shasum = "4ab98fe79fa0cc32b4d2cd20702303f507670f90daec536ae93b963e20771684";
    size = 55656500;
  };

  arm64-darwin = {
    tarball = "https://ziglang.org/builds/zig-aarch64-macos-0.15.0-dev.1034+bd97b6618.tar.xz";
    shasum = "2571bcc4425eb07fb5f15a3ec1c74abd24411c3611483b4875b976284d987455";
    size = 50513616;
  };

  x86_64-linux = {
    tarball = "https://ziglang.org/builds/zig-x86_64-linux-0.15.0-dev.1034+bd97b6618.tar.xz";
    shasum = "326883901c970f16c33a587bca44b26271c84d28d166e18f1411ef4a37fe8b53";
    size = 53603364;
  };

  aarch64-linux = {
    tarball = "https://ziglang.org/builds/zig-aarch64-linux-0.15.0-dev.1034+bd97b6618.tar.xz";
    shasum = "f2bdbfca92aaae755e7047bb73980fb8ef12c7920bc8165a5cf11bc996d3d97d";
    size = 49370384;
  };

  armv7l-linux = {
    tarball = "https://ziglang.org/builds/zig-arm-linux-0.15.0-dev.1034+bd97b6618.tar.xz";
    shasum = "f8ccb3761d37a8b2edea734068b344272176dd8e298c682d134a2708411c7443";
    size = 50284360;
  };

  riscv64-linux = {
    tarball = "https://ziglang.org/builds/zig-riscv64-linux-0.15.0-dev.1034+bd97b6618.tar.xz";
    shasum = "18673a0552957309e7fce26ef41a8d3a7910553c664a9d8fa12ca0e56ca6a6c1";
    size = 53487740;
  };

  powerpc64le-linux = {
    tarball = "https://ziglang.org/builds/zig-powerpc64le-linux-0.15.0-dev.1034+bd97b6618.tar.xz";
    shasum = "a8f30f4aa438dddd005d88f6e03fed0d0534f8d668f5aae8157445c69a54c957";
    size = 53451980;
  };

  i686-linux = {
    tarball = "https://ziglang.org/builds/zig-x86-linux-0.15.0-dev.1034+bd97b6618.tar.xz";
    shasum = "1d9c54af161fe7452b37146746421be4e7364ba031cfb27a2f0364b68a4ebca3";
    size = 56172876;
  };

  loongarch64-linux = {
    tarball = "https://ziglang.org/builds/zig-loongarch64-linux-0.15.0-dev.1034+bd97b6618.tar.xz";
    shasum = "f1e2bcbdb809f1822b7b45b5670ee8411604a18c66c66d85b3b8609dcbb647bf";
    size = 50698104;
  };

  s390x-linux = {
    tarball = "https://ziglang.org/builds/zig-s390x-linux-0.15.0-dev.1034+bd97b6618.tar.xz";
    shasum = "af66915e0148db507eface4a46171192585a052de4ae350c5fef38130d87efe3";
    size = 53382292;
  };

  x86_64-mingw32 = {
    tarball = "https://ziglang.org/builds/zig-x86_64-windows-0.15.0-dev.1034+bd97b6618.zip";
    shasum = "370c6d972d2ea7546fd4fd1680d6334ead75362741bf976af13d9ef4674aa7d1";
    size = 93186206;
  };

  aarch64-mingw32 = {
    tarball = "https://ziglang.org/builds/zig-aarch64-windows-0.15.0-dev.1034+bd97b6618.zip";
    shasum = "04944651dba008363d29dcc53cee7ac465f156f59a50f6f890c34fa4f4bc29bf";
    size = 89077030;
  };

  i686-mingw32 = {
    tarball = "https://ziglang.org/builds/zig-x86-windows-0.15.0-dev.1034+bd97b6618.zip";
    shasum = "f91ea4d8670353629e66b07654d5e3dbdf5e9134de9fd6f374212bb87f4863a8";
    size = 95108812;
  };

  aarch64-freebsd = {
    tarball = "https://ziglang.org/builds/zig-aarch64-freebsd-0.15.0-dev.1034+bd97b6618.tar.xz";
    shasum = "d7279771767c462cdb8737cc2f24dac0351049332b8f8737753f815e1c92558f";
    size = 49279256;
  };

  powerpc64-freebsd = {
    tarball = "https://ziglang.org/builds/zig-powerpc64-freebsd-0.15.0-dev.1034+bd97b6618.tar.xz";
    shasum = "4c44f6d82e9996d58ce7548a8a0da3cdd1789ef8ca43bb3bfa9f962307a986ed";
    size = 52024284;
  };

  powerpc64le-freebsd = {
    tarball = "https://ziglang.org/builds/zig-powerpc64le-freebsd-0.15.0-dev.1034+bd97b6618.tar.xz";
    shasum = "d61466f7eb0b777a86c7b76e4db1a01637cfb3402922f4bd7cd5bf19a5630e81";
    size = 53384472;
  };

  riscv64-freebsd = {
    tarball = "https://ziglang.org/builds/zig-riscv64-freebsd-0.15.0-dev.1034+bd97b6618.tar.xz";
    shasum = "0a25fb398e3df92b2e42a8be4b19c2d40298337e6ae4341abeca9227e63adf73";
    size = 53532996;
  };

  x86_64-freebsd = {
    tarball = "https://ziglang.org/builds/zig-x86_64-freebsd-0.15.0-dev.1034+bd97b6618.tar.xz";
    shasum = "5f1d832753c5dad1d476b89cabd38a2815c9937e1e3fe89dcc0269eaa49d5b89";
    size = 53655584;
  };

  aarch64-netbsd = {
    tarball = "https://ziglang.org/builds/zig-aarch64-netbsd-0.15.0-dev.1034+bd97b6618.tar.xz";
    shasum = "77b680d681f06fa7d27b82f58b01f49a5f1b74baad2d20997630df0e03cb1c20";
    size = 49283052;
  };

  armv7l-netbsd = {
    tarball = "https://ziglang.org/builds/zig-arm-netbsd-0.15.0-dev.1034+bd97b6618.tar.xz";
    shasum = "518799b10f76ee5a0cad7164c9b60abd50fc7170976769561a10b2e6c47faca9";
    size = 51859476;
  };

  i686-netbsd = {
    tarball = "https://ziglang.org/builds/zig-x86-netbsd-0.15.0-dev.1034+bd97b6618.tar.xz";
    shasum = "2158714710c2b8c19bc29e6fb668c3291638d0b0c257d1e30a88c8e5ec63bd73";
    size = 56771188;
  };

  x86_64-netbsd = {
    tarball = "https://ziglang.org/builds/zig-x86_64-netbsd-0.15.0-dev.1034+bd97b6618.tar.xz";
    shasum = "1a151b83aedd27793e2e888134b2abee6bb91a05d36bceac0a259e3cb2aadaf4";
    size = 53648888;
  };
}
