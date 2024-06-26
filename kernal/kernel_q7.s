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

.equ pcb_sp, 14
.equ pcb_ra, 15
.equ pcb_ear, 16
.equ pcb_cctrl, 17

main:

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



    # Unmask IRQ2,KU=1,OKU=1,IE=0,OIE=1
    addi $5, $0, 0x4d

    # Setup the pcb for task 1
    la $1, task1_pcb
    sw $1, current_task($0)
    # Setup the link field
    la $2, task2_pcb
    sw $2, pcb_link($1)
    # Setup the stack pointer
    la $2, task1_stack
    sw $2, pcb_sp($1)    #top of the tasks stack 
    # Setup the $ear field
    la $2, serial_main       
    sw $2, pcb_ear($1)      #where it goes after an exception. 

    # Setup the $cctrl field        #needs IRQ2 timer and IE global. enabled
    sw $5, pcb_cctrl($1)



    # Setup the pcb for task 2
    la $1, task2_pcb
    #sw $1, current_task($0)
    # Setup the link field
    la $2, task3_pcb
    sw $2, pcb_link($1)
    # Setup the stack pointer
    la $2, task2_stack
    sw $2, pcb_sp($1)    #top of the tasks stack 
    # Setup the $ear field
    la $2, parallel_main       
    sw $2, pcb_ear($1)      #where it goes after an exception. 

    # Setup the $cctrl field        #needs IRQ2 timer and IE global. enabled
    sw $5, pcb_cctrl($1)


    # Setup the pcb for task 3  
    la $1, task3_pcb
    #sw $1, current_task($0)
    # Setup the link field
    la $2, task1_pcb
    sw $2, pcb_link($1)
    # Setup the stack pointer 
    la $2, task3_stack
    sw $2, pcb_sp($1)    #top of the tasks stack 
    # Setup the $ear field
    la $2, rocks_main
    sw $2, pcb_ear($1)      #where it goes after an exception.  

    # Setup the $cctrl field        #needs IRQ2 timer and IE global. enabled
    sw $5, pcb_cctrl($1)




    #set serial to be the current task 



    j load_context

   


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
    # Acknowledge the interrupt
    sw $0, 0x72003($0)

    lw $7, counter($0) 
    addi $7, $7, 1
    sw $7, counter($0)

handle_time_slice:  
    lw $7, time_slice($0)
    subui $7, $7, 1
    sw $7, time_slice($0)
    beqz $7, dispatcher

    #return to the main program
    rfe

    
dispatcher:

save_context:
    # Get the base address of the current PCB
    lw $13, current_task($0)
    # Save the registers
    sw $1, pcb_reg1($13)
    sw $2, pcb_reg2($13)
    sw $3, pcb_reg3($13)
    sw $4, pcb_reg4($13)
    sw $5, pcb_reg5($13)
    sw $6, pcb_reg6($13)
    sw $7, pcb_reg7($13)
    sw $8, pcb_reg8($13)
    sw $9, pcb_reg9($13)
    sw $10, pcb_reg10($13)
    sw $11, pcb_reg11($13)
    sw $12, pcb_reg12($13)
    sw $sp, pcb_sp($13)
    sw $ra, pcb_ra($13)



    # $1 is saved now so we can use it
    # Get the old value of $13
    movsg $1, $ers
    # and save it to the pcb
    sw $1, pcb_reg13($13)
    
    # Save $ear
    movsg $1, $ear
    sw $1, pcb_ear($13)
    # Save $cctrl
    movsg $1, $cctrl
    sw $1, pcb_cctrl($13)

schedule:

    subui $sp,$sp,1     #create stack to store 3
    sw $3,0($sp)

    lw $13, current_task($0) #Get current task
    lw $13, pcb_link($13) #Get next task from pcb_link field
    sw $13, current_task($0) #Set next task as current task

    

    #check if it is the game running, if it is break so it can be priotrized. 
    la $3, task3_pcb
    sequ $13, $13, $3
    bnez $13, playing_game 
    
    lw $3, 0($sp)           #restore $3 
    addui $sp, $sp, 1    #delete stack 


    addui $13, $0, 1            #sets time sice to 1 if it is not the game. 
    sw $13,time_slice($0)




load_context:
    lw $13, current_task($0) #Get PCB of current task
    # Get the PCB value for $13 back into $ers
    lw $1, pcb_reg13($13)
    movgs $ers, $1
    # Restore $ear
    lw $1, pcb_ear($13)
    movgs $ear, $1
    # Restore $cctrl
    lw $1, pcb_cctrl($13)
    movgs $cctrl, $1
    # Restore the other registers
    lw $1, pcb_reg1($13)
    lw $2, pcb_reg2($13)
    lw $3, pcb_reg3($13)
    lw $4, pcb_reg4($13)
    lw $5, pcb_reg5($13)
    lw $6, pcb_reg6($13)
    lw $7, pcb_reg7($13)
    lw $8, pcb_reg8($13)
    lw $9, pcb_reg9($13)
    lw $10, pcb_reg10($13)
    lw $11, pcb_reg11($13)
    lw $12, pcb_reg12($13)
    lw $sp, pcb_sp($13)
    lw $ra, pcb_ra($13)

    # Return to the new task
    rfe

playing_game:           
    addi $13, $0, 4        #sets teh time slice to 4 only when playing the game
    sw $13, time_slice($0)

    j load_context          #jumps back to loading context



.data
time_slice:
    .word 1

.bss

current_task:
    .word

old_vector:
    .word

    .space 200
task1_stack:

    .space 200
task2_stack:

    .space 200
task3_stack:


task1_pcb:
    .space 18

task2_pcb:
    .space 18

task3_pcb:
    .space 18
