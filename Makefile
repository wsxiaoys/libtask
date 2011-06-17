LIB=libtask.a
IPHONE_LIB = libtask-iphone.a
TCPLIBS=

ASM=asm.o
OFILES=\
	$(ASM)\
	channel.o\
	context.o\
	fd.o\
	net.o\
	print.o\
	qlock.o\
	rendez.o\
	task.o\

all: $(LIB) primes tcpproxy testdelay

$(OFILES): taskimpl.h task.h 386-ucontext.h power-ucontext.h arm-ucontext.h

AS=gcc -c
CC=gcc
CFLAGS=-Wall -c -I. -ggdb

%.o: %.S
	$(AS) $*.S

%.o: %.c
	$(CC) $(CFLAGS) $*.c

$(LIB): $(OFILES)
	ar rvc $(LIB) $(OFILES)

primes: primes.o $(LIB)
	$(CC) -o primes primes.o $(LIB)

tcpproxy: tcpproxy.o $(LIB)
	$(CC) -o tcpproxy tcpproxy.o $(LIB) $(TCPLIBS)

httpload: httpload.o $(LIB)
	$(CC) -o httpload httpload.o $(LIB)

testdelay: testdelay.o $(LIB)
	$(CC) -o testdelay testdelay.o $(LIB)

testdelay1: testdelay1.o $(LIB)
	$(CC) -o testdelay1 testdelay1.o $(LIB)

clean:
	rm -f *.o primes tcpproxy testdelay testdelay1 httpload $(LIB) $(IPHONE_LIB)
	rm -rf build

install: $(LIB)
	cp $(LIB) /usr/local/lib
	cp task.h /usr/local/include

iphone:
	xcodebuild -project task.xcodeproj -sdk iphoneos -configuration Release
	xcodebuild -project task.xcodeproj -sdk iphonesimulator -configuration Debug
	lipo build/Debug-iphonesimulator/libtask.a build/Release-iphoneos/libtask.a -create -output $(IPHONE_LIB)

