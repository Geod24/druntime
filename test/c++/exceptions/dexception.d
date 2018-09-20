/**
 * Test that exception thrown to/from C++ works.
 *
 * The order of call is at follows:
 * - [ D ] main
 * - [CPP] func1
 * - [ D ] func2
 */
module dexception;

import core.stdc.string : strcmp;
import core.stdcpp.exception;

extern(C++) void func1 ();

void main ()
{
    try
    {
        func1();
        assert(0, "Exception not thrown");
    }
    catch (exception e)
    {
        assert(strcmp(e.what(), "C++ sends his regards") == 0);
    }
    assert(0);
}

// Make sure the GC doesn't free this
private dexception saved;

extern(C++)
class dexception : Exception
{
    extern(D) this (const(char)* p) { super(null); data = p; }

    private const(char)* data;
    const(char)* what() const nothrow { return data; }
}

extern(C++) void func2 ()
{
    saved = new dexception("Hello from D side");
    throw saved;
}
