// =================== UNITS ======================

pub const Distance = enum(i113) {
    meter = 1,
    kilometer = 1_000,
    megameter = 1_000_000,
    gigameter = 1_000_000_000,
    au = 149_597_870_700,

    pub fn toMeter(self: Distance) f128 {
        return @floatFromInt(@intFromEnum(self));
    }
};

pub const DistanceValue = struct {
    value: f128,
    unit: Distance,
    const Self = @This();

    pub fn toMeter(self: *const Self) f128 {
        return Distance.toMeter(self.unit) * self.value;
    }

    pub fn convert(self: *const Self, unit: Distance) f128 {
        return self.toMeter() / Distance.toMeter(unit);
    }
};

pub const Mass = enum(i113) {
    kilogram = 1,
    tonne = 1_000, // megagram
    gigagram = 1_000_000,
    solar_mass = 1_988_550_000_000_000_000_000_000_000_000,

    pub fn toKilogram(self: Mass) f128 {
        return @floatFromInt(@intFromEnum(self));
    }
};

pub const MassValue = struct {
    value: f128,
    unit: Mass,
    const Self = @This();

    pub fn toKilogram(self: *const Self) f128 {
        return Mass.toKilogram(self.unit) * self.value;
    }

    pub fn convert(self: *const Self, unit: Mass) f128 {
        return self.toKilogram() / Mass.toKilogram(unit);
    }
};

pub const Force = enum(i113) {
    newton = 1,

    pub fn toNewton(self: Force) f128 {
        return @floatFromInt(@intFromEnum(self));
    }
};

pub const ForceValue = struct {
    value: f128,
    unit: Force,
    const Self = @This();

    pub fn toNewton(self: *const Self) f128 {
        return Force.toNewton(self.unit) * self.value;
    }

    pub fn convert(self: *const Self, unit: Force) f128 {
        return self.toNewton() / Force.toNewton(unit);
    }
};

pub const Time = enum(i113) {
    second = 1,
    minute = 60,
    hour = 3_600,
    day = 86_400,
    year = 31_557_600,

    pub fn toSecond(self: Time) f128 {
        return @floatFromInt(@intFromEnum(self));
    }
};

pub const TimeValue = struct {
    value: f128,
    unit: Time,

    const Self = @This();

    pub fn toSecond(self: *const Self) f128 {
        return Time.toSecond(self.unit) * self.value;
    }

    pub fn convert(self: *const Self, unit: Time) f128 {
        return self.toSecond() / Time.toSecond(unit);
    }
};

pub const Vector3 = struct {
    x: f128,
    y: f128,
    z: f128,
};

// These are to ensure correct types/units are used in equations

pub const Position = struct {
    x: DistanceValue,
    y: DistanceValue,
    z: DistanceValue,
};

pub const Velocity = struct {
    value: f128,
    unit: Distance,
    time: Time,

    const Self = @This();

    pub fn toMeter(self: *const Self) f128 {
        return Distance.toMeter(self.unit) * self.value;
    }

    pub fn convert(self: *const Self, unit: Distance) f128 {
        return self.toMeter() / Distance.toMeter(unit);
    }
};

pub const VelocityVector3 = struct {
    x: Velocity,
    y: Velocity,
    z: Velocity,
};

pub const Acceleration = struct {
    value: f128,
    unit: Distance,
    time: Time,

    const Self = @This();

    pub fn toMeter(self: *const Self) f128 {
        return Distance.toMeter(self.unit) * self.value;
    }

    pub fn convert(self: *const Self, unit: Distance) f128 {
        return self.toMeter() / Distance.toMeter(unit);
    }
};

pub const AccelerationVector3 = struct {
    x: Acceleration,
    y: Acceleration,
    z: Acceleration,
};

pub const Displacement = struct {
    x: DistanceValue,
    y: DistanceValue,
    z: DistanceValue,
};

pub const ForceVector3 = struct {
    x: ForceValue,
    y: ForceValue,
    z: ForceValue,
};

// =============== CONSTANTS =================

pub const g_constant: f128 = 0.00000000006674;
