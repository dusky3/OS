#assemble boot.s file
as --32 boot.s -o boot.o
as --32 load_gdt.s -o load_gdt.o
as --32 load_idt.s -o load_idt.o

#compile kernel.c file
gcc -m32 -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

#compile util.c file
gcc -m32 -c util.c -o util.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

#compile gdt.c file
gcc -m32 -c gdt.c -o gdt.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

#compile idt.c file
gcc -m32 -c idt.c -o idt.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

#compile isr.c file
gcc -m32 -c isr.c -o isr.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

#linking the kernel with kernel.o and boot.o files
ld -m elf_i386 -T linker.ld kernel.o util.o boot.o gdt.o load_gdt.o load_idt.o idt.o isr.o -o MyOS.bin -nostdlib

#check MyOS.bin file is x86 multiboot file or not
grub-file --is-x86-multiboot MyOS.bin

#building the iso file
mkdir -p isodir/boot/grub
cp MyOS.bin isodir/boot/MyOS.bin
cp grub.cfg isodir/boot/grub/grub.cfg
grub-mkrescue -o MyOS.iso isodir

#run it in qemu
qemu-system-x86_64 -cdrom MyOS.iso