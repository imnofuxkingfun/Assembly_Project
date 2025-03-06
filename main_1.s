.data
	mlines:.space 4
	ncols:.space 4
	p:.space 4
	x:.space 4
	y:.space 4
	k:.space 4
	v:.space 4
	c:.space 4
	msj:.space 23
	matrix:.zero 1600
	matrix2:.zero 1600
	matrix_lit:.zero 800
	formatscanf:.asciz "%d"
	formatlet:.asciz "%c"
	formatprintf:.asciz "%d "
	formatword:.asciz "%s"
	stringx:.asciz "x"
	endl:.asciz "\n"
	lineindex:.space 4
	colindex:.space 4
	
.text
.global main
main:
#CITIRI__________________________________________________________________
	#citire m,n,p
	#scanf("%d",&mlines) analong ncols, p
	
	push $mlines
	push $formatscanf
	call scanf
	addl $8, %esp
	
	push $ncols
	push $formatscanf
	call scanf
	addl $8, %esp
	
	push $p
	push $formatscanf
	call scanf
	addl $8, %esp
	
	#bucla de citit perechile
	#for(i=0,i<p,i++)
	
	movl $matrix, %edi
	movl $0, %ecx
	
et_p: #citire p perechi
	cmp p, %ecx
	je cit_k
	
	push %ecx
	
	#citim x,y
	push $x
	push $formatscanf
	call scanf
	pop %ebx
	pop %ebx
	
	push $y
	push $formatscanf
	call scanf
	pop %ebx
	pop %ebx

	#x*ncols + y
	movl x, %eax
	mull ncols #eax este indexul din array
	addl y, %eax
	
	movl $1, (%edi,%eax,4)
	pop %ecx
	incl %ecx

	jmp et_p
		

	
cit_k:
	
	push $k
	push $formatscanf
	call scanf
	addl $8, %esp
	
cit_c:
	push $c
	push $formatscanf
	call scanf
	addl $8, %esp
	
	
cit_msj:
	push $msj
	push $formatword
	call scanf
	addl $8, %esp
	

	
	
#extinderea matricii de jos in sus
#___________________________________________________________________
ext_matrix:
	movl mlines, %eax
	movl %eax, lineindex
	decl lineindex
	

ext_matrix_lines:

	movl ncols, %eax
	movl %eax, colindex
	decl colindex

ext_matrix_cols:

	#element = (linie+1)*(nrcoloane +2) + col+1
	movl ncols, %eax
	addl $2, %eax
	movl lineindex, %edx
	addl $1, %edx
	mull %edx
	addl colindex, %eax
	addl $1, %eax
	
	movl %eax, %ebx
	
	
	movl lineindex, %eax
	mull ncols
	addl colindex, %eax
	movl (%edi,%eax,4), %edx
	
	
	movl %edx, (%edi,%ebx,4) #punere in extindere
	
	movl $0, (%edi,%eax,4) #stergerea vechiului element
	
	movl colindex, %ecx
	cmp $0, %ecx
	je ext_matrix_lines_dec
	
	decl colindex
	jmp ext_matrix_cols
	
ext_matrix_lines_dec:
	movl lineindex, %ecx
	cmp $0, %ecx
	je k_evolutie

	decl lineindex
	jmp ext_matrix_lines
	
	
#k-evolutie______________________________________________________
k_evolutie:
	movl k, %ecx
	cmp $0, %ecx
	je criptare_decriptare

#parcurgere matrix
	movl $matrix2, %esi
	movl $1, lineindex
	
parcurgere_linii:
	movl lineindex, %ecx
	cmp mlines, %ecx
	jg parcurgere_matrix2
	movl $1, colindex
	
parcurgere_coloane:
	movl colindex,  %ecx
	cmp ncols, %ecx
	jg cont_linii

#________________________________________________________
numarare_vecini_vii:
	
	movl $0, v #in v numaram vecinii vii
	
	#ao - a[i-1][j-1]
	
	movl ncols, %eax
	addl $2, %eax
	movl lineindex, %edx
	decl %edx
	mull %edx
	addl colindex, %eax
	decl %eax

	movl (%edi, %eax, 4), %ebx
	addl %ebx, v
	
	#a1 - a[i-1][j]
	
	movl ncols, %eax
	addl $2, %eax
	movl lineindex, %edx
	decl %edx
	mull %edx
	addl colindex, %eax
	
	movl (%edi, %eax, 4), %ebx
	addl %ebx, v
	
	#a2 - a[i-1][j+1]
	
	movl ncols, %eax
	addl $2, %eax
	movl lineindex, %edx
	decl %edx
	mull %edx
	addl colindex, %eax
	addl $1, %eax
	
	movl (%edi, %eax, 4), %ebx
	addl %ebx, v
	
	#a3 - a[i][j+1]
	
	movl ncols, %eax
	addl $2, %eax
	movl lineindex, %edx
	mull %edx
	addl colindex, %eax
	addl $1, %eax

	movl (%edi, %eax, 4), %ebx
	addl %ebx, v
	
	#a4 - a[i+1][j+1]
	
	movl ncols, %eax
	addl $2, %eax
	movl lineindex, %edx
	addl $1, %edx
	mull %edx
	addl colindex, %eax
	addl $1, %eax

	movl (%edi, %eax, 4), %ebx
	addl %ebx, v
	
	#a5 - a[i+1][j]
	
	movl ncols, %eax
	addl $2, %eax
	movl lineindex, %edx
	addl $1, %edx
	mull %edx
	addl colindex, %eax

	movl (%edi, %eax, 4), %ebx
	addl %ebx, v
	
	#a6 - a[i+1][j-1]
	
	movl ncols, %eax
	addl $2, %eax
	movl lineindex, %edx
	addl $1, %edx
	mull %edx
	addl colindex, %eax
	decl %eax


	movl (%edi, %eax, 4), %ebx
	addl %ebx, v
	
	#a7 - a[i][j-1]
	
	movl ncols, %eax
	addl $2, %eax
	movl lineindex, %edx
	mull %edx
	addl colindex, %eax
	decl %eax


	movl (%edi, %eax, 4), %ebx
	addl %ebx, v
	

	movl ncols, %eax
	addl $2, %eax
	movl lineindex, %edx
	mull %edx
	addl colindex, %eax
	
	movl (%edi,%eax,4), %ebx # <- elem curent
	
#_________________________________________________
	
#GAME OF LIFE
#subpopulare - in viata, v<2  -> moare
subpopulare:
	cmp $0, %ebx
	je creare
	
	movl v, %ecx
	cmp $2, %ecx
	je cont_viata
	cmp $3, %ecx
	je cont_viata
	jg ultrapopulare
	
	movl $0, (%esi,%eax,4) 
	jmp cont_coloana
	
#cont_vie - in viata 2-3 vecini -> ramane in viata
cont_viata:
	movl $1, (%esi,%eax,4)
	jmp cont_coloana
	
#ultrapopulare - in viata v>3 vecini -> moare
ultrapopulare:
	movl $0, (%esi,%eax,4)
	jmp cont_coloana
	
#creare - moarta - exact 3 vecini - > invie
creare:
	movl v, %ecx
	cmp $3, %ecx
	jne cont_mort
	
	movl $1, (%esi,%eax,4)
	jmp cont_coloana
	
#cont_mort - moarta - v!=3 -> ramane moarta
cont_mort:
	movl $0, (%esi,%eax,4)
	jmp cont_coloana
#____________________________________________________

cont_coloana:
	incl colindex
	jmp parcurgere_coloane

cont_linii:
	incl lineindex
	jmp parcurgere_linii

#_______________________________________
	
#update matrix cu matrix2

parcurgere_matrix2:
	movl $0, lineindex

matrix2_lines:
	movl lineindex, %ecx
	cmp mlines, %ecx
	jg k_evolutie_2
	movl $0, colindex
	
matrix2_cols:
	movl colindex,  %ecx
	cmp ncols, %ecx
	jg matrix2_lines_cont
	
	movl ncols, %eax
	addl $2, %eax
	movl lineindex, %edx
	mull %edx
	addl colindex, %eax
	
	
	movl (%esi, %eax, 4), %ebx
	movl %ebx, (%edi, %eax, 4)
	
	incl colindex
	jmp matrix2_cols
	
	
matrix2_lines_cont:
	incl lineindex
	jmp matrix2_lines

#______________________________________

k_evolutie_2:

	decl k
	jmp k_evolutie

#________________________________________________________

criptare_decriptare:
	movl c, %ecx
	cmp $0, %ecx
	je criptare
	jmp decriptare
	
#_______________________________________

#CRIPTARE!!
criptare:

	push $msj
	call strlen
	pop %ebx
	
	movl %eax, p #recycle p ca lungimea msj-ului
	
	movl $matrix_lit, %esi
	movl $0, %ecx #ecx e acum numarul lit la care ma aflu
	
	
#punerea de coduri ascii in binar in matrix_lit, p linii 8 coloane
litere_binar:
	cmp p, %ecx
	je dim_matrix

	movl msj(%ecx), %eax
	movl $0, %edx
	movl $256, %ebx
	divl %ebx
	movl %edx, x
	
	#acum in x am codul ascii al literei la care sunt
	
	
	
binar7:
	movl x, %edx
	cmp $128, %edx
	jl binar6
	
	movl $8, %eax
	mull %ecx
	addl $0, %eax
	movl $1, (%esi, %eax, 4)
	subl $128, x #?merge?? ! a mers
	

binar6:
	movl x, %edx
	cmp $64, %edx
	jl binar5
	
	movl $8, %eax
	mull %ecx
	addl $1, %eax
	movl $1, (%esi, %eax, 4)
	subl $64, x
	
	
binar5:
	movl x, %edx
	cmp $32, %edx
	jl binar4
	
	movl $8, %eax
	mull %ecx
	addl $2, %eax
	movl $1, (%esi, %eax, 4)
	subl $32, x
	
binar4:
	movl x, %edx
	cmp $16, %edx
	jl binar3
	
	movl $8, %eax
	mull %ecx
	addl $3, %eax
	movl $1, (%esi, %eax, 4)
	subl $16, x
	
binar3:
	movl x, %edx
	cmp $8, %edx
	jl binar2
	
	movl $8, %eax
	mull %ecx
	addl $4, %eax
	movl $1, (%esi, %eax, 4)
	subl $8, x
	
binar2:
	movl x, %edx
	cmp $4, %edx
	jl binar1
	
	movl $8, %eax
	mull %ecx
	addl $5, %eax
	movl $1, (%esi, %eax, 4)
	subl $4, x
	
binar1:
	movl x, %edx
	cmp $2, %edx
	jl binar0
	
	movl $8, %eax
	mull %ecx
	addl $6, %eax
	movl $1, (%esi, %eax, 4)
	subl $2, x
	
	
binar0:
	movl $8, %eax
	mull %ecx
	addl $7, %eax
	movl x, %ebx
	movl %ebx, (%esi, %eax, 4)
	
	
	
	
	incl %ecx
	jmp litere_binar
#______________________________________________________

#verificare daca matrix e mai mic decat matrix_lit
# ncols*mlines < 8*p => extindem matricea in cont
dim_matrix:
	
	movl ncols, %eax
	addl $2, %eax
	movl mlines, %ebx
	addl $2, %ebx
	mull %ebx
	movl %eax, %ebx
	
	movl $8, %eax
	movl p, %ecx
	mull %ecx
	
	cmp %eax, %ebx 
	jge xor_matrix
	
	#recycle y ca diferenta dintre lungimile matricelor
	subl %ebx, %eax
	movl %eax, y
	
	#calculez de unde sa incep sa scriu in matrix1 (edi)
	movl ncols, %eax
	addl $2, %eax
	movl mlines, %edx
	addl $2, %edx
	mull %edx
	
	movl %eax, x
	movl $0, %ecx
		
#de y ori, pun in de la inceputul matrix-ului la adresa+x
dim_matrix_loop:
	cmp y, %ecx
	je xor_matrix
	
	movl (%edi, %ecx, 4), %ebx
	
	movl %ecx, %eax
	addl x, %eax
	
	movl %ebx, (%edi, %eax, 4)
	
	incl %ecx
	jmp dim_matrix_loop
	
	
	

#________________________________________________
#INCEP CRIPTAREA! xor intre matrix si matrix_lit
xor_matrix:

	movl $8, %eax
	movl p, %ecx
	mull %ecx
	movl %eax, y #<-nr de elemente de xor-uit = 8*p
	movl $0, %ecx
	
	
xor_loop:
	cmp y, %ecx
	je hexa
	
	movl (%edi, %ecx, 4), %eax
	movl (%esi, %ecx, 4), %ebx
	
	#xor intre eax si ebx -> punere in esi -> hexa -> afisare
	xor %eax, %ebx
	movl %ebx, (%esi, %ecx, 4)
	
	incl %ecx
	jmp xor_loop
	
hexa:
	
	#mergem cate 4 -> calculam decimal 
	# 10<  -> afisam asa cum e
	# >10  adunam cu codul ascii lui 'A' (97-32=65) ->afisam
	
	#afisam  0x
	push $0
	push $formatscanf
	call printf
	addl $8, %esp
	
	push $stringx
	call printf
	addl $4, %esp
		
	push $0
	call fflush
	pop %ebx

	movl $0, v # <- elem la care sunt
	
hexa_loop:
	movl v, %ecx
	cmp y, %ecx # <-daca am trecut prin toate
	je et_exit #??
	

hexa_loop4:
	
	movl $0, %ebx
	
	movl v, %eax
	movl (%esi, %eax, 4), %eax
	movl $8, %ecx
	mull %ecx
	
	addl %eax, %ebx
	incl v
	
	movl v, %eax
	movl (%esi, %eax, 4), %eax
	movl $4, %ecx
	mull %ecx
	
	addl %eax, %ebx
	incl v
	
	movl v, %eax
	movl (%esi, %eax, 4), %eax
	movl $2, %ecx
	mull %ecx
	
	addl %eax, %ebx
	incl v
	
	movl v, %eax
	movl (%esi, %eax, 4), %eax
	movl $1, %ecx
	mull %ecx
	
	addl %eax, %ebx
	incl v
	
	cmp $9, %ebx
	jle hexa_afisare19
	jmp hexa_afisareAF
	
hexa_afisare19:
	addl $48, %ebx
	movl %ebx, x
	push x
	push $formatlet #fara spatiu
	call printf
	addl $8, %esp
	
	push $0
	call fflush
	pop %ebx
	
	jmp hexa_loop
	
hexa_afisareAF:
	addl $55, %ebx
	movl %ebx, x
	push x
	push $formatlet #??
	call printf
	addl $8, %esp
	
	push $0
	call fflush
	pop %ebx
	
	
	jmp hexa_loop
	
	
#_____________________________________________________________
#DECRIPTARE!!!!!!
decriptare:
	push $msj
	call strlen
	pop %ebx
	
	movl %eax, p #recycle p ca lungimea msj-ului
	
	movl $matrix_lit, %esi
	movl $2, %ecx #ecx e acum numarul lit la care ma aflu -> de la 0x incolo
	
	
#punerea de coduri ascii in binar in matrix_lit, p linii 4 coloane
hexa_binar:
	cmp p, %ecx
	je dim_matrix2
	
	movl msj(%ecx), %eax
	movl $0, %edx
	movl $256, %ebx
	divl %ebx
	movl %edx, x
	
	#acum in x am codul ascii al caracterului la care sunt
	
#unlike criptare, acum avem doar 4 biti, nu 8
# 48-57  -> scadem 48 -> apoi bagam
# 65-70 scadem cu codul ascii lui 'A'-10 (97-32=65-10=55)

hexa_binar_ascii19:

	cmp $57, %edx
	jg hexa_binar_asciiAF
	
	subl $48, x
	jmp hexa_binar3
	
hexa_binar_asciiAF:
	subl $55, x
	

hexa_binar3:

	movl x, %edx
	cmp $8, %edx
	jl hexa_binar2
	
	movl $4, %eax
	movl %ecx, %edx
	subl $2, %edx
	mull %edx
	addl $0, %eax
	movl $1, (%esi, %eax, 4)
	subl $8, x
	
hexa_binar2:
	movl x, %edx
	cmp $4, %edx
	jl hexa_binar1
	
	movl $4, %eax
	movl %ecx, %edx
	subl $2, %edx
	mull %edx
	addl $1, %eax
	movl $1, (%esi, %eax, 4)
	subl $4, x
	
hexa_binar1:
	movl x, %edx
	cmp $2, %edx
	jl hexa_binar0
	
	movl $4, %eax
	movl %ecx, %edx
	subl $2, %edx
	mull %edx
	addl $2, %eax
	movl $1, (%esi, %eax, 4)
	subl $2, x
	
hexa_binar0:
	movl $4, %eax
	movl %ecx, %edx
	subl $2, %edx
	mull %edx
	addl $3, %eax
	movl x, %ebx
	movl %ebx, (%esi, %eax, 4)
	
	
	incl %ecx
	jmp hexa_binar
	
#______________________________________________________

#verificare daca matrix e mai mic decat matrix_lit
# ncols*mlines < 4*(p-2) => extindem matricea in cont
dim_matrix2:

	movl ncols, %eax
	addl $2, %eax
	movl mlines, %ebx
	addl $2, %ebx
	mull %ebx
	movl %eax, %ebx
	
	subl $2, p
	
	movl $4, %eax
	movl p, %ecx
	mull %ecx
	
	cmp %eax, %ebx 
	jge xor_matrix2
	
	#recycle y ca diferenta dintre lungimile matricelor
	subl %ebx, %eax
	movl %eax, y
	
	#calculez de unde sa incep sa scriu in matrix1 (edi)
	movl ncols, %eax
	addl $2, %eax
	movl mlines, %edx
	addl $2, %edx
	mull %edx
	
	movl %eax, x
	movl $0, %ecx
	
#de y ori, pun in de la inceputul matrix-ului la adresa+x
dim_matrix_loop2:
	cmp y, %ecx
	je xor_matrix2
	
	movl (%edi, %ecx, 4), %ebx
	
	movl %ecx, %eax
	addl x, %eax
	
	movl %ebx, (%edi, %eax, 4)
	
	incl %ecx
	jmp dim_matrix_loop2
	
	
#________________________________________________
#INCEP DECRIPTAREA! xor intre matrix si matrix_lit
xor_matrix2:

	movl $4, %eax
	movl p, %ecx
	mull %ecx
	movl %eax, y #<-nr de elemente de xor-uit = 8*p
	movl $0, %ecx
	
	
xor_loop2:
	cmp y, %ecx
	je clar
	
	movl (%edi, %ecx, 4), %eax
	movl (%esi, %ecx, 4), %ebx
	
	#xor intre eax si ebx -> punere in esi -> hexa -> afisare
	xor %eax, %ebx
	movl %ebx, (%esi, %ecx, 4)
	
	incl %ecx
	jmp xor_loop2
	
clar:
	#mergem cate 8 -> calculam decimal
	#afisam
	
	movl $0, v # <- elem la care sunt
	
clar_loop:
	movl v, %ecx
	cmp y, %ecx # <-daca am trecut prin toate
	je et_exit 
	
clar_loop8:

	movl $0, %ebx
	
	movl v, %eax
	movl (%esi, %eax, 4), %eax
	movl $128, %ecx
	mull %ecx
	
	addl %eax, %ebx
	incl v
	
	movl v, %eax
	movl (%esi, %eax, 4), %eax
	movl $64, %ecx
	mull %ecx
	
	addl %eax, %ebx
	incl v
	
	movl v, %eax
	movl (%esi, %eax, 4), %eax
	movl $32, %ecx
	mull %ecx
	
	addl %eax, %ebx
	incl v
	
	movl v, %eax
	movl (%esi, %eax, 4), %eax
	movl $16, %ecx
	mull %ecx
	
	addl %eax, %ebx
	incl v
	
	
	movl v, %eax
	movl (%esi, %eax, 4), %eax
	movl $8, %ecx
	mull %ecx
	
	addl %eax, %ebx
	incl v
	
	movl v, %eax
	movl (%esi, %eax, 4), %eax
	movl $4, %ecx
	mull %ecx
	
	addl %eax, %ebx
	incl v
	
	movl v, %eax
	movl (%esi, %eax, 4), %eax
	movl $2, %ecx
	mull %ecx
	
	addl %eax, %ebx
	incl v
	
	movl v, %eax
	movl (%esi, %eax, 4), %eax
	movl $1, %ecx
	mull %ecx
	
	addl %eax, %ebx
	incl v
	
clar_afisare:
	movl %ebx, x
	push x
	push $formatlet
	call printf
	addl $8, %esp
	
	push $0
	call fflush
	pop %ebx
	
	jmp clar_loop
	
	

#AFISARI______________________________________________________

last_endl:
	push $endl
	call printf
	add $4, %esp
	jmp et_exit

et_exit:

	push $endl
	call printf
	pop %ebx
	
	push $0
	call fflush
	addl $4, %esp
	
	
	mov $1, %eax
	mov $0, %ebx
	int $0x80
	
	

	
	
	
	
	
