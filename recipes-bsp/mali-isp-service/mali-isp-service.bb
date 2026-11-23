SUMMARY = "Mali ISP service for Renesas platforms"
LICENSE = "CLOSED"

SRC_URI = " \
    file://mali-isp-single.service \
    file://mali-isp-dual.service \
"

inherit systemd

# Define the service name for the systemd class
SYSTEMD_SERVICE:${PN} = "mali-isp-single.service mali-isp-dual.service"
SYSTEMD_AUTO_ENABLE:${PN} = "disable"
do_install() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/mali-isp-single.service ${D}${systemd_system_unitdir}/mali-isp-single.service
    install -m 0644 ${WORKDIR}/mali-isp-dual.service ${D}${systemd_system_unitdir}/mali-isp-dual.service

}
