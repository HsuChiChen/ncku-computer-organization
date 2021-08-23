#ifndef _ISR_
#define _ISR_
#define __irq __attribute__((interrupt("IRQ")))
void __irq irq_isr(void);

#endif
