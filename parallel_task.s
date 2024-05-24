.global	displayhexi
.text
displayhexi:
	subui	$sp, $sp, 2
	sw	$12, 0($sp)
	sw	$13, 1($sp)
	lhi	$13, 0x7
	ori	$13, $13, 0x3009
	lw	$12, 2($sp)
	sw	$12, 0($13)
	lhi	$13, 0x7
	ori	$13, $13, 0x3008
	lw	$12, 2($sp)
	srai	$12, $12, 4
	sw	$12, 0($13)
	lhi	$13, 0x7
	ori	$13, $13, 0x3007
	lw	$12, 2($sp)
	srai	$12, $12, 8
	sw	$12, 0($13)
	lhi	$13, 0x7
	ori	$13, $13, 0x3006
	lw	$12, 2($sp)
	srai	$12, $12, 12
	sw	$12, 0($13)
L.5:
	lw	$12, 0($sp)
	lw	$13, 1($sp)
	addui	$sp, $sp, 2
	jr	$ra
.global	displaydeci
displaydeci:
	subui	$sp, $sp, 4
	sw	$7, 0($sp)
	sw	$11, 1($sp)
	sw	$12, 2($sp)
	sw	$13, 3($sp)
	lw	$13, 4($sp)
	srai	$12, $13, 12
	slli	$12, $12, 12
	srai	$11, $13, 8
	slli	$11, $11, 8
	add	$12, $12, $11
	srai	$11, $13, 4
	slli	$11, $11, 4
	add	$12, $12, $11
	add	$7, $12, $13
	lhi	$13, 0x7
	ori	$13, $13, 0x3009
	remi	$12, $7, 10
	sw	$12, 0($13)
	addui	$13, $0, 10
	lhi	$12, 0x7
	ori	$12, $12, 0x3008
	div	$11, $7, $13
	rem	$13, $11, $13
	sw	$13, 0($12)
	lhi	$13, 0x7
	ori	$13, $13, 0x3007
	divi	$12, $7, 100
	remi	$12, $12, 10
	sw	$12, 0($13)
	lhi	$13, 0x7
	ori	$13, $13, 0x3006
	divi	$12, $7, 1000
	sw	$12, 0($13)
L.6:
	lw	$7, 0($sp)
	lw	$11, 1($sp)
	lw	$12, 2($sp)
	lw	$13, 3($sp)
	addui	$sp, $sp, 4
	jr	$ra
.global	main
main:
	subui	$sp, $sp, 6
	sw	$6, 1($sp)
	sw	$7, 2($sp)
	sw	$13, 3($sp)
	sw	$ra, 4($sp)
	addu	$6, $0, $0
	addui	$13, $0, 16
	sw	$13, 5($sp)
	addu	$7, $0, $0
	j	L.9
L.8:
	lhi	$13, 0x7
	ori	$13, $13, 0x3000
	lw	$6, 0($13)
	lhi	$13, 0x7
	ori	$13, $13, 0x3001
	lw	$13, 0($13)
	sle	$13, $13, $0
	bnez	$13, L.11
	lhi	$13, 0x7
	ori	$13, $13, 0x3001
	lw	$7, 0($13)
L.11:
	seqi	$13, $7, 1
	bnez	$13, L.15
	seqi	$13, $7, 2
	bnez	$13, L.16
	seqi	$13, $7, 4
	bnez	$13, L.7
	j	L.14
L.15:
	sw	$6, 0($sp)
	jal	displaydeci
	j	L.14
L.16:
	sw	$6, 0($sp)
	jal	displayhexi
L.14:
L.9:
	j	L.8
	sw	$6, 0($sp)
	jal	displaydeci
L.7:
	lw	$6, 1($sp)
	lw	$7, 2($sp)
	lw	$13, 3($sp)
	lw	$ra, 4($sp)
	addui	$sp, $sp, 6
	jr	$ra
