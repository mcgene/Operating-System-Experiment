org 0B100h
clear:    
    mov ax,cs

    mov ah,0x06
    mov al,0   ;清窗口

    mov ch,0   ;左上角的行号
    mov cl,0   ;左上角的列号
    mov dh,24  ;右下角的行号
    mov dl,79  ;右下角的行号
    mov bh,0x07;属性为蓝底白字
    int 0x10 
    call DispStr
    mov ah,0
	int 16h
    ret
DispStr:
    pusha
    mov ax, BootMessage
    mov bp, ax ; ES:BP = 串地址
    mov cx, 21 ; CX = 串长度
    mov ax, 01300h ; AH = 13, AL = 01h
    mov bx, 000ch ; 页号为0 (BH = 0) 黑底红字(BL = 0Ch,高亮)
    mov dl, 0
    int 10h
    popa
    ret
    BootMessage: db "zhongzhicong 17341218"
    times 510-($-$$) db 0
    db 0x55,0xaa
