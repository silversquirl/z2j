pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const z2j = b.addExecutable(.{
        .name = "z2j",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/z2j.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    b.installArtifact(z2j);

    const test_options = b.addOptions();
    test_options.addOptionPath("z2j", z2j.getEmittedBin());

    const tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/tests.zig"),
            .target = target,
            .optimize = optimize,
            .imports = &.{
                .{ .name = "build_options", .module = test_options.createModule() },
            },
        }),
    });
    const run_tests = b.addRunArtifact(tests);
    b.step("test", "Run all tests").dependOn(&run_tests.step);
}
const std = @import("std");
