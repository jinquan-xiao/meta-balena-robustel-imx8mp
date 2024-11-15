FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# Refer to NXP's Yocto Projetct imx_5.4.70_2.3.0
SRC_URI:mx8-nxp-bsp = "${ATF_SRC};branch=${SRCBRANCH}"
ATF_SRC:mx8-nxp-bsp = "git://github.com/nxp-imx/imx-atf.git;protocol=https"
SRCBRANCH:mx8-nxp-bsp = "imx_5.4.70_2.3.0"
SRCREV:mx8-nxp-bsp = "15e8ff164a8becfddb76cba2c68eeeae684cb398"

#Note: Uncomment the following 3 lines if needed
#EXTRA_OEMAKE:append:imx8mp-rbt = " \
#    BL32_BASE=${TEE_LOAD_ADDR} \
#"
#
