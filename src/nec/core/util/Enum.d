module nec.core.util.Enum;

import std.traits;

uint Count(T)()
{
	return T.max + 1;
}

unittest
{
	enum Dwarves
	{
		Doc, 
		Happy, 
		Bashful, 
		Sneezy, 
		Sleepy, 
		Grumpy,
		Dopey,
	}
	static assert(Count!Dwarves == 7);
}

Value[Enum.max+1] EnumMapToArray(Enum, Value)(const auto ref Value[Enum] map) pure
{
	Value[Enum.max+1] result;
	foreach(key, value; map)
	{
		result[key] = value;
	}
	return result;
}

unittest
{
	enum Countries
	{
		Canada,
		Japan,
		Mexico,
		Somalia,
		UnitedStates,
		Vanuatu,
	}
	with(Countries)
	{
		enum IsViolent = [ 
			Mexico: true,
			Somalia: true,
			UnitedStates: true,
		];
		static assert(EnumMapToArray!()(IsViolent) == [false, false, true, true, true, false]);
	}
}