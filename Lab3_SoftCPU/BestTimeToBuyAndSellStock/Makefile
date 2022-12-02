
include ../common/Makefile.common

EXE      = .elf
SRC      = BestTimeToBuyAndSellStock.c
ASM	 = .s
CFLAGS  += -L../common
LDFLAGS += -T ../common/default.ld
TARGET   = BestTimeToBuyAndSellStock
MID	 = $(TARGET)$(ASM)
OUTPUT   = $(TARGET)$(EXE)

.PHONY: all clean

all: $(TARGET)

$(MID): $(SRC)
	$(CC) $(CFLAGS) -o $(MID) -S $(SRC) $(LDFLAGS)
	
$(TARGET): $(MID)
	$(CC) $(CFLAGS) -o $(OUTPUT) $(MID) $(LDFLAGS)
	$(OBJCOPY) -j .text -O binary $(OUTPUT) imem.bin
	$(OBJCOPY) -j .data -O binary $(OUTPUT) dmem.bin
	$(OBJCOPY) -O binary $(OUTPUT) memory.bin
	$(OBJDUMP) -d $(OUTPUT) > $(TARGET).dis
	$(READELF) -a $(OUTPUT) > $(TARGET).symbol

clean:
	$(RM) *.s *.o $(OUTPUT) $(TARGET).dis $(TARGET).symbol [id]mem.bin memory.bin
