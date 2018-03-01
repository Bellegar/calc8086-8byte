;17 вариант, калькулятор,4 арифм действия над целыми 8-байт числами
;числа представляются в виде байтого массива отдельно от знака и при
;записи например -1254 в znak* будет записан "1", а в число
;0000000000000001254
;числа состоят из 19 10тичных символов, т.к. макс 8байт-е знаковое число
;это 9223372036854775807 19 символов (беззнаковое в 2 раза больше)
print  macro str	;в str заносим адрес строки для вывода
mov ah, 09h			
lea dx, str			
int 21h				
endm

operset macro		;выбор операци +-/* и распределение
print operac		;сразу на функцию и вывод ответа
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
cmp al,'q'			;для выхода
jne b0
mov ah,4ch			;выход
int 21h
b0:
mov bh,0			;если введен иной символ, то переход
mov ah,03h			;в видео режим и попытка ввода символа
int 10h				;поверх "неправильного"
dec dl
mov ah,02h
int 10h
jmp b1
b2: ;-------------------------------plus
	mov al,znak2
	cmp znak1,al
	jne b21
	cmp znak1,'1'			;-1-2 (отрицательное первое число
	jne b23					;складывается с отрицательным 2ым)
	mov znakrez,'1'			;т.е. сумма при отриц ответе и т.д.
	push offset num1		;знаки заранее определяются кроме
	push offset num2		;операции прямого вычитания
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
	cmp znak1,'1'			;-1+2 т.е. вычитание из 2 1
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
	cmp znak1,'0'			;1--2 т.е сложение 1 и 2
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

stat macro					;статистика:кол-во цифр в числах
print dlina1				;какое больше, либо равны ли
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
newline db 10,13,'$';перевод каретки
result db 10,13,'Resultat: $'
bol1 db 10,13,'1 Bolse 2go (po modulu) $'
bol21 db 10,13,'2 Bolse 1go (po modulu) $'
ravny db 10,13,'Ravny (po modulu) $'
error0 db 10,13,'Delenie na 0$'
dlina1 db 'Dlina pervogo chisla $'
dlina2 db 'Dlina vtorogo chisla $'
predis db 10,13,'Press q for exit $'
newprogr db 10,13,'------------------------------$'
minn db 18 dup(0),'1'		;просто единица
nolch db 19 dup(0)			;абсолютный ноль
bufvv db 20 dup (0)			;буфер (изначально был со знаком)
bufdel db 19 dup (0) 		;буфер для большого деления
bufost db 19 dup (0) 		;буфер для остатка от деления
num1 db 19 dup (0)			;первое число
znak1 db 0 					;1 - / 0 +
num2 db 19 dup (0)			;второе число
znak2 db 0 					;1 - / 0 +
resul db 20 dup (0)			;результат
resul1 db 20 dup (0)		;результат для сложения и деления
znakrez db 0				;знак результата
len1 db 0					;длины 1 и 2 чисел
len2 db 0
oper db ?					;вид текущей операции
buf1 db 0					;буфер
buf2 db ?						
negmin db '0'				;если число надо дополнить (после минуса)
bolshemain db '0'			;больше ли первое число.0 нет/1 да/= равны
nol30 db '0'				;число из аски нулей? 0 нет/1 да
nol00 db '0'				;число из нулей-кодов? 0 нет/1 да
err1 db '0'					;ошибка, деление на 0

;-----------------------KOD--------------------------------------
.code
start:
mov ax, @data				;запись в ax адреса на сегмент данных
mov ds, ax					;инициализация сегмента данных
mov es, ax					;инициализация сегмента доп. данных
LOCALS
again:
call otchbuf				;отчистка значений
print predis				
push offset znak1
push offset num1
push offset len1
call vvod					;ввод первого числа. затем второго
push offset znak2
push offset num2
push offset len2
call vvod
operset						;выбор операции
print newline
call outrez
print newline
stat						;вывод статистики
print newprogr				;----
jmp again
mov ah,4ch
int 21h

;---------------------BOLSHE---------------------
bolshe proc pascal uses si di cx ax
arg @num11,@num22			;больше ли первое чем второе
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
nol proc pascal				;состоит число из нулей аски?
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
noln proc pascal			;число из нулей-кодов и аски?
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
arg @numm1,@numm2					;копирование числа из н1 в н2
mov si,@numm1
mov di,@numm2
mov cx,19
cld
rep movsb
ret
kopyr endp

;-----------------PLUS---------------
plus proc pascal					;сложение чисел
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
arg @num11, @num22    		;вычитание н1-н2
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
mov znakrez,'1'			;отриц результат вычитания
mov negmin,'1'			;надо дополнить ответ (инверт) 
minend:					;это когда н2>н1
cmp znakrez,'1'
jne ost1
push offset nolch		
push offset bufost
call kopyr
ost1:
push offset resul
push offset bufost
call kopyr				;копирование результата вычитания в "остаток"
ret						;для деления
minus endp

;---------------UMNOZENIE-----------------
umnoz proc pascal 
arg @num11, @num22		;н1*н2 умножение происходит методом столбика
push word ptr buf1		;послед цифра н1 умножается на последню цифру 
mov di,@num22			;н2, ответ запис  в конец с переносом и указатель 
add di,18				;конца сдвигается влево столбцы складываются 
mov buf1,19				;и т.д. при переходе на новую цифру н2 указатель 
mov buf2,0				;конца рез-а не меняется.
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
pl30h proc pascal			;прибавление к число 30h до аски
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
mn30h proc pascal			;убираем 30h из числа
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
arg @num11, @num22			;н1/н2  нужно для общего большого деления
push word ptr znakrez		;т.к. при делении столбиком каждый промежут
push offset nolch			;результат от 0 до 9
push offset resul1			;деление метдом вычитания отлично подойдет
call kopyr					;т.к. и тут многобайтовое делится на многоб-е
push offset nolch
push offset resul
call kopyr
push @num22
call noln
cmp nol00,'1'
jne no12
mov err1,'1'				;проверки на н2 на 0
jmp del1
no12:
push @num11
call noln					;проверка н1 на 0
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
cmp bolshemain,'0'			;првоерка какое число больше н1 или н2
jne delibaz11				;сначала чтобы узнать будет ли вообще>0
mov znakrez,'0'				;напр 102/157=0
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

push offset minn			;+1 пока вычитемое меньше
push offset resul1			;напр 102-50=52-50=2  итого 2 вычитания
call plus					;102/50=2
push @num11
push @num22
call minus
push offset resul
call nol
cmp nol30,'1'
je del1

del2:						;если не сразу 0 или числа не равны 
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
mov oper,'/'				;записываем что операция деления
push offset resul1
call pl30h
pop word ptr znakrez
ret
delibaz endp

;------------DELENIE BOLSHOE-----------
deli proc pascal
arg @numm1,@numm2,@len:byte	;делимое(н1) делитель(н2) и длинна н1
push word ptr znakrez		;метод такой, что посимвольно растет
int 3						;из н1 число, которое пытаемся делить
mov si,@numm1				;на н2,когда делить можно, вычитанием
add si,19					;делим и записываем цифру в финаль резуль
mov cl,@len					;сносим в добавок к осттатку след после 
mov ch,00h					;предыд цифру из н1 и пытаемся опять и так 
sub si,cx					;столько ходов сколько и цифр
push offset nolch			;12345/121: 1/121=0 12/121=0 123/121=1(ост 2)
push offset bufvv			;рез=1 24/121=0 245/121=2(ост 3)
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
arg @znak,@num,@len				;ввод чиса, его знак и длина определяются
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
mov dl,'-'						;считываение знака только в начале числа
int 21h
a1:
mov ah, 01h
int 21h 
cmp al,'q'						;выход по нажатию q
jne a0
mov ah,4ch
int 21h
a0:
cmp al,'0'						;здесь метод таков что пока не введется
je a2							;цифра или -(- только в начале) или ВВОд
cmp al,'1'						;курсор возвращается на место неправильной
je a2							;цифры, в буфер числа заносятся только 0-9
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
push cx					;видеорежим для изменения полоджения 
mov bh,0				;курсора
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
arg @n1,@n2,@len			;смещение числа в конец
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
arg @n1,@n2,@len			;не используется, смещение в начало		
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
print error0			;деление на 0
ret
outr1:
int 3
outr2:
mov bx,0
mov cx,19
cmp oper,'+'			;у суммы и при делении ответ в result1
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
mov dl,'-'				;выводится знак результата
int 21h
ou1:
cmp negmin,'1'			;дополнение числа после вычитания
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

mov al,30h				;из числа удаляются начальные нули
mov dl,[di]				;кроме последнего символа чтобы вывести 0
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
arg @a					;вывод длины числа обычым способом
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
otchbuf proc			;отчистки значений и буферов
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