module nec.core.collections.Queue;

import std.algorithm;
import std.conv;

private enum minCapacity = 8;
private enum growthFactor = 1.6;

class Queue(T)
{
	this() pure {}

	private
	{
		size_t front = 0;
		size_t count = 0;
		size_t capacity = 0;
		T[] buffer;
	}

	size_t length() const pure { return count; }

	private size_t back() const pure
	{
		return capacity == 0 ? front : (front + count) % capacity;
	}

	auto values() const pure
	{
		if(front <= back)
		{
			return buffer[front..back];
		}
		else
		{
			return buffer[front..capacity] ~ buffer[0..back];
		}
	}

	bool isEmpty() const pure
	{
		return count == 0;
	}

	T first() const pure
	{
		assert(!isEmpty);
		return buffer[front];
	}

	T last() const pure
	{
		assert(!isEmpty);
		return buffer[back-1];
	}

	private void resizeBuffer(size_t newCapacity) pure
	{
		T[] newBuffer;
		newBuffer.length = newCapacity; // TODO: or should reserve(newCap);?
		newBuffer[0..count] = values[0..$];
		front = 0;
		buffer = newBuffer;
		capacity = newCapacity;
	}

	auto ref pushBack(T t) pure
	{
		void growIfNecessary() pure
		{
			if(count + 1 <= capacity)
			{
				return;
			}
			const size_t newCap = count + 1 < minCapacity ?
				minCapacity : to!size_t(capacity * growthFactor);
			resizeBuffer(newCap);
		}
		growIfNecessary();

		buffer[back] = t;  // weirdness happens if front == back
		count++;
		return this;
	}

	T popFront() pure
	{
		assert(!isEmpty);
		void shrinkIfNecessary() pure
		{
			if(count*growthFactor > capacity) return;
			const size_t newCap = max(to!size_t(count*growthFactor), minCapacity);
			if(buffer.capacity <= newCap)
			{
				return;
			}
			else
			{
				// TODO
			}
		}
		shrinkIfNecessary();
		auto valueToPop = first;
		count--;
		front++;
		return valueToPop;
	}
}

unittest
{
	bool emptyTest() pure
	{
		return (new Queue!int()).isEmpty();
	}
	static assert(emptyTest());

	{
		bool emptyValuesTest() pure
		{
			return (new Queue!int()).values == [];
		}
		static assert(emptyValuesTest());
	}


	// Queue!int makeQueueWithPushNoResize() pure
	// {
	// 	auto queue = new Queue!int();
	// 	int[] arr;// = new int[];
	// 	arr.length = 1;
	// 	foreach(i; 0..1)//minSize)
	// 	{
	// 		arr[i] = i;
	// 		queue.pushBack(i);
	// 	}
	// 	//pragma(msg, queue.values);
	// 	//pragma(msg, arr);
	// 	return queue.values == arr;
	// }
	// static assert(pushTestWithoutResize());

	{
		Queue!int makeQueueWithPushNoResize() pure
		{
			auto queue = new Queue!int();
			return queue
				.pushBack(1)
				.pushBack(1)
				.pushBack(2)
				.pushBack(3)
				.pushBack(5);
		}
		static const queue = makeQueueWithPushNoResize();
		pragma(msg, queue.values);
		static assert(queue.values == [1,1,2,3,5]);
	}

	{
		// Give it enough values that it is forced to resize: twice
		Queue!int makeQueueWithPushResize()
		{
			auto queue = new Queue!int();
			return queue
				.pushBack(1)
				.pushBack(1)
				.pushBack(2)
				.pushBack(3)
				.pushBack(5)
				.pushBack(8)
				.pushBack(13)
				.pushBack(21)
				.pushBack(34)
				.pushBack(55)
				.pushBack(89)
				.pushBack(144)
				.pushBack(233)
				.pushBack(377);
		}
		static const queue = makeQueueWithPushResize();
		pragma(msg, queue.values);
		static assert(queue.values == [1,1,2,3,5,8,13,21,34,55,89,144,233,377]);
	}

	//assert(pushTest());
}
