DESCRIPTION = "Startup NXP SD8997 WIFI and Bluetooth"

LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

DEPENDS += "${@bb.utils.contains('DISTRO_FEATURES','systemd','','update-rc.d-native',d)}"

SRC_URI = " \
	file://sd8997-wifi \
	file://sd8997-wifi.service \
	file://sd8997-bt \
	file://sd8997-bt.service \
	file://firmware/nxp/ed_mac_ctrl_V3_8997.conf \
	file://firmware/nxp/wifi_mod_para.conf \
	file://firmware/nxp/sdsd8997_combo_v4.bin \
	file://firmware/nxp/tx_power_test.bin \
	file://firmware/nxp/sdiouart8997_combo_v4.bin \
	file://firmware/nxp/README_MLAN \
	file://firmware/nxp/sd8997_bt_v4.bin \
	file://firmware/nxp/sd8997_wlan_v4.bin \
	file://firmware/nxp/txpwrlimit_cfg_8997.conf \
"

FILES:${PN} = " \ 
	${sysconfdir}/wifi/*  \
	${sysconfdir}/bluetooth/*  \
	${nonarch_base_libdir}/firmware/nxp/*  \
	${@bb.utils.contains('DISTRO_FEATURES', 'systemd', '${systemd_unitdir}/system/* ${sysconfdir}/systemd/system/multi-user.target.wants/*', \
			'${sysconfdir}/init.d ${sysconfdir}/rcS.d ${sysconfdir}/rc2.d ${sysconfdir}/rc3.d ${sysconfdir}/rc4.d ${sysconfdir}/rc5.d', d)} \
"

RDEPENDS:${PN}:append = " bluez5 base-files"

S = "${WORKDIR}"

do_install() {
	install -d ${D}${nonarch_base_libdir}/firmware/nxp
	install -m 0755 ${WORKDIR}/firmware/nxp/* ${D}${nonarch_base_libdir}/firmware/nxp/

	install -d ${D}${sysconfdir}/wifi
	install -m 0755 ${WORKDIR}/sd8997-wifi ${D}/${sysconfdir}/wifi

	install -d ${D}${sysconfdir}/bluetooth
	install -m 0755 ${WORKDIR}/sd8997-bt ${D}/${sysconfdir}/bluetooth

	if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
		install -d ${D}${systemd_unitdir}/system
		install -d ${D}${sysconfdir}/systemd/system/multi-user.target.wants
		install -m 0644 ${WORKDIR}/sd8997-wifi.service ${D}/${systemd_unitdir}/system
		install -m 0644 ${WORKDIR}/sd8997-bt.service ${D}/${systemd_unitdir}/system
 
		ln -sf ${systemd_unitdir}/system/sd8997-wifi.service \
			${D}${sysconfdir}/systemd/system/multi-user.target.wants/sd8997-wifi.service
		ln -sf ${systemd_unitdir}/system/sd8997-bt.service \
			${D}${sysconfdir}/systemd/system/multi-user.target.wants/sd8997-bt.service
	else
		install -d ${D}${sysconfdir}/init.d
		ln -s ${sysconfdir}/wifi/sd8997-wifi ${D}${sysconfdir}/init.d/sd8997-wifi
		update-rc.d -r ${D} sd8997-wifi start 5 S .

		ln -s ${sysconfdir}/bluetooth/sd8997-bt ${D}${sysconfdir}/init.d/sd8997-bt
		update-rc.d -r ${D} sd8997-bt start 99 2 3 4 5 .
	fi
}

COMPATIBLE_MACHINE = "(imx8mp-rbt)"
