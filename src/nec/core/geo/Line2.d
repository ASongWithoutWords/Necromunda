module nec.core.geo.Line2;

import nec.core.math.Scalar;
import nec.core.math.Vector;

struct Line2(Units units)
{
    private alias Scalar!units S;
    private alias Vector2!S V;
    private alias Line2!S This;

    Point a;
    Point b;

    this(Point a, Point b)
    {
        this.a = a;
        this.b = b;
    }

    Vector2!(S) vector() { return b - a; }
}
unittest
{
    //static assert(Line2(Vector2(2.m, 3.m), Vector2(3.m, 2.m)).a == Vector2(2.m, 3.m));
}
