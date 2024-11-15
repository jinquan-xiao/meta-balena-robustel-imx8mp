inherit kernel-balena

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
	file://0001-adapts-to-robustel-eg5120-hardware.patch \
	file://0002-build-imx-sdma-as-a-module-instand-of-builtin.patch \
"
