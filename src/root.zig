const std = @import("std");
const ArrayList = std.ArrayList;

const errors = @import("errors.zig");
const StdErr = errors.StdErr;

const units = @import("units.zig");
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

const object = @import("object.zig");
const Object = object.Object;
const ProtoObject = object.ProtoObject;
const gravitationalForce = object.gravitationalForce;
const displacementDistance = object.displacementDistance;
const GravitationalForceValue = object.GravitationalForceValue;

pub var object_list: ArrayList(Object) = ArrayList(Object).empty;

pub fn updateObjects(allocator: std.mem.Allocator) StdErr!void {
    _ = allocator;
    for (0..object_list.items.len - 1, object_list.items[0 .. object_list.items.len - 1]) |index, i| {
        for (object_list.items[i + 1 .. object_list.items.len]) |j| {
            const result: GravitationalForceValue = try gravitationalForce(&i, &j);
        }
    }
}
