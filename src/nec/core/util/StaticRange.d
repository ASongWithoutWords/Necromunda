module nec.core.util.StaticRange;

import std.typetuple: TypeTuple;
import std.traits: isArray;

template StaticRange(int start, int stop) {
    static if (stop <= start)
        alias TypeTuple!() StaticRange;
    else
        alias TypeTuple!(StaticRange!(start, stop-1), stop-1) StaticRange;
}