.data
    RAM: .space 4096
    row_msg : .asciiz "Type ur row size: "
    cl_msg : .asciiz "Type ur column size: "
    num_msg : .asciiz "Type u num to change"
    msg: .asciiz "Choose ur operation (0 change a element or any else to get): "
    r_msg : .asciiz "Type ur row: "
    c_msg : .asciiz "Type ur column: "

.text
    main:
   	 # Prompt for the number of rows
   	 li $v0, 4
   	 la $a0, row_msg
   	 syscall
        # Wczytaj rozmiary tablicy od użytkownika
        li $v0, 5
        syscall
        move $t1, $v0  # $t1 - liczba wierszy
        
        # Prompt for the number of rows
   	li $v0, 4
    	la $a0, cl_msg
    	syscall

        li $v0, 5
        syscall
        move $t2, $v0  # $t2 - liczba kolumn

        # Oblicz rozmiar tablicy w pamięci
        li $t3, 4  # 4 bajty na każdy element
        mul $t3, $t3, $t2  # $t3 - rozmiar wiersza w bajtach

        # Alokuj pamięć dla tablicy adresów wierszy
        li $t4, 4  # 4 bajty na adres
        mul $t4, $t4, $t1  # $t4 - rozmiar tablicy adresów wierszy
        la $t5, RAM  # $t5 - adres początku bloku RAM
        move $t6 , $t5
        add $t6 , $t6 , $t4
        move $s3 , $t5
	addi $t6 , $t6 , 64    # odstep od tablicy adresow do rablicy value
        # Inicjalizuj tablicę adresów wierszy
        li $t7, 0  # $t7 - indeks wiersza

    init_rows:
        beq $t7, $t1, fill_matrix  # Zakończ, gdy wszystkie wiersze zostały zainicjalizowane

        sw $t6, ($s3)  # Zapisz adres początku wiersza do tablicy adresów wierszy

        add $t6, $t6, $t3  # Przejdź do następnego wiersza
        addi $t6 , $t6 , 16
        addi $s3, $s3, 4  # Przejdź do następnego elementu tablicy adresów wierszy

        addi $t7, $t7, 1  # Zwiększ indeks wiersza
        j init_rows

    fill_matrix:
    
    	
    	
        # Inicjalizuj tablicę wartościami
        lw $s3 , ($t5)  # $s3 - adres początku tablicy danych
        add $s4 , $s4 , $t5  # $s3 - adres początku tablicy danych
	
        li $s0, 0  # $s0 - indeks wiersza

    fill_rows:
        beq $s0, $t1, choice  # Zakończ, gdy wszystkie wiersze zostały wypełnione
	li $s5 , 100   # dodawanie 100
	
	mul $s6 , $s5 , $s0 
        li $s1, 1  # $s1 - wartość początkowa
	add $s1 , $s1 , $s6
        li $t0, 0  # $t0 - indeks kolumny

    fill_row:
        beq $t0, $t2, next_row  # Zakończ, gdy wiersz został wypełniony

        sw $s1, ($s3)  # Zapisz wartość do tablicy danych

        addi $s3, $s3, 4  # Przejdź do kolejnego elementu tablicy danych
        addi $s1, $s1, 1  # Zwiększ wartość

        addi $t0, $t0, 1  # Zwiększ indeks kolumny
        j fill_row

    next_row:
        addi $s0, $s0, 1  # Przejdź do kolejnego wiersza
        addi $s4 , $s4 , 4 #adress na nastepny element tablicy adresow
        lw $s3 , ($s4)	#adres kolejnej teblicy
        
        j fill_rows

     choice:
     	li $v0, 4
   	la $a0, msg
   	syscall
   	
   	# Wybor 0 czy 1 (zapis i odczyt)
        li $v0, 5
        syscall
        move $s0, $v0  
        
        bnez $s0 , get_num
        
     rewrite_num:
     	li $v0, 4
   	la $a0, r_msg
   	syscall
   	
   	# Wczytaj wiersz
        li $v0, 5
        syscall
        move $s0, $v0  
        
        
        li $v0, 4
   	la $a0, c_msg
   	syscall
   	
   	# Wczytaj kolumne
        li $v0, 5
        syscall
        move $s1, $v0  
        
        li $v0, 4
   	la $a0, num_msg
   	syscall
   	
   	# Wczytaj cyfre
        li $v0, 5
        syscall
        move $s6, $v0 
        
        addi $s0, $s0 , -1 #cause first element is +0
        addi $s1, $s1 , -1 #cause first element is +0
        
        
        
        li  $s4 , 4 #4 bytes
        
        mul $s3 , $s0 , $s4 #row in bytes
        
        
        
        
        add $s5 , $s3 , $t5 # start address + row in  bytes
        
        lw $s5 , ($s5)  #loading address from array of addresses
        
        mul $s2 , $s4 , $s1 #now trying to get column(column in bytes)
        
       
        add $s5 , $s5 , $s2
        
        sw $s6 , ($s5)
        
        j choice
        
     	
     	
     
     
     
     get_num:
     	li $v0, 4
   	la $a0, r_msg
   	syscall
   	
   	# Wczytaj wiersz
        li $v0, 5
        syscall
        move $s0, $v0  
        
        
        li $v0, 4
   	la $a0, c_msg
   	syscall
   	
   	# Wczytaj kolumne
        li $v0, 5
        syscall
        move $s1, $v0  
        
         
        
        addi $s0, $s0 , -1 #cause first element is +0
        addi $s1, $s1 , -1 #cause first element is +0
        
        
        
        li  $s4 , 4 #4 bytes
        
        mul $s3 , $s0 , $s4 #row in bytes
        
        
        
        add $s5 , $s3 , $t5 # start address + row in  bytes
        
        lw $s5 , ($s5)  #loading address from array of addresses
        
        mul $s2 , $s4 , $s1 #now trying to get column(column in bytes)
        
       
        add $s5 , $s5 , $s2
        lw $s5 , ($s5)
        
        
        li $v0 ,1
        move $a0 , $s5
        syscall
        
        li $v0, 11       # System call code for printing a character
	li $a0, 10       # ASCII value for newline character (\n)
	syscall          # Perform the system call to print the newline

        
       
   	
   	j choice
    
    exit:
        # Zakończ program
        li $v0, 10
        syscall
