
; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;                              klib.asm
; ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


; 导入全局变量
extern	_disp_pos
extern _CMDline
extern _dir
extern _input
extern _hour
extern _minute
extern _second
extern _century
extern _year
extern _month
extern _day
;****************************
; SCOPY@                    *
;****************************
;局部字符串带初始化作为实参问题补钉程序
public SCOPY@
SCOPY@ proc 
		arg_0 = dword ptr 6
		arg_4 = dword ptr 0ah
		push bp
			mov bp,sp
		push si
		push di
		push ds
			lds si,[bp+arg_0]
			les di,[bp+arg_4]
			cld
			shr cx,1
			rep movsw
			adc cx,cx
			rep movsb
		pop ds
		pop di
		pop si
		pop bp
		retf 8
SCOPY@ endp



;****************************
; void _cls()               *
;****************************

public _cls
_cls proc 
; 清屏
    mov ax,0003h
	int 10h
	ret
_cls endp

;********************************************************
; void _printChar(char ch)                            *
;********************************************************


public _printChar
_printChar proc 
	push bp
		mov bp,sp
		;***
		mov al,[bp+4]
		mov bl,0
		mov ah,0eh
		int 10h
		;***
		mov sp,bp
	pop bp
	ret
_printChar endp

;****************************
; void _getChar()           *
;****************************

public _getChar
_getChar proc
	mov ah,0
	int 16h
	mov byte ptr[_input],al
	in al,60h
	mov byte ptr[_dir],al
	ret
_getChar endp






; ========================================================================
;  void _printf(char * pszInfo);
; ========================================================================
Public	_printf
_printf proc
	push	bp         ;sp+2
	push	es         ;sp+2+2
	push    ax         ;sp+2+2+2
    	mov ax,0b800h
		mov es,ax
		mov	bp, sp

		mov	si, word ptr [bp + 2+2+2+2]	; pszInfo\IP\bp\es\ax
		mov	di, word ptr [_disp_pos]
		mov	ah, 0Fh
	.1:
		mov al,byte ptr [si]
		inc si
		mov byte ptr [di],al
		test	al, al
		jz	.2
		cmp	al, 0Ah	; 是回车吗?
		jnz	.3
		push	ax
		mov	ax, di
		mov	bl, 160
		div	bl
		and	ax, 0FFh
		inc	ax
		mov	bl, 160
		mul	bl
		mov	di, ax
		pop	ax
		jmp	.1
	.3:
		mov	es:[di], ax
		add	di, 2
		jmp	.1

	.2:
		mov	[_disp_pos], di
    pop ax
	pop es
	pop	bp
	ret
_printf endp
; ========================================================================
;                  void _cprintf(char * info, int color);
; ========================================================================
Public	_cprintf
_cprintf proc
	push	bp         ;sp+2
	push	es         ;sp+2+2
	push    ax         ;sp+2+2+2
    	mov ax,0b800h
		mov es,ax
		mov	bp, sp

		mov	si, word ptr [bp + 2+2+2+2]	; pszInfo\IP\bp\es\ax
		mov	di, word ptr [_disp_pos]
		mov	ah, byte ptr [bp +2+2+2+2]	; color
	.1@:
		mov al,byte ptr [si]
		inc si
		mov byte ptr [di],al

		test	al, al
		jz	.2@
		cmp	al, 0Ah	; 是回车吗?
		jnz	.3@
		push	ax
		mov	ax, di
		mov	bl, 160
		div	bl
		and	ax, 0FFh
		inc	ax
		mov	bl, 160
		mul	bl
		mov	di, ax
		pop	ax
		jmp	.1@
	.3@:
		mov	word ptr es:[di], ax
		add	di, 2
		jmp	.1@

	.2@:
		mov	word ptr [_disp_pos], di

    pop ax
	pop es
	pop	bp
	ret
_cprintf endp
; ========================================================================
;                  void _port_out(u16 port, u8 value);
; ========================================================================
Public	_port_out
_port_out proc
    push bp
            mov bp,sp
        	mov	dx, word ptr [bp + 2]		; port
			mov	al, byte ptr [bp + 2 + 2]	; value
			out	dx, al
			nop	; 一点延迟
			nop
			mov sp,bp
	pop bp
	ret
_port_out endp
; ========================================================================
;                  u8 _port_in(u16 port);
; ========================================================================
Public	_port_in
_port_in proc
    push bp
            mov bp,sp
        	mov	dx, word ptr [bp + 2]		; port
			xor	ax, ax
			in	al, dx
			nop	; 一点延迟
			nop
			mov sp,bp
	pop bp
	ret
_port_in endp

; ****************************************
;* Show Time                    *;
; ****************************************
public _show_Time
_show_Time proc

    push ax
    push bx
    push cx
    push dx	
	
	mov ah,2h
    int 1ah
    mov  byte ptr[_hour],ch
    mov  byte ptr[_minute],cl 
    mov  byte ptr[_second],dh
	
	
	pop dx
    pop cx
	pop bx
	pop ax
	ret
 _show_Time endp
 ; ****************************************
;* Show Date                    *;
; ****************************************
public _show_Date
_show_Date proc
    push ax
    push bx
    push cx
    push dx
	
	mov ah,4h
    int 1ah
	
	mov byte ptr[_century],ch
	mov byte ptr[_year],cl
	mov byte ptr[_month],dh
	mov byte ptr[_day],dl
	
	pop dx
    pop cx
	pop bx
	pop ax
	ret
 _show_Date endp

public _ReadCommand
_ReadCommand proc
        push es
        push ds
		mov cx,20
        mov bx,0b800h
		mov es,bx
        mov si,offset _CMDline
		mov di,650
pro3:   
		mov ah,0
        int 16h
		cmp al,0Dh
        jz  pro4
		mov [si],al
		mov ah,0ah
		mov bh,00h
		mov cx,1
		int 10h
		mov bh,00h
		mov ah,03h
		int 10h
		inc dl
		mov ah,02h
		int 10h
        inc si
        loop pro3
	
pro4:
		inc si
		mov al,0h
		mov [si],al
		mov bh,00h
		mov ah,03h
		int 10h
		inc dh
		mov dl,0
		mov ah,02h
		int 10h
        pop   es
        pop   ds
        ret
_ReadCommand endp


public _printff
_printff proc
	push	bp         ;sp+2
	push	es         ;sp+2+2
	push    ax         ;sp+2+2+2
		mov	ax, cs	       ; 置其他段寄存器值与CS相同
		mov	ds, ax	       ; 数据段
		mov	ax, ds		 ; ES:BP = 串地址
		mov	es, ax		 ; 置ES=DS
		mov bx, sp
		mov	bp, word ptr [bx + 2+2+2+2]	; pszInfo\IP\bp\es\ax
		mov	cx, word ptr [bx + 2+2+2+2+2]	; pszInfo\IP\bp\es\ax
		mov	ax, 1301h		 ; AH = 13h（功能号）、AL = 01h（光标置于串尾）
		mov	bx, 0007h		 ; 页号为0(BH = 0) 黑底白字(BL = 07h)
		int	10h			 ; BIOS的10h功能：显示一行字符
    pop ax
	pop es
	pop	bp
    ret
_printff  endp

delay proc
	push cx
	mov cx,5000
L:
	loop L
	pop cx
	ret
delay endp

SetTimer: 
    push ax
    mov al,34h   ; 设控制字值 
    out 43h,al   ; 写控制字到控制字寄存器 
    mov ax,29830 ; 每秒 20 次中断（50ms 一次） 
    out 40h,al   ; 写计数器 0 的低字节 
    mov al,ah    ; AL=AH 
    out 40h,al   ; 写计数器 0 的高字节 
	pop ax
	ret

public _setClock
_setClock proc
    push ax
	push bx
	push cx
	push dx
	push ds
	push es
	
    ;call SetTimer
    xor ax,ax
	mov es,ax
	mov word ptr es:[20h],offset Timer
	mov ax,cs
	mov word ptr es:[22h],cs
	
	pop ax
	mov es,ax
	pop ax
	mov ds,ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_setClock endp

public _Open_Key_Int
_Open_Key_Int proc
    push ax
	push bx
	push cx
	push dx
	push es
	push ds
	
    xor ax,ax
	mov es,ax
	push word ptr es:[9*4]
	pop word ptr ds:[0]
	push word ptr es:[9*4+2]
	pop word ptr ds:[2]
	
	xor ax,ax
	mov es,ax
	mov word ptr es:[24h],offset INT09H
	mov ax,cs
	mov word ptr es:[26h],cs
	
	pop ax
	mov ds,ax
	pop ax
	mov es,ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
_Open_Key_Int endp

public _Close_Key_Int
_Close_Key_Int proc
	push ax
	push bx
	push cx
	push dx
	push es
	push ds
	
	xor ax,ax
	mov es,ax
	push word ptr ds:[0]
	pop word ptr es:[9*4]
	push word ptr ds:[2]
	pop word ptr es:[9*4+2]
	int 9h
	
	pop ax
	mov ds,ax
	pop ax
	mov es,ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
_Close_Key_Int endp

extern _CurrentPCBno
extern _Program_Num
extern _Segment
extern _Save_Process:near
extern _special:near
extern _Schedule:near
extern _Current_Process:near
extern _bug:near
extern _PrintInt:near
Finite dw 0	

public _another_load
_another_load proc
    push ax
	push bp
	
	mov bp,sp
	
    mov ax,[bp+6]      	;段地址 ; 存放数据的内存基地址
	mov es,ax          	;设置段地址（不能直接mov es,段地址）
	mov bx,0A100h        	;偏移地址; 存放数据的内存偏移地址
	mov ah,2           	;功能号
	mov al,1          	;扇区数
	mov dl,0          	;驱动器号 ; 软盘为0，硬盘和U盘为80H
	mov dh,0          	;磁头号 ; 起始编号为0
	mov ch,0          	;柱面号 ; 起始编号为0
	mov cl,[bp+8]       ;起始扇区号 ; 起始编号为1
	int 13H          	; 调用中断
	mov ax,0A100h
	;call es:ax

	pop bp
	pop ax

	ret
_another_load endp

extern _getCurrentPCB:near
extern _SaveCurrentPCB:near
extern _getCurrentPCB:near
extern _isProgramRunning
extern _processNum
Timer: ;时间中断，用于用户程序轮转
	cmp word ptr[_processNum],0
	jnz SaveCurrentPCB
	jmp TimeExit
SaveCurrentPCB:     ;当前栈顶:\psw\cs\ip   用户栈，第一次进入为内核栈
	.386
	push ss 
	push gs
	push fs
	push es
	push ds
	.8086
	
	push di
	push si
	push bp
	push sp  ;  这里的sp是当前的栈顶,而非进入前栈顶
	push bx
	push dx
	push cx
	push ax     ;将pcb 表需要的东西压栈作为参数传给_SaveCurrentPCB

	mov ax,cs
	mov ds, ax
	mov es, ax

	call _SaveCurrentPCB ;sp暂时是不正确的,在restart里面修复
	
	call _Schedule      ;时间片顺序轮转

	mov word ptr[_isProgramRunning],1  ; isProgramRunning = 1时上面两个函数才有作用,否则直接退出

	mov ax, cs
	mov ds, ax
	call _getCurrentPCB             ;第一次进入时为 &pcb_list[0]
	mov si, ax

	mov ss,word ptr ds:[si+0]         
	mov sp,word ptr ds:[si+2*8] 
	add sp, 11*2    ;恢复进入时间中断前 栈顶

	;cmp word ptr ds:[si+0], 2000h     ;debug信息
	;je put0
	;cmp word ptr ds:[si+0], 3000h
	;je put1
	;cmp word ptr ds:[si+0], 4000h
	;je put2
	;cmp word ptr ds:[si+0], 5000h
	;je put3
	;cmp word ptr ds:[si+13*2],100h
	;je puth
restart:

	push word ptr ds:[si+2*15] ; push fl
	push word ptr ds:[si+2*14] ;push cs
	push word ptr ds:[si+2*13]	;push ip    ;模拟中断进入操作
	
	push word ptr ds:[si+2*1]   ;push gs    ;调出寄存器值
	push word ptr ds:[si+2*2]   ;push fs
	push word ptr ds:[si+2*3]   ;push es
	push word ptr ds:[si+2*4]   ;push ds
	push word ptr ds:[si+2*5]   ;push di
	push word ptr ds:[si+2*6]   ;push si
	push word ptr ds:[si+2*7]   ;push bp
	push word ptr ds:[si+2*9]   ;push bx
	push word ptr ds:[si+2*10]   ;push dx
	push word ptr ds:[si+2*11]   ;push cx
	push word ptr ds:[si+2*12]   ;push ax

	;恢复各寄存器值
	pop ax
	pop cx
	pop dx
	pop bx
	pop bp
	pop si
	pop di
	pop ds
	pop es
	.386
	pop fs
	pop gs
	.8086

TimeExit:            ;结束中断
	push ax         
	mov al,20h; AL = EOI          ; 发送中断处理结束消息给中断控制器
	out 20h,al; 发送EOI到主8529A
	out 0A0h,al; 发送EOI到从8529A
	pop ax
	iret
