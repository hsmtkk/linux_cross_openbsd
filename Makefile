default: hello.linux.bin

hello.linux.bin: hello.linux.o
	gcc -o hello.linux.bin hello.linux.o

hello.linux.o: hello.c
	gcc -c -o hello.linux.o -Wall hello.c

clean:
	rm -f *.bin *.o
