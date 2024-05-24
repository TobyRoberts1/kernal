.global	display
.text
display:
	subui	$sp, $sp, 3
	sw	$11, 0($sp)
	sw	$12, 1($sp)
	sw	$13, 2($sp)
	lhi	$13, 0x7
	ori	$13, $13, 0x3009
	lw	$12, 3($sp)
	sw	$12, 0($13)
	lhi	$13, 0x7
	ori	$13, $13, 0x3008
	lw	$12, 3($sp)
	lw	$11, 4($sp)
	sub	$12, $12, $11
	sw	$12, 0($13)
L.5:
	lw	$11, 0($sp)
	lw	$12, 1($sp)
	lw	$13, 2($sp)
	addui	$sp, $sp, 3
	jr	$ra
.global	main
main:
	subui	$sp, $sp, 6
	sw	$6, 2($sp)
	sw	$7, 3($sp)
	sw	$13, 4($sp)
	sw	$ra, 5($sp)
	addu	$7, $0, $0
	addui	$6, $0, 16
	j	L.8
L.7:
	lhi	$13, 0x7
	ori	$13, $13, 0x3000
	lw	$7, 0($13)
	sw	$7, 0($sp)
	sw	$6, 1($sp)
	jal	display
L.8:
	j	L.7
L.6:
	lw	$6, 2($sp)
	lw	$7, 3($sp)
	lw	$13, 4($sp)
	lw	$ra, 5($sp)
	addui	$sp, $sp, 6
	jr	$ra
