FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

inherit resin-u-boot

SRC_URI:append = " \
	file://0001-adapts-to-robustel-eg5120-hardware-and-adds-support-.patch \
"
