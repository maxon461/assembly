# 1. Napisz program sortuj�cy zadany ci�g liczb ca�kowitych algorytmem b�belkowym.
# 	a. Struktura programu ma by� nast�puj�ca: �Modu� g��wny� jest odpowiedzialny za komunikacje z u�ytkownikiem, wprowadzanie danych oraz wyprowadzanie
#	   wyniku, sam algorytm sortowania ma by� zaimplementowany jako procedura (funkcja) wywo�ywana z modu�u g��wnego.
#	b. Zmodyfikuj program napisany w punkcie (a) w taki spos�b aby przestawienie dw�ch element�w ci�gu by�o realizowane przez procedur� (funkcj�) wywo�ywan�
#	   przez procedur� sortuj�c�.
#	c. Czym r�ni� si� programy w wersji (a) oraz (b), oczywi�cie poza dodatkow� procedur� (funkcj�) ?
#2. Czy w programie wersji (b) musia�e� zachowywa� warto�ci rejestr�w, je�li tak to czy za
#zabezpieczenie warto�ci rejestr�w odpowiedzialna by�a funkcja wywo�ywana czy wywo�uj�ca? 
#Dlaczego wybra�e� takie rozwi�zanie ? Je�li nie to przeprowad� �teoretyczn�� dyskusj�
#kt�ra z wymienionych powy�ej mo�liwo�ci jest �lepsza� i dlaczego

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
	
	