FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# Note: Uncomment the following 3 lines if DDR Capacity is 8GiB
#EXTRA_OEMAKE:append:imx8mp-rbt = " \
#    CFG_DDR_SIZE=0x200000000 \
#"

