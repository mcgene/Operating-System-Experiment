del myos.obj
del .obj
del myos.exe
tasm myos.asm
tcc -mt -c -o my_os_c.c
tlink /3 myos.obj .obj, myos,,