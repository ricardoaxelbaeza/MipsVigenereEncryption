#Authors: 
#Ki Hong Son
#Joshua Barrientos
#Ricardo Baeza
#Ishan Dhaliwal
#Last Edit-Date: May 17th, 2021
#Description: Text encryption with vigenere cypher

# MSG = RMUZGDFZND
# KEY = KIJOSHRICARDO
# HELLOWORLD

# MSH = ONLYTWOMOREWEEKSLEFT
# KEY = KIJOSHRICARDO
# YVUMLDFUQRVZSOSBZWMK



.data
greeting: .asciiz "Would you like to encrypt (1), decrypt (2), or quit(3): "
invalidMenuChoice: .asciiz "Invalid menu option. Please enter (1), (2) or (3).\n"
invalidMessage: .asciiz "Invalid message\n"
invalidMenuChoiceZeroOrOne: "Invalid input, Please enter 1 to continue, or 0 to exit."
invalidMessageCapital: "Invalid message. Please make sure all letters are captial!\n"
invalidMessageOnlyLetters: "Invalid message. Please only enter letters and spaces, nothing else."
restartMenu: .asciiz "Would you like to continue? (Yes=1/No=0): "

encrypt: .asciiz "Enter the message you wish to encrypt: "
enteredKey: .asciiz "Enter the key (make sure all capital letters): "

decrypt: .asciiz "Enter the message you wish to decrypt: "
decryptKey: .asciiz "Enter the key (make sure all capital letters): "

encryptInput: .space 100
keyInput: .space 100

decryptInput: .space 100

newLine: .asciiz "\n"

.text
main:

message: 

	li $v0, 4
	la $a0, newLine
	syscall
	
	#displays the .asiiz greeting: "Would you like to encrypt (1), decrypt (2), or quit(3): "
	la $a0, greeting
	li $v0, 4
	syscall
	
	#syscall that allows the user to enter a character 
	li $v0, 12 #$v0 = the character entered by the user
	syscall
	move $t5, $v0 #$t5 = $v0 (character entered by the user
	
	beq $t5, 49, encryptionStart	# if character entered is .asciiz 49 ("1") go to menu choice 1 is encrypt 
	beq $t5, 50, decryptionStart	# if character entered is .asciiz 50 ("2") go to menu choice 2 is decrypt
	beq $t5, 51, end		# if character entered is .asciiz 51 ("3") jump to end
	
	#if the value entered by the user is not 1, 2, or 3, then: display invalid menu option & go back until, input is 1,2 or 3
	
	#new line
	li $v0, 4
	la $a0, newLine
	syscall
	
	#display "Invalid menu option"
	la $a0, invalidMenuChoice	# invalid choice
	li $v0, 4
	syscall
	
	j message #jump back to message
	
encryptionStart:

	#new line
	li $v0, 4
	la $a0, newLine
	syscall
	
	# display encrypt message "Enter the message you wish to encrypt: "
	la $a0, encrypt
	li $v0, 4
	syscall
	
	# get encrypt message
	li $v0, 8 #syscall 8 which allows user to enter a string
	la $a0, encryptInput #stores the string in "encryptInput" 
	li $a1, 100	# tells system the maximum length (100 characters)
	syscall
	move $s0, $a0	# s0 = encrypt message entered by the user
	move $t0, $s0	# t0 holds a copy of message
	j checkMessage	#once, we store the string, we jump to checkMessage

key: 
	# display key message "Enter the key (make sure all capital letters): "
	la $a0, enteredKey
	li $v0, 4
	syscall
	
	# get key
	li $v0, 8
	la $a0, keyInput
	li $a1, 100
	syscall
	move $s1, $a0	# s1 = key entered by the user

	
	move $t1, $s1	# t1 holds a copy of the key
	j checkKey 	# jumps to checkKey to see if the key entered is valid
	
#after the user enters the key, we will verify if all characters in key are Capital

cipher:
	lb $t2, 0($t0)  		# t2 = first byte from message
	lb $t3, 0($t1)		# t3 = first byte from key
	beq $t2, 10, end   		# check if t2 is a null character (end of string)
	beq $t3, 10, loopKey	# check if t3 is a null character (end of string)

	beq $t2, 32, space		# ignore spaces
	bgt $t2, 90, toUpper	# checks to see if its lower case
	
	upperCase: #here we conver lower case characters to uppercase
		add $t2, $t2, $t3		# $t2 = c + key.charAt(j)
		addi $t2, $t2, -130		# $t2 = c + key.charAt(j) - 2 * 'A' //(-2 * 65) = -130
	
		#if $t2, is greater or equal 26, go to Mod
		bge $t2, 26, Mod		# ((c + key.charAt(j) - 2 * 'A') % 26
		
continue:
	addi $t2, $t2, 65 #$t2 = $t2 + 65  (remember uppercase is 65-90 is uppercase)
	
	move $a0, $t2 #$a0 = $t2
	li $v0, 11	# print character (syscall 11)
	syscall
	
	addi $t0, $t0, 1    # increment address of message
	addi $t1, $t1, 1	# increment address of key
	j cipher
	
decryptionStart:

	#new line
	li $v0, 4
	la $a0, newLine
	syscall
	
	# display decrypt message "Enter the message you wish to decrypt: "
	la $a0, decrypt
	li $v0, 4
	syscall
	
	# get decrypt message
	li $v0, 8
	la $a0, encryptInput
	li $a1, 100	# tells system the maximum length (100 characters)
	syscall
	move $s0, $a0	# s0 = encrypt message
	move $t0, $s0	# t0 holds a copy of message
	j checkMessageD #jump to checkMessageD (check message for Decryption)

keyD: 
	# display decrypt key message "Enter the key (make sure all capital letters): "
	la $a0, decryptKey
	li $v0, 4
	syscall
	
	# get key from the user input
	li $v0, 8
	la $a0, decryptInput
	li $a1, 100
	syscall
	move $s1, $a0	# s1 = key

	
	move $t1, $s1	# t1 holds a copy of the key
	j checkKeyD #checks to see if

cipherD:
	lb $t2, 0($t0)  		# t2 = first byte from message
	lb $t3, 0($t1)		# t3 = first byte from key
	beq $t2, 10, end   		# check if t2 is a null character, if it is, means we iterated through whole string
	beq $t3, 10, loopKeyD	# check if t3 is a null character  if it is, means we iterated through whole string for key

	beq $t2, 32, spaceD		# ignore spaces
	bgt $t2, 90, toUpperD	# checks to see if greater than 90 ('z'), and if it is go to upperD
	
	# (c - key.charAt(j) + 26) % 26 + 'A'
	
	upperCaseD:
		sub $t2, $t2, $t3		# $t2 = c - key.charAt(j)
		addi $t2, $t2, 26		# $t2 = c - key.charAt(j) + 26
	
		bge $t2, 26, ModD		# (c - key.charAt(j) + 26) % 26

continueD:
	addi $t2, $t2, 65	# (c - key.charAt(j) + 26) % 26 + 'A'
	
	move $a0, $t2
	li $v0, 11	# print character
	syscall
	
	addi $t0, $t0, 1    # increment address
	addi $t1, $t1, 1	# increment address
	j cipherD

end:	
	#prints new line
	la $a0, newLine
	li $v0, 4
	syscall
	#Prints "Would you like to continue? (Yes=1/No=0): "
	la $a0, restartMenu
	li $v0, 4
	syscall
	
	#syscall that allows the user to enter a character 
	li $v0, 12 #$v0 = the character entered by the user
	syscall
	move $t7, $v0 #$t7 = $v0 (character entered by the user
	
	#if user enters a 1 (49), then go back to the beginning, and choose "encrypt" (1), "decrypt" (2) or "exit" (3)
	beq $t7, 49, message
	beq $t7, 48, exitProgram
	#anythine else entered by the user:
	
	#new line
	li $v0, 4
	la $a0, newLine
	syscall
	
	#display "Invalid menu option"
	la $a0, invalidMenuChoiceZeroOrOne	# invalid choice
	li $v0, 4
	syscall
	
	j end #jump back to message
	
	
	exitProgram:
	# exit
	li $v0, 10
	syscall

loopKey:
	# if t3 is a null character, we reset the key for it to be iterated through again
	move $t1, $s1	# t1 holds a copy of the key
	lb $t3, 0($t1)
	j cipher
	

checkMessage: 
	#Message entered by the user can only be uppercase letters and lowercase letters (anything else will result as invalid)
	
	lb $t3, 0($t0)		# $t3 = first byte from the message entered by the user
	#if $t3 = 10, go to exitCheckMessage
	beq $t3, 10, exitCheckMessage	# if $t3 is a null character, then go to exitCheckMessage (once finished iterating through string)
	beq $t3, 32, continueMessage #if $t3 is a space continue the message
	#Comparison for ASCII Values (A(65) - Z(90)
	blt $t3, 65, error2 #if $t3 is less than 65(A) then we go to error2, (back to encryptionStart)
	blt $t3, 91, continueMessage #if $t3 is less than 91, 90(Z), then we go to continueMessage
	blt $t3, 97, error2 #if $t3, is less than 97(a), then we’ll go to encryptionStart
	blt $t3, 123, continueMessage #if $t3 is less than 123, 122(z) then we’ll continueMessage
	
	
	j error2
	continueMessage: #if character is valid, then check the next character
		addi $t0, $t0, 1	# increment address
		j checkMessage
		#if $t3 != 10, do the following:
	exitCheckMessage:
		move $t0, $s0
		j key #jump to key
	error2:  #if the character in the string is not in A-Z uppercase & a-z lowercase
		la $a0, invalidMessageOnlyLetters
		li $v0, 4
		syscall
		j encryptionStart





checkKey:
	lb $t3, 0($t1)		# t3 = first byte from key

	#if $t3 = 10 (null), go to exitLoopKey
	beq $t3, 10, exitLoopKey	# check if t3 is a null character (once done reading string (and is valid) go to exitLoopKey)
	#Comparison for ASCII Values (A(65) - Z(90)
	blt $t3, 65, error #if $t3 is less than 65(A) then we will let user know their input is not valid & go back to re-enter key
	bgt $t3, 90, error #if $t3 is greater than 90(Z), then we will let user know their input is not valid & go back to re-enter key
	addi $t1, $t1, 1	# increment address to iterate through the string
	j checkKey
	#if $t3 != 10, do the following:
	exitLoopKey: 
		move $t1, $s1
		j cipher #jump to cipher
		 

	error:
		la $a0, invalidMessageCapital
		li $v0, 4
		syscall
		j key

Mod:
	addi $t2, $t2, -26 #$t2 = $t2 - 26
	bgt $t2, 26, Mod #if $t2 > 26 (27), then do Mod operation again
	#else
	j continue 
	
space:
	addi $t0, $t0, 1
	j cipher

toUpper:
	addi  $t2, $t2, -32
	j upperCase
	
loopKeyD:
	# if t3 is a null character, we reset the key for it to be iterated through again
	move $t1, $s1	# t1 holds a copy of the key
	lb $t3, 0($t1)
	j cipherD
checkMessageD: 

	lb $t3, 0($t0)		# t3 = first byte from message entered
	#if $t3 = 10, go to exit exitCheckMessageD (meaning it has ended reading the string)
	beq $t3, 10, exitCheckMessageD	# check if t3 is a null character
	beq $t3, 32, continueMessageD #if the character is a space continue the message
	#Comparison for ASCII Values (A(65) - Z(90)
	blt $t3, 65, errorDD #if $t3 is less than 65(A) then we throw an error to the user
	blt $t3, 91, continueMessageD #if $t3 is less than 90(Z), then we go to continueMessageD
	blt $t3, 97, errorDD #if $t3, is less than 97(a), then we’ll throw an error to the user (b/c symbols like: - [] not accepted
	blt $t3, 122, continueMessageD #if $t3 is less than 122(z) then we’ll continueMessage
	j errorDD
	continueMessageD:
		addi $t0, $t0, 1	# increment address
		j checkMessageD
		#if $t3 != 10, do the following:
	exitCheckMessageD: 
		move $t0, $s0
		j keyD #jump to keyD, so the user can enter their key
	errorDD:
		la $a0, invalidMessageOnlyLetters
		li $v0, 4
		syscall
		j decryptionStart

checkKeyD:
	lb $t3, 0($t1)		# t3 = first byte from key

	#if $t3 = 10, go to exitLoopKeyD (meaning we finished iterating through the key string)
	beq $t3, 10, exitLoopKeyD	# check if t3 is a null character
	#Comparison for ASCII Values (A(65) - Z(90)
	blt $t3, 65, errorD #if $t3 is less than 65(A) then we go to errorD
	bgt $t3, 90, errorD #if $t3 is greater than 90(Z), then go to errorD
	addi $t1, $t1, 1	# increment address
	j checkKeyD
	#if $t3 != 10, do the following:
	exitLoopKeyD: 
		move $t1, $s1
		j cipherD #jump to cipher
	errorD:
		la $a0, invalidMessageCapital
		li $v0, 4
		syscall
		j keyD

ModD:
	addi $t2, $t2, -26
	bgt $t2, 26, ModD
	j continueD
	
spaceD:
	addi $t0, $t0, 1
	j cipherD

toUpperD:
	addi  $t2, $t2, -32
	j upperCaseD


