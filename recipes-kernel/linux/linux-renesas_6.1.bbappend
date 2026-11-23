FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# meta-rz-isp limits its recipes to rzv2h-evk
COMPATIBLE_MACHINE:imdt-v2n-sbc = "imdt-v2n-sbc"

# meta-rz-isp's 0001 does not apply to this kernel; apply it via do_patch below
# after correcting it with our fixup, ahead of the rest of the series.
SRC_URI:remove = "file://0001-Input-Video-Control-driver.patch"
SRC_URI:append = " \
    file://0001-Input-Video-Control-driver.patch;apply=no \
    file://0001-Input-Video-Control-driver.patch.fixup;apply=no \
    file://isp-imdt.cfg \
    file://0014-Add-support-for-using-the-ARM-Mali-ISP-with-the-AR13-IMDT.patch \
    file://0015-drivers-media-i2c-ar1335-Exposure-writes-were-missin-IMDT.patch \
    file://0016-media-v4l2-async-don-t-fwnode-match-subdevs-without--IMDT.patch \
    file://0017-clk-renesas-r9a09g056-add-ISP-clocks-and-resets-IMDT.patch \
    file://0018-arm64-dts-renesas-r9a09g056-add-ISP-and-match-the-RZ-IMDT.patch \
    file://0019-media-rzv2h-isp-run-without-a-sensor-subdev-IMDT.patch \
    file://0020-arm64-dts-renesas-add-an-IMDT-V2-SBC-ISP-overlay-for-IMDT.patch \
"

do_patch:prepend() {
    patch --fuzz=0 -o ${WORKDIR}/0001-Input-Video-Control-driver-fixed.patch \
        ${WORKDIR}/0001-Input-Video-Control-driver.patch \
        ${WORKDIR}/0001-Input-Video-Control-driver.patch.fixup
    git -C ${S} apply --index --whitespace=nowarn ${WORKDIR}/0001-Input-Video-Control-driver-fixed.patch
    git -C ${S} -c user.name="${PATCH_GIT_USER_NAME}" -c user.email="${PATCH_GIT_USER_EMAIL}" \
        commit -q -m "Input Video Control driver (meta-rz-isp 0001 with IMDT fixup)"
}

# Add device tree overlays for IMDT V2 SBC with ISP
KERNEL_DEVICETREE:append:imdt-v2h-sbc = " \
    renesas/imdt-v2-sbc-ar1335-csi2-isp.dtbo \
    renesas/imdt-v2-sbc-ar1335-csi3-isp.dtbo \
    renesas/imdt-v2-sbc-ar1335-dual-isp.dtbo \
    renesas/imdt-v2-sbc-ap1302-csi0-isp.dtbo \
"

KERNEL_DEVICETREE:append:imdt-v2n-sbc = " \
    renesas/imdt-v2-sbc-ap1302-csi0-isp.dtbo \
"
