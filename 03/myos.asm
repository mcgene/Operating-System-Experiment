;程序源代码（myos1.asm）
extern  macro %1    ;统一用extern导入外部标识符
	extrn %1
endm

		; BIOS将把引导扇区加载到0:7C00h处，并开始执行
OffSetOfUserPrg1 equ 0A100h
OffSetOfUserPrg2 equ 0B100h
OffSetOfUserPrg3 equ 0C100h
OffSetOfUserPrg4 equ 0D100h

extern _cmain:near
extern _buffer

.8086
_TEXT segment byte public 'CODE'
DGROUP group _TEXT
assume cs:_TEXT
org  0E000h
Start:
	mov	ax, cs	       ; 置其他段寄存器值与CS相同
	mov	ds, ax	       ; 数据段
      mov   ax,ds
	mov	es, ax		 ; 置ES=DS
      call near ptr _cmain
      call _getChar
      MOV	AH,	4CH		
      	INT	21H
AfterRun:
      jmp key                      ;无限循环     
      
      
      
key:     
      jmp key

public _pr1
_pr1 proc
      mov bx,OffSetOfUserPrg1  ;偏移地址; 存放数据的内存偏移地址
      mov ah,2                 ; 功能号
      mov al,1                 ;扇区数
      mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
      mov dh,0                 ;磁头号 ; 起始编号为0
      mov ch,0                 ;柱面号 ; 起始编号为0
      mov cl,2h                 ;起始扇区号 ; 起始编号为1
      int 13H ;                调用读磁盘BIOS的13h功能
      mov ax,OffSetOfUserPrg1
      call ax
      ret
_pr1 endp

public _pr2
_pr2 proc
      mov bx,OffSetOfUserPrg2  ;偏移地址; 存放数据的内存偏移地址
      mov ah,2                 ; 功能号
      mov al,1                 ;扇区数
      mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
      mov dh,0                 ;磁头号 ; 起始编号为0
      mov ch,0                 ;柱面号 ; 起始编号为0
      mov cl, 3               ;起始扇区号 ; 起始编号为1
      int 13H ;                调用读磁盘BIOS的13h功能
      mov ax,OffSetOfUserPrg2
      call ax
      ret
_pr2 endp

public _pr3
_pr3 proc
      mov bx, OffSetOfUserPrg3  ;偏移地址; 存放数据的内存偏移地址
      mov ah,2                 ; 功能号
      mov al,1                 ;扇区数
      mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
      mov dh,0                 ;磁头号 ; 起始编号为0
      mov ch,0                 ;柱面号 ; 起始编号为0
      mov cl,4                 ;起始扇区号 ; 起始编号为1
      int 13H ;                调用读磁盘BIOS的13h功能
      mov ax,OffSetOfUserPrg3
      call ax
      ret
_pr3 endp

public _pr4
_pr4 proc
      mov bx,OffSetOfUserPrg4  ;偏移地址; 存放数据的内存偏移地址
      mov ah,2                 ; 功能号
      mov al,1                 ;扇区数
      mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
      mov dh,0                 ;磁头号 ; 起始编号为0
      mov ch,0                 ;柱面号 ; 起始编号为0
      mov cl,5H                 ;起始扇区号 ; 起始编号为1
      int 13H ;                调用读磁盘BIOS的13h功能
      mov ax,OffSetOfUserPrg4
      call ax
      ret
_pr4 endp

include kliba.asm

_TEXT ends

_DATA segment word public 'DATA'

_DATA ends

_BSS	segment word public 'BSS'
_BSS ends

end start
