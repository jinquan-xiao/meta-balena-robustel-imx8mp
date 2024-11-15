LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://Licenses/gpl-2.0.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263"

DEPENDS += "bison-native"

UBOOT_SRC ?= "git://github.com/nxp-imx/uboot-imx;protocol=https"
SRCBRANCH = "imx_v2020.04_5.4.70_2.3.0"
SRC_URI = "${UBOOT_SRC};branch=${SRCBRANCH}"
SRCREV = "e42dee801ec55bc40347cbb98f13bfb5899f0368"
UBOOT_INITIAL_ENV_DEVICE = "sd"

S = "${WORKDIR}/git"
