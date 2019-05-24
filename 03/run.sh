nasm p1.asm
nasm p2.asm
nasm p3.asm
nasm p4.asm
nasm boot.asm
dd if=p1 of=b.flp conv=notrunc count=1 bs=512 seek=1
dd if=p2 of=b.flp conv=notrunc count=1 bs=512 seek=2
dd if=p3 of=b.flp conv=notrunc count=1 bs=512 seek=3
dd if=p4 of=b.flp conv=notrunc count=1 bs=512 seek=4
dd if=boot of=b.flp conv=notrunc count=1 bs=512 seek=0
dd if=myos.exe of=b.flp conv=notrunc count=4 bs=512 seek=5 skip=113
