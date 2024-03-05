[org 0x0100]
jmp start
;--------------------------------------------
;     ALL the variables
;--------------------------------------------
last: db 0
tickcountc: dw 0
choice: db 2
random: dw 0
over: db 'GAME OVER'
scoreText: db 'YOUR SCORE:'
name1: db 'Abdullah Butt 22L-6928'
name2: db 'Ahmad Fraz    22L-6735'
game_title:db'JUMPING RABBITS' 
inst1:db 'Press UP Arrow Key to Jump'
inst2:db 'Collect Carrots to Score'
inst3:db 'Cant linger for 10 seconds on a brick'
inst4 : db 'PRESS ANY KEY TO START THE GAME'
inst5 :db 'Press ESC to exit the Game! '
Pause :db 'Do you want to Continue ?'
yes: db 'Press Y for Yes'
No: db 'Press N for No'
term_flag: dw 0
;----------for carrot-----------
carrot_flag: db 1
carrot_x: dw 0
tickcount: dw 0
score : dw 0
bar_end_flag:db 0
bar_end_value:dw 0
;------flags for bar removal---------
remove_bar1: dw 0
remove_bar2: dw 0
remove_bar3: dw 0
td1: dw 0
td2: dw 0
td3: dw 0

;----------char position--------------
y_pos : dw 189
x_pos_l : dw 150
temp_flag_for_char: dw 1
coordinated_x_pos_l_foot:dw 0
coordinated_x_pos_r_foot:dw 0
;-----------bar 1-----
color1: dw 15
movebar_y1 :dw 190
var_di1: dw 0
var_dx1: dw 0
flag1:dw 0
stop_forward_bar1:dw 0
stop_backward_bar1:dw 0
temp_var_di:dw 0
temp_stop_forward_bar1:dw 0
temp_stop_backward_bar1:dw 0
;---------------bar2--------
color2: dw 2
movebar_y2 :dw 165
var_di2: dw 0
var_dx2: dw 0
flag2:dw 1
stop_forward_bar2:dw 0
stop_backward_bar2:dw 0
temp_var_di2:dw 0
temp_stop_forward_bar2:dw 0
temp_stop_backward_bar2:dw 0
;-----------------bar3
color3: dw 20
movebar_y3 :dw 140
var_di3: dw 0
var_dx3: dw 0
flag3:dw 0
stop_forward_bar3:dw 0
stop_backward_bar3:dw 0
temp_var_di3:dw 0
temp_stop_forward_bar3:dw 0
temp_stop_backward_bar3:dw 0
oldisr: dd 0
Tisr: dd 0
;------------------------------------------------------------------------------------
									;Drawing bars
;------------------------------------------------------------------------------------

bars_smooth:
push bp
mov bp,sp
push ax
push bx
push cx
push dx
push es
push di
push si

			mov dx,[bp+6]

			mov bx,0A000h ;video screen address as we used to to 0xb800
			mov es,bx

;--------------------------------------first bar----------------------------------------------------
            mov ax,dx
			mov bx,[bp+4] 							;rows for bar
			mov di,[bp+8]

			cld  									;clearing direction flag	
				
			loop1b:
						mov byte [es:di],14
						add di,320
						dec bx
						cmp bx,0
			jne loop1b

pop si
pop di
pop es
pop dx
pop cx
pop bx
pop ax
pop bp
ret 6



barsr:
push bp
mov bp,sp
push ax
push bx
push cx
push dx
push es
push di
push si

			mov dx,[bp+6]

			mov bx,0A000h ;video screen address as we used to to 0xb800
			mov es,bx

;--------------------------------------first bar----------------------------------------------------
            mov ax,dx
			mov bx,[bp+4] 							;rows for bar
			mov di,[bp+8]

			cld  									;clearing direction flag	
			lloop1:
						mov cx,53
						rep stosb					;innerloop
						sub di,53
						add di,320
						dec bx
						cmp bx,0
			jne lloop1

pop si
pop di
pop es
pop dx
pop cx
pop bx
pop ax
pop bp
ret 6
;-----------------------------------------------------------------------------




bars:
push bp
mov bp,sp
push ax
push bx
push cx
push dx
push es
push di
push si

			mov dx,[bp+6]

			mov bx,0A000h ;video screen address as we used to to 0xb800
			mov es,bx

;--------------------------------------first bar----------------------------------------------------
            mov ax,dx
			mov bx,[bp+4] 							;rows for bar
			mov di,[bp+8]

			cld  									;clearing direction flag	
			loop1:
						mov cx,50
						rep stosb					;innerloop
						sub di,50
						add di,320
						dec bx
						cmp bx,0
			jne loop1

pop si
pop di
pop es
pop dx
pop cx
pop bx
pop ax
pop bp
ret 6
;-----------------------------------------------------------------------------

;-------------------Delay function made for moving bars-----------------------
delayd:
push cx
  		mov cx,0x0fff
		loop11d loop loop11d
 		mov cx,0x0fff
 		loop22d loop loop22d
		mov cx,0x0fff
		loop33d loop loop33d
		mov cx,0x0fff
		loop44d loop loop44d
  		mov cx,0x0fff
 		loop55d loop loop55d
  		mov cx,0x0fff
 		loop66d loop loop66d
  		mov cx,0x0fff
 		loop77d loop loop77d
pop cx
ret
;-----------------------------------------------------------------------------------

;----------------------checks for moving bars (boundary conditions)------------------
reachedforward1:
				mov word[flag1],1
jmp movingback1

reachedbackward1:
				mov word[flag1],0
jmp loopformovingbars1

;----------------function to remove bar1--------------------------------------------

remove_current_bars1:

		    mov ax,0
			mov ax,14	;color
			mov bx,[td1]
            sub bx,1
     	    push bx;starting value
			push ax;color
			mov ax,5
			push ax;rows
			call barsr
			mov word[remove_bar1],0
jmp nextprocess1

;---------------------------------------------------------------------------------------
  ;functions for moving bars
;---------------------------------------------------------------------------------------

movingbar1:

push ax
push bx
push cx
push dx
push es
push di
push si

cmp word[remove_bar1],1
je remove_current_bars1
nextprocess1:

cmp word[flag1],0
je loopformovingbars1   							 ;if flag is 0 then move forward else move backward
jne movingback1
			
loopformovingbars1:
	
			;displaying the bar
			mov ax,0
			mov ax,[color1]									;color		      
			mov bx, [var_di1]
		    push bx										;starting value
			push ax										;color
			mov ax,5
			push ax										;rows
			call bars
			call delayd
			
			;removing the bar
		    mov ax,0
			mov ax,14									;color
			mov bx,[var_di1]
			sub bx,1
     	    push bx										;starting value
			push ax										;color
			mov ax,5
			push ax										;rows
			call bars_smooth
			
			
			
			cmp word[temp_flag_for_char],1
			jne char_not_here11
			;-----for removing char----- 
			mov ax,[y_pos]
			push ax
			call remove_character
			;--------------------------

			;for character to move right
			add word[x_pos_l],1
			mov ax,[y_pos]
			push ax
			call character
			
			char_not_here11:
			add word[var_di1],1							;move one byte ahead
			sub word[var_dx1],1							;move one byte ahead
			mov cx,[var_di1]
			cmp word cx,[stop_forward_bar1]
			je  reachedforward1
			jmp endf1
movingback1:
			;displaying the bar
			mov ax,0
			mov ax,[color1]								;color
			mov bx,[var_di1]
		    push bx										;starting value
			push ax										;color
			mov ax,5
			push ax										;rows
			call bars
			call delayd
			
			;removing the bar
		    mov ax,0
			mov ax,14									;color	
			mov bx,[var_di1]
			add bx,50
     	    push bx										;starting value
			push ax										;color
			mov ax,5
			push ax										;rows
			call bars_smooth
			
			cmp word[temp_flag_for_char],1
			jne char_not_here12
			;-----for removing char----- 
			mov ax,[y_pos]
			push ax
			call remove_character
			;--------------------------

			;for character to move left
			sub word[x_pos_l],1
			mov ax,[y_pos]
			push ax
			call character
			
			char_not_here12:
			sub word[var_di1],1;move one byte ahead
			add word[var_dx1],1;move one byte ahead
			mov cx,[var_di1]
			cmp word cx,[stop_backward_bar1]
			je  reachedbackward1

endf1:
pop si
pop di
pop es
pop dx
pop cx
pop bx
pop ax
ret

reachedforward2:
				mov word[flag2],1
jmp movingback2

reachedbackward2:
				mov word[flag2],0
jmp loopformovingbars2

remove_current_bars2:
		    mov ax,0
			mov ax,14									;color
			mov bx,[td2]
			sub bx,1
     	    push bx										;starting value
			push ax										;color
			mov ax,5
			push ax										;rows
			call barsr
			mov word[remove_bar2],0
jmp nextprocess2


movingbar2:

push ax
push bx
push cx
push dx
push es
push di
push si


cmp word[remove_bar2],1
je remove_current_bars2
nextprocess2:


cmp word[flag2],0
je loopformovingbars2    										;if flag is 0 then move forward else move backward
jne movingback2

   			
loopformovingbars2:
		

			;displaying the bar
			mov ax,0
			mov ax,[color2]											;color		      
			mov bx, [var_di2]
		    push bx												;starting value
			push ax												;color
			mov ax,5
			push ax												;rows
			call bars
			call delayd
			
			;removing the bar
		    mov ax,0
			mov ax,14											;color
			mov bx,[var_di2]
			sub bx,1
     	    push bx												;starting value
			push ax												;color
			mov ax,5
			push ax												;rows
			call bars_smooth
			
					
			cmp word[temp_flag_for_char],2
			jne char_not_here21
			;-----for removing char---- 
			mov ax,[y_pos]
			push ax
			call remove_character
			;--------------------------

			;for character to move left
			add word[x_pos_l],1
			mov ax,[y_pos]
			push ax
			call character
			;;;;;;;;;;;;;;;;;;;;;;;;;;
			
			char_not_here21:
			add word[var_di2],1										;move one byte ahead	
			sub word[var_dx2],1										;move one byte ahead
			mov cx,[var_di2]
			cmp word cx,[stop_forward_bar2]
			je  reachedforward2
			jmp endf2
movingback2:
			;displaying the bar
			mov ax,0
			mov ax,[color2]												;color
			mov bx,[var_di2]
		    push bx													;starting value
			push ax													;color
			mov ax,5
			push ax													;rows
			call bars
			call delayd

			;removing the bar
		    mov ax,0
			mov ax,14												;color	
			mov bx,[var_di2]
			add bx,50
     	    push bx													;starting value
			push ax													;color
			mov ax,5
			push ax													;rows
			call bars_smooth
						
			cmp word[temp_flag_for_char],2
			jne char_not_here22
			;-----for removing char--- 
			mov ax,[y_pos]
			push ax
			call remove_character
			;------------------------

			;for character to move right
			sub word[x_pos_l],1
			mov ax,[y_pos]
			push ax
			call character
			;;;;;;;;;;;;;;;;;;;;;;;;;;
			
			char_not_here22:
			sub word[var_di2],1;move one byte ahead
			add word[var_dx2],1;move one byte ahead
			mov cx,[var_di2]
			cmp word cx,[stop_backward_bar2]
			je  reachedbackward2

endf2:
pop si
pop di
pop es
pop dx
pop cx
pop bx
pop ax
ret

reachedforward3:
			mov word[flag3],1
jmp movingback3

reachedbackward3:
			mov word[flag3],0
jmp loopformovingbars3

remove_current_bars3:
		    mov ax,0
			mov ax,14														;color
			mov bx,[td3]
			sub bx,1
     	    push bx															;starting value
			push ax															;color
			mov ax,5
			push ax															;rows
			call barsr
			mov word[remove_bar3],0
jmp nextprocess3

movingbar3:

push ax
push bx
push cx
push dx
push es
push di
push si

cmp word[remove_bar3],1
je remove_current_bars3
nextprocess3:


cmp word[flag3],0
je loopformovingbars3  												    ;if flag is 0 then move forward else move backward
jne movingback3
			
loopformovingbars3:
		

			;displaying the bar
			mov ax,0
			mov ax,[color3]													;color		      
			mov bx, [var_di3]
		    push bx														;starting value
			push ax														;color
			mov ax,5
			push ax														;rows
			call bars
			call delayd
			
			;removing the bar
		    mov ax,0
			mov ax,14													;color
			mov bx,[var_di3]
			sub bx,1
     	    push bx														;starting value
			push ax														;color
			mov ax,5
			push ax														;rows
			call bars_smooth
						
			cmp word[temp_flag_for_char],3
			jne char_not_here32
			;-----for removing char---- 
			mov ax,[y_pos]
			push ax
			call remove_character
			;-------------------------

			;for character to move right
			add word[x_pos_l],1
			mov ax,[y_pos]
			push ax
			call character
			;;;;;;;;;;;;;;;;;;;;;;;;;;
			
			char_not_here32:
			
			add word[var_di3],1											;move one byte ahead
			sub word[var_dx3],1											;move one byte ahead
			mov cx,[var_di3]
			cmp word cx,[stop_forward_bar3]
			je  reachedforward3
			
			jmp endf3
movingback3:
			;displaying the bar
			mov ax,0
			mov ax,[color3]													;color
			mov bx,[var_di3]
		    push bx														;starting value
			push ax														;color
			mov ax,5
			push ax														;rows
			call bars
			call delayd
			
			;removing the bar
		    mov ax,0
			mov ax,14													;color	
			mov bx,[var_di3]
		    add bx,50
     	    push bx														;starting value
			push ax														;color
			mov ax,5
			push ax														;rows
			call bars_smooth
			
			cmp word[temp_flag_for_char],3
			jne char_not_here33
			;-----for removing char--- 
			mov ax,[y_pos]
			push ax
			call remove_character
			;-------------------------

			;for character to move left
			sub word[x_pos_l],1
			mov ax,[y_pos]
			push ax
			call character
			;;;;;;;;;;;;;;;;;;;;;;;;;;
			
			char_not_here33:
			sub word[var_di3],1											;move one byte ahead
			add word[var_dx3],1											;move one byte ahead
			mov cx,[var_di3]
			cmp word cx,[stop_backward_bar3]
			je  reachedbackward3

endf3:
pop si
pop di
pop es
pop dx
pop cx
pop bx
pop ax
ret

;------------------------------------------------------------------------
;						     Black screen
;------------------------------------------------------------------------
game_end:
   push ax
   push es
   push di   
   mov di,0
   
  
						mov cx,64000 													 ;number of pixels as before 4000
						mov di,0
						mov bx,0A000h 													;video screen address as we used to to 0xb800
						mov es,bx
						mov al,14													 	;color
						rep stosb



						mov cx,32
						mov si,0
						carrotLoop3:
						push 41															 ;orange
  				        push 3 															 ;green
				        push 3															 ;row
						push si 														 ;col
						call carrot
					    add si,10
  loop carrotLoop3
  
  
						mov cx,32
						mov si,0
						carrotLoop4:
									push 41 											 ;orange
									push 3  											 ;green
									push 190								      		 ;row
									push si 											 ;col
									call carrot
									add si,10
						loop carrotLoop4

						;set cursor
						mov cx,9
						mov si,0
						mov dl,54;col
						endloop:
									  mov ah,02h										;sub interupt
									  mov bh,0  										;page
									  mov dh,10 										;rows
									  int 0x10
									  mov al,[over+si]
									  mov bh,0											;page
									  mov bl,15											;row
									  push cx
									  mov cx,1											;number of char
									  mov ah,09h
									  int 0x10
									  inc si
									  inc dl
									  pop cx
						loop endloop

  
						;score print  
						mov cx,11
						mov si,0
						mov dl,51														;col
						endloop1:
  								mov ah,02h
  								mov bh,0  														;page
  								mov dh,12 														;rows
  								int 0x10
								mov al,[scoreText+si]
								mov bh,0														;page
								mov bl,41
								push cx
								mov cx,1
								mov ah,09h
								int 0x10
								inc si
								inc dl
								pop cx
						loop endloop1	
  
  					    push 12 																;row
  					    push 65 																;col
						call printscore
						push 41 																;orange
						push 3  																;green
						push 97																	;row
						push 180 																;col
						call carrot
   
   pop di
   pop es
   pop ax
ret
;---------------------------------------------------------------   
;								Intro Screen
;---------------------------------------------------------------
intro:
push ax
push bx
push cx
push dx
push es
push di
push si
									
									mov cx,64000  						;number of pixels as before 4000
									mov di,0
									mov bx,0A000h 						;video screen address as we used to to 0xb800
									mov es,bx
									mov al,0 							;color
									rep stosb
 									mov cx,32
 									mov si,0
 									carrotLoop:
												push 41 				;orange
												push 3  				;green
  												push 3					;row
  												push si 				;col
  												call carrot
  												add si,10
									loop carrotLoop
  
  
   									mov cx,32
 									mov si,0
 									carrotLoop1:
											push 41 					;orange
											push 3  					;green
											push 190					;row
											push si 					;col
											call carrot
											add si,10
  									loop carrotLoop1
 
 
 
									;set cursor
									mov cx,15
									mov si,0
									mov dl,52							;col
									endloopn3:
  											mov ah,02h
											mov bh,0 					;page
  											mov dh,3 					;rows
  											int 0x10
											mov al,[game_title+si]
											mov bh,0;page
											mov bl,40
											push cx
											mov cx,1
											mov ah,09h
											int 0x10
  										    inc si
											inc dl
											pop cx
											call delay1
  									loop endloopn3

  									push 41 							;orange
  									push 3  							;green
  									push 65								;row
  									push 60 							;col
  									call carrot
  
  									push 41 							;orange
  									push 3  							;green
  									push 50								;row
  									push 60 							;col
  									call carrot

									;set cursor
									mov cx,22
									mov si,0
									mov dl,50
									endloopn1:
												mov ah,02h
												mov bh,0 				 ;page
												mov dh,6 				 ;rows
												int 0x10
												mov al,[name1+si]
												mov bh,0				 ;page
												mov bl,15
												push cx
												mov cx,1
												mov ah,09h
												int 0x10
												inc si
												inc dl
												pop cx
  									loop endloopn1
  
  
 
									;set cursor
									mov cx,22
									mov si,0
									mov dl,50
									endloopn2:
												mov ah,02h
												mov bh,0 				 ;page
												mov dh,8 				 ;rows
  												int 0x10
												mov al,[name2+si]
												mov bh,0				 ;page
												mov bl,15
												push cx
												mov cx,1
												mov ah,09h
												int 0x10
												inc si
												inc dl
												pop cx
									loop endloopn2
 

									;instructions
									;set cursor
									mov cx,26
									mov si,0
									mov dl,1
									endloopi1:
  									mov ah,02h
  									mov bh,0  							;page
  									mov dh,12 							;rows
  									int 0x10
  
  
  									mov al,[inst1+si]
  									mov bh,0							;page
  									mov bl,41
  									push cx
  									mov cx,1
  									mov ah,09h
  									int 0x10
  									inc si
  									inc dl
  									pop cx
  									call delayw
  									loop endloopi1
  
    									;inst2  
    	     						    mov cx,24 
  									    mov si,0
    									mov dl,1
    									endloopi2:
    									mov ah,02h
    									mov bh,0  						;page
    									mov dh,14 						;rows
    									int 0x10
    									mov al,[inst2+si]
    									mov bh,0						;page
    									mov bl,41
    									push cx
    									mov cx,1
    									mov ah,09h
    									int 0x10
    									inc si
    									inc dl
    									pop cx
    									call delayw
    									loop endloopi2
  
    									;inst3  
  									    mov cx,37
  									    mov si,0
  									    mov dl,1
  									    endloopi3:
    									mov ah,02h
    									mov bh,0	  					;page
    									mov dh,16 						;rows
										int 0x10
  
     									mov al,[inst3+si]
										mov bh,0;page
			     						mov bl,41
										push cx
										mov cx,1
										mov ah,09h
										int 0x10
										inc si
										inc dl
										pop cx
										call delayw
										loop endloopi3
  
   
  ;inst5
mov cx,27
mov si,0
mov dl,1
endloopi5:
  mov ah,02h
  mov bh,0  ;page
  mov dh,18 ;rows
  int 0x10
  
  mov al,[inst5+si]
  mov bh,0;page
  mov bl,41
  push cx
  mov cx,1
  mov ah,09h
  int 0x10
  inc si
  inc dl
  pop cx
  call delayw
  loop endloopi5
  
 ;inst4
mov cx,31
mov si,0
mov dl,4
endloopi4:
  mov ah,02h
  mov bh,0  ;page
  mov dh,21 ;rows
  int 0x10
  
  mov al,[inst4+si]
  mov bh,0;page
  mov bl,15
  push cx
  mov cx,1
  mov ah,09h
  int 0x10
  inc si
  inc dl
  pop cx
  
  loop endloopi4



mov ah,0
int 0x16

pop si
pop di
pop es
pop dx
pop cx
pop bx
pop ax
ret
;------------------clrscr------------------
clrscr:
    push ax
    push es
    push di
    
    mov di, 0

    mov cx, 64000  ; number of pixels as before 4000
    mov di, 0

    mov bx, 0A000h  ; video screen address as we used to to 0xb800
    mov es, bx
    mov al, 14  ; color
    rep stosb

    pop di
    pop es
    pop ax
    ret  ; end of clrscr function

;------------------print_cars-------------

print_cars:
    mov ax, 40  ; x value for car
    push ax
    mov ax, 14  ; color of car
    push ax
    call cars

    mov ax, 120  ; x value for car
    push ax
    mov ax, 85  ; color of car
    push ax
    call cars

    mov ax, 210  ; x value for car
    push ax
    mov ax, 45  ; color of car
    push ax
    call cars

    ret

;--------------print_building-----------
print_building:
push ax
push bx
push cx
push si
push di
push dx

   mov ax,20;x value for building
   push ax
   mov ax,10;y value
   push ax
   mov ax,60;width
   push ax
   mov ax,222;color
   push ax
   call building
   
   mov ax,60;x value for building
   push ax
   mov ax,20;y value
   push ax
   mov ax,40;width
   push ax
   mov ax,22;color
   push ax
   call building
   
   mov ax,250;x value for building
   push ax
   mov ax,4;y value
   push ax
   mov ax,40;width
   push ax
   mov ax,57;color
   push ax
   call building
   
   mov ax,200;x value for building
   push ax
   mov ax,20;y value
   push ax
   mov ax,55;width
   push ax
   mov ax,249;color
   push ax
   call building
   
   
   mov ax,160 ;x value for building
   push ax
   mov ax,3;y value
   push ax
   mov ax,30;width
   push ax
   mov ax,60;color
   push ax
   call building
   
   ;kfc
   mov ax,120 ;x value for building
   push ax
   mov ax,55  ;y value
   push ax
   mov ax,20  ;width
   push ax
   mov ax,40 ;color
   push ax
   call building
   
   mov ax,115 ;x value for building
   push ax
   mov ax,55  ;y value
   push ax
   mov ax,5  ;width
   push ax
   mov ax,15 ;color
   push ax
   call building

  
pop dx
pop di
pop si
pop cx
pop bx
pop ax

ret

;--------------print_background--------------
print_background:
   push ax
   push es
   push di
   push bx
   
   mov bx ,0x0a000
   mov es,bx
   mov di,0
   mov al,100
   mov cx ,22400
   
   rep stosb

;---------------screen 2 for grass and road----------------
  call screen2;for grass
   pop bx
   pop di
   pop es
   pop ax
   
   ret;end of bluebackground function
;----------------------------------------------------------------------------------
;										building
;----------------------------------------------------------------------------------
building:
   push bp
   mov bp,sp
   push ax
   push bx
   push cx
   push es
   push di
   push si
   push dx
   
   mov bx ,0A000h
   mov es,bx
   
   mov ax ,320
   mov dx,[bp+8]
   mul dx
   add ax,[bp+10]
   mov dx,ax
   mov di,dx;starting location

   
   mov cx,70
   sub cx,[bp+8] ;number of rows
   
  
   mov al,[bp+4] ;color
  
   outerbuild:
   mov bx,[bp+6] ;width
   innerbuild:
   mov [es:di],al
   add di,1
   dec bx
   cmp bx,0
   jnz innerbuild
   sub di,[bp+6] 
   add di,320
   loop outerbuild

   pop dx
   pop si
   pop di
   pop es
   pop cx
   pop bx
   pop ax
   pop bp
   ret 8 ;end of bluebackground function
;-----------------screen2----------------

road_strips:
   push bx
   push ax
   push es
   push di

 ;-------------road stips-----------------
   outerstrip2:
    mov bx, 35  ; width
innerstrip2:
    mov [es:di], al
    add di, 1
    dec bx
    cmp bx, 0
    jnz innerstrip2
    sub di, 35
    add di, 320
    loop outerstrip2

    mov al, 15  ; color
    mov di, 30240
    mov cx, 5

outerstrip3:
    mov bx, 35  ; width
innerstrip3:
    mov [es:di], al
    add di, 1
    dec bx
    cmp bx, 0
    jnz innerstrip3
    sub di, 35
    add di, 320
    loop outerstrip3

    mov al, 15  ; color
    mov di, 30340
    mov cx, 5

outerstrip4:
    mov bx, 35  ; width
innerstrip4:
    mov [es:di], al
    add di, 1
    dec bx
    cmp bx, 0
    jnz innerstrip4
    sub di, 35
    add di, 320
    loop outerstrip4

    pop di
    pop es
    pop ax
    pop bx
    ret

;--------------------------------------------------------------------
;                            Screen 2
;--------------------------------------------------------------------

screen2:
   push bx
   push ax
   push es
   push di
;grass
   mov bx ,0x0a000
   mov es,bx
   
   mov di,22399
   mov al,49   ;color
   mov cx ,2560
   rep stosb
   
   
   ;lower strip
   mov di,36480
   mov al,49 ;color
   mov cx ,2560
   rep stosb
   ;road
    mov di,24959
   mov al,24 ;color
   mov cx ,11521
   rep stosb
   
   
   mov al,15;color
   mov di,30080
   mov cx,5
  
   mov al,15;color
   mov di,30160
   mov cx,5
 
 call road_strips
   pop di
   pop es
   pop ax
   pop bx
   ret
   
 ;---------------------------------------------------------------------------
;------Printing  cars-----
;---------------------------------------------------------------------------
cars:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push es
    push di
    push si
    push dx
    
    ; Setting ES to video memory address
    mov bx, 0x0a000
    mov es, bx
    
    ; Calculating starting location
    mov di, 29760; starting location
    add di, [bp + 6] ; x loc
    
    ; Lower part of the car
    mov cx, 8; lower
    
    mov al, [bp + 4] ; color
    
outercarlow:
    mov bx, 35 ; width
innercarlow:
    mov [es:di], al
    add di, 1
    dec bx
    cmp bx, 0
    jnz innercarlow
    sub di, 35
    add di, 320
    loop outercarlow
    
    ; Upper part of the car
    mov di, 27200
    add di, [bp + 6]
    add di, 10
    mov cx, 8
    
outercarup:
    mov bx, 15 ; width
innercarup:
    mov [es:di], al
    add di, 1
    dec bx
    cmp bx, 0
    jnz innercarup
    sub di, 15
    add di, 320
    loop outercarup
    
    ; Tyre - first tyre
    mov al, 16
    
tyre:
    ; Back tyre
    mov di, 32640
    add di, [bp + 6]
    add di, 8
    
    mov cx, 5
    
outertyreback:
    mov bx, 6 ; width
innertyreback:
    mov [es:di], al
    add di, 1
    dec bx
    cmp bx, 0
    jnz innertyreback
    sub di, 6
    add di, 320
    loop outertyreback
    
    ; Front tyre
    mov di, 32640
    add di, [bp + 6]
    add di, 23
    
    mov cx, 5
    
outertyrefront:
    mov bx, 5 ; width
innertyrefront:
    mov [es:di], al
    add di, 1
    dec bx
    cmp bx, 0
    jnz innertyrefront
    sub di, 5
    add di, 320
    loop outertyrefront
    
    pop dx
    pop si
    pop di
    pop es
    pop cx
    pop bx
    pop ax
    pop bp
    ret 4

;-------------------------------------------------------------------------
;--------------------delay functions------------------
;-------------------------------------------------------------------------
delay:
push cx
mov cx, 0x00ff
loop11: loop loop11
   
pop cx

ret

delayw:
push cx
mov cx, 0xffff
loop111: loop loop111
   
pop cx

ret


delay1:
push cx
mov cx, 0xffff
loop1111: loop loop1111
    mov cx, 0xFFFF
loop22: loop loop22
mov cx, 0xFFFF
loop33: loop loop33
pop cx
ret

;-----------Rabbit------------------------
character:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push si
    push di
    push dx
    push es

    ; Setting ES to video memory address
    mov bx, 0x0a000
    mov es, bx

    ; Calculating starting location
    mov ax, 320
    mov di, [bp + 4]  ; parameter
    mul di
    add ax, [cs:x_pos_l]
    mov di, ax

    ; Drawing the body of the rabbit
    mov al, 40
    mov cx, 3
    cld
    rep stosb

    sub di, 323
    mov cx, 3
    rep stosb

    mov cx, 3
    add di, 7
    rep stosb

    mov cx, 3
    add di, 317
    rep stosb

    ; Drawing the head of the rabbit
    mov al, 15  ; color
    mov cx, 10

    mov ax, 320
    mov di, [bp + 4]
    mul di
    add ax, [cs:x_pos_l]
    mov di, ax
    sub di, 3521

    mov al, 15
    outerchar:
        mov bx, 15  ; width
        innerchar:
            mov [es:di], al
            add di, 1
            dec bx
            cmp bx, 0
            jnz innerchar
        sub di, 15
        add di, 320
        loop outerchar

    ; Drawing the mouth of the rabbit
    mov ax, 320
    mov di, [bp + 4]
    mul di
    add ax, [cs:x_pos_l]
    mov di, ax

    mov al, 40
    sub di, 2556
    mov [es:di], al

    add di, 5
    mov [es:di], al

    mov cx, 4
    add di, 1279
    mov [es:di], al

    std
    rep stosb
    cli

    ; Drawing the ears of the rabbit
    mov ax, 320
    mov di, [bp + 4]
    mul di
    add ax, [cs:x_pos_l]
    mov di, ax

    mov al, 40

    sub di, 4476
    mov cx, 3
    rep stosb

    add di, 323
    mov cx, 3
    rep stosb

    add di, 323
    mov cx, 3
    rep stosb

    add di, 10
    mov cx, 3
    rep stosb

    sub di, 317
    mov cx, 3
    rep stosb

    sub di, 317
    mov cx, 3
    rep stosb

    pop es
    pop dx
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    pop bp
    ret 2

remove_character:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push si
    push di
    push dx
    push es

    ; Setting ES to video memory address
    mov bx, 0x0a000
    mov es, bx

    ; Calculating starting location
    mov ax, 320
    mov di, [bp + 4]  ; parameter
    mul di
    add ax, [cs:x_pos_l]
    mov di, ax

    ; Drawing the body of the removed rabbit
    mov al, 14
    mov cx, 3
    rep stosb

    sub di, 323
    mov cx, 3
    rep stosb

    mov cx, 3
    add di, 7
    rep stosb

    mov cx, 3
    add di, 317
    rep stosb

    ; Drawing the head of the removed rabbit
    mov al, 14  ; color
    mov cx, 10

    mov ax, 320
    mov di, [bp + 4]
    mul di
    add ax, [cs:x_pos_l]
    mov di, ax
    sub di, 3521

    mov al, 14
    outercharr:
        mov bx, 15  ; width
        innercharr:
            mov [es:di], al
            add di, 1
            dec bx
            cmp bx, 0
            jnz innercharr
        sub di, 15
        add di, 320
        loop outercharr

    ; Drawing the ears of the removed rabbit
    mov ax, 320
    mov di, [bp + 4]
    mul di
    add ax, [cs:x_pos_l]
    mov di, ax

    mov al, 14
    sub di, 2556
    mov [es:di], al

    add di, 5
    mov [es:di], al

    mov cx, 4
    add di, 1279
    mov [es:di], al

    std
    rep stosb
    cli

    ; Drawing the tail of the removed rabbit
    mov ax, 320
    mov di, [bp + 4]
    mul di
    add ax, [cs:x_pos_l]
    mov di, ax

    mov al, 14

    sub di, 4476
    mov cx, 3
    rep stosb

    add di, 323
    mov cx, 3
    rep stosb

    add di, 323
    mov cx, 3
    rep stosb

    add di, 10
    mov cx, 3
    rep stosb

    sub di, 317
    mov cx, 3
    rep stosb

    sub di, 317
    mov cx, 3
    rep stosb

    pop es
    pop dx
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    pop bp
    ret 2

;----------------------------------------------------------------------------------
;                                   Animation
;---------------------------------------------------------------------------------
Animation:	
cli
			push bp
			mov bp, sp
			push es
			pushad
			push ds
			push di
			push si
			
			mov ax,0xa000		
			mov es,ax
			mov ds,ax				

;---------------road-----------------------
			cld						
			mov bx,35				
			mov si,24001			
			mov di,24000 		
			
roadloop:		
            mov cx,319				;For each element of the row
			mov dl,[es:di]			;Remembers the leftmost element
			rep movsb				;Moves left
			mov [es:di],dl			;Updates the rightmost element with dx
			add si,1				;Moves to the row below
			add di,1				;Moves to the row below
			dec bx
			jnz roadloop
			std
			mov bx,70				;Contains the number of rows to move
			mov si,22400			;ending of building screen
			mov di,22401			
build_loop:	
         	mov cx,319			
			mov dl,[es:di]			
			rep movsb			
			mov [es:di],dl			
			sub si,1				
			sub di,1				
			dec bx
			jnz build_loop
			cld
			pop si
			pop di
			pop ds
			popad
			pop es
			pop bp
			sti
			ret 			
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
;--------------------Print character,platform---------------
;---------------------------------------------------------------------------
screen3:

push ax
push bx
push cx
push es
push di
push si
push dx
push ds


		mov ax,[cs:y_pos]
		push ax
		call character
		call platform

pop ds
pop dx   
pop si
pop di
pop es
pop cx
pop bx
pop ax
ret 

;-----------------------------------------------------------------------------

; Greater 11
greater11:
mov bx, [var_di1]
sub bx, 60930
mov ax, 320
mov dx, [movebar_y1]
mul dx
mov di, ax
add di, 130
add di, bx 
mov [var_di1], di
sub di, bx
jmp cont11		

; Greater 12
greater12:
mov bx, [var_di2]
sub bx, 52930
mov ax, 320
mov dx, [movebar_y2]
mul dx
mov di, ax
add di, 130
add di, bx  	
mov [var_di2], di
sub di, bx
jmp cont12		

; Greater 13
greater13:
mov bx, [var_di3]
sub bx, 44930
mov ax, 320
mov dx, [movebar_y3]
mul dx
mov di, ax
add di, 130
add di, bx  
mov [var_di3], di
sub di, bx
jmp cont13
; -------------- bar 1 at last conditions --------------
di1_at_last:
    mov dx, [var_di1]
    mov [td1], dx
    mov dx, [var_di2]
    mov [td2], dx
    mov dx, [var_di3]
    mov [td3], dx

    mov word [movebar_y1], 140

    ; for bar1

    ; calculation if 190 is the starting location of bar1 and we are now moving it to the top
    ; so now we will calculate how far it had moved from its starting location
    ; and then start its moving from the same location in the top row
    cmp word [var_di1], 60930
    jg greater11
    mov dx, [var_di1]
    mov bx, 60930
    sub bx, dx
    
    mov ax, 320
    mov dx, [movebar_y1]
    mul dx
    mov di, ax
    add di, 130
    sub di, bx 	
    mov [var_di1], di
    add di, bx

cont11:          
    mov [stop_forward_bar1], di
    add word [stop_forward_bar1], 70 ; forward stopping value in dx
    mov [stop_backward_bar1], di
    sub word [stop_backward_bar1], 70 ; backward stopping value in bx

    ; for bar2
    mov word [movebar_y2], 190

    ; calculation if 165 is the starting location of bar2 and we are now moving it to 190
    ; so now we will calculate how far it had moved from its starting location
    ; and then start its moving from the same location in the top row
    cmp word [var_di2], 52930
    jg greater12
    mov dx, [var_di2]
    mov bx, 52930
    sub bx, dx
    mov ax, 320
    mov dx, [movebar_y2]
    mul dx
    mov di, ax
    add di, 130
    sub di, bx  
    mov [var_di2], di
    add di, bx

cont12:          
    mov [stop_forward_bar2], di
    add word [stop_forward_bar2], 70 ; forward stopping value in dx
    mov [stop_backward_bar2], di
    sub word [stop_backward_bar2], 70 ; backward stopping value in bx

    ; for bar 3
    mov word [movebar_y3], 165

    ; for bar1

    ; calculation if 190 is the starting location of bar1 and we are now moving it to the top
    ; so now we will calculate how far it had moved from its starting location
    ; and then start its moving from the same location in the top row
    cmp word [var_di3], 44930
    jg greater13
    mov dx, [var_di3]
    mov bx, 44930
    sub bx, dx
    mov ax, 320
    mov dx, [movebar_y3]
    mul dx
    mov di, ax
    add di, 130
    sub di, bx  
    mov [var_di3], di
    add di, bx

cont13:          
    mov [stop_forward_bar3], di
    add word [stop_forward_bar3], 70 ; forward stopping value in dx
    mov [stop_backward_bar3], di
    sub word [stop_backward_bar3], 70 ; backward stopping value in bx

jmp continuekrlo

greater21:
    mov bx, [var_di1]
    sub bx, 44930
    
    mov ax, 320
    mov dx, [movebar_y1]
    mul dx

    mov di, ax
    add di, 130
    add di, bx
    
    mov [var_di1], di
    sub di, bx
    jmp cont21

greater22:
    mov bx, [var_di2]
    sub bx, 60930
    mov ax, 320
    mov dx, [movebar_y2]
    mul dx

    mov di, ax
    add di, 130
    add di, bx
    
    mov [var_di2], di
    sub di, bx
    jmp cont22

greater23:
    mov bx, [var_di3]
    sub bx, 52930
    
    mov ax, 320
    mov dx, [movebar_y3]
    mul dx

    mov di, ax
    add di, 130
    add di, bx
    
    mov [var_di3], di
    sub di, bx
    jmp cont23

; -------------------- 2nd bar at last ----------------
di2_at_last: ; if the second bar is in the last

mov dx, [var_di1]
mov [td1], dx
mov dx, [var_di2]
mov [td2], dx
mov dx, [var_di3]
mov [td3], dx

mov word [movebar_y1], 165

; for bar1

; calculation if 190 is the starting location of bar1 and we are now moving it to the top
; so now we will calculate how far it had moved from its starting location
; and then start its moving from the same location in the top row
cmp word [var_di1], 44930
jg greater21
mov dx, [var_di1]
mov bx, 44930
sub bx, dx

mov ax, 320
mov dx, [movebar_y1]
mul dx
mov di, ax
add di, 130
sub di, bx
mov [var_di1], di
add di, bx

cont21:

mov [stop_forward_bar1], di
add word [stop_forward_bar1], 70 ; forward stopping value in dx
mov [stop_backward_bar1], di
sub word [stop_backward_bar1], 70 ; backward stopping value in bx

; for bar2
mov word [movebar_y2], 140

; calculation if 165 is the starting location of bar2 and we are now moving it to 190
; so now we will calculate how far it had moved from its starting location
; and then start its moving from the same location in the top row
cmp word [var_di2], 60930
jg greater22
mov dx, [var_di2]
mov bx, 60930
sub bx, dx
mov ax, 320
mov dx, [movebar_y2]
mul dx
mov di, ax
add di, 130
sub di, bx
mov [var_di2], di
add di, bx

cont22:

mov [stop_forward_bar2], di
add word [stop_forward_bar2], 70 ; forward stopping value in dx
mov [stop_backward_bar2], di
sub word [stop_backward_bar2], 70 ; backward stopping value in bx

; for bar 3
mov word [movebar_y3], 190

; for bar1

; calculation if 190 is the starting location of bar1 and we are now moving it to the top
; so now we will calculate how far it had moved from its starting location
; and then start its moving from the same location in the top row
cmp word [var_di3], 52930
jg greater23
mov dx, [var_di3]
mov bx, 52930
sub bx, dx

mov ax, 320
mov dx, [movebar_y3]
mul dx
mov di, ax
add di, 130
sub di, bx
mov [var_di3], di
add di, bx

cont23:

mov [stop_forward_bar3], di
add word [stop_forward_bar3], 70 ; forward stopping value in dx
mov [stop_backward_bar3], di
sub word [stop_backward_bar3], 70 ; backward stopping value in bx

jmp continuekrlo

greater31:
    mov bx, [var_di1]
    sub bx, 52930
    mov ax, 320
    mov dx, [movebar_y1]
    mul dx

    mov di, ax
    add di, 130
    add di, bx
    mov [var_di1], di
    sub di, bx
    jmp cont31

greater32:
    mov bx, [var_di2]
    sub bx, 44930
    mov ax, 320
    mov dx, [movebar_y2]
    mul dx

    mov di, ax
    add di, 130
    add di, bx
    mov [var_di2], di
    sub di, bx
    jmp cont32

greater33:
    mov bx, [var_di3]
    sub bx, 60930
    mov ax, 320
    mov dx, [movebar_y3]
    mul dx

    mov di, ax
    add di, 130
    add di, bx
    mov [var_di3], di
    sub di, bx
    jmp cont33

; ------------- bar 3 at last --------------
di3_at_last: ; if the third bar is in last

mov dx, [var_di1]
mov [td1], dx
mov dx, [var_di2]
mov [td2], dx
mov dx, [var_di3]
mov [td3], dx

mov word [movebar_y1], 190

; for bar1

; calculation if 190 is the starting location of bar1 and we are now moving it to the top
; so now we will calculate how far it had moved from its starting location
; and then start its moving from the same location in the top row
cmp word [var_di1], 52930
jg greater31
mov dx, [var_di1]
mov bx, 52930
sub bx, dx

mov ax, 320
mov dx, [movebar_y1]
mul dx
mov di, ax
add di, 130
sub di, bx
mov [var_di1], di
add di, bx

cont31:

mov [stop_forward_bar1], di
add word [stop_forward_bar1], 70 ; forward stopping value in dx
mov [stop_backward_bar1], di
sub word [stop_backward_bar1], 70 ; backward stopping value in bx

; for bar2
mov word [movebar_y2], 165

; calculation if 165 is the starting location of bar2 and we are now moving it to 190
; so now we will calculate how far it had moved from its starting location
; and then start its moving from the same location in the top row
cmp word [var_di2], 44930
jg greater32
mov dx, [var_di2]
mov bx, 44930
sub bx, dx
mov ax, 320
mov dx, [movebar_y2]
mul dx
mov di, ax
add di, 130
sub di, bx
mov [var_di2], di
add di, bx

cont32:

mov [stop_forward_bar2], di
add word [stop_forward_bar2], 70 ; forward stopping value in dx
mov [stop_backward_bar2], di
sub word [stop_backward_bar2], 70 ; backward stopping value in bx

; for bar 3
mov word [movebar_y3], 140

; for bar1

; calculation if 190 is the starting location of bar1 and we are now moving it to the top
; so now we will calculate how far it had moved from its starting location
; and then start its moving from the same location in the top row
cmp word [var_di3], 60930
jg greater33
mov dx, [var_di3]
mov bx, 60930
sub bx, dx

mov ax, 320
mov dx, [movebar_y3]
mul dx
mov di, ax
add di, 130
sub di, bx
mov [var_di3], di
add di, bx

cont33:

mov [stop_forward_bar3], di
add word [stop_forward_bar3], 70 ; forward stopping value in dx
mov [stop_backward_bar3], di
sub word [stop_backward_bar3], 70 ; backward stopping value in bx

jmp continuekrlo


changing_flag_of_char_di1:

mov word[temp_flag_for_char],1

jmp conttt


changing_flag_of_char_di2:

mov word[temp_flag_for_char],2

jmp conttt


changing_flag_of_char_di3:
 
mov word[temp_flag_for_char],3

jmp conttt


calculate_l_r_val:
push ax
push bx
push cx
push dx

			mov ax,320
			mov bx,165
					
			mul bx
			add ax,[x_pos_l]
		    
			mov [coordinated_x_pos_l_foot],ax
			
			add ax,13
			mov [coordinated_x_pos_r_foot],ax

pop dx
pop cx
pop bx
pop ax
ret

bar2_at_mid:
		mov ax,[var_di2]
		mov cx,50
		loopt2:
			cmp ax,[coordinated_x_pos_l_foot]
		    je contnuinghere
			cmp ax,[coordinated_x_pos_r_foot]
			je contnuinghere
			add ax,1
			sub cx,1
			cmp cx,0
			jne loopt2
			
            mov word[term_flag],1


			jmp contnuinghere

bar3_at_mid:

mov ax,[var_di3]
mov cx,50
		loopt3:
			cmp ax,[coordinated_x_pos_l_foot]
		    je contnuinghere
			cmp ax,[coordinated_x_pos_r_foot]
			je contnuinghere
			add ax,1
			sub cx,1
			cmp cx,0
			jne loopt3
			
            mov word[term_flag],1
			jmp contnuinghere
		
bar1_at_mid:

mov ax,[var_di1]
mov cx,50
		loopt1:
			cmp ax,[coordinated_x_pos_l_foot]
		    je contnuinghere
			cmp ax,[coordinated_x_pos_r_foot]
			je contnuinghere
			add ax,1
			sub cx,1
			cmp cx,0
			jne loopt1
			
            mov word[term_flag],1
			jmp contnuinghere
		
		
		
		;--------------------for terminition conditions---------------
check_for_bar:
push ax
push bx
push cx
push dx
push si
push di

call calculate_l_r_val         ;for the value of left and right foot of the character

				cmp word[var_di1], 60860      ; Compare AX with the lower bound
				jl  not_within_range22 ; Jump if AX is less than 60860
				cmp word[var_di1], 61000      ; Compare AX with the upper bound
				jg  not_within_range22 ; Jump if AX is greater than 61000
			
				jmp bar2_at_mid
								
				not_within_range22:
				cmp word[var_di2], 60860      ; Compare AX with the lower bound
				jl  not_within_range222 ; Jump if AX is less than 60860
				cmp word[var_di2], 61000      ; Compare AX with the upper bound
				jg  not_within_range222 ; Jump if AX is greater than 61000
			
				jmp bar3_at_mid
				
				
			 
				not_within_range222:
			 cmp word[var_di3], 60860      ; Compare AX with the lower bound
				jl  not_within_range322 ; Jump if AX is less than 60860
				cmp word[var_di3], 61000      ; Compare AX with the upper bound
				jg  not_within_range322 ; Jump if AX is greater than 61000
			
				jmp bar1_at_mid
						 
			 not_within_range322:

contnuinghere:

pop di
pop si
pop dx
pop cx
pop bx
pop ax
ret

move_rabbit_up:
push ax
            mov ax,[cs:y_pos]
			push ax 
			call remove_character
			sub word[cs:y_pos],25
			call screen3
		
			
			call delay1
			call delay1
			call delay1
			call delay1
pop ax
ret

;--------------------checking last bar;----------------
check_last_bar:

push ax
push bx
push cx
push es
push di
push si
push dx
	           cmp word[var_di1], 60860      ; Compare AX with the lower bound
				jl  not_within_range ; Jump if AX is less than 60860
				cmp word[var_di1], 61000      ; Compare AX with the upper bound
				jg  not_within_range ; Jump if AX is greater than 61000
			
				jmp di1_at_last
				
				
				not_within_range:
				cmp word[var_di2], 60860      ; Compare AX with the lower bound
				jl  not_within_range2 ; Jump if AX is less than 60860
				cmp word[var_di2], 61000      ; Compare AX with the upper bound
				jg  not_within_range2 ; Jump if AX is greater than 61000
			
				jmp di2_at_last
			
				not_within_range2:
     			 cmp word[var_di3], 60860      ; Compare AX with the lower bound
				jl  not_within_range3 ; Jump if AX is less than 60860
				cmp word[var_di3], 61000      ; Compare AX with the upper bound
				jg  not_within_range3 ; Jump if AX is greater than 61000
			
				jmp di3_at_last
			 
			 not_within_range3:
			 continuekrlo:
			
			mov word[remove_bar1],1
            mov word[remove_bar2],1
            mov word[remove_bar3],1
pop dx   
pop si
pop di
pop es
pop cx
pop bx
pop ax
ret


move_down:
push cx
push ax
			mov cx,25
			loopintd:
			mov ax,[cs:y_pos]
			push ax
			call remove_character
			add word[cs:y_pos],1
			call screen3
			
			call delay
			loop loopintd
			pop ax
			pop cx
			
ret
kbisr:
    push ax
    push es
    push bx
    push cx
    push dx

    mov bx, 0x0A000
    mov es, bx  ; point es to video memory
	
    in al, 0x60  ; read a char from the keyboard port
    
    cmp al, 0x01 ;escape key
    jne nextcmp

	mov word[flag_for_pause_screen],0
    call pause_Screen
	mov byte [choice],0
	jmp nomatch
	mov word[flag_for_pause_screen],1
    
	nextcmp:
    cmp al, 0x48 ; up key
    jne nextcmp2
	
    ; setting the timer value for game termination to zero (if jump made)
    mov word [bar_end_value], 0
    ;after the up key, the first thing to check is if the bar is present
    call check_for_bar
    ; step 1: moving upwards the character
    call move_rabbit_up
    ; comparing for termination condition
	a1:
    cmp word [term_flag],1
    jne cont
	mov byte [last],1

cont:
   
    ; step 2: moving the bar downward
    ; moving current values to temp
    call check_last_bar
    call move_down
    ; score check
    ; mov di, 150 ; [carrot_x]
    ; mov ax, 320
    ; add di, 3
    ; add di, 640
    ; add di, 49920 ; y loc
	mov di,50716

    mov dl, [es:di]
    cmp dl, 14
    jne noincrease
	cmp word [carrot_flag],1
	jne noincrease
    add word [score], 1
	
	
 ;yellow
 push 14
 ;yellow
 push 14
  ;y loc
 push 156
  ;x loc
 push 156
 call carrot
	mov word [carrot_flag],0

noincrease:
    ; conditions for moving the character along with the bar
    mov ax, 320
    mov bx, [y_pos]
    mul bx
    add ax, [x_pos_l]
    add ax, 3
    mov [coordinated_x_pos_l_foot], ax
    add ax, 10
    mov [coordinated_x_pos_r_foot], ax

    ; using bx for left foot and dx for right foot
    mov bx, [coordinated_x_pos_l_foot]
    mov dx, [coordinated_x_pos_r_foot]
    add bx, 320
    add dx, 320

    mov si, bx
    lodsb
    ; now al has the color of the location below the character's left foot
    cmp al, 14
    jne z1
	mov byte[last],1
	
z1:
    mov si, dx
    lodsb
    ; now al has the color of the location below the character's right foot
    cmp al, 14
    jne continuation
	mov byte[last],1

continuation:
    ; now using the same condition for checking which bar is in the last row
    cmp word [var_di1], 60860 ; Compare AX with the lower bound
    jl not_within_range_2    ; Jump if AX is less than 60860
    cmp word [var_di1], 61000 ; Compare AX with the upper bound
    jg not_within_range_2    ; Jump if AX is greater than 61000
    jmp changing_flag_of_char_di1

not_within_range_2:
    cmp word [var_di2], 60860 ; Compare AX with the lower bound
    jl not_within_range2_2   ; Jump if AX is less than 60860
    cmp word [var_di2], 61000 ; Compare AX with the upper bound
    jg not_within_range2_2   ; Jump if AX is greater than 61000
    jmp changing_flag_of_char_di2

not_within_range2_2:
    cmp word [var_di3], 60860 ; Compare AX with the lower bound
    jl not_within_range3_2   ; Jump if AX is less than 60860
    cmp word [var_di3], 61000 ; Compare AX with the upper bound
    jg not_within_range3_2   ; Jump if AX is greater than 61000
    jmp changing_flag_of_char_di3

not_within_range3_2:
conttt:
    jmp nomatch ; leave interrupt routine
  
  
  nextcmp2:
  
  cmp byte [choice],0
  jne nomatch
  cmp al,0x15 ;yes
  je updatechoice
 
  
  cmp al,0x31 ;no
  jne nomatch
  mov byte [last],1
 
   
  updatechoice:
  mov byte [choice],2
  
call clrscr
call print_background
call print_building
call print_cars
call screen3

mov ax, 41 ;orange
push ax
mov ax, 3 ;green
push ax
mov ax,128
push ax
mov ax,285
push ax		
call carrot 

    
nomatch:
    pop dx
    pop cx
    pop bx
    pop es
    pop ax
    jmp far [cs:oldisr]



platform:
 
push ax
push bx
push cx
push es
push di
push si
push dx

mov bx,0x0a000
mov es,bx

mov di,62400
mov cx,8;outer loop counter
mov al,40 ;color

cld
outerplat:
mov bx,320 ;inner loop value

innerplat:
stosb
dec bx
cmp bx,0
jnz innerplat
sub di,320
add di,320
loop outerplat


pop dx   
pop si
pop di
pop es
pop cx
pop bx
pop ax
ret  
 
 
 
 
 
 
 ;----------------carrot-----------
carrot:
push bp
mov bp,sp
push ax
push bx
push cx
push dx
push es
push di
push si


mov bx,0xa000
mov es,bx


mov ax,320
mov bx,[bp+6]
mul bx
add ax,[bp+4]

mov di,ax
push di
mov cx,7

mov al,[bp+10]

loopcarrot:

mov [es:di],al
add di,1
loop loopcarrot

add di,313

mov cx,7
loopcarrot6:
mov [es:di],al
add di,1
loop loopcarrot6

add di,313

mov cx,7
loopcarrot1:
mov [es:di],al
add di,1
loop loopcarrot1


add di, 314
mov cx,5

loopcarrot2:
mov [es:di],al
add di,1
loop loopcarrot2

add di, 315
mov cx,5

loopcarrot3:
mov [es:di],al
add di,1
loop loopcarrot3


add di, 316
mov cx,3
loopcarrot4:
mov [es:di],al
add di,1
loop loopcarrot4

add di, 317
mov cx,3
loopcarrot5:
mov [es:di],al
add di,1
loop loopcarrot5


add di, 318
mov [es:di],al
add di,320
mov [es:di],al

mov al,[bp+8]
;leaf
pop di
add di,2
sub di,320
push di

mov cx,3

loopcarrot7:
mov [es:di],al
sub di, 321
loop loopcarrot7



pop di

add di,2
mov cx,3
loopcarrot8:
mov [es:di],al
sub di, 319
loop loopcarrot8



pop si
pop di
pop es
pop dx
pop cx
pop bx
pop ax
pop bp
ret 8
 
 
 print_carrot:
push ax
push bx
push cx
push es
push di
push si
push dx


cmp byte[carrot_flag],1
jne contc
mov ax, 41 ;orange
push ax
mov ax, 3 ;green
push ax
;----------

mov ax,156  ;y loc
push ax
mov ax, 156;  ;x loc
push ax
call carrot
;mov byte [carrot_flag],0

contc:  
  
pop dx   
pop si
pop di
pop es
pop cx
pop bx
pop ax
ret
  
  
printscore:
push bp
mov bp,sp
push ax
push bx
push cx
push es
push di
push si
push dx
push ds
  


	;set cursor
  mov ah,02h
  mov bh,0  ;page
  mov dh,[bp+6] ;rows
  mov dl,[bp+4]   ;col
  int 0x10
  
  mov bl,10
  mov ah,0
  mov cx,[score]
  mov ax,cx
  div bl
  mov bh,ah ;remainder
  mov cl,al ;quotient
  push cx
 
  
   add bh,'0'
  
 
  mov al,bh
  mov bh,0;page
  mov bl,15
  mov cx,1
  mov ah,09h
  int 0x10
  
  mov ah,02h
  mov bh,0  ;page
  mov dh,[bp+6] ;rows
  mov dl,[bp+4]   ;col
  dec dl
  int 0x10
  
  
  pop cx
  add cl,'0'
  mov al,cl
  mov bh,0;page
  mov bl,15
  mov cx,1
  mov ah,09h
  int 0x10
  
sti
    
pop ds
pop dx   
pop si
pop di
pop es
pop cx
pop bx
pop ax
pop bp
ret 4
  
  
 
 
timer:
push ax
push bx
;only blue bar have terminations condition

cmp word [movebar_y3],190
jne skipp 

inc word[cs:bar_end_value]
cmp word [bar_end_value],90
jne skipp ;je gameover
mov byte [last],1
 ;je gameover
skipp:


inc word [cs:tickcountc]
;mov bx,[random]
cmp word [tickcountc],120
jne nor

;remove carrot first


mov byte [carrot_flag],1
mov word[tickcountc],0


nor:
xor ax,ax
mov al,0x20
out 0x20 ,al

pop bx
pop ax
iret

Rand:		push bp
			mov bp,sp
			pushad
			
			rdtsc
			xor  dx, dx
			mov  cx, [bp+4]    
			div  cx       ; here dx contains the remainder of the division - from 0 to 9
			mov [random],dx
			
			;call game_end
			popad
			pop bp
			ret 2
 
 
 
 
 
 
 

moving_values:
 

;---------------for bar 1----------
           mov ax,320
           mov dx,[movebar_y1]
           mul dx

            mov di, ax
			add di,130
			mov [var_di1],di
			mov [stop_forward_bar1],di
			add word[stop_forward_bar1],70;forward stopping value in dx
			mov [stop_backward_bar1],di
			sub word[stop_backward_bar1],70;backward stopping value in bx
									
			;moving these values to temp
			mov ax,[var_di1]
			 mov [temp_var_di],ax
		
		     mov ax,[stop_backward_bar1]
			 mov [temp_stop_backward_bar1],ax
		     mov ax,[stop_forward_bar1]
			 mov [temp_stop_forward_bar1],ax
			 
;---------------for bar 2----------
           mov ax,320
           mov dx,[movebar_y2]
           mul dx

            mov di, ax
			add di,130
			mov [var_di2],di
			mov [stop_forward_bar2],di
			add word[stop_forward_bar2],70;forward stopping value in dx
			mov [stop_backward_bar2],di
			sub word[stop_backward_bar2],70;backward stopping value in bx
			
			;moving these values to temp
			mov ax,[var_di2]
			 mov [temp_var_di2],ax
		
		     mov ax,[stop_backward_bar2]
			 mov [temp_stop_backward_bar2],ax
		     mov ax,[stop_forward_bar2]
			 mov [temp_stop_forward_bar2],ax
;---------------for bar 3----------
           mov ax,320
           mov dx,[movebar_y3]
           mul dx

            mov di, ax
			add di,130
			mov [var_di3],di
			mov [stop_forward_bar3],di
			add word[stop_forward_bar3],70;forward stopping value in dx
			mov [stop_backward_bar3],di
			sub word[stop_backward_bar3],70;backward stopping value in bx
					
			;moving these values to temp
			mov ax,[var_di3]
			 mov [temp_var_di3],ax
		
		     mov ax,[stop_backward_bar3]
			 mov [temp_stop_backward_bar3],ax
		     mov ax,[stop_forward_bar3]
			 mov [temp_stop_forward_bar3],ax
			 
			 
			
			
;----------------------------------


call clrscr
call print_background
call print_building
call print_cars
call screen3


mov ax, 41 ;orange
push ax
mov ax, 3 ;green
push ax
mov ax,128
push ax
mov ax,285
push ax		
call carrot 
 
jmp loop_for_animation
  
 game:
		 call movingbar1
		 call movingbar2
		 call movingbar3 
 		 call print_carrot
		 push 16 ;rows
		 push 38 ;col
		 call printscore
		 
		
		
 ret
 

pause_Screen:
    push ax
    push es
    push di
    mov di, 0

    mov cx, 64000  ; number of pixels as before 4000
    mov di, 0
    mov bx, 0A000h  ; video screen address as we used to do with 0xb800
    mov es, bx
    mov al, 14  ; color
    rep stosb

    mov cx, 32
    mov si, 0
carrotLoop31:
    push 41  ; orange
    push 3   ; green
    push 3   ; row
    push si  ; col
    call carrot
    add si, 10
    loop carrotLoop31

    mov cx, 32
    mov si, 0
carrotLoop41:
    push 41  ; orange
    push 3   ; green
    push 190  ; row
    push si  ; col
    call carrot
    add si, 10
    loop carrotLoop41

; set cursor
mov cx, 25
mov si, 0
mov dl, 50  ; col
pauseloop:
    mov ah, 02h  ; sub interrupt
    mov bh, 0    ; page
    mov dh, 10   ; rows
    int 0x10

    mov al, [Pause+si]
    mov bh, 0  ; page
    mov bl, 15 ; row
    push cx
    mov cx, 1  ; number of chars
    mov ah, 09h
    int 0x10
    inc si
    inc dl
    pop cx
    loop pauseloop

; yes
mov cx, 15
mov si, 0
mov dl, 45  ; col
pauseloop1:
    mov ah, 02h
    mov bh, 0    ; page
    mov dh, 12   ; rows
    int 0x10

    mov al, [yes+si]
    mov bh, 0  ; page
    mov bl, 41 ; row
    push cx
    mov cx, 1  ; number of chars
    mov ah, 09h
    int 0x10
    inc si
    inc dl
    pop cx
    loop pauseloop1

mov cx, 14
mov si, 0
mov dl, 45  ; col
pauseloop2:
    mov ah, 02h
    mov bh, 0    ; page
    mov dh, 14   ; rows
    int 0x10

    mov al, [No+si]
    mov bh, 0  ; page
    mov bl, 41 ; row
    push cx
    mov cx, 1  ; number of chars
    mov ah, 09h
    int 0x10
    inc si
    inc dl
    pop cx
    loop pauseloop2

pop di
pop es
pop ax
ret  


flag_for_pause_screen: dw 0

;main()
start:


mov ah,00h
mov al,13h
int 10h


call intro
;---------timer hook -------------
xor ax,ax
mov es,ax
mov ax,[es:8*4]
mov [Tisr],ax
mov ax, [es:8*4+2]
mov [Tisr+2], ax	
cli
mov word [es:8*4], timer		
mov [es:8*4+2], cs
sti
;-------------keyboard hook---------------------
			xor ax, ax
			mov es, ax								
			
			mov ax, [es:9*4]
			mov [oldisr], ax						
			mov ax, [es:9*4+2]
			mov [oldisr+2], ax						
			cli										; disable interrupts
			mov word [es:9*4], kbisr				; store offset at n*4
			mov [es:9*4+2], cs						; store segment at n*4+2
			sti										; enable interrupts
				
;----------------------------------------------- 




jmp moving_values


loop_for_animation:

cmp byte[choice],2
jne sss

at_pause:
cmp word[flag_for_pause_screen],0
jne at_pause

				call Animation
				call game 	

              ;check for termination
				cmp byte[last],1
				jne sss
				jmp gameover
sss:
				
				
jmp loop_for_animation


 gameover:
 

			call game_end
 terminate:

;Unhooking Timer
mov ax, [Tisr]
mov bx,[Tisr+2]
cli												
mov [es:8*4], ax								
mov [es:8*4+2], bx								
sti

;Unhooking Keyboard
mov ax, [oldisr]
mov bx,[oldisr+2]
cli												
mov [es:9*4], ax								
mov [es:9*4+2], bx								
sti

; ---------------------------------------------
mov ax, 0x4c00
int 0x21