#
_XDCBUILDCOUNT = 
ifneq (,$(findstring path,$(_USEXDCENV_)))
override XDCPATH = C:/ti/grace_3_00_01_59/packages;C:/ti/msp430/MSP430ware_1_95_00_32/driverlib/packages;C:/ti/msp430/MSP430ware_1_95_00_32/driverlib;C:/ti/ccsv6/ccs_base;C:/ti/msp430/MSP430_Book/gracetrial/.config
override XDCROOT = c:/ti/xdctools_3_30_05_60_core
override XDCBUILDCFG = ./config.bld
endif
ifneq (,$(findstring args,$(_USEXDCENV_)))
override XDCARGS = 
override XDCTARGETS = 
endif
#
ifeq (0,1)
PKGPATH = C:/ti/grace_3_00_01_59/packages;C:/ti/msp430/MSP430ware_1_95_00_32/driverlib/packages;C:/ti/msp430/MSP430ware_1_95_00_32/driverlib;C:/ti/ccsv6/ccs_base;C:/ti/msp430/MSP430_Book/gracetrial/.config;c:/ti/xdctools_3_30_05_60_core/packages;..
HOSTOS = Windows
endif
