const std = @import("std");
const ArrayList = std.ArrayList;

pub const errors = @import("errors.zig");
const StdErr = errors.StdErr;

pub const units = @import("units.zig");
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

pub const object = @import("object.zig");
const Object = object.Object;
const ProtoObject = object.ProtoObject;
pub const gravitationalForce = object.gravitationalForce;
const displacementDistance = object.displacementDistance;
pub const GravitationalForceValue = object.GravitationalForceValue;

pub const solar_system_obj = @import("solar_system_obj.zig");

pub const update_rate: i64 = 24 * 7;
pub fn calculateGravity(objects: []const *Object) StdErr!void {
    for (objects) |obj| {
        obj.acceleration3 = .{
            .x = .{ .value = 0, .unit = .meter, .time = .second },
            .y = .{ .value = 0, .unit = .meter, .time = .second },
            .z = .{ .value = 0, .unit = .meter, .time = .second },
        };

        obj.force3 = .{
            .x = .{ .value = 0, .unit = .newton },
            .y = .{ .value = 0, .unit = .newton },
            .z = .{ .value = 0, .unit = .newton },
        };

        obj.acceleration = .{
            .value = 0,
            .unit = .meter,
            .time = .second,
        };

        obj.force = .{
            .value = 0,
            .unit = .newton,
        };
    }

    for (objects, 0..) |i, index| {
        for (objects[index + 1 ..]) |j| {
            const result = try gravitationalForce(i, j);

            i.acceleration3 = units.addAccelerationVector3(
                &i.acceleration3,
                &result.i.a3,
            );

            j.acceleration3 = units.addAccelerationVector3(
                &j.acceleration3,
                &result.j.a3,
            );

            i.force3 = units.addForceVector3(
                &i.force3,
                &result.i.f3,
            );

            j.force3 = units.addForceVector3(
                &j.force3,
                &result.j.f3,
            );
        }
    }

    for (objects) |obj| {
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
    }
}

pub fn updateObjects(allocator: std.mem.Allocator, object_list: *ArrayList(*Object), elapsed_time: *const TimeValue) StdErr!void {
    _ = allocator;
    const half_timestep: TimeValue = .{ .value = elapsed_time.toSecond() / 2.0, .unit = .second };

    for (object_list.items) |obj| {
        obj.kick(&half_timestep);
    }

    for (object_list.items) |obj| {
        obj.drift(elapsed_time);
    }

    try calculateGravity(object_list.items);

    for (object_list.items) |obj| {
        obj.kick(&half_timestep);
    }
}
