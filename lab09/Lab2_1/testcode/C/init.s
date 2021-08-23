.section ".init", "x"

.global _ENTRY

_ENTRY:

    b BOOT_CODE
    nop
    nop
    nop
    nop
    nop
    ldr pc,=irq_isr
    nop

BOOT_CODE:
    mov r0,#0x10000
    mov sp,r0           
	#SVC mode sp is initialized, value is 0x10000

    mrs r0,cpsr
    bic r0,r0,#0x1
    msr cpsr,r0
    mov r1,#0x20000
    mov sp,r0           
	#IRQ mode sp is initialized, value is 0x20000

    orr r0,r0,#0x1
    bic r0,r0,#0xa0
    msr cpsr,r0         
	#Retrun SVC mode, and set IRQ enable
    mov lr,pc
    ldr pc,=main_function

END_CODE:
    mov r12,#0x20000004
    mov r13,#0x4
    str r13,[r12]

    
.end
