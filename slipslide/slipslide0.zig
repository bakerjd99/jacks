const std = @import("std");

pub fn main() !void {

    // There are seven numeric arguments to slipslide0 - example calls:
    //
    // command line:
    //   slipslide0 25 0.001 1.226 0.5 0.0002835287369864788 0.0090502372846084037 1.0
    //
    // compile and run:
    //   zig run slipslide0.zig -- 100 0.001 1.226 0.5 0.00028352874 0.0090502373 1.0

    // Get allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    // Parse args into string array (error union needs 'try')
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    const stdout = std.io.getStdOut().writer();

    if (8 != args.len) {
        try stdout.print("ERROR - invalid argument count - needs 7 - see example:\n", .{});
        try stdout.print("slipslide0 7200000 0.001 1.226 0.5 0.00028352874 0.0090502373 1.0\n", .{});
        return;
    }

    // iteration count - greater than zero
    const dcnt: f64 = std.fmt.parseFloat(f64, args[1]) catch 0.0;
    const cnt: i64 = @intFromFloat(dcnt);
    if (0 < dcnt) {
        try stdout.print("iteration count:              {d}\n", .{cnt});
    } else {
        try stdout.print("ERROR - iteration count: {s}\n", .{args[1]});
        return;
    }

    // Δt (sec) - greater than zero
    const d_t: f64 = std.fmt.parseFloat(f64, args[2]) catch 0.0;
    if (0.0 < d_t) {
        try stdout.print("delta T (sec):                {d}\n", .{d_t});
    } else {
        try stdout.print("ERROR - delta T: {s}\n", .{args[2]});
        return;
    }

    // ρ air density (kg/m^3) - greater than zero
    // https://www.wolframalpha.com/input?i=air+density+at+sea+level+in+kilograms+per+cubic+meter
    const rho: f64 = std.fmt.parseFloat(f64, args[3]) catch 0.0;
    if (0.0 < rho) {
        try stdout.print("\nair density (kg/m^3):         {d}\n", .{rho});
    } else {
        try stdout.print("ERROR - air density: {s}\n", .{args[3]});
        return;
    }

    // drag constant - greater than zero
    // basic drag formula is: R = ½ρCAv^2  https://physics.info/drag/
    const c_d: f64 = std.fmt.parseFloat(f64, args[4]) catch 0.0;
    if (0.0 < c_d) {
        try stdout.print("drag constant:                {d}\n", .{c_d});
    } else {
        try stdout.print("ERROR - drag constant: {s}\n", .{args[4]});
        return;
    }

    // area cross section (m^2) - greater than zero
    const ac: f64 = std.fmt.parseFloat(f64, args[5]) catch 0.0;
    if (0.0 < ac) {
        try stdout.print("area (m^2):                   {d}\n", .{ac});
    } else {
        try stdout.print("ERROR - area: {s}\n", .{args[5]});
        return;
    }

    // mass (kg) - greater than zero
    const mo: f64 = std.fmt.parseFloat(f64, args[6]) catch 0.0;
    if (0.0 < mo) {
        try stdout.print("mass (kg):                    {d}\n", .{mo});
    } else {
        try stdout.print("ERROR - mass: {s}\n", .{args[6]});
        return;
    }

    // initial velocity (m/sec) - greater than zero
    var vn: f64 = std.fmt.parseFloat(f64, args[7]) catch 0.0;
    if (0.0 < vn) {
        try stdout.print("initial velocity (m/sec):     {d}\n", .{vn});
    } else {
        try stdout.print("ERROR - initial velocity: {s}\n", .{args[7]});
        return;
    }

    // drag constant
    const drgc: f64 = 0.5 * rho * c_d * ac;

    // initial drag force (kg*m/sec^2)
    var rn: f64 = drgc * (vn * vn);

    // initial acceleration (m/sec^2)
    var an: f64 = rn / mo;

    // total distance (m)
    var s_t: f64 = 0.0;

    var i: i64 = 0;
    var d_s: f64 = 0;
    while (i < cnt) {
        d_s = vn * d_t; // step distance
        vn = vn - (an * d_t); // new velocity (decreasing)
        rn = drgc * (vn * vn); // new drag force
        an = rn / mo; // new acceleration
        s_t += d_s; // total distance
        //std.debug.print("\n-- {d} {d} {d} {d}", .{ i, d_s, vn, s_t });
        i += 1;
    }

    try stdout.print("\ntotal distance (m):           {d}\n", .{s_t});
    try stdout.print("final velocity (m/sec):       {d}\n", .{vn});
    try stdout.print("final acceleration (m/sec^2): {d}\n", .{an});
    try stdout.print("final count:                  {d}\n", .{i});
}
