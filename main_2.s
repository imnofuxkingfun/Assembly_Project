.data
	endl:.asciz "\n"
	in_txt:.asciz "in.txt"
	out_txt:.asciz "out.txt"
	mr:.asciz "r"
	mw:.asciz "w"
	fdesc:.space 4
	fdesc2:.space 4
	space:.asciz " "
	formatscanf:.asciz "%d"
	formatprintf:.asciz "%d "
	mlines:.space 4
	ncols:.space 4
	p:.space 4
	x:.space 4
	y:.space 4
	k:.space 4
	v:.space 4
	matrix:.zero 1600
	matrix2:.zero 1600
	lineindex:.space 4
	colindex:.space 4
	
.text
.global main
main:
#CITIRI__________________________________________________________________
	#citire m,n,p
	#DESCHIDERE FISIER
	
	push $mr #reading
	push $in_txt
	call fopen
	addl $8, %esp
	
	movl %eax, fdesc
	
	push $mlines
	push $formatscanf
	push fdesc
	call fscanf
	addl $12, %esp
	
	push $ncols
	push $formatscanf
	push fdesc
	call fscanf
	addl $12, %esp
	
	push $p
	push $formatscanf
	push fdesc
	call fscanf
	addl $12, %esp
	
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
	push fdesc
	call fscanf
	addl $12, %esp
	
	push $y
	push $formatscanf
	push fdesc
	call fscanf
	addl $12, %esp

	#x*ncols + y
	movl x, %eax
	mull ncols #eax este indexul din array
	addl y, %eax
	
	movl $1, (%edi,%eax,4)
	
	pop %ecx
	incl %ecx

	jmp et_p
		

	
cit_k:
	movl $0, p
	
	push $k
	push $formatscanf
	push fdesc
	call fscanf
	addl $12, %esp
	
	push fdesc
	call fclose
	pop %ebx
	
	
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
	je afisare_matrix_ext_mij

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
	
	

#AFISARI______________________________________________________
		

afisare_matrix:
	movl $0, lineindex
	
	push $mw #writing
	push $out_txt
	call fopen
	addl $8, %esp
	
	movl %eax, fdesc
	
et_lines:
	movl lineindex, %ecx
	cmp mlines, %ecx
	je k_evolutie_2  #AFISARE DE VERIFICARE LA FIECARE PAS
	
	movl $0, colindex

et_col:
	movl colindex,  %ecx
	cmp ncols, %ecx
	je et_cont_lines
	movl lineindex, %eax
	mull ncols
	addl colindex, %eax	
	push (%edi,%eax,4)
	push $formatprintf
	push fdesc
	call fprintf
	addl $12, %esp
	incl colindex
	jmp et_col
	

et_cont_lines:
	push $endl
	push fdesc
	call fprintf
	addl $8, %esp
	incl lineindex
	jmp et_lines
	

#___________________________________	
afisare_matrix_ext_mij:
	movl $1, lineindex
	
	push $mw #writing
	push $out_txt
	call fopen
	addl $8, %esp
	
	movl %eax, fdesc
mij_lines:
	movl lineindex, %ecx
	cmp mlines, %ecx
	jg last_endl
	
	movl $1, colindex
	
mij_cols:
	movl colindex, %ecx
	cmp ncols, %ecx
	jg mij_lines_cont
	
	movl ncols, %eax
	addl $2, %eax
	movl lineindex, %edx
	mull %edx
	addl colindex, %eax
	
	push (%edi,%eax,4)
	push $formatprintf
	push fdesc
	call fprintf
	addl $12, %esp
	incl colindex
	jmp mij_cols
	

mij_lines_cont:
	push $endl
	push fdesc
	call fprintf
	addl $8, %esp
	
	incl lineindex
	jmp mij_lines

last_endl:
	#push $endl
	#call printf
	#add $4, %esp
	#jmp et_exit

et_exit:

	push $0
	call fflush
	addl $4, %esp
	
	push fdesc
	call fclose
	addl $4, %esp
	
	mov $1, %eax
	mov $0, %ebx
	int $0x80
	
	

	
	
	
	
	
