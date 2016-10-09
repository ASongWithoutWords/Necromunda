module nec.core.util.Array;

T first(T)(const T[] arr) pure
{
	return arr[0];
}
unittest
{
	static assert([4, 7, 1, 9].first == 4);
	static assert([5, 8, 2, 1].first == 5);
}
T last(T)(const T[] arr) pure
{
	return arr[$-1];
}
unittest
{
	static assert([9,8,1,3].last == 3);
	static assert([2,9,3,0].last == 0);
}
T[] nil(T)()
{
	T[] arr;
	return arr;
}
unittest
{
	static assert(nil!int == []);
}
bool isEmpty(T)(const T[] arr) pure
{
	return arr.length == 0;
}
unittest
{
	static assert(nil!int.isEmpty);
	static assert(([4,2,1])[1..1].isEmpty);
}
auto ref T[] push(T)(auto ref T[] arr, T elem) pure
{
	arr ~= elem;
	return arr;
}
unittest
{
	static assert(nil!int.push(1).push(2) == [1,2]);
	static assert([5,4].push(7) == [5,4,7]);
	bool pushTest()
	{
		int[] arr;
		arr.push(1).push(1);
		arr.push(2).push(3);
		arr.push(5).push(8);
		arr.push(13).push(21);
		arr.push(34);
		return arr == [1,1,2,3,5,8,13,21,34];
	}
	static assert(pushTest());
}
T pop(T)(auto ref T[] arr) pure
{
	assert(!arr.isEmpty);
	T elem = arr.last;
	arr = arr[0..$-1];
	return elem;
}
unittest
{
	static assert([5,1].pop == 1);
	static assert([4,9].pop == 9);
	bool popTest() pure
	{
		auto arr = [5,4,3,2,1];
		assert(arr.pop == 1);
		assert(arr == [5,4,3,2]);
		assert(arr.pop == 2);
		assert(arr == [5,4,3]);
		assert(arr.pop == 3);
		assert(arr == [5,4]);
		assert(arr.pop == 4);
		assert(arr == [5]);
		assert(arr.pop == 5);
		return arr == [];
	}
	static assert(popTest());
}