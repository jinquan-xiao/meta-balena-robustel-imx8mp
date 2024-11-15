# remove recovery module because otherwise the initramfs grows beyond 32 MB
PACKAGE_INSTALL:remove = " initramfs-module-recovery"
