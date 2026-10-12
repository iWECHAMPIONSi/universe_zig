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
const gravitationalForce = object.gravitationalForce;
const displacementDistance = object.displacementDistance;
const GravitationalForceValue = object.GravitationalForceValue;

pub const solar_system_obj = @import("solar_system_obj.zig");

pub const update_rate: i64 = 10;

pub fn updateObjects(allocator: std.mem.Allocator, object_list: *ArrayList(*Object), elapsed_time: *const TimeValue) StdErr!void {
    const half_timestep: TimeValue = .{ .value = elapsed_time.toSecond(), .unit = .second };
    _ = allocator;
    for (object_list.items) |obj| {
        obj.kick(&half_timestep);
        obj.drift(elapsed_time);
    }
    for (0..object_list.items.len - 1, object_list.items[0 .. object_list.items.len - 1]) |index, i| {
        for (object_list.items[index + 1 .. object_list.items.len]) |j| {
            const result: GravitationalForceValue = try gravitationalForce(i, j);
            i.*.acceleration3 = units.addAccelerationVector3(&result.i.a3, &i.acceleration3);
            i.*.acceleration = units.addAcceleration(&i.acceleration, &result.i.a);
            i.*.force = units.addForce(&i.force, &result.i.f);
            i.*.force3 = units.addForceVector3(&i.force3, &result.i.f3);

            j.*.acceleration3 = units.addAccelerationVector3(&result.j.a3, &j.acceleration3);
            j.*.acceleration = units.addAcceleration(&j.acceleration, &result.j.a);
            j.*.force = units.addForce(&j.force, &result.j.f);
            j.*.force3 = units.addForceVector3(&j.force3, &result.j.f3);
        }
    }

    for (object_list.items) |obj| {
        obj.kick(&half_timestep);
    }
}
