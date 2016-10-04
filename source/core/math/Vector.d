module core.math.Vector;

import std.conv;
import std.traits;

import core.util.StaticRange;

alias Vector2(T) = Vector!(2, T);
alias Vector3(T) = Vector!(3, T);


Vector!(size, T) Vector(T, uint size)(T[size] values)
{
	Vector!(size, T) vec;
	vec.values = values;
	return vec;
}

Vector!(size, T) Vector(T, uint size)(T[size] values ...)
{
	Vector!(size, T) vec;
	vec.values = values;
	return vec;
}

struct Vector(uint size, T)
	if(isNumeric!T)
{
	private alias Vector!(size, T) This;
	
	public T[size] values;
	this(T[size] args) pure
	{
		values = args;
	}
	this(T[size] args ...) pure
	{
		values = args;
	}

	T opIndex(uint index) const pure
	{
		return values[index];
	}

	T opIndexAssign(T value, uint index) pure
	{
		return values[index] = value;
	}
	
	bool opEquals()(auto ref const This rhs) const pure
	{
		foreach(i; StaticRange!(0, size))
		{
			if(this[i] != rhs[i]) return false;
		}
		return true;
	}

	This opUnary(string op)() const pure
		if(op == "-")
	{
		This result;
		foreach(i; StaticRange!(0,size))
		{
			result[i] = -this[i];
		}
		return result;
	}


	This opBinary(string op)(This rhs) const pure
		if(op == "+" || op == "-")
	{
		This result;
		foreach(i; StaticRange!(0,size))
		{
			mixin("result[i] = this[i]"~op~"rhs[i];");
		}
		return result;
	}
	unittest
	{
		static assert(V2i(4, 5) + V2i(5, 6) == V2i(9, 11));
		static assert(V2i(7,-1) + V2i(-3, 4) == V2i(4, 3));
		static assert(V2i(7, 1) - V2i(5, -1) == V2i(2, 2));
	}

    // TODO: Ian - fix this, is not necessarily T, can be any scalar.
	This opBinary(string op)(T rhs) const pure
		if(isNumeric!T && (op == "*" || op == "/"))
	{
		This result;
		foreach(i; StaticRange!(0,size))
		{
			mixin("result[i] = this[i]"~op~"rhs;");
		}
		return result;
	}
	unittest
	{
		static assert(V2i(2,4) * 2 == V2i(4,8));
		static assert(V2i(4, 16) / 2 == V2i(2,8));
	}

	This opBinaryRight(string op)(T rhs) const pure
		if(isNumeric!T && (op == "*"))
	{
		This result;
		foreach(i; StaticRange!(0,size))
		{
			result[i] = this[i] * rhs;
		}
		return result;
	}
	unittest
	{
		static assert(2 * V2i(2,4) == V2i(4,8));
		static assert(3 * V2i(1, 7) == V2i(3,21));
	}
}
unittest
{
    alias Vector2!int V2i;

    // Constructor
    static assert(V2i(1, 7).values == [1,7]);

    // Generic vector construction
    static assert(Vector!()([3, 2, 1]) == Vector3!int(3, 2, 1)); // TODO: can be improved on?

    // Indexing
 	static assert(V2i(1, 7)[1] == 7);

    // Index assignment
    {
        V2i BuildWithIndexAssign(int a, int b) pure
        {
            V2i v;
            v[0] = a;
            v[1] = b;
            return v;
        }
        static assert(BuildWithIndexAssign(2,3) == V2i(2, 3));
    }

    // Equality operator
    static assert(V2i(2,-7) == V2i(2,-7));
    static assert(V2i(3,4) != V2i(4,5));


	static assert(-V2i(-2, 3) == V2i(2,-3));
}
