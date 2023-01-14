.PHONY: clean
.PHONY: elfhead
.PHONY: elfsize

include ../toolchain.mk

ASFLAGS = -march=rv32i -mabi=ilp32
LDFLAGS = --oformat=elf32-littleriscv

all: c_fastOpt.elf
	
c_fastOpt.elf: c_fastOpt.s
	$(CROSS_COMPILE)gcc $(ASFLAGS) -o c_fastOpt.elf c_fastOpt.s

c_fastOpt.s: line.c
	$(CROSS_COMPILE)gcc $(ASFLAGS) -Ofast -o c_fastOpt.s -S line.c

clean:
	$(RM) c_fastOpt.elf c_fastOpt.s line.png line

elfhead:
	$(CROSS_COMPILE)readelf -h c_fastOpt.elf
	
elfsize:
	$(CROSS_COMPILE)size c_fastOpt.elf
	
