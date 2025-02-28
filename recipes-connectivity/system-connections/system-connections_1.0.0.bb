# Copyright (C) 2024 Guangzhou Robustel Technologies Co., Ltd

DESCRIPTION = "System Connections"
  
LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

inherit deploy

SRC_URI = " \
            file://eth1.nmconnection \
            file://system-if-mac-set.sh \
            file://read-base-macaddr.c \
            file://Makefile \
"

RDEPENDS:${PN}:append = " bash base-files balena-net-config"

FILES:${PN} = " \
        ${sysconfdir}/connections/*  \
"

S = "${WORKDIR}"

do_compile() {
    ${CC} ${LDFLAGS} read-base-macaddr.c -o read-base-macaddr
}

do_install() {
    install -d ${D}${sysconfdir}/connections
    install -m 0755 ${S}/read-base-macaddr ${D}/${sysconfdir}/connections
    install -m 0755 ${S}/system-if-mac-set.sh ${D}/${sysconfdir}/connections
}

do_deploy() {
    mkdir -p "${DEPLOYDIR}/system-connections/"
    install -m 0600 "${S}/eth1.nmconnection" "${DEPLOYDIR}/system-connections/"
}
addtask deploy after do_install before do_build
