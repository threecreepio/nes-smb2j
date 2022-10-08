AS = ca65
CC = cc65
LD = ld65
AFLAGS = --listing "$@.lst" --create-dep "$@.dep" --debug-info
ifdef ANN
AFLAGS += -DANN
endif

.PHONY: clean

build: main.nes

patch.zip: patch_ann.ips patch_2j.ips README.md
	zip patch.zip patch_ann.ips patch_2j.ips README.md

patch_ann.ips:
	make clean
	ANN=1 make main.nes
	python scripts/ips.py create --output patch_ann.ips original_ann.fds main.nes

patch_2j.ips:
	make clean
	make main.nes
	python scripts/ips.py create --output patch_2j.ips original.fds main.nes

%.o: %.asm
	$(AS) $(AFLAGS) $< -o $@

main.nes: layout main.o
	$(LD) -vm --mapfile "$@.map" --dbgfile "main.dbg" -C layout main.o -o $@

clean:
	rm -f main.nes *.dep *.o *.dbg patch.zip *.deb *.map *.o.lst

include $(wildcard *.dep)
