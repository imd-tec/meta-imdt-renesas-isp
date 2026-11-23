#
# Copyright (c) 2024 IMD Technologies
#

DESCRIPTION = "Utilities for controlling and configuring the ISP cameras"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

PV = "1.0.0"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI = " \
    file://ar1335-csi2-isp.sh \
    file://ar1335-csi3-isp.sh \
    file://ap1302-isp.sh \
"

S = "${WORKDIR}"

do_install() {
    install -d ${D}/opt/imdt/isp/
    install -m 0755 ${WORKDIR}/ar1335-csi2-isp.sh ${D}/opt/imdt/isp/
    install -m 0755 ${WORKDIR}/ar1335-csi3-isp.sh ${D}/opt/imdt/isp/
    install -m 0755 ${WORKDIR}/ap1302-isp.sh ${D}/opt/imdt/isp/
}

FILES:${PN} += " \
    /opt/imdt/isp/* \
"

RDEPENDS:${PN} += "bash v2h-isp-driver"