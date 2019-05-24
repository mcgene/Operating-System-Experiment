; 程序源代码（stone.asm）
; 本程序在文本方式显示器上从左边射出一个*号,以45度向右下运动，撞到边框后反射,如此类推.
;  凌应标 2014/3
;   NASM汇编格式
org 0A100h					; 程序加载到100h，可用于生成COM

 
    Dn_Rt equ 1                  ;D-Down,U-Up,R-right,L-Left
    Up_Rt equ 2                  ;
    Up_Lt equ 3                  ;
    Dn_Lt equ 4                  ;
    delay equ 50000					; 计时器延迟计数,用于控制画框的速度
    ddelay equ 580					; 计时器延迟计数,用于控制画框的速度
    
start:
	;xor ax,ax					; AX = 0   程序加载到0000：100h才能正确执行
      mov ax,cs
	mov es,ax					; ES = 0
	mov ds,ax					; DS = CS
	mov es,ax					; ES = CS
	mov	ax,0B800h				; 文本窗口显存起始地址
	mov	gs,ax					; GS = B800h
      mov byte[char],'A'
loop1:
	
	dec word[count]				; 递减计数变量
	jnz loop1					; >0：跳转;
	mov word[count],delay
	dec word[dcount]				; 递减计数变量
      jnz loop1
	mov word[count],delay
	mov word[dcount],ddelay
	call DispStr

      mov al,1
      cmp al,byte[rdul]
	jz  DnRt
      mov al,2
      cmp al,byte[rdul]
	jz  UpRt
      mov al,3
      cmp al,byte[rdul]
	jz  UpLt
      mov al,4
      cmp al,byte[rdul]
	jz  DnLt
      jmp $	

DnRt:
	inc word[x]
	inc word[y]
	mov bx,word[x]
	mov ax,25
	sub ax,bx
      jz  dr2ur
	mov bx,word[y]
	mov ax,80
	sub ax,bx
      jz  dr2dl
	mov ah,0dh
	mov al,byte[char]
	push ax
	jmp show
dr2ur:
      mov word[x],23
      mov byte[rdul],Up_Rt
	mov ah,0dh
	mov al,byte[char]
	push ax	
      jmp show
dr2dl:
      mov word[y],78
      mov byte[rdul],Dn_Lt
	mov ah,0dh
	mov al,byte[char]
	push ax	
      jmp show

UpRt:
	dec word[x]
	inc word[y]
	mov bx,word[y]
	mov ax,80
	sub ax,bx
      jz  ur2ul
	mov bx,word[x]
	mov ax,-1
	sub ax,bx
      jz  ur2dr
	mov ah,0ch
	mov al,byte[char]
	push ax
	jmp show
ur2ul:
      mov word[y],78
      mov byte[rdul],Up_Lt
	mov ah,0ch
	mov al,byte[char]
	push ax	
      jmp show
ur2dr:
      mov word[x],1
      mov byte[rdul],Dn_Rt
	mov ah,0ch
	mov al,byte[char]
	push ax	
      jmp show

	
	
UpLt:
	dec word[x]
	dec word[y]
	mov bx,word[x]
	mov ax,-1
	sub ax,bx
      jz  ul2dl
	mov bx,word[y]
	mov ax,-1
	sub ax,bx
      jz  ul2ur
	mov ah,0bh
	mov al,byte[char]
	push ax
	jmp show

ul2dl:
      mov word[x],1
      mov byte[rdul],Dn_Lt
	mov ah,0bh
	mov al,byte[char]
	push ax	
      jmp show
ul2ur:
      mov word[y],1
      mov byte[rdul],Up_Rt
	mov ah,0bh
	mov al,byte[char]
	push ax
      jmp show

	
	
DnLt:
	inc word[x]
	dec word[y]
	mov bx,word[y]
	mov ax,-1
	sub ax,bx
      jz  dl2dr
	mov bx,word[x]
	mov ax,25
	sub ax,bx
      jz  dl2ul
	mov ah,0eh
	mov al,byte[char]
	push ax
	jmp show

dl2dr:
      mov word[y],1
      mov byte[rdul],Dn_Rt	
	mov ah,0ah
	mov al,byte[char]
	push ax
      jmp show
	
dl2ul:
      mov word[x],23
      mov byte[rdul],Up_Lt
	mov ah,0eh
	mov al,byte[char]
	push ax	
      jmp show
	
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
    jmp $                   ; 停止画框，无限循环 

DispStr:
 pusha
 mov ax, BootMessage
 mov bp, ax ; ES:BP = 串地址
 mov cx, 21 ; CX = 串长度
 mov ax, 01301h ; AH = 13, AL = 01h
 mov bx, 000ch ; 页号为0 (BH = 0) 黑底红字(BL = 0Ch,高亮)
 mov dl, 0
 int 10h
 popa
 ret

BootMessage: db "zhongzhicong 17341218"

datadef:	
    count dw delay
    dcount dw ddelay
    rdul db Dn_Rt         ; 向右下运动
    x    dw 7
    y    dw 0
    char db 'A'

times 510-($-$$) db 0
db 0x55,0xaa