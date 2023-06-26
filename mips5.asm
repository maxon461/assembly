.data
coefs: .float 2.3 3.45 7.67 5.32
degree: .word 3
info1: .asciiz "\nwpisz 1, zeby policzyc wartosc wielomianu: "
info2: .asciiz "\nwpisz x: "
info3: .asciiz "\nobliczona wartosc: "
.text
main: 
		
li $v0, 4       	# informacja o wyborach         
la $a0, info1            
syscall                       
	
li $v0, 5		# pobieramy wybor                
syscall
   
li $t0, 1	 	# sprawdzamy, czy trzeba liczyc wartosc wielomianu                    
move $t1, $v0
bne $t0, $t1, end

li $v0, 4		# pytamy o wartosc x
la $a0, info2
syscall
     
li $v0, 7		# pobieramy x do $f0 
syscall
               
eval_poly:		# podprogram eval_poly   
li $t4, 4		# wczytujemy 4 do $t4, aby pomnozyc

li $t0, 0		# czyscimy poprzedni wynik z $f12
mtc1.d $t0, $f12

lw $t0, degree		# pobieramy stopien wielomianu do $t0

la $t2, coefs		# wczytujemy adres pierwszego wspolczynnika

mul $t1, $t0, $t4	# mnozymy razy 4, bo tyle zajmuje slowo

add $t2, $t2, $t1	# przesuwamy sie do wspolczynnika wyrazu wolnego

lui $t3, 0x3F80		# wczytujemy 1 w wersji 32bit IEEE754

mtc1 $t3, $f3		# przenosimy do $f3

cvt.d.s $f2, $f3	# zamieniamy 1 z float na double

poly_loop:		# rozpoczynamy obliczenia

bltz $t0, poly_loop_end	# sprawdzamy czy policzylismy juz wszystkie wspolczynniki*potegi x 

addi $t0, $t0, -1	# zmniejszamy licznik

lwc1 $f7, ($t2)		# pobieramy wspolczynnik wielomianu, idziemy od konca

cvt.d.s $f6, $f7	# zamieniamy z float na double

mul.d $f4, $f6, $f2	# mnozymy wsploczynnik i potege 

add.d $f12, $f12, $f4	# dodajemy wartosc do szukanej wartosci wielomianu

mul.d $f2, $f2, $f0	# mnozymy tymczasowa potege x*x, zwiekszamy potege

addi $t2, $t2, -4	# przesuwamy sie na adres kolejnego wpolczynnika wielomianu

j poly_loop		# wracamy do liczenia wartosci

poly_loop_end:  	# policzylismy, wiec wyswietlamy wynik z $f12

li $v0, 4      		# informacja o wyniku         
la $a0, info3  
syscall                      

li $v0, 3		# wynik z $f12                
syscall

j main			# wracamy do programu glownego
                  
end:			# konczymy program                              
li $v0, 10
syscall
