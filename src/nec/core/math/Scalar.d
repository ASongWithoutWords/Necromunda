module nec.core.math.Scalar;

import std.conv;

import nec.core.math.Vector;
import nec.core.util.Enum;

private enum Unit
{
	radians,	// angle
	meters,     // displacement
	pixels,
	kilograms,	// mass
	seconds     // time
}
private enum numUnits = Unit.max + 1;

alias Units = Vector!(numUnits, int);

struct Scalar(Units units)
{
	private alias Scalar!units This;
	real value;
	this(real value)
	{
		this.value = value;
	}
	auto opBinary(string op, Units rhsUnits)(Scalar!(rhsUnits) rhs) const pure
	{
		static if(op == "+" && rhsUnits == units) return Scalar!(units)(value+rhs.value);
		static if(op == "-" && rhsUnits == units) return Scalar!(units)(value-rhs.value);
		static if(op == "*") return Scalar!(units + rhsUnits)(value*rhs.value);
		static if(op == "/") return Scalar!(units - rhsUnits)(value/rhs.value);
	}
	int toInt()
	{
		return to!int(value);
	}
}
unittest
{
    static assert(6.s - 1.s == 5.s);
    static assert(2.m * 5.m == 10.m2);
    static assert(2.m + 5.m == 7.m);
    static assert(2.N * 5.s == 10.kg_m_per_s);
    static assert(2.m / 5.s == 0.4.m_per_s);
}

alias Scalar(int[Unit] units) = Scalar!(Vector!()(EnumMapToArray!()(units)));

// Angle
//enum RadianDim = [Unit.radians: 1];
//struct Scalar(RadianDim)
//{
//    
//}
//alias Scalar!RadianDim Radians;

//mixin template Declare(string name, string symbol, string units)
//{
//
//}

mixin template Declare(string name, string symbol, string units)
{
    mixin("alias Scalar!(["~units~"]) "~name~";");
    mixin("auto "~symbol~"(real r) { return "~name~"(r); }");
}
//
//private string Declare(string name, string symbol, string units) pure
//{
//	return
//}


// Length
mixin Declare!("Meters",					"m",			"Unit.meters: 1");
mixin Declare!("Pixels",					"px",			"Unit.pixels: 1");

// Mass
mixin Declare!("Kilograms",					"kg",			"Unit.kilograms: 1");

// Time
mixin Declare!("Seconds",					"s",			"Unit.seconds: 1");

// Area
mixin Declare!("MetersSquared",				"m2",			"Unit.meters: 2");
mixin Declare!("PixelsSquared",				"px2",			"Unit.pixels: 2");

// Length ratios
mixin Declare!("MetersPerPixel",			"m_per_px",		"Unit.meters: 1, Unit.pixels: -1");
mixin Declare!("PixelsPerMeter",			"px_per_m",		"Unit.pixels: 1, Unit.meters: -1");

// Velocity
mixin Declare!("MetersPerSecond",		    "m_per_s",		"Unit.meters: 1, Unit.seconds: -1");
mixin Declare!("PixelsPerSecond",		    "px_per_s",		"Unit.pixels: 1, Unit.seconds: -1");

// Acceleration
mixin Declare!("MetersPerSecondSquared",	"m_per_s2",		"Unit.meters: 1, Unit.seconds: -2");
mixin Declare!("PixelsPerSecondSquared",	"px_per_s2",	"Unit.pixels: 1, Unit.seconds: -2");

// Momentum
mixin Declare!("KilogramMetersPerSecond",   "kg_m_per_s",	"Unit.kilograms: 1, Unit.meters: 1, Unit.seconds: -1");
mixin Declare!("KilogramPixelsPerSecond",	"kg_px_per_s",	"Unit.kilograms: 1, Unit.pixels: 1, Unit.seconds: -1");

// Force
mixin Declare!("Newtons",					"N",			"Unit.kilograms: 1, Unit.meters: 1, Unit.seconds: -2");
mixin Declare!("PixelNewtons",				"N_px",			"Unit.kilograms: 1, Unit.pixels: 1, Unit.seconds: -2");

// Energy
mixin Declare!("Joules",					"J",			"Unit.kilograms: 1, Unit.meters: 2, Unit.seconds: -2");
mixin Declare!("PixelJoules",				"J_px",			"Unit.kilograms: 1, Unit.pixels: 2, Unit.seconds: -2");

// Power
mixin Declare!("Watts",						"W",			"Unit.kilograms: 1, Unit.meters: 2, Unit.seconds: -3");
mixin Declare!("PixelWatts",				"W_px",			"Unit.kilograms: 1, Unit.pixels: 2, Unit.seconds: -3");
