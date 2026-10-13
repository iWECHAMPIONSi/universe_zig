const std = @import("std");
const debugPrint = std.debug.print;

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

pub const Object = struct {
    name: []const u8,
    mass: MassValue,
    position: Position,
    velocity: Velocity,
    velocity3: VelocityVector3,
    acceleration: Acceleration,
    acceleration3: AccelerationVector3,
    force: ForceValue,
    force3: ForceVector3,
    radius: DistanceValue,
    const Self = @This();

    pub fn kick(self: *Self, half_timestep: *const TimeValue) void {
        self.velocity3.applyAccelerationVector3(&self.acceleration3, half_timestep);
    }

    pub fn drift(self: *Self, half_timestep: *const TimeValue) void {
        self.position.applyVelocityVector3(&self.velocity3, half_timestep);
    }

    pub fn print(self: *const Self) struct {
        f128,
        f128,
        f128,
        f128,
        f128,
        f128,
        f128,
        f128,
        f128,
        f128,
        f128,
    } {
        const str =
            \\name: {s}
            \\  position:
            \\    x: {}
            \\    y: {}
            \\    z: {}
            \\  mass: {} kg
            \\  radius: {} tonne
            \\  velocity: {} m/s
            \\  velocity3:
            \\    x: {} m/s
            \\    y: {} m/s
            \\    z: {} m/s
            \\  acceleration: {} m/s^2
            \\  acceleration3:
            \\    x: {} m/s^2
            \\    y: {} m/s^2
            \\    z: {} m/^2s
            \\
        ;
        // \\  force: {} N\n
        // \\  force3:\n
        // \\    x: {} N\n
        // \\    y: {} N\n
        // \\    z: {} N\n
        debugPrint(str, .{
            self.name,
            self.position.x.toMeter(),
            self.position.y.toMeter(),
            self.position.z.toMeter(),
            self.mass.toKilogram(),
            self.radius.toMeter(),
            self.velocity.toMeterPerSecond(),
            self.velocity3.x.toMeterPerSecond(),
            self.velocity3.y.toMeterPerSecond(),
            self.velocity3.z.toMeterPerSecond(),
            self.acceleration.toMeterPerSecondSquared(),
            self.acceleration3.x.toMeterPerSecondSquared(),
            self.acceleration3.y.toMeterPerSecondSquared(),
            self.acceleration3.z.toMeterPerSecondSquared(),
            // @trunc(self.position.x.toMeter()),
            // @trunc(self.position.y.toMeter()),
            // @trunc(self.position.z.toMeter()),
            // @trunc(self.mass.toKilogram()),
            // @trunc(self.radius.toMeter()),
            // @trunc(self.velocity.toMeterPerSecond()),
            // @trunc(self.velocity3.x.toMeterPerSecond()),
            // @trunc(self.velocity3.y.toMeterPerSecond()),
            // @trunc(self.velocity3.z.toMeterPerSecond()),
            // @trunc(self.acceleration.toMeterPerSecondSquared()),
            // @trunc(self.acceleration3.x.toMeterPerSecondSquared()),
            // @trunc(self.acceleration3.y.toMeterPerSecondSquared()),
            // @trunc(self.acceleration3.z.toMeterPerSecondSquared()),
            // self.force.toNewton()),
            // self.force3.x.toNewton()),
            // self.force3.y.toNewton()),
            // self.force3.z.toNewton()),
        });
        return .{
            self.position.x.toMeter(),
            self.position.y.toMeter(),
            self.position.z.toMeter(),
            self.velocity.toMeterPerSecond(),
            self.velocity3.x.toMeterPerSecond(),
            self.velocity3.y.toMeterPerSecond(),
            self.velocity3.z.toMeterPerSecond(),
            self.acceleration.toMeterPerSecondSquared(),
            self.acceleration3.x.toMeterPerSecondSquared(),
            self.acceleration3.y.toMeterPerSecondSquared(),
            self.acceleration3.z.toMeterPerSecondSquared(),
        };
    }
};

pub const ProtoObject = struct {
    name: []const u8,
    mass: MassValue,
    radius: DistanceValue,

    const Self = @This();

    pub fn place(self: *const Self, position: Position, velocity: ?Velocity, velocity3: ?VelocityVector3) Object {
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
            .acceleration = .{ .value = 0, .unit = .meter, .time = .second },
            .acceleration3 = .{
                .x = .{ .value = 0, .unit = .meter, .time = .second },
                .y = .{ .value = 0, .unit = .meter, .time = .second },
                .z = .{ .value = 0, .unit = .meter, .time = .second },
            },
            .force = .{ .value = 0, .unit = .newton },
            .force3 = .{
                .x = .{ .value = 0, .unit = .newton },
                .y = .{ .value = 0, .unit = .newton },
                .z = .{ .value = 0, .unit = .newton },
            },
            .radius = self.radius,
        };
    }
};

pub fn displacementDistance(i: *const Object, j: *const Object) struct { displacement: Displacement, distance: DistanceValue } {
    const delta: Vector3 = .{ .x = j.position.x.toMeter() - i.position.x.toMeter(), .y = j.position.y.toMeter() - i.position.y.toMeter(), .z = j.position.z.toMeter() - i.position.z.toMeter() };
    return .{
        .displacement = .{ .x = .{ .value = delta.x, .unit = .meter }, .y = .{ .value = delta.y, .unit = .meter }, .z = .{ .value = delta.z, .unit = .meter } },
        .distance = .{ .value = @sqrt(delta.x * delta.x + delta.y * delta.y + delta.z * delta.z), .unit = .meter },
    };
}

pub const GravitationalForceValue = struct {
    i: struct {
        a: Acceleration,
        a3: AccelerationVector3,
        f: ForceValue,
        f3: ForceVector3,
    },
    j: struct {
        a: Acceleration,
        a3: AccelerationVector3,
        f: ForceValue,
        f3: ForceVector3,
    },
};

pub fn gravitationalForce(
    i: *const Object,
    j: *const Object,
) StdErr!GravitationalForceValue {
    const d = displacementDistance(i, j);

    const displacement: Displacement = d.displacement;
    const magnitude: f128 = d.distance.value;

    if (magnitude == 0.0 or !std.math.isFinite(magnitude)) {
        return StdErr.InvalidStateReached;
    }

    const inverse_r: f128 = 1.0 / magnitude;
    const inverse_r_squared: f128 = inverse_r * inverse_r;
    const inverse_r_cubed: f128 = inverse_r_squared * inverse_r;

    const mass_i: f128 = i.mass.toKilogram();
    const mass_j: f128 = j.mass.toKilogram();

    const c1: f128 = units.g_constant * mass_j * inverse_r_cubed;
    const c2: f128 = -units.g_constant * mass_i * inverse_r_cubed;
    const c_force: f128 = units.g_constant * mass_i * mass_j * inverse_r_cubed;

    const i_accel3: AccelerationVector3 = .{
        .x = .{ .value = c1 * displacement.x.value, .unit = .meter, .time = .second },
        .y = .{ .value = c1 * displacement.y.value, .unit = .meter, .time = .second },
        .z = .{ .value = c1 * displacement.z.value, .unit = .meter, .time = .second },
    };

    const j_accel3: AccelerationVector3 = .{
        .x = .{ .value = c2 * displacement.x.value, .unit = .meter, .time = .second },
        .y = .{ .value = c2 * displacement.y.value, .unit = .meter, .time = .second },
        .z = .{ .value = c2 * displacement.z.value, .unit = .meter, .time = .second },
    };

    const i_accel: Acceleration = .{
        .value = @sqrt(
            i_accel3.x.value * i_accel3.x.value +
                i_accel3.y.value * i_accel3.y.value +
                i_accel3.z.value * i_accel3.z.value,
        ),
        .unit = .meter,
        .time = .second,
    };

    const j_accel: Acceleration = .{
        .value = @sqrt(
            j_accel3.x.value * j_accel3.x.value +
                j_accel3.y.value * j_accel3.y.value +
                j_accel3.z.value * j_accel3.z.value,
        ),
        .unit = .meter,
        .time = .second,
    };

    const force: ForceValue = .{
        .value = units.g_constant * mass_i * mass_j * inverse_r_squared,
        .unit = .newton,
    };

    const i_force_vector: ForceVector3 = .{
        .x = .{ .value = c_force * displacement.x.value, .unit = .newton },
        .y = .{ .value = c_force * displacement.y.value, .unit = .newton },
        .z = .{ .value = c_force * displacement.z.value, .unit = .newton },
    };

    const j_force_vector: ForceVector3 = .{
        .x = .{ .value = -i_force_vector.x.value, .unit = .newton },
        .y = .{ .value = -i_force_vector.y.value, .unit = .newton },
        .z = .{ .value = -i_force_vector.z.value, .unit = .newton },
    };

    return .{
        .i = .{
            .a = i_accel,
            .a3 = i_accel3,
            .f = force,
            .f3 = i_force_vector,
        },
        .j = .{
            .a = j_accel,
            .a3 = j_accel3,
            .f = force,
            .f3 = j_force_vector,
        },
    };
}
