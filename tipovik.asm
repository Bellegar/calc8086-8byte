;17 �������, �����������,4 ����� �������� ��� ������ 8-���� �������
;����� �������������� � ���� ������� ������� �������� �� ����� � ���
;������ �������� -1254 � znak* ����� ������� "1", � � �����
;0000000000000001254
;����� ������� �� 19 10������ ��������, �.�. ���� 8����-� �������� �����
;��� 9223372036854775807 19 �������� (����������� � 2 ���� ������)
print  macro str	;� str ������� ����� ������ ��� ������
mov ah, 09h			
lea dx, str			
int 21h				
endm

operset macro		;����� ������� +-/* � �������������
print operac		;����� �� ������� � ����� ������
b1:
mov ah, 01h
int 21h 
cmp al,'+'
je b2
cmp al,'-'
je b313
cmp al,'*'
je b44
cmp al,'/'				
je b55
cmp al,'q'			;��� ������
jne b0
mov ah,4ch			;�����
int 21h
b0:
mov bh,0			;���� ������ ���� ������, �� �������
mov ah,03h			;� ����� ����� � ������� ����� �������
int 10h				;������ "�������������"
dec dl
mov ah,02h
int 10h
jmp b1
b2: ;-------------------------------plus
	mov al,znak2
	cmp znak1,al
	jne b21
	cmp znak1,'1'			;-1-2 (������������� ������ �����
	jne b23					;������������ � ������������� 2��)
	mov znakrez,'1'			;�.�. ����� ��� ����� ������ � �.�.
	push offset num1		;����� ������� ������������ �����
	push offset num2		;�������� ������� ���������
	call plus
	jmp bend
	b23:
	mov znakrez,'0'
	push offset num1
	push offset num2
	call plus				;1+2
	jmp bend
	b313:
	jmp b3
	b44:
	jmp b4
	b55:
	jmp b5
	b21:
	cmp znak1,'1'			;-1+2 �.�. ��������� �� 2 1
	jne b22
	push offset num2
	push offset num1
	call minus
	jmp bend
	b22:					;1-2
	push offset num1
	push offset num2
	call minus
	jmp bend

b3: ;---------------------------------minus
	cmp znak2,'1'			;x--2
	jne b31		
	cmp znak1,'0'			;1--2 �.� �������� 1 � 2
	jne b32
	mov znakrez,'0'	
	push offset num1
	push offset num2
	call plus		
	jmp bend
	b32:					;-1--2
	push offset num2
	push offset num1
	call minus
	jmp bend
	b31:					;x-2
	cmp znak1,'1'			;-1-2
	jne b33
	mov znakrez,'1'	
	push offset num1
	push offset num2
	call plus
	jmp bend
	b33:					;1-2
	push offset num1
	push offset num2
	call minus
	jmp bend
b4:	;------------------------------umnoz
	mov oper,'*'
	mov al,znak2
	cmp znak1,al
	jne b41
	mov znakrez,'0' 		;(-1)*(-2)| 1*2
	push offset num1
	push offset num2
	call umnoz
	jmp bend
	b41:
	mov znakrez,'1'			;(-1)*2 | 1*(-2)
	push offset num1
	push offset num2
	call umnoz
	jmp bend
b5:	;-------------------------------deli
	mov oper,'/'
	mov al,znak2
	cmp znak1,al
	jne b51
	mov znakrez,'0' 		;(-1)/(-2)| 1/2
	push offset num1
	push offset num2
	push word ptr len1
	call deli
	jmp bend
	b51:
	mov znakrez,'1'			;(-1)/2 | 1/(-2)
	push offset num1
	push offset num2
	push word ptr len1
	call deli
	jmp bend
bend:
endm

stat macro					;����������:���-�� ���� � ������
print dlina1				;����� ������, ���� ����� ��
push word ptr len1
call OutInt
print newline
print dlina2
push word ptr len2
call OutInt
print newline
push offset num1
push offset num2
call bolshe
cmp bolshemain,'1'
jne k1
print bol1
k1:
cmp bolshemain,'='
jne k2
print ravny
k2:
cmp bolshemain,'0'
jne k3
print bol21
k3:
endm
;--------------------NACHALO-------------------------
.model small
.stack 100h
.data
vvedich db 10,13,'Vvedi chislo: ',10,13, '$'
operac db 10,13,'Operaciya(+,-,/,*): $'
newline db 10,13,'$';������� �������
result db 10,13,'Resultat: $'
bol1 db 10,13,'1 Bolse 2go (po modulu) $'
bol21 db 10,13,'2 Bolse 1go (po modulu) $'
ravny db 10,13,'Ravny (po modulu) $'
error0 db 10,13,'Delenie na 0$'
dlina1 db 'Dlina pervogo chisla $'
dlina2 db 'Dlina vtorogo chisla $'
predis db 10,13,'Press q for exit $'
newprogr db 10,13,'------------------------------$'
minn db 18 dup(0),'1'		;������ �������
nolch db 19 dup(0)			;���������� ����
bufvv db 20 dup (0)			;����� (���������� ��� �� ������)
bufdel db 19 dup (0) 		;����� ��� �������� �������
bufost db 19 dup (0) 		;����� ��� ������� �� �������
num1 db 19 dup (0)			;������ �����
znak1 db 0 					;1 - / 0 +
num2 db 19 dup (0)			;������ �����
znak2 db 0 					;1 - / 0 +
resul db 20 dup (0)			;���������
resul1 db 20 dup (0)		;��������� ��� �������� � �������
znakrez db 0				;���� ����������
len1 db 0					;����� 1 � 2 �����
len2 db 0
oper db ?					;��� ������� ��������
buf1 db 0					;�����
buf2 db ?						
negmin db '0'				;���� ����� ���� ��������� (����� ������)
bolshemain db '0'			;������ �� ������ �����.0 ���/1 ��/= �����
nol30 db '0'				;����� �� ���� �����? 0 ���/1 ��
nol00 db '0'				;����� �� �����-�����? 0 ���/1 ��
err1 db '0'					;������, ������� �� 0

;-----------------------KOD--------------------------------------
.code
start:
mov ax, @data				;������ � ax ������ �� ������� ������
mov ds, ax					;������������� �������� ������
mov es, ax					;������������� �������� ���. ������
LOCALS
again:
call otchbuf				;�������� ��������
print predis				
push offset znak1
push offset num1
push offset len1
call vvod					;���� ������� �����. ����� �������
push offset znak2
push offset num2
push offset len2
call vvod
operset						;����� ��������
print newline
call outrez
print newline
stat						;����� ����������
print newprogr				;----
jmp again
mov ah,4ch
int 21h

;---------------------BOLSHE---------------------
bolshe proc pascal uses si di cx ax
arg @num11,@num22			;������ �� ������ ��� ������
mov si,@num11
mov di,@num22
mov cx, 19
push @num11
call pl30h
push @num22
call pl30h
mov si,@num11
mov di,@num22
mov cx, 19
push ax
bol2:
mov al,byte ptr [di]
cmp byte ptr [si], al
jne bol11
inc si
inc di
loop bol2
mov bolshemain,'='
jmp bol12
bol11:
cmp byte ptr [si], al
ja bol3
mov bolshemain,'0'
jmp bol12
bol3:
mov bolshemain,'1'
bol12:
pop ax
ret
bolshe endp

;----------nol30h?----------
nol proc pascal				;������� ����� �� ����� ����?
arg @nu1
mov cx,19
mov di,@nu1
pll:
cmp byte ptr [di],30h
jne no1
inc di
loop pll
mov nol30, '1'
ret
no1:
mov nol30,'0'
ret
nol endp
;----------nol0030h?----------
noln proc pascal			;����� �� �����-����� � ����?
arg @nu1
mov cx,19
mov di,@nu1
pl0l:
cmp byte ptr [di],00h
jne no011
jmp no21
no011:
cmp byte ptr [di],30h
jne no01
no21:
inc di
loop pl0l
mov nol00, '1'
ret
no01:
mov nol00,'0'
ret
noln endp

;-----------kopirovanie is numm1 v numm2------
kopyr proc pascal uses si di cx		
arg @numm1,@numm2					;����������� ����� �� �1 � �2
mov si,@numm1
mov di,@numm2
mov cx,19
cld
rep movsb
ret
kopyr endp

;-----------------PLUS---------------
plus proc pascal					;�������� �����
arg @num11, @num22
clc
mov oper,'+'
mov si,@num11
add si,18
mov di,@num22
add di,18
lea bx,resul1+18
mov cx, 19
pl1:
mov ah,00
mov al,[si]
adc al,[di]
aaa
pushf
or al,30h
popf
mov [bx],al
dec di
dec si
dec bx
loop pl1
mov [bx],ah
ret

plus endp

;--------------------MINUS-------------
minus proc pascal
arg @num11, @num22    		;��������� �1-�2
mov oper,'-'
clc
mov znakrez,'0'
mov si,@num11
add si,18
mov di,@num22
add di,18
lea bx,resul+18
mov cx, 19
mn1:
mov ah,00
mov al,[si]
sbb al,[di]
aas
pushf
or al,30h
popf
mov [bx],al
dec di
dec si
dec bx
loop mn1
mov [bx],ah
cmp ah,0ffh
jne minend
mov znakrez,'1'			;����� ��������� ���������
mov negmin,'1'			;���� ��������� ����� (������) 
minend:					;��� ����� �2>�1
cmp znakrez,'1'
jne ost1
push offset nolch		
push offset bufost
call kopyr
ost1:
push offset resul
push offset bufost
call kopyr				;����������� ���������� ��������� � "�������"
ret						;��� �������
minus endp

;---------------UMNOZENIE-----------------
umnoz proc pascal 
arg @num11, @num22		;�1*�2 ��������� ���������� ������� ��������
push word ptr buf1		;������ ����� �1 ���������� �� �������� ����� 
mov di,@num22			;�2, ����� �����  � ����� � ��������� � ��������� 
add di,18				;����� ���������� ����� ������� ������������ 
mov buf1,19				;� �.�. ��� �������� �� ����� ����� �2 ��������� 
mov buf2,0				;����� ���-� �� ��������.
um2:
and byte ptr [di],0fh
mov si,@num11
add si,18
lea bx,resul+18
sub bx,word ptr buf2
mov cx, 19
um1:
mov al,[si]
and al,0fh
mul byte ptr [di]
aam
add al,[bx]
aaa
mov [bx],al
dec bx
add [bx],ah
aaa
dec si
loop um1

dec di
inc buf2 
dec buf1
cmp buf1,0
jne um2
push offset resul
call pl30h
pop word ptr buf1
ret
umnoz endp
;-------------30h----------------
pl30h proc pascal			;����������� � ����� 30h �� ����
arg @nu1
mov cx,19
mov di,@nu1
plll:
or byte ptr [di],30h
inc di
loop plll
ret
pl30h endp
;------------mn30h--------------------
mn30h proc pascal			;������� 30h �� �����
arg @nuu1
mov cx,19
mov di,@nuu1
plllm:
and byte ptr [di],0fh
inc di
loop plllm
ret
mn30h endp

;----------DELENIE bazovoe--------------------
delibaz proc pascal uses si di cx bx ax dx
arg @num11, @num22			;�1/�2  ����� ��� ������ �������� �������
push word ptr znakrez		;�.�. ��� ������� ��������� ������ ��������
push offset nolch			;��������� �� 0 �� 9
push offset resul1			;������� ������ ��������� ������� ��������
call kopyr					;�.�. � ��� ������������� ������� �� ������-�
push offset nolch
push offset resul
call kopyr
push @num22
call noln
cmp nol00,'1'
jne no12
mov err1,'1'				;�������� �� �2 �� 0
jmp del1
no12:
push @num11
call noln					;�������� �1 �� 0
cmp nol00,'1'
jne nool1
mov znakrez,'0'
push offset nolch
push offset resul1
call kopyr
jmp del1
nool1:
push @num11
push @num22
call bolshe	
cmp bolshemain,'0'			;�������� ����� ����� ������ �1 ��� �2
jne delibaz11				;������� ����� ������ ����� �� ������>0
mov znakrez,'0'				;���� 102/157=0
push offset nolch
push offset resul1
call kopyr
jmp del1
delibaz11:
cmp bolshemain,'='
jne delibaz123
push offset minn
push offset resul1
call plus
jmp del1
delibaz123:

push offset minn			;+1 ���� ��������� ������
push offset resul1			;���� 102-50=52-50=2  ����� 2 ���������
call plus					;102/50=2
push @num11
push @num22
call minus
push offset resul
call nol
cmp nol30,'1'
je del1

del2:						;���� �� ����� 0 ��� ����� �� ����� 
push offset resul
push @num22
call bolshe
cmp bolshemain,'0'
jne delibaz112
jmp del1
delibaz112:
push offset resul
push  @num22
call minus

push offset minn
push offset resul1
call plus
push offset resul
call nol
cmp nol30,'1'
je del1
cmp znakrez,'1'
je del1
jmp del2
del1:
mov oper,'/'				;���������� ��� �������� �������
push offset resul1
call pl30h
pop word ptr znakrez
ret
delibaz endp

;------------DELENIE BOLSHOE-----------
deli proc pascal
arg @numm1,@numm2,@len:byte	;�������(�1) ��������(�2) � ������ �1
push word ptr znakrez		;����� �����, ��� ����������� ������
int 3						;�� �1 �����, ������� �������� ������
mov si,@numm1				;�� �2,����� ������ �����, ����������
add si,19					;����� � ���������� ����� � ������ ������
mov cl,@len					;������ � ������� � �������� ���� ����� 
mov ch,00h					;������ ����� �� �1 � �������� ����� � ��� 
sub si,cx					;������� ����� ������� � ����
push offset nolch			;12345/121: 1/121=0 12/121=0 123/121=1(��� 2)
push offset bufvv			;���=1 24/121=0 245/121=2(��� 3)
call kopyr					;
lea bx,bufvv				;
mov al,0					;
d2:
lea di,bufdel
cmp al,byte ptr @len
je d4
mov cx,18
inc di
d5:
mov ah,byte ptr [di]
mov byte ptr [di-1],ah
inc di
loop d5
mov ah,byte ptr [si]
mov byte ptr [bufdel+18],ah
inc si

d3:
push offset bufdel
push @numm2
call delibaz
mov ah, byte ptr [resul1+18]
mov byte ptr [bx],ah
inc bx
inc al
cmp ah,'0'
je d2
push offset bufost
push offset bufdel
call kopyr
jmp d2
d4:
int 3
mov ch,00h
mov cl,@len
push offset bufvv
push offset resul1
push cx
call smesh
pop word ptr znakrez
push offset resul1
call nol
cmp nol30,'1'
jne d11
mov znakrez,'0'
d11:
ret
deli endp

;------------------VVOD-------------------
vvod proc pascal 
arg @znak,@num,@len				;���� ����, ��� ���� � ����� ������������
lea di,bufvv
mov si,@znak
mov cx,0
print vvedich
mov buf2,0

mov byte ptr [si],'0'
a112:
cmp byte ptr [si],'1'
jne a1
mov ah,02h
mov dl,'-'						;����������� ����� ������ � ������ �����
int 21h
a1:
mov ah, 01h
int 21h 
cmp al,'q'						;����� �� ������� q
jne a0
mov ah,4ch
int 21h
a0:
cmp al,'0'						;����� ����� ����� ��� ���� �� ��������
je a2							;����� ��� -(- ������ � ������) ��� ����
cmp al,'1'						;������ ������������ �� ����� ������������
je a2							;�����, � ����� ����� ��������� ������ 0-9
cmp al,'2'
je a2
cmp al,'3'
je a2
cmp al,'4'
je a2
cmp al,'5'
je a2
cmp al,'6'
je a2
cmp al,'7'
je a2
cmp al,'8'
je a2
cmp al,'9'
je a2
cmp al,'-'
jne a4
cmp buf2,0
jne a4
cmp byte ptr [si],'0'
jne a4
mov byte ptr [si],'1'
jmp a1

a4:
cmp al,13
jne a5
cmp buf2,0
jne a111
jmp a112
a111:
mov dx, offset newline
mov ah,9
int 21h
jmp a6
a5:
push cx					;���������� ��� ��������� ���������� 
mov bh,0				;�������
mov ah,03h
int 10h
cmp buf1,0
jne a3
inc dl
a3:
dec dl
mov buf1,1
mov ah,02h
int 10h
pop cx
jmp a1
a2:
mov buf2,1
inc cl
mov [di],byte ptr al
inc di
cmp cl,19
jae a6
jmp a1
a6:

push si
mov si,@len
mov byte ptr [si],cl
pop si
mov ch,0
a7:
push offset bufvv
push @num
push cx
call smesh
ret
vvod endp

;----------CMESHENIE V KONEC--------
smesh proc pascal uses si di cx
arg @n1,@n2,@len			;�������� ����� � �����
mov si,@n1					;1234->...0001234
add si,@len
dec si
mov di,@n2
add di,18
mov cx,@len
std
rep movsb
ret
smesh endp

;----------CMESHENIE V NACHALO--------
smeshna proc pascal uses si di cx
arg @n1,@n2,@len			;�� ������������, �������� � ������		
mov si,@n1
add si,19
sub si,@len
mov di,@n2
mov cx,@len
std
rep movsb
ret
smeshna endp

;----------------VIVOD REZULTATOV-----------
outrez proc
;int 3
cmp err1,'1'
jne outr1
print error0			;������� �� 0
ret
outr1:
int 3
outr2:
mov bx,0
mov cx,19
cmp oper,'+'			;� ����� � ��� ������� ����� � result1
je op3
cmp oper,'/'
jne op1
op3:
lea di,resul1
jmp op2
op1:
lea di,resul
op2:
mov ah,2
mov dl,znakrez
cmp dl,'1'
jne ou1
mov dl,'-'				;��������� ���� ����������
int 21h
ou1:
cmp negmin,'1'			;���������� ����� ����� ���������
jne ou4
;mov dl,[di]
add byte ptr [di],byte ptr 06h
xor byte ptr [di],byte ptr 0fh
inc di
loop ou1
push offset resul
push offset minn
call plus
mov cx, 19
lea di,resul1
mov bx,0
ou4:

mov al,30h				;�� ����� ��������� ��������� ����
mov dl,[di]				;����� ���������� ������� ����� ������� 0
cmp dl,al
jne ou2
cmp bx,0
jne ou2
cmp cx,1
je ou2
jmp ou3
ou2:
mov bx,1
push ax
mov ah,02h
int 21h
pop ax
ou3:
inc di
loop ou4
ret
outrez endp
;--------VIVOD DLINY(CHISLO)-----------
OutInt proc pascal uses cx ax bx dx
arg @a					;����� ����� ����� ������ ��������
	mov 	ax,@a
oi1:  
    xor     cx, cx
    mov     bl, 10 
oi2:
	xor     ah,ah
    div     bl
    push    ax
    inc     cx
    test    al, al
    jnz     oi2
    mov     ah, 02h
oi3:
    pop     dx
	mov 	dl,dh
    add     dl, '0'
    int     21h
    loop    oi3
mov dl,' '
int 21h
ret 
 
OutInt ENDp 

;----------------OTCHISTKA----------------
otchbuf proc			;�������� �������� � �������
mov cx, 20
lea si,num1
lea di,num2
 otch1:
mov [di], byte ptr 00
mov [si], byte ptr 00
inc di
inc si
 loop otch1
 mov cx, 20
 lea di,bufvv
 lea si,resul
 lea bx,resul1
 otch2:
mov [di], byte ptr 00
mov [si], byte ptr 00
mov [bx], byte ptr 00
inc di
inc si
inc bx
 loop otch2
 mov cx, 20
 lea di,bufost
 lea si,bufdel
 otch3:
mov [di], byte ptr 00
mov [si], byte ptr 00
inc di
inc si
 loop otch3
 
mov znak1,0
mov znak2,0
mov znakrez,0
mov negmin,0
mov bolshemain,'0'
mov buf2,0
mov err1,'0'
mov nol30,'0'
mov nol00,'0'
ret
otchbuf endp

end start