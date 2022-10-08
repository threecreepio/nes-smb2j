AS = ca65
CC = cc65
LD = ld65

.PHONY: clean

build: main.nes

%.o: %.asm
	$(AS) --listing "$@.lst" --create-dep "$@.dep" --debug-info $< -o $@

main.nes: layout main.o
	$(LD) -vm --mapfile "$@.map" --dbgfile "main.dbg" -C layout main.o -o $@

clean:
	rm -f main.nes *.dep *.o *.dbg

include $(wildcard *.dep)
