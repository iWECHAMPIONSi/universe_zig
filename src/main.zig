const std = @import("std");
const Io = std.Io;
const ArrayList = std.ArrayList;

const universe_zig = @import("universe_zig");

const units = universe_zig.units;
const Distance = units.Distance;
const DistanceValue = units.DistanceValue;
const Force = units.Force;
const ForceValue = units.ForceValue;
const ForceVector3 = units.ForceVector3;
const Mass = units.Mass;
const MassValue = units.MassValue;
const Time = units.Time;
const TimeValue = units.TimeValue;
const Vector3 = units.Vector3;
const Velocity = units.Velocity;
const VelocityVector3 = units.VelocityVector3;
const Acceleration = units.Acceleration;
const AccelerationVector3 = units.AccelerationVector3;
const Position = units.Position;
const Displacement = units.Displacement;

const object = universe_zig.object;
const Object = object.Object;
const ProtoObject = object.ProtoObject;

const solar_system_obj = universe_zig.solar_system_obj;

const update_rate: i64 = @divFloor(1000, universe_zig.update_rate);

pub fn main(init: std.process.Init) !void {
    const allocator = init.gpa;
    var object_list: ArrayList(*Object) = ArrayList(*Object).empty;
    defer object_list.deinit(allocator);
    var io: Io = init.io;
    var earth: Object = solar_system_obj.earth.place(
        .{
            .x = .{
                .value = 1,
                .unit = .au,
            },
            .y = .{
                .value = 0,
                .unit = .meter,
            },
            .z = .{
                .value = 0,
                .unit = .meter,
            },
        },
        null,
        .{
            .x = .{
                .value = 0,
                .unit = .meter,
                .time = .second,
            },
            .y = .{ .value = 29.79, .unit = .kilometer, .time = .second },
            .z = .{
                .value = 0,
                .unit = .meter,
                .time = .second,
            },
        },
    );
    var sun: Object = solar_system_obj.sun.place(
        .{
            .x = .{
                .value = 0,
                .unit = .meter,
            },
            .y = .{
                .value = 0,
                .unit = .meter,
            },
            .z = .{
                .value = 0,
                .unit = .meter,
            },
        },
        null,
        null,
    );
    try object_list.append(allocator, &earth);
    try object_list.append(allocator, &sun);

    const time_interval: TimeValue = .{ .value = 1, .unit = .hour };
    const now = Io.Clock.real.now(io);

    for (0..object_list.items.len - 1, object_list.items[0 .. object_list.items.len - 1]) |index, i| {
        for (object_list.items[index + 1 .. object_list.items.len]) |j| {
            const result: universe_zig.GravitationalForceValue = try universe_zig.gravitationalForce(i, j);
            i.*.acceleration3 = units.addAccelerationVector3(&result.i.a3, &i.acceleration3);
            i.*.force3 = units.addForceVector3(&i.force3, &result.i.f3);

            j.*.acceleration3 = units.addAccelerationVector3(&result.j.a3, &j.acceleration3);
            j.*.force3 = units.addForceVector3(&j.force3, &result.j.f3);
        }
    }

    for (0..(@as(usize, @trunc(Time.toSecond(.year) / Time.toSecond(.hour))) * 2)) |h| {
        const start = now.toMilliseconds();
        try universe_zig.updateObjects(allocator, &object_list, &time_interval);

        std.debug.print("\nDay: {} Hour: {}\n", .{ h / 24, @mod(h, 24) });

        for (object_list.items) |obj| {
            const ax = obj.acceleration3.x.toMeterPerSecondSquared();
            const ay = obj.acceleration3.y.toMeterPerSecondSquared();
            const az = obj.acceleration3.z.toMeterPerSecondSquared();

            obj.acceleration = .{
                .value = @sqrt(ax * ax + ay * ay + az * az),
                .unit = .meter,
                .time = .second,
            };

            const fx = obj.force3.x.toNewton();
            const fy = obj.force3.y.toNewton();
            const fz = obj.force3.z.toNewton();

            obj.force = .{
                .value = @sqrt(fx * fx + fy * fy + fz * fz),
                .unit = .newton,
            };
            _ = obj.print();
        }

        try io.sleep(
            .fromMilliseconds(@max(0, update_rate - (now.toMilliseconds() - start))),
            .awake,
        );
    }
}
