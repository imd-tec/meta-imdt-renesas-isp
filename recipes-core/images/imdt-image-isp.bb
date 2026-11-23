require recipes-core/images/imdt-image-weston.bb
# Packages added for the ISP image
IMAGE_INSTALL:append = " \
    v2h-isp-scripts \
    gdb \
    mali-isp-service \
    imdt-isp-camera-utils \
"