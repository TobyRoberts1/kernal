.text
.global main
main: 

    #check if we should quit checks the quit flag 
    add $2, $0, $0
    add $4, $0, $ra

mainLoop:
    lw $2, quit_flag($0)
    bnez $2, end

    #check for input form searil port 2 
    # lw $11, 0x71003($0)             # Get the second serial port status
    # andi $11, $11, 0x1              # Check if the RDR bit is set
    # beqz $11, no_input          # If not, loop and try again


    lw $11, 0x71001($0)             #store the read value from serial port 
    
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



# no_input: 

#     j main

    



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

    #write first time value in minute
    jal polling 
    divi $8, $9, 10000    #divide by 100000
    divi $8, $8, 10
    remi $8, $8, 10
    addi $8, $8, 48  #add 48 to get ascii value 
    sw $8, 0x71000($0)

    #write second time value in minute
    jal polling 
    divi $8, $9, 10000    #divide by 10000
    remi $8, $8, 10
    addi $8, $8, 48  #add 48 to get ascii value 
    sw $8, 0x71000($0)

    #write : is 72 as ascii
    jal polling 
    addi $8, $0, 0x3A
    sw $8, 0x71000($0)

    #write 3rd time value as a second
    jal polling 
    divi $8, $9, 1000   #divide by 1000
    remi $8, $8, 10
    addi $8, $8, 48  #add 48 to get ascii value 
    sw $8, 0x71000($0)

    #write 4th time value as a second
    jal polling 
    divi $8, $9, 100   #divide by 100
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
    addi $2, $0, 1
    sw $2, quit_flag($0)
    j mainLoop

end: 
    add $ra, $0, $4
    jr $ra


    

.data
counter:
    .word 123456

quit_flag:
    .word 0 


