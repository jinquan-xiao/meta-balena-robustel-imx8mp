# Copyright (C) 2024 Guangzhou Robustel Technologies Co., Ltd

DESCRIPTION = "System Connections"
  
LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

DEPENDS += "${@bb.utils.contains('DISTRO_FEATURES','systemd','','update-rc.d-native',d)}"

SRC_URI = " \
            file://eth1.conf \
            file://system-connections-init.service \
            file://system-connections-init.sh \
            file://system-if-mac-set.sh \
            file://read-base-macaddr.c \
            file://Makefile \
"

RDEPENDS:${PN}:append = " bash base-files"

S = "${WORKDIR}"

do_compile() {
    ${CC} ${LDFLAGS} read-base-macaddr.c -o read-base-macaddr
}

do_install() {
        install -d ${D}${sysconfdir}/NetworkManager
        install -d ${D}${sysconfdir}/NetworkManager/dnsmasq-shared.d
        install -m 0600 ${S}/eth1.conf ${D}${sysconfdir}/NetworkManager/dnsmasq-shared.d

        install -d ${D}${sysconfdir}/connections
        install -m 0755 ${S}/read-base-macaddr ${D}/${sysconfdir}/connections
        install -m 0755 ${S}/system-connections-init.sh ${D}/${sysconfdir}/connections
        install -m 0755 ${S}/system-if-mac-set.sh ${D}/${sysconfdir}/connections

        install -d ${D}${systemd_unitdir}/system
        install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants
        install -m 0644 ${S}/system-connections-init.service ${D}/${systemd_unitdir}/system

        ln -sf ${systemd_unitdir}/system/system-connections-init.service \
                 ${D}${sysconfdir}/systemd/system/multi-user.target.wants/system-connections-init.service
}

FILES:${PN} = " \
        ${sysconfdir}/NetworkManager/dnsmasq-shared.d/eth1.conf  \
        ${sysconfdir}/connections/*  \
        ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '${systemd_unitdir}/system/* ${sysconfdir}/systemd/system/multi-user.target.wants/*', \
        '${sysconfdir}/init.d ${sysconfdir}/rcS.d ${sysconfdir}/rc2.d ${sysconfdir}/rc3.d ${sysconfdir}/rc4.d ${sysconfdir}/rc5.d', d)} \
"
