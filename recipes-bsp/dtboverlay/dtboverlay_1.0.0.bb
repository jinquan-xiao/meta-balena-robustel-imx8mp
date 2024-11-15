# Copyright (C) 2024 Guangzhou Robustel Technologies Co., Ltd.

DESCRIPTION = "Hardware interface dtb overlay service"
  
LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

DEPENDS += "${@bb.utils.contains('DISTRO_FEATURES','systemd','','update-rc.d-native',d)}"

SRC_URI = " \
            file://dtboverlay.sh \
            file://dtboverlay.service \
"

RDEPENDS:${PN}:append = " bash base-files"

S = "${WORKDIR}"

do_install() {
        install -d ${D}${sysconfdir}/dtboverlay
        install -m 0755 ${WORKDIR}/dtboverlay.sh ${D}/${sysconfdir}/dtboverlay

        install -d ${D}${systemd_unitdir}/system
        install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants
        install -m 0644 ${WORKDIR}/dtboverlay.service ${D}/${systemd_unitdir}/system

        ln -sf ${systemd_unitdir}/system/dtboverlay.service \
                 ${D}${sysconfdir}/systemd/system/multi-user.target.wants/dtboverlay.service
}

FILES:${PN} = " \
        ${sysconfdir}/dtboverlay/*  \
        ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '${systemd_unitdir}/system/* ${sysconfdir}/systemd/system/multi-user.target.wants/*', \
		'${sysconfdir}/init.d ${sysconfdir}/rcS.d ${sysconfdir}/rc2.d ${sysconfdir}/rc3.d ${sysconfdir}/rc4.d ${sysconfdir}/rc5.d', d)} \
"
