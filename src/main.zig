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
            .x = .{ .value = 29.79, .unit = .kilometer, .time = .second },
            .y = .{
                .value = 0,
                .unit = .meter,
                .time = .second,
            },
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

    for (0..(@as(usize, @trunc(Time.toSecond(.year))) * 2)) |_| {
        const start = now.toMilliseconds();
        try universe_zig.updateObjects(allocator, &object_list, &time_interval);
        for (object_list.items) |obj| {
            obj.print();
        }

        try io.sleep(
            .fromMilliseconds(@max(0, update_rate - (now.toMilliseconds() - start))),
            .awake,
        );
    }
}
