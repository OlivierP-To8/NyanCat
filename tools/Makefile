TOOLS = c6809 bmp snd6bitTO snd6bitMO k7mofs fdfs fdtosd fdtohfe

.PHONY: all clean

all: $(TOOLS)

clean:
	-rm -f $(TOOLS)

c6809:
	gcc -o $@ $@.c

bmp:
	gcc -o $@ $@.c

snd6bitTO:
	gcc -o $@ $@.c -lm

snd6bitMO:
	gcc -o $@ $@.c -lm

k7mofs:
	gcc -o $@ $@.c

fdfs:
	gcc -o $@ $@.c

fdtosd:
	gcc -o $@ $@.c

fdtohfe:
	gcc -o $@ $@.c
