# invoke SourceDir generated makefile for main.pe430
main.pe430: .libraries,main.pe430
.libraries,main.pe430: package/cfg/main_pe430.xdl
	$(MAKE) -f C:\ti\msp430\MSP430_Book\butled1/src/makefile.libs

clean::
	$(MAKE) -f C:\ti\msp430\MSP430_Book\butled1/src/makefile.libs clean

