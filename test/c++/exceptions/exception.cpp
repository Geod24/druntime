#include <cassert>
#include <cstring>
#include <stdexcept>
#include <string>

extern void func2();

void func1()
{
    try
    {
        func2();
        assert(0);
    }
    catch (std::exception& e)
    {
        assert(strcmp(e.what(), "Hello from D side") == 0);
        throw std::runtime_error("C++ sends his regards");
    }
}
