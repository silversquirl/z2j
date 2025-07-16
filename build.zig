pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const z2j = b.addExecutable(.{
        .name = "z2j",
        .root_module = b.createModule(.{
            .root_source_file = b.path("z2j.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    b.installArtifact(z2j);
}
const std = @import("std");
