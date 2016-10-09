module nec.core.collections.Tree;

import std.algorithm.iteration;

struct Tree(T)
{
	T[] children;
	Tree!T[] subtrees;

	this(T[] children, Tree!T[] subtrees ...) pure
	{
		this(children, subtrees);
	}

	this(T[] children, Tree!T[] subtrees) pure
	{
		this.children = children;
		this.subtrees = subtrees;
	}
	// Intend this to be something like T[]
	const(T[]) descendants() const pure
	{
		return reduce!((a, b) => a ~ b)(children, subtrees.map!(t => t.descendants));
	}
	// Intend this to be something like T[]
	auto descendantsBreadthFirst() const pure
	{

	}
}
unittest
{
	static assert(Tree!int([5,7,9]).children == [5,7,9]);
	static assert(Tree!int([]).children == []);
	static assert(Tree!int([], Tree!int([1,2])).descendants == [1,2]);
	{
		enum myTree = Tree!int([5,7,9], [ Tree!int([5,7,9]) ] );
		static assert(myTree.descendants() == [5,7,9,5,7,9]);
	}
}

class parent
{
	static immutable string name = "parent";
	class child
 	{
 		static immutable string name = "child";
 	}
}
static assert(parent.child.name == "child");