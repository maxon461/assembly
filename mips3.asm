# 1. Napisz program sortuj¹cy zadany ci¹g liczb ca³kowitych algorytmem b¹belkowym.
# 	a. Struktura programu ma byæ nastêpuj¹ca: „Modu³ g³ówny” jest odpowiedzialny za komunikacje z u¿ytkownikiem, wprowadzanie danych oraz wyprowadzanie
#	   wyniku, sam algorytm sortowania ma byæ zaimplementowany jako procedura (funkcja) wywo³ywana z modu³u g³ównego.
#	b. Zmodyfikuj program napisany w punkcie (a) w taki sposób aby przestawienie dwóch elementów ci¹gu by³o realizowane przez procedurê (funkcjê) wywo³ywan¹
#	   przez procedurê sortuj¹c¹.
#	c. Czym ró¿ni¹ siê programy w wersji (a) oraz (b), oczywiœcie poza dodatkow¹ procedur¹ (funkcj¹) ?
#2. Czy w programie wersji (b) musia³eœ zachowywaæ wartoœci rejestrów, jeœli tak to czy za
#zabezpieczenie wartoœci rejestrów odpowiedzialna by³a funkcja wywo³ywana czy wywo³uj¹ca? 
#Dlaczego wybra³eœ takie rozwi¹zanie ? Jeœli nie to przeprowadŸ „teoretyczn¹” dyskusjê
#która z wymienionych powy¿ej mo¿liwoœci jest „lepsza” i dlaczego

.data
	message: .asciiz "Podaj 5 liczb \n"
	array: .space 20
.text
	li $s0, 5
	li $s1, 20
	li $s2, 16
	
	main:
		li $v0, 4
		la $a0, message
		syscall
		
		# Licznik wprowadzania
		li $t0, 0
		input:
			li $v0, 5
			syscall
			
			sw $v0, array($t0)
			addi $t0, $t0, 4
			
			blt $t0, $s1, input
		# Koniec wprowadzania
		
		jal sort
		
		# Wyswietlanie tablicy
		li $t0, 0
		print:	
			lw $a0, array($t0)
			
			li $v0, 1
			syscall
			
			li $v0, 11
			li $a0, ' '
			syscall
			
			addi $t0, $t0, 4
			blt $t0, $s1, print
		# Koniec wyswietlania
	# Koniec programu
	li $v0, 10
	syscall
	
	sort:
		# Licznik i
		li $t0, 0
		for1:
			# Licznik j, t2 = t1 +4			
			li $t1, 0
			
			for2:
				addi $t2, $t1, 4
				lw $t3, array($t1)
				lw $t4, array($t2)
				
				ble $t3, $t4, noswap
				
				swap:
					sw $t4, array($t1)
					sw $t3, array($t2)	
															
				noswap:				
				addi $t1, $t1, 4
				blt $t1, $s2, for2
				
			# Koniec for2
			addi $t0, $t0, 1
			blt $t0, $s0, for1
		
		jr $ra
	
	