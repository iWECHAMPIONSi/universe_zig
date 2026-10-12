const std = @import("std");

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

pub const ProtoObject = struct {
    name: []const u8,
    mass: MassValue,
    radius: DistanceValue,

    const Self = @This();

    pub fn place(self: *const Self, position: Position, velocity: ?Velocity, velocity3: ?VelocityVector3, accel: ?Acceleration, accel3: AccelerationVector3) Object {
        return .{
            .name = self.name,
            .mass = self.mass,
            .position = position,
            .velocity = if (velocity != null) velocity.? else .{ .value = 0, .unit = .meter, .time = .second },
            .velocity3 = if (velocity3 != null) velocity3.? else .{
                .x = .{ .value = 0, .unit = .meter, .time = .second },
                .y = .{ .value = 0, .unit = .meter, .time = .second },
                .z = .{ .value = 0, .unit = .meter, .time = .second },
            },
            .acceleration = if (accel != null) accel.? else .{ .value = 0, .unit = .meter, .time = .second },
            .acceleration3 = if (accel3 != null) accel3.? else .{
                .x = .{ .value = 0, .unit = .meter, .time = .second },
                .y = .{ .value = 0, .unit = .meter, .time = .second },
                .z = .{ .value = 0, .unit = .meter, .time = .second },
            },
            .radius = self.radius,
        };
    }
};

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
