org 0B100h
call DispStr
clear:    
    mov ax,cs
    mov ss,ax
    mov sp,0x7c00  ;set stack and sp

    mov ah,0x06
    mov al,0   ;清窗口

    mov ch,2   ;左上角的行号
    mov cl,2   ;左上角的列号
    mov dh,23  ;右下角的行号
    mov dl,77  ;右下角的行号
    mov bh,0x17;属性为蓝底白字
    int 0x10
@1:  
    jmp @1
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
    times 510-($-$$) db 0
    db 0x55,0xaa
