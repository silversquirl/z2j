pub fn main() !void {
    const gpa = std.heap.smp_allocator;

    const source = blk: {
        var buf: [1]u8 = undefined;
        var reader = std.fs.File.stdin().readerStreaming(&buf);
        var list: std.ArrayListUnmanaged(u8) = try .initCapacity(gpa, try reader.getSize() + 1);
        try reader.interface.appendRemaining(gpa, null, &list, .limited(16 << 30));
        break :blk try list.toOwnedSliceSentinel(gpa, 0);
    };

    const ast = try std.zig.Ast.parse(gpa, source, .zon);
    const zoir = try std.zig.ZonGen.generate(gpa, ast, .{});

    if (zoir.hasCompileErrors()) {
        var buf: [4 << 10]u8 = undefined;
        var stderr = std.fs.File.stderr().writerStreaming(&buf);

        const diag: std.zon.parse.Diagnostics = .{ .ast = ast, .zoir = zoir };
        try diag.format(&stderr.interface);
        try stderr.interface.flush();

        return error.ParseZon;
    }

    var stdout_buf: [4 << 10]u8 = undefined;
    var stdout = std.fs.File.stdout().writerStreaming(&stdout_buf);

    var printer: Printer = .{
        .ast = ast,
        .zoir = zoir,
        .writer = &stdout.interface,
        .opts = .{}, // TODO: parse args
    };
    try printer.print(.root);

    try stdout.interface.writeByte('\n');
    try stdout.interface.flush();
}

const Printer = struct {
    ast: std.zig.Ast,
    zoir: std.zig.Zoir,
    writer: *std.Io.Writer,
    opts: Options,

    fn print(p: *Printer, node: std.zig.Zoir.Node.Index) !void {
        switch (node.get(p.zoir)) {
            .true => try p.writer.writeAll("true"),
            .false => try p.writer.writeAll("false"),
            .null => try p.writer.writeAll("null"),

            .float_literal => |value| try p.writer.print("{d}", .{value}),
            .string_literal => |str| try encodeJsonString(str, .{}, p.writer),

            .int_literal => |int| switch (int) {
                .small => |val| switch (p.opts.integer) {
                    .num => try p.writer.print("{d}", .{val}),
                    .string => try p.writer.print("\"{d}\"", .{val}),
                    .bigint => try p.writer.print("{d}n", .{val}),
                },
                .big => |val| switch (p.opts.integer) {
                    .num => try p.writer.print("{d}", .{val}),
                    .string => try p.writer.print("\"{d}\"", .{val}),
                    .bigint => try p.writer.print("{d}n", .{val}),
                },
            },

            .pos_inf => switch (p.opts.infinity) {
                .err => return failValue("infinity"),
                .string => try p.writer.writeAll("\"Infinity\""),
                .ident => try p.writer.writeAll("Infinity"),
            },
            .neg_inf => switch (p.opts.infinity) {
                .err => return failValue("negative infinity"),
                .string => try p.writer.writeAll("\"-Infinity\""),
                .ident => try p.writer.writeAll("-Infinity"),
            },
            .nan => switch (p.opts.nan) {
                .err => return failValue("NaN"),
                .string => try p.writer.writeAll("\"NaN\""),
                .ident => try p.writer.writeAll("NaN"),
            },

            .enum_literal => |str| switch (p.opts.enum_literal) {
                .err => return failValue("enum literal"),
                .string => try encodeJsonString(str.get(p.zoir), .{}, p.writer),
                .ident => try p.writer.writeAll(str.get(p.zoir)),
            },

            .char_literal => |c| switch (p.opts.char_literal) {
                .string => {
                    var buf: [4]u8 = undefined;
                    // i'm pretty sure this can't error, but i'll `try` it just in case
                    const count = try std.unicode.utf8Encode(c, &buf);
                    try encodeJsonString(buf[0..count], .{}, p.writer);
                },
                .num => try p.writer.print("{d}", .{c}),
            },

            .empty_literal => switch (p.opts.empty_literal) {
                .array => try p.writer.writeAll("[]"),
                .object => try p.writer.writeAll("{}"),
            },

            .array_literal => |items| {
                try p.writer.writeByte('[');
                var i: u32 = 0;
                while (i < items.len) : (i += 1) {
                    if (i > 0) {
                        try p.writer.writeByte(',');
                    }
                    try p.print(items.at(i));
                }
                try p.writer.writeByte(']');
            },

            .struct_literal => |fields| {
                try p.writer.writeByte('{');
                var i: u32 = 0;
                std.debug.assert(fields.names.len == fields.vals.len);
                while (i < fields.vals.len) : (i += 1) {
                    if (i > 0) {
                        try p.writer.writeByte(',');
                    }
                    const name = fields.names[i].get(p.zoir);
                    try encodeJsonString(name, .{}, p.writer);
                    try p.writer.writeByte(':');
                    try p.print(fields.vals.at(i));
                }
                try p.writer.writeByte('}');
            },
        }
    }

    fn failValue(kind: []const u8) error{Unrepresentable} {
        std.log.err("{s} cannot be represented in JSON", .{kind});
        return error.Unrepresentable;
    }
};

const Options = packed struct {
    /// Because many JSON impls use floats for everything, it's useful to have other options for ints
    integer: enum(u2) { num, string, bigint } = .num,
    char_literal: enum(u2) { string, num } = .string,
    /// Zon doesn't distinguish between empty arrays and empty objects, so you have to choose
    empty_literal: enum(u1) { array, object } = .array,

    infinity: enum(u2) { err, string, ident } = .ident,
    nan: enum(u2) { err, string, ident } = .ident,
    enum_literal: enum(u2) { err, string, ident } = .string,
};

const std = @import("std");
const encodeJsonString = std.json.Stringify.encodeJsonString;
