

public _interupt
_interupt proc
; 设置时钟中断向量（08h），初始化段寄存器
push ax
push es
push ds
    xor ax,ax			; AX = 0
    mov ds,ax			; ES = 0

    ;mov bx,4*08h+2
    ;mov word ptr [bx],seg INT08H	; 设置时钟中断向量的偏移地址
    ;mov bx, 4*08h
    ;mov word ptr [bx], offset INT08H		; 设置时钟中断向量的段地址=CS

    mov bx,4*33+2
    mov word ptr [bx],seg INT33H	; 设置时钟中断向量的偏移地址
    mov bx, 4*33
    mov word ptr [bx], offset INT33H		; 设置时钟中断向量的段地址=CS

    mov bx,4*34+2
    mov word ptr [bx],seg INT34H	; 设置时钟中断向量的偏移地址
    mov bx, 4*34
    mov word ptr [bx], offset INT34H		; 设置时钟中断向量的段地址=CS

    mov bx,4*35+2
    mov word ptr [bx],seg INT35H	; 设置时钟中断向量的偏移地址
    mov bx, 4*35
    mov word ptr [bx], offset INT35H		; 设置时钟中断向量的段地址=CS

    mov bx,4*36+2
    mov word ptr [bx],seg INT36H	; 设置时钟中断向量的偏移地址
    mov bx, 4*36
    mov word ptr [bx], offset INT36H		; 设置时钟中断向量的段地址=CS

    mov bx,4*37+2
    mov word ptr [bx],seg INT37H;初始化20H号中断
    mov bx, 4*37
    mov word ptr [bx], offset INT37H

    ;call SetTimer
    ;mov bx,4*8+2
    ;mov word ptr [bx]],seg Pro_Timer
	;mov bx,4*8
	;mov word ptr [bx]],offset Pro_Timer

    mov dl, 'a'
    mov ax, 0300h
    int 37

pop ax
pop es
pop ds
ret			; 死循环
_interupt endp

; 时钟中断处理程序
delayy equ 4		; 计时器延迟计数
ccount db 0	; 计时器计数变量，初值=delay

INT08H proc
push bp
push es
push ax
push bx
push dx
    ;***
    cli
    mov ax,0b800h
    mov es,ax
    mov al, byte ptr ccount
test0:
    cmp al,0
    jnz test1
    mov al,'|'
    mov ah,00fh
    mov byte ptr ccount,1
    jmp end_cmp
test1:
    cmp al,1
    jnz test2
    mov al,'\'
    mov ah,00fh
    mov byte ptr ccount,2
    jmp end_cmp
test2:
    cmp al,2
    jnz test3
    mov al,'-'
    mov ah,00fh
    mov byte ptr ccount,3
    jmp end_cmp
test3:
    cmp al,3
    jnz end_cmp
    mov al,'/'
    mov ah,00fh
    mov byte ptr ccount,0
    jmp end_cmp
end_cmp:
    mov	es:[((80*24+79)*2)], al
    sti
    ;*** 
mov al,20h
out 20h,al			; 发送EOI到主8529A
out 0A0h,al			; 发送EOI到从8529A
pop dx
pop bx
pop ax
pop es
pop bp
iret			; 从中断返回
INT08H ENDP

ouch_string db 'OUCH! OUCH!'
ouch_len dw $-ouch_string
cnt db 0
INT09H proc
push cx
push bp
push es
push ax
push bx
push dx
    cli
    in al,60h
    ;mov [raw_key], al
    mov cx, word ptr ouch_len
    mov bp, offset ouch_string
    mov ax,seg ouch_string
    mov es, ax
    mov ax,1300h
    mov	bx, 0007h
    mov dh,cnt
    mov dl,34h
    int 10h
    inc cnt
    sti
mov al,20h
out 20h,al			; 发送EOI到主8529A
out 0A0h,al			; 发送EOI到从8529A
pop dx
pop bx
pop ax
pop es
pop bp
pop cx
iret
INT09H endp


INT33H_string db '17341218 zhong zhicong'
INT33H_len dw $-INT33H_string
INT33H proc
push cx
push bp
push es
push ax
push bx
push dx
    mov cx, word ptr INT33H_len
    mov bp, offset INT33H_string
    mov ax,seg INT33H_string
    mov es, ax
    mov ax,1300h
    mov	bx, 0007h
    mov dx,610h
    int 10h
pop dx
pop bx
pop ax
pop es
pop bp
pop cx
iret
INT33H endp

INT34H_string db 'I Love OS'
INT34H_len dw $-INT34H_string
INT34H proc
push cx
push bp
push es
push ax
push bx
push dx
    cli
    mov cx, word ptr INT34H_len
    mov bp, offset INT34H_string
    mov ax,seg INT34H_string
    mov es, ax
    mov ax,1300h
    mov	bx, 0007h
    mov dx,634h
    int 10h
    sti
pop dx
pop bx
pop ax
pop es
pop bp
pop cx
iret
INT34H endp

INT35H_string db 'But OS hate me'
INT35H_len dw $-INT35H_string
INT35H proc
push cx
push bp
push es
push ax
push bx
push dx
    cli
    mov cx, word ptr INT35H_len
    mov bp, offset INT35H_string
    mov ax,seg INT35H_string
    mov es, ax
    mov ax,1300h
    mov	bx, 0007h
    mov dx,1210h
    int 10h
    sti
pop dx
pop bx
pop ax
pop es
pop bp
pop cx
iret
INT35H endp

INT36H_string db 'I am sad'
INT36H_len dw $-INT36H_string
INT36H proc
push cx
push bp
push es
push ax
push bx
push dx
    cli
    mov cx, word ptr INT36H_len
    mov bp, offset INT36H_string
    mov ax,seg INT36H_string
    mov es, ax
    mov ax,1300h
    mov	bx, 0007h
    mov dx,1334h
    int 10h
    sti
pop dx
pop bx
pop ax
pop es
pop bp
pop cx
iret 
INT36h endp

origin_offset dw ?
origin_seg dw ?

public _set_int09h
_set_int09h proc
push ax
push es
push ds
    xor ax,ax			; AX = 0
    mov ds,ax			; ES = 0

    mov bx,4*09h+2
    mov ax,word ptr[bx]
    mov word ptr origin_seg, ax
    mov word ptr [bx],seg INT09H	; 设置时钟中断向量的偏移地址

    mov bx, 4*09h
    mov ax,word ptr[bx]
    mov word ptr origin_offset, ax
    mov word ptr [bx], offset INT09H		; 设置时钟中断向量的段地址=CS

pop ax
pop es
pop ds
ret
_set_int09h endp

public _reset_int09h
_reset_int09h proc
push ax
push es
push ds
    xor ax,ax			; AX = 0
    mov ds,ax			; ES = 0

    mov bx,4*09h+2
    mov ax,word ptr origin_seg
    mov word ptr [bx],ax	; 设置时钟中断向量的偏移地址

    mov bx, 4*09h
    mov ax, word ptr origin_offset
    mov word ptr [bx], ax		; 设置时钟中断向量的段地址=CS

pop ax
pop es
pop ds
ret
_reset_int09h endp

extern _int37h_call:near
INT37H proc
    cli
    push word ptr cx
    push word ptr dx
    push word ptr ax
    call _int37h_call
    pop word ptr ax
    pop word ptr dx
    pop word ptr cx
    sti
    iret 
INT37h endp