;程序源代码（myos1.asm）
org  7c00h		; BIOS将把引导扇区加载到0:7C00h处，并开始执行
OffSetOfUserPrg1 equ 0A100h
OffSetOfUserPrg2 equ 0B100h
OffSetOfUserPrg3 equ 0C100h
OffSetOfUserPrg4 equ 0D100h
Start:
	mov	ax, cs	       ; 置其他段寄存器值与CS相同
	mov	ds, ax	       ; 数据段
	mov	bp, Message		 ; BP=当前串的偏移地址
	mov	ax, ds		 ; ES:BP = 串地址
	mov	es, ax		 ; 置ES=DS
	mov	cx, MessageLength  ; CX = 串长（=9）
	mov	ax, 1301h		 ; AH = 13h（功能号）、AL = 01h（光标置于串尾）
	mov	bx, 0007h		 ; 页号为0(BH = 0) 黑底白字(BL = 07h)
      mov dh, 0		       ; 行号=0
	mov	dl, 0			 ; 列号=0
	int	10h			 ; BIOS的10h功能：显示一行字符
LoadnEx:
     ;读软盘或硬盘上的若干物理扇区到内存的ES:BX处：
      mov ax,cs                ;段地址 ; 存放数据的内存基地址
      mov es,ax                ;设置段地址（不能直接mov es,段地址）
      mov bx, OffSetOfUserPrg1  ;偏移地址; 存放数据的内存偏移地址
      mov ah,2                 ; 功能号
      mov al,1                 ;扇区数
      mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
      mov dh,0                 ;磁头号 ; 起始编号为0
      mov ch,0                 ;柱面号 ; 起始编号为0
      mov cl,2                 ;起始扇区号 ; 起始编号为1
      int 13H ;                调用读磁盘BIOS的13h功能
      mov bx, OffSetOfUserPrg2  ;偏移地址; 存放数据的内存偏移地址
      mov ah,2                 ; 功能号
      mov al,1                 ;扇区数
      mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
      mov dh,0                 ;磁头号 ; 起始编号为0
      mov ch,0                 ;柱面号 ; 起始编号为0
      mov cl,3                 ;起始扇区号 ; 起始编号为1
      int 13H ;                调用读磁盘BIOS的13h功能
      mov bx, OffSetOfUserPrg3  ;偏移地址; 存放数据的内存偏移地址
      mov ah,2                 ; 功能号
      mov al,1                 ;扇区数
      mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
      mov dh,0                 ;磁头号 ; 起始编号为0
      mov ch,0                 ;柱面号 ; 起始编号为0
      mov cl,4                 ;起始扇区号 ; 起始编号为1
      int 13H ;                调用读磁盘BIOS的13h功能
      mov bx, OffSetOfUserPrg4  ;偏移地址; 存放数据的内存偏移地址
      mov ah,2                 ; 功能号
      mov al,1                 ;扇区数
      mov dl,0                 ;驱动器号 ; 软盘为0，硬盘和U盘为80H
      mov dh,0                 ;磁头号 ; 起始编号为0
      mov ch,0                 ;柱面号 ; 起始编号为0
      mov cl,5                 ;起始扇区号 ; 起始编号为1
      int 13H ;                调用读磁盘BIOS的13h功能
key:     
      mov ah,0x00     ;在寄存器ah中指定功能号0x00
      int 0x16        ;执行中断0x16的0x00号功能:从键盘读字符
      cmp al,'1'
      je pr1
      cmp al,'2'
      je pr2
      cmp al,'3'
      je pr3
      cmp al,'4'
      je pr4
      jmp key
pr1:
      jmp OffSetOfUserPrg1
      jmp AfterRun
pr2:
      jmp OffSetOfUserPrg2
      jmp AfterRun
pr3:
      jmp OffSetOfUserPrg3
      jmp AfterRun
pr4:
      jmp OffSetOfUserPrg4
      jmp AfterRun
AfterRun:
      jmp $                      ;无限循环
Message:
      db 'please enter 1,2,3,4:'
MessageLength  equ ($-Message)
      times 510-($-$$) db 0
      db 0x55,0xaa
