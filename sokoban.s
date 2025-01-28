# Name: Ibrahim Ellahi
# Description: This assembly program implements a simple Sokoban game. The game involves moving a player 
# character ('!') on a grid with walls ('+'), boxes ('#'), and target positions ('O'). The player must push
# the boxes to the target positions to win. The player uses the keys W, A, S, D for movement and R to reset the game.
# The game board is dynamically rendered, and the win condition is checked after each move.
# Assembly Language: RISC-V Assembly
# Date: October 2024
#
# Features:
# - Customizable grid size, player, box, and target skins
# - Input handling for movement (WASD) and reset (R)
# - Dynamic rendering of the game board
# - Collision detection with walls and boxes
# - Win condition check when box is moved to the target position
#
# Functions:
# - _start: Main entry point of the program, initializes the game state.
# - chooseMove: Reads user input and sets movement direction based on WASD keys.
# - gameFinished: Checks if the box is on the target, indicating a win.
# - playerMove: Handles player's movement, checks for collisions, and moves the player or box if valid.
# - printBoard: Renders the game board on the console.
# - Additional helper functions handle movement, collision detection, and board rendering.


.data
#customizable variables
gridsize:   .byte 10,10 # minimum size is 6x6!
playerSkin: .string "!" # must be of type char.


#fixed variables
wallSkin: .string "+"
boxSkin: .string "#"
targetSkin: .string "O"
playerPos:  .byte 0,0
boxPos:        .byte 0,0
targetPos:     .byte 0,0
board: .word 0

#messages
newline: .string "\n"
startMsg: .string "WELCOME TO RISCV SOKOBAN!"
winMsg: .string "You Win! Use CTRL + R and then F3 to restart."
gameMsg: .string "R (Reset) | WASD (Move)"
invalidMoveMsg: .string "CAN'T GO THERE!!!"


.text
.globl _start

_start:

	li a7, 4            # syscall for print string
	la a0, newline
	ecall      
	
	li a7, 4            # syscall for print string
	la a0, startMsg
	ecall               # make the syscall

	li a7, 4            # syscall for print string
	la a0, newline
	ecall               # make the syscall
	jal createBoard
	jal setBoxPos
	jal setTargetPos
	jal setPlayerPos

loop:
	jal renderTarget
	jal renderBox
	jal renderPlayer
	
	li a7, 4            # syscall for print string
	la a0, newline
	ecall   
	
	jal printBoard
	
	li a7, 4            # syscall for print string
	la a0, newline
	ecall               # make the syscall
	
	jal gameFinished
	bne a0, x0, exit
	
	jal chooseMove
	# ask for player move and have a check game finished
	jal playerMove
	j loop

	
exit:
	li a7, 4            # syscall for print string
	la a0, winMsg
	ecall               # make the syscall
	
	li a7, 4            # syscall for print string
	la a0, newline
	ecall               # make the syscall
	
    li a7, 10
    ecall
 
    
# --- HELPER FUNCTIONS ---
# Feel free to use, modify, or add to them however you see fit.

chooseMove:
	validMove:
	    # Print the game message asking for a move
	    li a7, 4            # syscall for print string
		la a0, gameMsg      # load the address of the game message
		ecall               # make the syscall
		
		li a7, 4            # syscall for print string
		la a0, newline
		ecall               # make the syscall
		
		# Read the player's input (one character)
		li a7, 12            # syscall for reading input
		ecall               # make the syscall
		mv t0, a0           # store input character in t0
		
        # Check if input is 'W' or 'w'
        li t1, 'W'          # load ASCII value of 'W' into t1
        beq t0, t1, moveW   # if input is 'W', jump to moveW
        li t1, 'w'          # load ASCII value of 'w' into t1
        beq t0, t1, moveW   # if input is 'w', jump to moveW

        # Check if input is 'A' or 'a'
        li t1, 'A'          # load ASCII value of 'A' into t1
        beq t0, t1, moveA   # if input is 'A', jump to moveA
        li t1, 'a'          # load ASCII value of 'a' into t1
        beq t0, t1, moveA   # if input is 'a', jump to moveA

        # Check if input is 'S' or 's'
        li t1, 'S'          # load ASCII value of 'S' into t1
        beq t0, t1, moveS   # if input is 'S', jump to moveS
        li t1, 's'          # load ASCII value of 's' into t1
        beq t0, t1, moveS   # if input is 's', jump to moveS

        # Check if input is 'D' or 'd'
        li t1, 'D'          # load ASCII value of 'D' into t1
        beq t0, t1, moveD   # if input is 'D', jump to moveD
        li t1, 'd'          # load ASCII value of 'd' into t1
        beq t0, t1, moveD   # if input is 'd', jump to moveD

        # Check if input is 'R' or 'r'
        li t1, 'R'          # load ASCII value of 'R' into t1
        beq t0, t1, moveR   # if input is 'R', jump to moveR
        li t1, 'r'          # load ASCII value of 'r' into t1
        beq t0, t1, moveR   # if input is 'r', jump to moveR

		
		# If input is not valid, ask for input again
		j validMove         # jump back to validMove to ask for input again
		
	moveW:
		# Move up (W): set direction to (0, 1)
		li a0, 0
		li a1, -1
		j exitMove           # jump to exitMove
		
	moveA:
		# Move left (A): set direction to (-1, 0)
		li a0, -1
		li a1, 0
		j exitMove           # jump to exitMove
		
	moveS:
		# Move down (S): set direction to (0, -1)
		li a0, 0
		li a1, 1
		j exitMove           # jump to exitMove
		
	moveD:
		# Move right (D): set direction to (1, 0)
		li a0, 1
		li a1, 0
		j exitMove           # jump to exitMove
		
	moveR:
		# Move right (D): set direction to (1, 0)
		li a0, 0
		li a1, 0
		j _start           # jump to exitMove
		
	exitMove:
		# Code after choosing the move can be added here
		# a0 and a1 contain the movement direction (dx, dy)
		# e.g., (0, 1) for up, (-1, 0) for left, etc.
		jr ra


gameFinished:
	# check if box pos = target pos
	la t0, boxPos
	la t1, targetPos
	
	checkSameX:
		lb t2, 0(t0)
		lb t3, 0(t1)
		beq t3, t2, checkSameY
		j notFinished
	
	checkSameY:
		lb t2, 1(t0)
		lb t3, 1(t1)
		beq t3, t2, finished
		j notFinished
		
	notFinished:
		addi a0, x0, 0
		jr ra
	
	finished:
		addi a0, x0, 1
		jr ra
	
playerMove:
    addi sp, sp, -16        # Make space for s0, s1, s2, and ra
    sw ra, 12(sp)           # Save return address
    sw s0, 8(sp)            # Save s0
    sw s1, 4(sp)            # Save s1
    sw s2, 0(sp)            # Save s2
	
    la s0, board           # Load the address of the board array into s0 (pointer to board memory)
    lw s0, 0(s0)           # Load the contents of the board into s0 (could be the start of the board)

    # Load the player's current position from memory
    la s1, playerPos       # Load the address of playerPos into s1
    lb t0, 0(s1)           # Load player's x-coordinate into t0
    lb t1, 1(s1)           # Load player's y-coordinate into t1

    # Load wall skin for comparison later
    la t6, wallSkin        # Load the address of wallSkin into t6
    lb t6, 0(t6)           # Load the wall skin value (character representing the wall)

    # a0 is dx, a1 is dy (direction of movement)
    mv t2, a0              # Move dx (change in x-direction) into t2
    mv t3, a1              # Move dy (change in y-direction) into t3

    # Calculate next position of the player
    add t4, t0, t2         # Next x position = current x + dx
    add t5, t1, t3         # Next y position = current y + dy

    # Load the box's position from memory
    la s2, boxPos          # Load the address of boxPos into s2
    lb t0, 0(s2)           # Load box's x-coordinate into t0
    lb t1, 1(s2)           # Load box's y-coordinate into t1

	checkDirection:
		bne t2, x0, moveX      # If dx (t2) is not zero, jump to moveX (check x-direction)
		bne t3, x0, moveY      # If dy (t3) is not zero, jump to moveY (check y-direction)

	moveX:
		beq t4, t0, checkCollisionY  # If player's next x position equals box's x position, check y-collision
		j checkWallInfront            # Otherwise, check if there's a wall in front of the player

	moveY:
		beq t5, t1, checkCollisionX  # If player's next y position equals box's y position, check x-collision
		j checkWallInfront            # Otherwise, check if there's a wall in front of the player

	checkCollisionY:
		beq t5, t1, boxCollide         # If x positions of player's next move and box match, handle box collision
		j checkWallInfront             # Otherwise, check if a wall is in front

	checkCollisionX:
		beq t4, t0, boxCollide         # If y positions of player's next move and box match, handle box collision
		j checkWallInfront             # Otherwise, check if a wall is in front

	boxCollide:
		# Handle the case where the player is trying to move the box
		# Calculate the position after the box (box is pushed)
		add t0, t0, t2         # Box's next x position (box x + dx)
		add t1, t1, t3         # Box's next y position (box y + dy)

		mv a0, t0              # Move box's new x position into a0
		mv a1, t1              # Move box's new y position into a1

		jal coordToIndex       # Call coordToIndex function to convert coordinates to board index
		mv t3, a0              # Store the resulting board index in t3

		# Check if the space after the box is a wall
		add s0, s0, a0         # Move the board index (t3) into s0
		lb t3, 0(s0)           # Load the value at the board index (is it a wall?)
		sub s0, s0, a0         # Adjust the pointer to ensure correct index for checking
		beq t3, t6, invalidPlayerMove  # If the next space is a wall, the move is invalid
		
		# If no wall is in front of the box, move the box
		sb t0, 0(s2)           # Store the new x position of the box in memory
		sb t1, 1(s2)           # Store the new y position of the box in memory
		j makeMove             # Jump to the makeMove section to update player position

	checkWallInfront:
		# Check if a wall is in front of the player (no box in front)
		addi a0, t4, 0         # Move next x position into a0
		addi a1, t5, 0         # Move next y position into a1

		jal coordToIndex       # Call coordToIndex to get the board index of the player's next position
		mv t3, a0              # Store the resulting board index in t3

		add s0, s0, a0         # Move the board index into s0
		lb t3, 0(s0)           # Load the value at the board index (is it a wall?)
		sub s0, s0, a0         # Adjust the pointer to ensure correct index for checking
		beq t3, t6, invalidPlayerMove  # If it's a wall, the move is invalid

		j makeMove             # Otherwise, move the player

	invalidPlayerMove:
		lw s2, 0(sp)            # Restore s2
		lw s1, 4(sp)            # Restore s1
		lw s0, 8(sp)            # Restore s0
		lw ra, 12(sp)           # Restore return address
		addi sp, sp, 16         # Restore stack pointer
		
		li a7, 4            # syscall for print string
		la a0, newline
		ecall        
		
		li a7, 4            # syscall for print string
		la a0, invalidMoveMsg
		ecall               # make the syscall

		li a7, 4            # syscall for print string
		la a0, newline
		ecall               # make the syscall
		
		jr ra                  # Return from the function (invalid move, no action)

	makeMove:
		# Update the player's position
		lb t0, 0(s1)           # Load current player x position
		lb t1, 1(s1)           # Load current player y position

		addi a0, t0, 0         # Move player x position into a0
		addi a1, t1, 0         # Move player y position into a1

		jal coordToIndex       # Convert player's current coordinates to board index
		mv t3, a0              # Store the resulting board index in t3

		add s0, s0, t3         # Move the board index into s0
		li t3, ' '             # Load space character (to "clear" the old position)
		sb t3, 0(s0)           # Store space character at the old player position on the board

		# Update the new player position on the board
		sb t4, 0(s1)           # Store new x position of the player in memory
		sb t5, 1(s1)           # Store new y position of the player in memory

		lw s2, 0(sp)            # Restore s2
		lw s1, 4(sp)            # Restore s1
		lw s0, 8(sp)            # Restore s0
		lw ra, 12(sp)           # Restore return address
		addi sp, sp, 16         # Restore stack pointer

		jr ra                  # Return after the move is made


printBoard:
    addi sp, sp, -4         # Make space for s1 and ra
    sw s1, 0(sp)            # Save s1
	
    la s1, board           # Load the address of the board variable (pointer to board memory)
    lw s1, 0(s1)           # Load the board memory address into s1
    la t4, gridsize        # Load the address of the gridSize
    lb t0, 0(t4)           # Load the width of the grid (x)
    lb t1, 1(t4)           # Load the height of the grid (y)
    
    li t5, 0               # Initialize row counter (y)

	outerPrintLoop:    
		beq t5, t1, endPrintLoop  # If y == height, stop outer loop
		li t6, 0               # Initialize column counter (x)

		innerRowLoop:
			beq t6, t0, endRowLoop  # If x == width, end row loop and print newline


			li a7, 11
			lb a0, 0(s1)
			ecall                  # Make syscall to print character

			# Move to next board position
			addi s1, s1, 1         # Move to the next character in memory
			addi t6, t6, 1         # Increment column counter
			j innerRowLoop            # Repeat for next column

		endRowLoop:

			li a7, 4
			la a0, newline
			ecall                  # Make syscall to print newline

			addi t5, t5, 1         # Increment row counter
			j outerPrintLoop            # Repeat for next row

	endPrintLoop:
	
	lw s1, 0(sp)            # Restore s1
    addi sp, sp, 4          # Restore stack pointer
	
	jr ra # Return from printBoard

coordToIndex:
	la a2, gridsize
	#grab width
	lb a2, 0(a2)
	
	mv a3, a0
	mv a4, a1
	
	#subtract total width - current x pos to find offset
	sub a5, a2, a3
	#calculate y pos * total width
	mul a6, a4, a2
	#subtract the offset from y pos * total width
	sub a6, a6, a5
	
	mv a0, a6
	jr ra

renderPlayer:
	addi sp, sp, -4
    sw ra, 0(sp)
	#load board address
	la t2, board
	#get address of dynamic board
	lw t2, 0(t2)
	
	
	#load skins and position
	la t0, playerSkin
	la t1, playerPos
	lb a0, 0(t1)
	lb a1, 1(t1)
	
	jal coordToIndex
	
	
	#add coordinate to address
	add t2, t2, a0
	#load character into position
	lb t0, 0(t0)
	sb t0, 0(t2)
	
	lw ra, 0(sp)
	addi sp, sp, 4
	jr ra

renderBox:
	addi sp, sp, -4
    sw ra, 0(sp)
	#load board address
	la t2, board
	#get address of dynamic board
	lw t2, 0(t2)
	
	
	#load skins and position
	la t0, boxSkin
	la t1, boxPos
	lb a0, 0(t1)
	lb a1, 1(t1)
	
	jal coordToIndex
	
	
	#add coordinate to address
	add t2, t2, a0
	#load into position
	lb t0, 0(t0)
	sb t0, 0(t2)
	
	lw ra, 0(sp)
	addi sp, sp, 4
	jr ra
	
renderTarget:
	addi sp, sp, -4
    sw ra, 0(sp)
	#load board address
	la t2, board
	#get address of dynamic board
	lw t2, 0(t2)
	
	
	#load skins and position
	la t0, targetSkin
	la t1, targetPos
	lb a0, 0(t1)
	lb a1, 1(t1)
	
	jal coordToIndex
	
	#add coordinate to address
	add t2, t2, a0
	#load into position
	lb t0, 0(t0)
	sb t0, 0(t2)
	
	lw ra, 0(sp)
	addi sp, sp, 4
	jr ra

createBoard:
    addi sp, sp, -12       # Adjust stack pointer for 3 registers
    sw s0, 0(sp)           # Save s0
    sw s1, 4(sp)           # Save s1
    sw s3, 8(sp)           # Save s3
	
    la s0, gridsize       # Load the address of gridSize
    lb t0, 0(s0)          # Load grid width (x)
    lb t1, 1(s0)           # Load grid height (y)

    # get total board size (x * y)
    mul t2, t1, t0

    # allocate memory for the board
    li a7, 9              # Syscall for sbrk
    mv a0, t2             # Request memory size (board size)
    ecall
    mv s1, a0             # Store board memory address in s1

    # store the board address in the static variable 'board'
    la t3, board
    sw s1, 0(t3)

    # Prepare the skins
    la t4, wallSkin       # Load wallSkin addr ('+')
    lb t4, 0(t4)          # Load wall skin

    # Fill the board with walls ('+') at the borders and empty spaces inside
    # Outer loops to traverse the grid
    li t5, 0              # Initialize y-counter (row index)

	createLoop:
		beq t5, t1, endCreateLoop    # If y == grid height, stop
		li t6, 0              # Initialize x-counter (column index)

		innerLoop:
			beq t6, t0, endInnerLoop    # If x == grid width, stop inner loop

			# Check if it's a border (first or last row/column)
			beq t5, x0, placeWall        # Top row (y == 0)
			addi t2, t1, -1
			beq t5, t2, placeWall        # Bottom row (y == height-1)
			beq t6, x0, placeWall        # Left border (x == 0)
			addi t2, t0, -1
			beq t6, t2, placeWall        # Right border (x == width-1)

			# Otherwise, place empty space (' ')
			li s3, ' '                # Load empty space character
			sb s3, 0(s1)              # Store in board memory

			j continueInnerLoop

		placeWall:
			sb t4, 0(s1)              # Store the wall character in memory

		continueInnerLoop:
			addi t6, t6, 1            # Increment column counter (x++)
			addi s1, s1, 1            # Move to the next board cell
			j innerLoop

		endInnerLoop:
			addi t5, t5, 1            # Increment row counter (y++)
			j createLoop

	endCreateLoop:
	
	lw s0, 0(sp)               # Restore s0
    lw s1, 4(sp)               # Restore s1
    lw s3, 8(sp)               # Restore s3
    addi sp, sp, 12            # Adjust stack pointer back
	
	jr ra 

setBoxPos:
    addi sp, sp, -8          # Allocate space for ra and s1
    sw ra, 0(sp)             # Save return address
    sw s1, 4(sp)             # Save s1

	la t0, gridsize
	lb t1, 0(t0)
	lb t2, 1(t0)
	
	# set random player, target and box pos
	
	la s1, boxPos

	# pass player range for x
	li a0, 3
	mv a1, t1
	addi a1, a1, -3
	
	jal RNG
	sb a0, 0(s1)

	# pass player range for y
	li a0, 3
	mv a1, t2
	addi a1, a1, -3
	
	jal RNG
	sb a0, 1(s1)
	
    lw s1, 4(sp)             # Restore s1
    lw ra, 0(sp)             # Restore return address
    addi sp, sp, 8           # Restore stack
	jr ra

setTargetPos:
    addi sp, sp, -12         # Allocate space for ra, s1, and s2
    sw ra, 0(sp)             # Save return address
    sw s1, 4(sp)             # Save s1
    sw s2, 8(sp)             # Save s2
	
	la t0, gridsize
	lb t1, 0(t0)
	lb t2, 1(t0)
	
	# set random player, target and box pos
	
	la s1, targetPos

	getTargetPos:
		# pass player range for x
		li a0, 2
		mv a1, t1
		addi a1, a1, -2

		jal RNG
		sb a0, 0(s1)

		# pass player range for y
		li a0, 2
		mv a1, t2
		addi a1, a1, -2

		jal RNG
		sb a0, 1(s1)
	
	# check for box collision
		lb t3, 0(s1) # load box x pos
		lb t4, 1(s1) # load box y pos
		la s2, boxPos # Load target position
		lb t5, 0(s2) # load target x
		lb t6, 1(s2) # load target y
		
		# compare x
		bne t3, t5, confirmTargetPos
		
		# compare y
		bne t4, t6, confirmTargetPos
		
		j getTargetPos

	
	confirmTargetPos:
	
    lw s2, 8(sp)             # Restore s2
    lw s1, 4(sp)             # Restore s1
    lw ra, 0(sp)             # Restore return address
    addi sp, sp, 12          # Restore stack
	jr ra

setPlayerPos:
    addi sp, sp, -12         # Allocate space for ra, s1, and s2
    sw ra, 0(sp)             # Save return address
    sw s1, 4(sp)             # Save s1
    sw s2, 8(sp)             # Save s2
	
	la t0, gridsize
	lb t1, 0(t0)
	lb t2, 1(t0)
	
	# set random player, target and box pos
	
	la s1, playerPos


getPlayerPos:
    # pass player range for x
    li a0, 2
    mv a1, t1
    addi a1, a1, -2

    jal RNG
    sb a0, 0(s1)            # Store player's x position

    # pass player range for y
    li a0, 2
    mv a1, t2
    addi a1, a1, -2

    jal RNG
    sb a0, 1(s1)            # Store player's y position

    # Check for box collision
    lb t3, 0(s1)            # Load player's x position
    lb t4, 1(s1)            # Load player's y position
    la s2, boxPos           # Load box position
    lb t5, 0(s2)            # Load box's x position
    lb t6, 1(s2)            # Load box's y position

    # compare x
    bne t3, t5, checkTargetCollision   # If player's x != box's x, check target
    # compare y
    bne t4, t6, checkTargetCollision   # If player's y != box's y, check target
    j getPlayerPos                     # If both match, re-generate player position

checkTargetCollision:
    # Check for target collision
    la s2, targetPos        # Load target position
    lb t5, 0(s2)            # Load target's x position
    lb t6, 1(s2)            # Load target's y position

    # compare x
    bne t3, t5, confirmPlayerPos       # If player's x != target's x, position is valid
    # compare y
    bne t4, t6, confirmPlayerPos       # If player's y != target's y, position is valid
    j getPlayerPos                     # If both match, re-generate player position

	confirmPlayerPos:
	
    lw s2, 8(sp)             # Restore s2
    lw s1, 4(sp)             # Restore s1
    lw ra, 0(sp)             # Restore return address
    addi sp, sp, 12          # Restore stack
	jr ra

RNG:
    # Save min value in a temporary register
    mv a5, a0            # a5 = min
	mv a6, a1

    # Syscall to gettimeofday (get time in a0)
    li a7, 30            # System call number for gettimeofday
    ecall                    # Perform syscall
	
	li a2, 0x0FFFFFFF    # Load mask for 32-bit unsigned
    and a0, a0, a2
    mv a2, a0            # Move result (time) to t1 (for use in Xorshift)
	
    # Xorshift algorithm
    slli a3, a2, 13        # t2 = t1 << 13
    xor a2, a2, a3        # t1 ^= t2

    srli a3, a2, 17        # t2 = t1 >> 17
    xor a2, a2, a3        # t1 ^= t2

    slli a3, a2, 5         # t2 = t1 << 5
    xor a2, a2, a3        # t1 ^= t2

    # Map the random number to the range [min, max]
    # a0 = min, a1 = max
    sub a3, a6, a5        # t2 = max - min (range size)
    addi a3, a3, 1         # t2 = range size + 1 (to make max inclusive)
	

    remu a2, a2, a3        # t1 = t1 % (range size)
    add a0, a2, a5        # a0 = min + t1 (random number in [min, max])

	jr ra
