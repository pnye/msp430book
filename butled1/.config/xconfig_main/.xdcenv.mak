#
_XDCBUILDCOUNT = 
ifneq (,$(findstring path,$(_USEXDCENV_)))
override XDCPATH = C:/ti/grace_3_00_01_59/packages;C:/ti/msp430/driverlib_1_90_00_65/packages;C:/ti/msp430/driverlib_1_90_00_65;C:/ti/ccsv6/ccs_base;C:/ti/msp430/MSP430_Book/butled1/.config
override XDCROOT = c:/ti/xdctools_3_30_03_47_core
override XDCBUILDCFG = ./config.bld
endif
ifneq (,$(findstring args,$(_USEXDCENV_)))
override XDCARGS = 
override XDCTARGETS = 
endif
#
ifeq (0,1)
PKGPATH = C:/ti/grace_3_00_01_59/packages;C:/ti/msp430/driverlib_1_90_00_65/packages;C:/ti/msp430/driverlib_1_90_00_65;C:/ti/ccsv6/ccs_base;C:/ti/msp430/MSP430_Book/butled1/.config;c:/ti/xdctools_3_30_03_47_core/packages;..
HOSTOS = Windows
endif
