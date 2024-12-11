# Copyright (C) 2013-2016 Freescale Semiconductor
# Copyright 2017 NXP
# Copyright 2018-2020 Robustel Ltd.
# Released under the MIT license (see COPYING.MIT for the terms)

SUMMARY = "Linux kernel provided and supported by Robustel"
DESCRIPTION = "Linux kernel provided and supported by Robustel (based on the kernel provided by NXP) \
with focus on i.MX Family. It includes support for many IPs such as GPU, VPU and IPU."

require recipes-kernel/linux/linux-imx.inc
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"

FILES:${KERNEL_PACKAGE_NAME}-base += "${nonarch_base_libdir}/modules/${KERNEL_VERSION}/modules.builtin.modinfo "

DEPENDS += "lzop-native bc-native"

DEFAULT_PREFERENCE = "1"

KERNEL_SRC ?= "git://github.com/nxp-imx/linux-imx;protocol=https"

SRCBRANCH = "imx_5.4.70_2.3.0"
SRCREV = "4f2631b022d843c1f2a5d34eae2fd98927a1a6c7"
LINUX_VERSION = "5.4.70"

SRC_URI = "${KERNEL_SRC};branch=${SRCBRANCH}"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

LOCALVERSION:imx8mp-rbt = "-imx8mp"

#KBUILD_DEFCONFIG:mx8-nxp-bsp = "imx8mp_eg5120_defconfig"
KBUILD_DEFCONFIG:mx8-nxp-bsp = "imx_v8_defconfig"
KERNEL_CONFIG_COMMAND = "oe_runmake_call -C ${S} CC="${KERNEL_CC}" O=${B} olddefconfig"
# Use a verbatim copy of the defconfig from the linux-imx repo.
# IMPORTANT: This task effectively disables kernel config fragments
# since the config fragments applied in do_kernel_configme are replaced.
addtask copy_defconfig after do_kernel_configme before do_kernel_localversion
do_copy_defconfig () {
	install -d ${B}
	mkdir -p ${B}
	cp ${S}/arch/arm64/configs/imx8mp_eg5120_defconfig ${B}/.config
	cp ${S}/arch/arm64/configs/imx8mp_eg5120_defconfig ${B}/../defconfig
}

pkg_postinst:kernel-devicetree:append () {
   rm -f $D/boot/devicetree-*
}

# Re-compile dtb and dtbo at the end of do_compile using compile method within kernel-source
#   to overwrite the ones compiled with kernel-devicetree.bbclass.
do_compile:append() {
		find ${B} -name '*.dtb' -exec rm -f {} +
		find ${B} -name '*.dtbo' -exec rm -f {} +
                oe_runmake dtbs CC="${KERNEL_CC} $cc_extra " LD="${KERNEL_LD}" ${KERNEL_EXTRA_ARGS}
}

KERNEL_VERSION_SANITY_SKIP="1"
COMPATIBLE_MACHINE = "(mx8-nxp-bsp)"
