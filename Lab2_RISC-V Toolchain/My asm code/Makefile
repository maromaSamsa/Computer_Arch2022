.PHONY: clean
.PHONY: elfhead
.PHONY: elfsize

include ../toolchain.mk

ASFLAGS = -march=rv32i -mabi=ilp32
LDFLAGS = --oformat=elf32-littleriscv

all: my_asm.elf

my_asm.elf: my_asm.s
	$(CROSS_COMPILE)gcc $(ASFLAGS) -o my_asm.elf my_asm.s
	
clean:
	$(RM) my_asm.elf

elfhead:
	$(CROSS_COMPILE)readelf -h my_asm.elf
	
elfsize:
	$(CROSS_COMPILE)size my_asm.elf
