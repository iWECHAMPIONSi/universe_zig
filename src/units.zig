// =================== UNITS ======================

pub const Distance = enum(i64) {
    meter = 1,
    kilometer = 1_000,
    megameter = 1_000_000,
    gigameter = 1_000_000_000,
    au = 149_597_870_700,

    pub fn toMeter(self: Distance) f80 {
        return @floatFromInt(@intFromEnum(self));
    }
};

pub const DistanceValue = struct {
    value: f80,
    unit: Distance,
    const Self = @This();

    pub fn toMeter(self: *Self) f80 {
        return Distance.toMeter(self.unit) * self.value;
    }

    pub fn convert(self: *Self, unit: Distance) f80 {
        return self.toMeter() / Distance.toMeter(unit);
    }
};

pub const Mass = enum(i64) {
    kilogram = 1,
    tonne = 1_000, // megagram
    gigagram = 1_000_000,
    solar_mass = 1_988_550_000_000_000_000_000_000_000_000,

    pub fn toKilogram(self: Mass) f80 {
        return @floatFromInt(@intFromEnum(self));
    }
};

pub const MassValue = struct {
    value: f80,
    unit: Mass,
    const Self = @This();

    pub fn toKilogram(self: *Self) f80 {
        return Mass.toKilogram(self.unit) * self.value;
    }

    pub fn convert(self: *Self, unit: Mass) f80 {
        return self.toKilogram() / Mass.toKilogram(unit);
    }
};

pub const Force = enum(i64) {
    newton = 1,

    pub fn toNewton(self: Force) f80 {
        return @floatFromInt(@intFromEnum(self));
    }
};

pub const ForceValue = struct {
    value: f80,
    unit: Force,
    const Self = @This();

    pub fn toNewton(self: *Self) f80 {
        return Force.toNewton(self.unit) * self.value;
    }

    pub fn convert(self: *Self, unit: Force) f80 {
        return self.toNewton() / Force.toNewton(unit);
    }
};

pub const Time = enum(i64) {
    second = 1,
    minute = 60,
    hour = 3_600,
    day = 86_400,
    year = 86_400 * 365,

    pub fn toSecond(self: Time) f80 {
        return @floatFromInt(@intFromEnum(self));
    }
};

pub const TimeValue = struct {
    value: f80,
    unit: Time,

    const Self = @This();

    pub fn toSecond(self: *Self) f80 {
        return Time.toSecond(self.unit) * self.value;
    }

    pub fn convert(self: *Self, unit: Time) f80 {
        return self.toSecond() / Time.toSecond(unit);
    }
};

pub const Vector3 = struct {
    x: f80,
    y: f80,
    z: f80,
};

// These are just Vector3s with different name to differentiate types

pub const Position = struct {
    x: DistanceValue,
    y: DistanceValue,
    z: DistanceValue,
};

pub const Velocity = struct {
    x: DistanceValue,
    y: DistanceValue,
    z: DistanceValue,
};

pub const Acceleration = struct {
    x: DistanceValue,
    y: DistanceValue,
    z: DistanceValue,
};

// =============== CONSTANTS =================

pub const g_constant: f80 = 0.000000006674;
