/**
 * Provides basic utilities and interfaces for backtrace handling
 *
 * This module is publicly imported from `object`, hence is kept
 * lightweight - and separate - from all other modules in this package.
 *
 * Copyright: D Language Foundation 2020
 * License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Authors:   Mathias 'Geod24' Lang
 * Source:    $(LINK2 https://github.com/dlang/druntime/blob/master/src/core/backtrace/primitives.d, _primitives.d)
 * Documentation: https://dlang.org/phobos/core_backtrace_primitives.html
 */
module core.internal.backtrace.primitives;

interface TraceInfo
{
    int opApply(scope int delegate(ref const(char[]))) const;
    int opApply(scope int delegate(ref size_t, ref const(char[]))) const;
    string toString() const;
}
