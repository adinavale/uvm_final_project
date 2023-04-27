/* a simple gnu ld script for learning riscv tool chain */

SECTIONS {
    data 0x00000000 :
    {
        *(.data)
    }
    text 0x80000000 :
    {
        *(.text)
    }
}
