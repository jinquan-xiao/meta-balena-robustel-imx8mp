# Copyright (C) 2024 Guangzhou Robustel Technologies Co., Ltd

DESCRIPTION = "Udev Rules"
  
LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = " \
            file://99-tty.rules \
"

RDEPENDS:${PN}:append = "base-files"

S = "${WORKDIR}"

do_install() {
        install -d ${D}${base_libdir}/udev
        install -d ${D}${base_libdir}/udev/rules.d
        install -m 0644 ${S}/99-tty.rules ${D}${base_libdir}/udev/rules.d
}

INSANE_SKIP_${PN} = "ldflags"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"

FILES:${PN} = " \
        ${base_libdir}/udev/rules.d/99-tty.rules  \
"
