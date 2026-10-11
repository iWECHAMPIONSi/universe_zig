const std = @import("std");
const math = std.math;

const units = @import("units.zig");
const Distance = units.Distance;
const DistanceValue = units.DistanceValue;
const Force = units.Force;
const ForceValue = units.ForceValue;
const Mass = units.Mass;
const MassValue = units.MassValue;
const Time = units.Time;
const TimeValue = units.TimeValue;
const Vector3 = units.Vector3;
const Velocity = units.Velocity;
const Acceleration = units.Acceleration;
const Position = units.Position;

pub const Object = struct {
    mass: MassValue,
    position: Position,
    velocity: Velocity,
    acceleration: Acceleration,
    radius: DistanceValue,
};

pub fn displacementDistance(i: *Object, j: *Object) struct { displacement: Vector3, distance: DistanceValue } {
    const delta: Vector3 = .{ .x = i.position.x.toMeter() - j.position.x.toMeter(), .y = i.position.y.toMeter() - j.position.y.toMeter(), .z = i.position.z.toMeter() - j.position.z.toMeter() };
    return .{ .displacement = delta, .distace = .{ .value = @sqrt(delta.x * delta.x + delta.y * delta.y + delta.z * delta.z), .unit = Distance.meter } };
}

pub fn gravitationalForce(i: *Object, j: *Object) struct { i: ForceValue, j: ForceValue } {
    const d: DistanceValue = displacementDistance(i, j);
}
