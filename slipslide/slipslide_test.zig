const std = @import("std");
const expect = @import("std").testing.expect;

// slideslide0 for shooter marble as a zig test

test "shooter marble slip slide" {
    
    // Archimedes' constant (π)
    const pi = 3.14159265358979323846264338327950288419716939937510;

    // ρ air density (kg/m^3)	   
    // https://www.wolframalpha.com/input?i=air+density+at+sea+level+in+kilograms+per+cubic+meter
    const rho: f64 = 1.226;

    // glass density (kg/m^3)
    // https://www.wolframalpha.com/input?i=2520+kilograms+per+cubic+meter&assumption=%22ClashPrefs%22+-%3E+%22%22
    const gd: f64 = 2520.0;

    // radius shooter marble (m)
    // https://www.moonmarble.com/t2-marbleinfo.aspx
    const rm: f64 = 0.0095;

    // mass of shooter marble (kg)
    const mm: f64 = gd * (4.0/3.0) * pi * (rm * rm * rm);

    // area shooter marble (m^2)    
    const ma: f64 = pi * (rm * rm);

    // drag coefficient ideal sphere 
    // https://physics.info/drag/    
    const C: f64 = 0.5;

    // drag constant
    const drgc: f64 = 0.5 * rho * C * ma;

    // delta t (sec)
    const dT: f64 = 0.001;

    // iteration count - two hours at dT
    const cnt: i64 = 1000 * 3600 * 2;

    // initial velocity (m/sec)
    var vn: f64 = 1.0;

    // initial drag force (kg*m/sec^2)
    var rn: f64 = drgc * (vn * vn);

    // initial acceleration (m/sec^2)
    var an: f64 = rn/mm;

    // total distance (m)
    var S: f64 = 0.0;
    
    var i: i64 = 0;
    var dS: f64 = 0;
    while (i < cnt) {
        dS = vn * dT;           // step distance
        vn = vn - (an * dT);    // new velocity (decreasing)
        rn = drgc * (vn * vn);  // new drag force
        an = rn/mm;             // new acceleration
        S += dS;                // total distance
        i += 1;
    }
    try expect(i == 7200000);

    std.log.warn("\nfinal count: {}\n", .{i});
    std.log.warn("\nmarble mass: {}\n", .{mm});
    std.log.warn("\nmarble area: {}\n", .{ma});
    std.log.warn("\nfinal velocity: {}\n", .{vn});
    std.log.warn("\nfinal acceleration: {}\n", .{an});
    std.log.warn("\ntotal distance: {}\n", .{S});
}
