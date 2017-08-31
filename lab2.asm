#	Kyle Spomer
#	EEL 4768c.01 Comp. Arch. & Org.
#	Laboratory 2
#	Last Modification: 6.7.17
#	Purpose: To perform a bubble sort on an array of 2-byte unsigned integers of a given length, and
#			replace their locations in memory with the sorted values
#	Input Description: The input array address is set via the .data 0x10010000 directive below (given as a word)
#			   The input array length is set via the .data 0x10010004 directive below (given as an unsigned byte)
#			   The input array itself is set via a set of halfword .data (beginning at the chosen address)
#				directives labeled below (given as a set of unsigned 2-byte integers)
#	Output Description: The output array will be stored at the same location of the input array (the address of which is stored at
#				0x10010000), stored as a series of unsigned, 2-byte integers

###——————————————————————————------------------------------------------------——————###

.data 0x10010000 # stores the location of the starting point
	.word 0x10010100 # location of the array
.data 0x10010004 # stores the length of the array
	.byte 0x05 # length of the array (in elements)

### These values are used for entering the test array beginning at address given above ###

.data 0x10010100
	.half 0x1000, 0x2000, 0x3000, 0x4000, 0x0000

###-----------------number of data points should match length above----------------###



.text

	lui $t0, 0x1001
	lbu $t3, 4($t0) # load the length of the array into $t3
	addiu $s1, $0, 0x01 # load value of 1 into $s1, to later be used for comparisons

outer_loop: #manages the passes through the array
	beq $t3, $s1, done #end program when remaining length of unsorted array is 1
	lw $t1, 0x0000($t0) #load the address of the first element of the array into $t1, resetting at each pass
	addiu $t2, $t1, 0x02 #load the address of the second element, 1 byte offset of $t1 , resetting at each pass
	lhu $t4, ($t1) #load the first element of the array into $t4, resetting at each pass
	lhu $t5, 0x02($t1) #load the next array element into $t5, resetting at each pass
	lbu $t8, 4($t0) #load the length of the array into $t8, to be used as a counter in inner_loop, resetting at each pass
	addiu $t3, $t3, -1 #decrement the outer_loop counter
	beq $0, $0, inner_loop #branch to inner_loop (on every pass)

inner_loop: #manages the sorting of each pass through the array
	beq $t8, $s1, outer_loop #return to outer_loop if the length counter is 1 (only one element unsorted)
	sltu $t6, $t4, $t5 #compares the values of $t4 and $t5, and uses $t6 to hold result (0 if swap is needed)
	beq $t6, $0, swap_func #branch to swap_func if $t6 is zero
	addu $t1, $t1, 0x02 #shift to the address of the next "first" value to be compared
	addu $t2, $t2, 0x02 #shift to the address of the next "second" value to be compared
	lhu $t4, ($t1) #load the value of the new "first" value into $t4
	lhu $t5, ($t2) #load the value of the new "second" value into $t5
	addiu $t8, $t8, -1 # decrement the inner_loop counter
	beq $0, $0, inner_loop

swap_func: #swaps the two compared values
	addu $t7, $0, $t4 #puts the value of $t4 into the temporary value holder, $t7
	addu $t4, $0, $t5 #copies the value of $t5 into $t4
	addu $t5, $0, $t7 #copies the value of $t7 into $t5
	sh $t4, ($t1) #stores the swapped values into memory address
	sh $t5, ($t2) #stores the swapped values into memory address
	beq $0, $0, inner_loop #return to inner loop

done:
	nop
