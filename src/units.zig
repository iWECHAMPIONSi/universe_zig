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

pub fn addDistance(a: *const DistanceValue, b: *const DistanceValue) DistanceValue {
    return .{
        .value = a.toMeter() + b.toMeter(),
        .unit = .meter,
    };
}

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

pub fn addMass(a: *const MassValue, b: *const MassValue) MassValue {
    return .{
        .value = a.toKilogram() + b.toKilogram(),
        .unit = .kilogram,
    };
}

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

pub fn addForce(a: *const ForceValue, b: *const ForceValue) ForceValue {
    return .{
        .value = a.toNewton() + b.toNewton(),
        .unit = .newton,
    };
}

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

pub fn addTime(a: *const TimeValue, b: *const TimeValue) TimeValue {
    return .{
        .value = a.toSecond() + b.toSecond(),
        .unit = .second,
    };
}

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

    const Self = @This();

    pub fn applyVelocityVector3(self: *Self, velocity: *const VelocityVector3, t: *const TimeValue) void {
        self.x.value = self.x.toMeter() + (velocity.x.toMeterPerSecond() * t.toSecond());
        self.x.unit = .meter;
        self.y.value = self.y.toMeter() + (velocity.y.toMeterPerSecond() * t.toSecond());
        self.y.unit = .meter;
        self.z.value = self.z.toMeter() + (velocity.z.toMeterPerSecond() * t.toSecond());
        self.z.unit = .meter;
    }
};

pub const Velocity = struct {
    value: f128,
    unit: Distance,
    time: Time,

    const Self = @This();

    pub fn toMeterPerSecond(self: *const Self) f128 {
        return Distance.toMeter(self.unit) * self.value / Time.toSecond(self.time);
    }

    pub fn changeUnit(self: *const Self, unit: Distance) Self {
        return .{
            .value = self.value * (Distance.toMeter(self.unit) / Distance.toMeter(unit)),
            .unit = unit,
            .time = self.time,
        };
    }

    pub fn changeTime(self: *const Self, unit: Time) Self {
        return .{
            .value = self.value * (Time.toSecond(unit) / Time.toSecond(self.time)),
            .unit = self.unit,
            .time = unit,
        };
    }

    pub fn applyAcceleration(self: *Self, acceleration: *const Acceleration, t: *const TimeValue) void {
        self.value = self.toMeterPerSecond() + acceleration.toMeterPerSecondSquared() * t.toSecond();
        self.unit = .meter;
        self.time = .second;
    }
};

pub fn addVelocity(a: *const Velocity, b: *const Velocity) Velocity {
    return .{
        .value = a.toMeterPerSecond() + b.toMeterPerSecond(),
        .unit = .meter,
        .time = .second,
    };
}

pub const VelocityVector3 = struct {
    x: Velocity,
    y: Velocity,
    z: Velocity,

    const Self = @This();

    pub fn applyAccelerationVector3(self: *Self, acceleration: *const AccelerationVector3, t: *const TimeValue) void {
        self.x.applyAcceleration(&acceleration.x, t);
        self.y.applyAcceleration(&acceleration.y, t);
        self.z.applyAcceleration(&acceleration.z, t);
    }
};

pub fn addVelocityVector3(a: *const VelocityVector3, b: *const VelocityVector3) VelocityVector3 {
    return .{
        .x = addVelocity(&a.x, &b.x),
        .y = addVelocity(&a.y, &b.y),
        .z = addVelocity(&a.z, &b.z),
    };
}

pub const Acceleration = struct {
    value: f128,
    unit: Distance,
    time: Time,

    const Self = @This();

    pub fn toMeterPerSecondSquared(self: *const Self) f128 {
        return Distance.toMeter(self.unit) * self.value / ((Time.toSecond(self.time) * Time.toSecond(self.time)));
    }

    pub fn changeUnit(self: *const Self, unit: Distance) Self {
        return .{
            .value = self.value * (Distance.toMeter(self.unit) / Distance.toMeter(unit)),
            .unit = unit,
            .time = self.time,
        };
    }

    pub fn changeTime(self: *const Self, unit: Time) Self {
        return .{
            .value = self.value * (Time.toSecond(unit) * Time.toSecond(unit)) / (Time.toSecond(self.time) * Time.toSecond(self.time)),
            .unit = self.unit,
            .time = unit,
        };
    }

    pub fn toVelocity(self: *const Self, t: *const TimeValue) Velocity {
        return .{
            .value = self.toMeterPerSecondSquared() * t.toSecond(),
            .unit = .meter,
            .time = .second,
        };
    }
};

pub fn addAcceleration(a: *const Acceleration, b: *const Acceleration) Acceleration {
    return .{
        .value = a.toMeterPerSecondSquared() + b.toMeterPerSecondSquared(),
        .unit = .meter,
        .time = .second,
    };
}
pub const AccelerationVector3 = struct {
    x: Acceleration,
    y: Acceleration,
    z: Acceleration,

    const Self = @This();

    pub fn toVelocityVector3(self: *const Self, t: *const TimeValue) VelocityVector3 {
        return .{
            .x = self.x.toVelocity(t),
            .y = self.y.toVelocity(t),
            .z = self.z.toVelocity(t),
        };
    }
};

pub fn addAccelerationVector3(a: *const AccelerationVector3, b: *const AccelerationVector3) AccelerationVector3 {
    return .{
        .x = addAcceleration(&a.x, &b.x),
        .y = addAcceleration(&a.y, &b.y),
        .z = addAcceleration(&a.z, &b.z),
    };
}

pub const Displacement = struct {
    x: DistanceValue,
    y: DistanceValue,
    z: DistanceValue,
};

pub fn addDisplacement(a: *const Displacement, b: *const Displacement) Displacement {
    return .{
        .x = addDistance(&a.x, &b.x),
        .y = addDistance(&a.y, &b.y),
        .z = addDistance(&a.z, &b.z),
    };
}

pub const ForceVector3 = struct {
    x: ForceValue,
    y: ForceValue,
    z: ForceValue,
};

pub fn addForceVector3(a: *const ForceVector3, b: *const ForceVector3) ForceVector3 {
    return .{
        .x = addForce(&a.x, &b.x),
        .y = addForce(&a.y, &b.y),
        .z = addForce(&a.z, &b.z),
    };
}

// =============== CONSTANTS =================

pub const g_constant: f128 = 6.6743e-11;
