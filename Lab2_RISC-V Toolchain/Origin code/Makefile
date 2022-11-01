.PHONY: clean
.PHONY: elfhead
.PHONY: elfsize

include ../toolchain.mk

ASFLAGS = -march=rv32i -mabi=ilp32
LDFLAGS = --oformat=elf32-littleriscv

all: org_asm.elf c_fastOpt.elf

org_asm.elf: BestTimeToBuyAndSellStock.s
	$(CROSS_COMPILE)gcc $(ASFLAGS) -o org_asm.elf BestTimeToBuyAndSellStock.s
	
c_fastOpt.elf: c_fastOpt.s
	$(CROSS_COMPILE)gcc $(ASFLAGS) -o c_fastOpt.elf c_fastOpt.s

c_fastOpt.s: BestTimeToBuyAndSellStock.c
	$(CROSS_COMPILE)gcc $(ASFLAGS) -Ofast -o c_fastOpt.s -S BestTimeToBuyAndSellStock.c

clean:
	$(RM) org_asm.elf c_fastOpt.elf c_fastOpt.s

elfhead:
	$(CROSS_COMPILE)readelf -h c_fastOpt.elf
	$(CROSS_COMPILE)readelf -h org_asm.elf
elfsize:
	$(CROSS_COMPILE)size c_fastOpt.elf
	$(CROSS_COMPILE)size org_asm.elf
