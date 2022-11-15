.PHONY: clean
.PHONY: elfhead
.PHONY: elfsize

include toolchain.mk

ASFLAGS = -march=rv32i -mabi=ilp32
LDFLAGS = --oformat=elf32-littleriscv

all: MSE.elf

MSE.elf: MSE.s
	$(CROSS_COMPILE)gcc $(ASFLAGS) -o MSE.elf MSE.s

clean:
	$(RM) MSE.elf


