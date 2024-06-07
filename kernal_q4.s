.text
.global main

.equ pcb_link, 0
.equ pcb_reg1, 1
.equ pcb_reg2, 2
.equ pcb_reg3, 3
.equ pcb_reg4, 4
.equ pcb_reg5, 5
.equ pcb_reg6, 6
.equ pcb_reg7, 7
.equ pcb_reg8, 8
.equ pcb_reg9, 9
.equ pcb_reg10, 10
.equ pcb_reg11, 11
.equ pcb_reg12, 12
.equ pcb_reg13, 13
.equ pcb_regsp, sp
.equ pcb_regra, ra
.equ pcb_regear, ear
.equ pcb_regccrtl, ccrtl
main:
   


    # Unmask IRQ2,KU=1,OKU=1,IE=0,OIE=1
    addi $5, $0, 0x4d

    # Setup the pcb for task 1
    la $1, task1_pcb
    # Setup the link field
    la $2, task1_pcb
    sw $2, pcb_link($1)
    # Setup the stack pointer
    la $2, task1_stack
    sw $2, pcb_sp($1)
    # Setup the $ear field
    la $2, serial_main
    sw $2, pcb_ear($1)
    # Setup the $cctrl field
    sw $5, pcb_cctrl($1)

    

    #copy cpu control ($cctrl) to $2
    movsg $2, $cctrl
    # disable interupts 
    andi $2, $2, 0x000f
    #Enable IRQ2 and IE
    ori $2, $2, 0x42
    # Copy the new CPU control value back to $cctrl
    movgs $cctrl, $2

    # Copy old handler's address to $2
    movsg $2, $evec
    # Save it to memory
    sw $2, old_vector($0)
    # Get the address of the new handler
    la $2, handler
    # Copy handler location into $evec register
    movgs $evec, $2

    # Acknowledge any outstanding interrupts
    sw $0, 0x72003($0)
    # Put our count value into the timer load reg
    addi $11, $0, 0x18
    sw $11, 0x72001($0)
    # Enable the timer and set auto-restart mode only timer 
    addi $11, $0, 0x3
    sw $11, 0x72000($0)

   


handler:
#only use $13
    # Get the value of the exception status register
    movsg $13, $estat
    # Check if any interrupt other than IRQ3 is generated
    andi $13, $13, 0xFFB0
    # If it is IRQ2, go to it
    beqz $13, handle_IRQ2

    # Otherwise, jump to default handler
    lw $13, old_vector($0)
    jr $13


handle_IRQ2:
#IQR2 Timer interrupt
    
    lw $7, counter($0) 
    addi $7, $7, 1
    sw $7, counter($0)

    # Acknowledge the interrupt
    sw $0, 0x72003($0)

    #return to the main program
    rfe

    
ispatcher:
    save_context:
        # Get the base address of the current PCB
        lw $13, current_task($0)
        # Save the registers
        sw $1, pcb_reg1($13)
        sw $2, pcb_reg2($13)
        …
        # $1 is saved now so we can use it
        # Get the old value of $13
        movsg $1, $ers
        # and save it to the pcb
        sw $1, pcb_reg13($13)
        …
        # Save $ear
        movsg $1, $ear
        sw $1, pcb_ear($13)
        # Save $cctrl
        movsg $1, $cctrl
        sw $1, pcb_cctrl($13)



.data

.bss
old_vector:
    .word

task1_pcb:
.space 200