.text
.global main
main:

    

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

    jal serial_main
   


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

    

.data

.bss
old_vector:
    .word