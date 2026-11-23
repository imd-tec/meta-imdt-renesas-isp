#echo "file drivers/media/platform/rzv2h-ivc* +p" > /sys/kernel/debug/dynamic_debug/control
#echo "file drivers/media/platform/rzg2l-cru* +p" > /sys/kernel/debug/dynamic_debug/control
#echo "file drivers/media/platform/rzg2l-dma* +p" > /sys/kernel/debug/dynamic_debug/control
#echo "file drivers/media/platform/rzv2h-isp* +p" > /sys/kernel/debug/dynamic_debug/control
set -e
WIDTH=1920
HEIGHT=1080
FMT=SGRBG10_1X10
MEDIA_DEV=/dev/media2
INSTANCE_NAME=16020400.csi22
AR1335=ar1335.6-0036

media-ctl -d ${MEDIA_DEV} -r
media-ctl -d ${MEDIA_DEV} -V "'rzg2l_csi2 ${INSTANCE_NAME}':1 [fmt:${FMT}/${WIDTH}x${HEIGHT} field:none colorspace:srgb]"
media-ctl -d ${MEDIA_DEV} -V "'${AR1335}':0 [fmt:${FMT}/${WIDTH}x${HEIGHT} field:none colorspace:srgb]"
media-ctl -d ${MEDIA_DEV} -l "'rzg2l_csi2 ${INSTANCE_NAME}':1 -> 'CRU output':0 [1]"
media-ctl -d ${MEDIA_DEV} -l "'${AR1335}':0 -> 'rzg2l_csi2 ${INSTANCE_NAME}':0 [1]"
v4l2-ctl -d `media-ctl -d ${MEDIA_DEV} -e "CRU output"` --set-fmt-video=width=${WIDTH},height=${HEIGHT},pixelformat=BA10
v4l2-ctl -d /dev/video0fr --set-fmt-video=width=${WIDTH},height=${HEIGHT},pixelformat=RGB3
v4l2-ctl -d /dev/video0fr --set-selection target=crop,left=0,top=0,width=${WIDTH},height=${HEIGHT}
