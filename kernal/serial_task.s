.text
.global serial_main
serial_main: 

    #check if we should quit checks the quit flag 
    add $6, $0, $0
    add $4, $0, $ra

mainLoop:
    lw $6, quit_flag($0)
    bnez $6, end

    #check for input form searil port 2 
    # lw $11, 0x71003($0)             # Get the second serial port status
    # andi $11, $11, 0x1              # Check if the RDR bit is set
    # beqz $11, no_input          # If not, loop and try again


    lw $11, 0x71001($0)             #store the read value from serial port 
    beqz $11, one
    
    #check what the input is  then jump to the correct place. 
    seqi $3, $11, 0x31      #sets $3 to 1 if $11 is = to 1
    bnez $3, one
    seqi $3, $11, 0x32      #sets $3 to 1 if $11 is = to 2
    bnez $3, two
    seqi $3, $11, 0x33      #sets $3 to 1 if $11 is = to 3
    bnez $3, three
    seqi $3, $11, 0x71      #sets $3 to 1 if $11 is = to q
    bnez $3, quit

    j mainLoop




polling:
    lw $10, 0x71003($0)                  # has a button been pressed stores it in $2
    andi $10, $10, 0x2                   #check the tds 
    beqz $10, polling                    # if not keep looping until it has been pressed
    jr $ra 

#\rtttttt format 
one: 
    lw $9, counter($0)
    # writes ‘\r’ the carriage return character to serial port 2
    jal polling 
    addi $11, $0, '\r'
    sw $11, 0x71000($0)

    #write first time value 
    jal polling 
    divi $8, $9, 10000    #divide by 100000
    divi $8, $8, 10
    remi $8, $8, 10
    addi $8, $8, 48  #add 48 to get ascii value 
    sw $8, 0x71000($0)

    #write seocnd time value 
    jal polling 
    divi $8, $9, 10000    #divide by 10000
    remi $8, $8, 10
    addi $8, $8, 48  #add 48 to get ascii value 
    sw $8, 0x71000($0)

    #write thrid time value 
    jal polling 
    divi $8, $9, 1000    #divide by 1000
    remi $8, $8, 10
    addi $8, $8, 48  #add 48 to get ascii value 
    sw $8, 0x71000($0)

    #write forth time value 
    jal polling 
    divi $8, $9, 100   #divide by 100
    remi $8, $8, 10
    addi $8, $8, 48  #add 48 to get ascii value 
    sw $8, 0x71000($0)

    #write 5th time value 
    jal polling 
    divi $8, $9, 10   #divide by 10
    remi $8, $8, 10
    addi $8, $8, 48  #add 48 to get ascii value 
    sw $8, 0x71000($0)

    #write 6th time value 
    jal polling 
    divi $8, $9, 1   #divide by 1
    remi $8, $8, 10
    addi $8, $8, 48  #add 48 to get ascii value 
    sw $8, 0x71000($0)

    # prints the space to the serial port 2
    jal polling 
    addi $12, $0, 32
    sw $12, 0x71000($0)


    j mainLoop

#\rmm:ss format
two:
    lw $9, counter($0)
    # writes ‘\r’ the carriage return character to serial port 2
    jal polling 
    addi $11, $0, '\r'
    sw $11, 0x71000($0)

    divi $5, $9, 6000   #converts to min

    #write first time value in minute
    jal polling 
    divi $8, $5, 10      #divide by 10 to get the 10s minute
    remi $8, $8, 10
    addi $8, $8, 48  #add 48 to get ascii value 
    sw $8, 0x71000($0)

    #write second time value in minute
    jal polling  
    remi $8, $5, 10
    addi $8, $8, 48         #add 48 to get ascii value 
    sw $8, 0x71000($0)

    #write : is 72 as ascii
    jal polling 
    addi $8, $0, 0x3A
    sw $8, 0x71000($0)


    remi $5, $9, 6000 #converts to seconds 

    #write 3rd time value as a second
    jal polling 
    divi $8, $5, 1000  #divide by 10
    remi $8, $8, 10
    addi $8, $8, 48  #add 48 to get ascii value 
    sw $8, 0x71000($0)

    #write 4th time value as a second
    jal polling 
    
    divi $8, $5, 100  #divide by 10
    remi $8, $8, 10
    addi $8, $8, 48  #add 48 to get ascii value 
    sw $8, 0x71000($0)

      # prints the space to the serial port 2
    jal polling 
    addi $12, $0, 32
    sw $12, 0x71000($0)

      # prints the space to the serial port 2
    jal polling 
    addi $12, $0, 32
    sw $12, 0x71000($0)


    j mainLoop



#\rssss.ss
three:
    lw $9, counter($0)
    # writes ‘\r’ the carriage return character to serial port 2
    jal polling 
    addi $11, $0, '\r'
    sw $11, 0x71000($0)

    #write first time value 
    jal polling 
    divi $8, $9, 10000    #divide by 100000
    divi $8, $8, 10
    remi $8, $8, 10
    addi $8, $8, 48  #add 48 to get ascii value 
    sw $8, 0x71000($0)

    #write seocnd time value 
    jal polling 
    divi $8, $9, 10000    #divide by 10000
    remi $8, $8, 10
    addi $8, $8, 48  #add 48 to get ascii value 
    sw $8, 0x71000($0)

    #write thrid time value 
    jal polling 
    divi $8, $9, 1000    #divide by 1000
    remi $8, $8, 10
    addi $8, $8, 48  #add 48 to get ascii value 
    sw $8, 0x71000($0)

    #write forth time value 
    jal polling 
    divi $8, $9, 100   #divide by 100
    remi $8, $8, 10
    addi $8, $8, 48  #add 48 to get ascii value 
    sw $8, 0x71000($0)

    # prints the . to the serial port 2
    jal polling 
    addi $12, $0, 46
    sw $12, 0x71000($0)


    #write 5th time value 
    jal polling 
    divi $8, $9, 10   #divide by 10
    remi $8, $8, 10
    addi $8, $8, 48  #add 48 to get ascii value 
    sw $8, 0x71000($0)

    #write 6th time value 
    jal polling 
    divi $8, $9, 1   #divide by 1
    remi $8, $8, 10
    addi $8, $8, 48  #add 48 to get ascii value 
    sw $8, 0x71000($0)

    j mainLoop


quit: 
    addi $6, $0, 1
    sw $6, quit_flag($0)
    j mainLoop

end: 
    add $ra, $0, $4
    jr $ra


    

.data
.global counter
counter:
    .word 0
.global quit_flag
quit_flag:
    .word 0 


