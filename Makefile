CC=gcc
CFLAGS=-DLINUX -m32 -O3 -Wall -DLE_ARCH
LDFLAGS=-m32 -lpng -lz -Llib/
OBJS=avs2bdnxml.o auto_split.o palletize.o sup.o sort.o ass.o
ASMOBJS=frame-a.o
EXE=avs2bdnxml

%.o: %.c
	$(CC) -c $< $(CFLAGS)

$(EXE): $(OBJS) $(ASMOBJS)
	$(CC) -o $(EXE) $(OBJS) $(ASMOBJS) $(LDFLAGS)

all: $(EXE)

$(ASMOBJS): $(ASMOBJS:%.o=%.asm)
    yasm -f macho32 -m x86 -DARCH_X86_64=0 -DPREFIX=1 $< -o $(<:%.asm=%.o)

dist: clean all
	strip -s $(EXE)
	upx-ucl --best $(EXE)
	rm -f $(OBJS) $(ASMOBJS)

.phony clean:
	rm -f $(EXE) $(OBJS) $(ASMOBJS)

