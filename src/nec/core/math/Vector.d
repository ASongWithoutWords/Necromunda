module nec.core.math.Vector;

import std.conv;
import std.traits;

import nec.core.math.Scalar;

import nec.core.util.StaticRange;

alias Vector2(T) = Vector!(2, T);
alias Vector3(T) = Vector!(3, T);


Vector!(T.length, typeof(T[0])) Vector(T...)()
	if(T.length > 0)
{
	Vector!(T.length, typeof(T[0])) vec;
	foreach(i, t; T)
	{
		vec[i] = t;
	}
	//vec.values = values;
	return vec;
}
unittest
{
	static assert(Vector!(4, 5, 7)[0] == 4);
	static assert(Vector!(2.m, 3.m, 4.m)[1] == 3.m);
}

Vector!(size, T) Vector(T, uint size)(T[size] values ...)
{
	Vector!(size, T) vec;
	vec.values = values;
	return vec;
}

struct Vector(uint size, T)
	//if(isNumeric!T)
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
}
unittest
{
    //alias Vector2!int V2i;

    // Construction
    static assert(Vector!(1, 7).values == [1,7]);

    // Generic vector construction
    static assert(Vector!(3, 2, 1) == Vector3!int(3, 2, 1));

    // Indexing
 	static assert(Vector!(1, 7)[1] == 7);

    // Index assignment
    {
        Vector2!int BuildWithIndexAssign(int a, int b) pure
        {
            Vector2!int v;
            v[0] = a;
            v[1] = b;
            return v;
        }
        enum v = BuildWithIndexAssign(2, 3);
        static assert(v[0] == 2 && v[1] == 3);
    }

    // Equality
    static assert(Vector!(2,-7) == Vector!(2,-7));
    static assert(Vector!(3, 4) != Vector!(4, 5));

    // Negation
	static assert(-Vector!(-2, 3) == Vector!(2,-3));

    // Addition/Subtraction
	static assert(Vector!(4, 5) + Vector!(5, 6) == Vector!(9, 11));
	static assert(Vector!(7,-1) + Vector!(-3, 4) == Vector!(4, 3));
	static assert(Vector!(7, 1) - Vector!(5, -1) == Vector!(2, 2));

	// Scalar multiplication and division
	static assert(Vector!(2,4) * 2 == Vector!(4,8));
    static assert(Vector!(4, 16) / 2 == Vector!(2,8));
    static assert(2 * Vector!(2,4) == Vector!(4,8));
    static assert(3 * Vector!(1, 7) == Vector!(3,21));


}
