.PHONY: clean
.PHONY: elfhead
.PHONY: elfsize

include ../toolchain.mk

ASFLAGS = -march=rv32i -mabi=ilp32
LDFLAGS = --oformat=elf32-littleriscv

all: output.elf

output.elf: BestTimeToBuyAndSellStock.s
	$(CROSS_COMPILE)gcc $(ASFLAGS) -o output.elf BestTimeToBuyAndSellStock.s
	
clean:
	$(RM) output.elf

elfhead:
	$(CROSS_COMPILE)readelf -h output.elf
	
elfsize:
	$(CROSS_COMPILE)size output.elf