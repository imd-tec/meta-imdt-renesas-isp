# meta-rz-isp limits this recipe to rzv2h-evk
COMPATIBLE_MACHINE:imdt-v2n-sbc = "imdt-v2n-sbc"

# The binaries ask for /lib64/ld-linux-aarch64.so.1; the loader lives in ${base_libdir}
do_install:append() {
    install -d ${D}/lib64
    ln -sf ${base_libdir}/ld-linux-aarch64.so.1 ${D}/lib64/ld-linux-aarch64.so.1
}
FILES:${PN} += "/lib64"
INSANE_SKIP:${PN} += "libdir"
