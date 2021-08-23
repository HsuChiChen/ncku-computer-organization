OUTPUT_ARCH( "riscv" )

SECTIONS
{
    . = 0x00000000;
    .text : { *(.text) }

}
