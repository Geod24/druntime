/**
 * This code reads ELF files and sections using memory mapped IO.
 *
 * Reference: http://www.dwarfstd.org/
 *
 * Copyright: Copyright Digital Mars 2015 - 2018.
 * License:   $(HTTP www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors:   Yazan Dabain
 * Source: $(DRUNTIMESRC rt/backtrace/elf.d)
 */

module rt.backtrace.elf;

version (linux)
{
    import core.sys.linux.elf;
    version = LinuxOrBSD;
}
else version (FreeBSD)
{
    import core.sys.freebsd.sys.elf;
    version = LinuxOrBSD;
}
else version (DragonFlyBSD)
{
    import core.sys.dragonflybsd.sys.elf;
    version = LinuxOrBSD;
}

version (LinuxOrBSD):

import core.internal.elf.dl;
import core.internal.elf.io;

struct Image
{
    private ElfFile file;

    static immutable(Image)* openSelf()
    {
        const(char)* selfPath = SharedObject.thisExecutable().name().ptr;

        auto image = new Image();
        if (!ElfFile.open(selfPath, image.file))
            return null;

        return cast(immutable) image;
    }

    @property bool isValid() const
    {
        return file != ElfFile.init;
    }

    T processDebugLineSectionData(T)(scope T delegate(const(ubyte)[]) processor)
        const
    {
        ElfSectionHeader dbgSectionHeader;
        ElfSection dbgSection;

        if (file.findSectionHeaderByName(".debug_line", dbgSectionHeader))
        {
            // we don't support compressed debug sections
            if (!(dbgSectionHeader.shdr.sh_flags & SHF_COMPRESSED))
                dbgSection = ElfSection(file, dbgSectionHeader);
        }

        return processor(cast(const(ubyte)[]) dbgSection.data());
    }

    @property size_t baseAddress() const
    {
        // the DWARF addresses for DSOs are relative
        const isDynamicSharedObject = (file.ehdr.e_type == ET_DYN);
        if (!isDynamicSharedObject)
            return 0;

        return cast(size_t) SharedObject.thisExecutable().baseAddress;
    }
}
