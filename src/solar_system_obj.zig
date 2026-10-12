const std = @import("std");

// const errors = @import("errors.zig");

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

pub const earth: ProtoObject = .{
    .name = "Earth",
    .mass = .{ .value = 5.972e21, .unit = .tonne },
    .radius = .{ .value = 6_371, .unit = .kilometer },
};

pub const sun: ProtoObject = .{
    .name = "Sun",
    .mass = .{ .value = 1, .unit = .solar_mass },
    .radius = .{ .value = 695_700, .unit = .kilometer },
};
