FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
	file://robustel-blacklist.conf \
"

SRC_URI:append:imx8mp-rbt = " \
	file://robustel-hdmi-audio.conf \
"

do_install:append() {
	install -m 0755 -d ${D}${sysconfdir}/modprobe.d
	install -m 0644 ${WORKDIR}/robustel-blacklist.conf ${D}${sysconfdir}/modprobe.d
}

#do_install:append:imx8mp-rbt() {
#	install -m 0644 ${WORKDIR}/robustel-hdmi-audio.conf ${D}${sysconfdir}/modprobe.d
#}
