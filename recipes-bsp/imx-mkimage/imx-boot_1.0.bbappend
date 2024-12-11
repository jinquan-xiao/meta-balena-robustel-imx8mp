# Copyright (C) 2017-2020 NXP
# Copyright (C) 2024 Robustel LTD

do_compile() {
    echo "Copying DTBs"
    if [ "mx8m" = "${SOC_FAMILY}" ]; then
        cp ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/${UBOOT_DTB_NAME} ${BOOT_STAGING}

        for UBOOT_DTB_EXTRA_FILE in ${UBOOT_DTB_EXTRA}; do
            cp ${DEPLOY_DIR_IMAGE}/${BOOT_TOOLS}/${UBOOT_DTB_EXTRA_FILE} ${BOOT_STAGING}
        done
    fi

    # mkimage for i.MX8
    # Copy TEE binary to SoC target folder to mkimage
    if ${DEPLOY_OPTEE}; then
        cp ${DEPLOY_DIR_IMAGE}/tee.bin ${BOOT_STAGING}
    fi
    for target in ${IMXBOOT_TARGETS}; do
        UBOOT_CONFIG_EXTRA="${UBOOT_CONFIG}"
        UBOOT_DTB_NAME_EXTRA="imx8mp-evk.dtb"
        UBOOT_NAME_EXTRA="u-boot.bin"
        compile_${SOC_FAMILY}
        unset UBOOT_DTB_NAME_EXTRA
        unset UBOOT_NAME_EXTRA
        if [ "$target" = "flash_linux_m4_no_v2x" ]; then
           # Special target build for i.MX 8DXL with V2X off
           bbnote "building ${IMX_BOOT_SOC_TARGET} - ${REV_OPTION} V2X=NO ${target}"
           make SOC=${IMX_BOOT_SOC_TARGET} ${REV_OPTION} V2X=NO \
                dtbs="${UBOOT_DTB_NAME} ${UBOOT_DTB_EXTRA}" \
                flash_linux_m4
        else
           bbnote "building ${IMX_BOOT_SOC_TARGET} - ${REV_OPTION} ${target}"
           make SOC=${IMX_BOOT_SOC_TARGET} ${REV_OPTION} \
                dtbs="${UBOOT_DTB_NAME} ${UBOOT_DTB_EXTRA}" \
                ${target}
        fi
        if [ -e "${BOOT_STAGING}/flash.bin" ]; then
            BOOT_CONFIG_MACHINE="${BOOT_NAME}-${MACHINE}-${UBOOT_CONFIG_EXTRA}.bin"
            cp ${BOOT_STAGING}/flash.bin ${S}/${BOOT_CONFIG_MACHINE}-${target}
            unset BOOT_CONFIG_MACHINE
        fi
        unset UBOOT_CONFIG_EXTRA
    done
}
