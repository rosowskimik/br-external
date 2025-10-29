ifneq ($(KERNELRELEASE),)
obj-m += lab.o
else

KDIR ?= /lib/modules/$(shell uname -r)/build

modules:
	$(MAKE) -C $(KDIR) M=$$PWD modules

modules_install:
	$(MAKE) -C $(KDIR) M=$$PWD modules_install

compile_commands.json:
	$(MAKE) -C $(KDIR) M=$$PWD compile_commands.json

clean:
	$(MAKE) -C $(KDIR) M=$$PWD clean

.PHONY: modules modules_install compile_commands.json clean

endif
