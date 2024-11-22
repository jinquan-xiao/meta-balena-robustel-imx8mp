# Copyright (C) 2024 Guangzhou Robustel Technologies Co., Ltd

DESCRIPTION = "Modem Control"
  
LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

DEPENDS += "${@bb.utils.contains('DISTRO_FEATURES','systemd','','update-rc.d-native',d)}"

SRC_URI = " \
            file://modem_init.sh \
            file://modem_init.service \
            file://ledctrl.sh \
            file://ledctrl.service \
            file://ledctrl.timer \
"

RDEPENDS:${PN}:append = " bash base-files"

S = "${WORKDIR}"

do_install() {
        install -d ${D}${sysconfdir}/modem
        install -m 0755 ${S}/modem_init.sh ${D}/${sysconfdir}/modem
        install -m 0755 ${S}/ledctrl.sh ${D}/${sysconfdir}/modem

        install -d ${D}${systemd_unitdir}/system
        install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants
        install -m 0644 ${S}/modem_init.service ${D}/${systemd_unitdir}/system
        install -m 0644 ${S}/ledctrl.service ${D}/${systemd_unitdir}/system 
        install -m 0644 ${S}/ledctrl.timer ${D}/${systemd_unitdir}/system

        ln -sf ${systemd_unitdir}/system/modem_init.service \
                 ${D}${sysconfdir}/systemd/system/multi-user.target.wants/modem_init.service
        ln -sf ${systemd_unitdir}/system/ledctrl.service \
                 ${D}${sysconfdir}/systemd/system/multi-user.target.wants/ledctrl.service
        ln -sf ${systemd_unitdir}/system/ledctrl.timer \
                 ${D}${sysconfdir}/systemd/system/multi-user.target.wants/ledctrl.timer
}

INSANE_SKIP_${PN} = "ldflags"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"

FILES:${PN} = " \
        ${sysconfdir}/modem/*  \
        ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '${systemd_unitdir}/system/* ${sysconfdir}/systemd/system/multi-user.target.wants/*', \
        '${sysconfdir}/init.d ${sysconfdir}/rcS.d ${sysconfdir}/rc2.d ${sysconfdir}/rc3.d ${sysconfdir}/rc4.d ${sysconfdir}/rc5.d', d)} \
"
