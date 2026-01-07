ENTRY(limine_main)

SECTIONS {
    . = 0xffffffff80000000;

    .text : {
        *(.text*)
    }

    .rodata : {
        *(.rodata*)
    }

    .data : {
        *(.data*)
    }

    .bss : {
        *(.bss*)
        *(COMMON)
    }

    .limine_requests : {
        *(.limine_requests*)
    }
}