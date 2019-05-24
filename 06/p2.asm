org 02000h
; 程序源代码（stone.asm）
; 本程序在文本方式显示器上从左边射出一个*号,以45度向右下运动，撞到边框后反射,如此类推.
;  凌应标 2014/3
;   NASM汇编格式
				; 程序加载到100h，可用于生成COM

 
    Dn_Rt equ 1                  ;D-Down,U-Up,R-right,L-Left
    Up_Rt equ 2                  ;
    Up_Lt equ 3                  ;
    Dn_Lt equ 4                  ;
    delay equ 50000					; 计时器延迟计数,用于控制画框的速度
    ddelay equ 580					; 计时器延迟计数,用于控制画框的速度
    
start:
    	int 35
	;xor ax,ax					; AX = 0   程序加载到0000：100h才能正确执行
      mov ax,cs
	mov es,ax					; ES = 0
	mov ds,ax					; DS = CS
	mov es,ax					; ES = CS
	mov	ax,0B800h				; 文本窗口显存起始地址
	mov	gs,ax					; GS = B800h
	mov word[y],0
	mov word[x],11
      mov byte[char],'B'
	mov byte[rdul], 4
loop1:
	dec word[count]				; 递减计数变量
	jnz loop1					; >0：跳转;
	mov word[count],delay
	dec word[dcount]				; 递减计数变量
      jnz loop1
	mov word[count],delay
	mov word[dcount],ddelay
	dec word[cnt]
	jz Exit

      mov al,1
      cmp al,byte[rdul]
	jz  Dn
      mov al,2
      cmp al,byte[rdul]
	jz  Up
      mov al,3
      cmp al,byte[rdul]
	jz  Lt
      mov al,4
      cmp al,byte[rdul]
	jz  Rt
      ret	

Dn:
	inc word[y]
	mov bx,word[y]
	cmp bx,40
	jz DnChange
	Dnnext:
	mov ah,0dh
	mov al,byte[char]
	push ax
	jmp show
	DnChange:
		mov byte[rdul], 3
		push ax
		mov al,byte[char]
		inc al
		mov byte[char],al
		pop ax
		jmp Dnnext

Up:
	dec word[y]
	mov bx,word[y]
	cmp bx,0
	jz UpChange
	Upnext:
	mov ah,0ch
	mov al,byte[char]
	push ax
	jmp show
	UpChange:
		mov byte[rdul], 4
		push ax
		mov al,byte[char]
		inc al
		mov byte[char],al
		pop ax
		jmp Upnext	
	
Lt:
	dec word[x]
	mov bx,word[x]
	cmp bx,12
	jz LtChange
	Ltnext:
	mov ah,0bh
	mov al,byte[char]
	push ax
	jmp show
	LtChange:
		mov byte[rdul], 2
		push ax
		mov al,byte[char]
		inc al
		mov byte[char],al
		pop ax
		jmp Ltnext	
	
Rt:
	inc word[x]
	mov bx,word[x]
	cmp bx,24
	jz RtChange
	Rtnext:
	mov ah,0eh
	mov al,byte[char]
	push ax
	jmp show
	RtChange:
		mov byte[rdul], 1
		push ax
		mov al,byte[char]
		inc al
		mov byte[char],al
		pop ax
		jmp Rtnext

	
show:	
      xor ax,ax                 ; 计算显存地址
      mov ax,word[x]
	mov bx,80
	mul bx
	add ax,word[y]
	mov bx,2
	mul bx
	mov bp,ax
	pop ax			;  AL = 显示字符值（默认值为20h=空格符）
	mov word[gs:bp],ax  		;  显示字符的ASCII码值
	jmp loop1
	
end:
    ret                   ; 停止画框，无限循环 

Exit:
	pop ax
	ret


datadef:	
    count dw delay
    dcount dw ddelay
    rdul db Dn_Rt         ; 向右下运动
    x    dw 11
    y    dw 0
    char db 'B'
    cnt  dw 200

