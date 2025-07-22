test "basic functionality" {
    const res = try run(opts.z2j,
        \\.{
        \\  .name = .hello,
        \\  .version = "0.1.0",
        \\  .paths = .{
        \\    "build.zig",
        \\    "build.zig.zon",
        \\    "src/hello.zig",
        \\  },
        \\}
    );
    defer std.testing.allocator.free(res);

    try std.testing.expectEqualStrings(
        \\{"name":"hello","version":"0.1.0","paths":["build.zig","build.zig.zon","src/hello.zig"]}
        \\
    , res);
}

fn run(exe_path: []const u8, input: []const u8) ![]const u8 {
    var child: std.process.Child = .init(&.{exe_path}, std.testing.allocator);
    child.stdin_behavior = .Pipe;
    child.stdout_behavior = .Pipe;
    child.stderr_behavior = .Ignore;
    try child.spawn();

    var buf: [4 << 10]u8 = undefined;

    {
        var w = child.stdin.?.writerStreaming(&buf);
        try w.interface.writeAll(input);
        try w.interface.flush();
        child.stdin.?.close();
        child.stdin = null;
    }

    var r = child.stdout.?.readerStreaming(&buf);
    const out = try r.interface.allocRemaining(std.testing.allocator, .limited(1 << 20));
    errdefer std.testing.allocator.free(out);

    const term = try child.wait();
    if (term != .Exited or term.Exited != 0) {
        return error.ChildFailed;
    }
    return out;
}
fn deinit(res: std.process.Child.RunResult) void {
    std.testing.allocator.free(res.stdout);
    std.testing.allocator.free(res.stderr);
}

const std = @import("std");
const opts = @import("build_options");
