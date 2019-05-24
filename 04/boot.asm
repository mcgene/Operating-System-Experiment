org 7c00h
OffSetOfKernal equ 0xE000
mov    ax, cs
mov    ds, ax
mov    es, ax

mov bx,OffSetOfKernal ;偏移地址; 存放数据的内存偏移地址
mov ah,2                 ; 功能号
mov al,5                ;扇区数
mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
mov dh,0                 ;磁头号 ; 起始编号为0
mov ch,0                 ;柱面号 ; 起始编号为0
mov cl,6h                 ;起始扇区号 ; 起始编号为1
int 13H ;                调用读磁盘BIOS的13h功能
					
jmp OffSetOfKernal
			
times 510-($-$$) db 0
db 0x55,0xaa