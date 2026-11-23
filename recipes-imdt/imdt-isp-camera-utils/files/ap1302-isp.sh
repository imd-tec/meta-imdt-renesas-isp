#!/bin/sh
# AP1302 on CSI<port> (default 0) in raw passthrough -> CRU -> ISP (/dev/video0fr)
set -e
PORT=${1:-0}
WIDTH=1920
HEIGHT=1080
FMT=SGRBG8_1X8

for MEDIA_DEV in /dev/media*; do
	media-ctl -d ${MEDIA_DEV} -p | grep -q "^- entity .*csi2${PORT} (" && break
done
entity() { media-ctl -d ${MEDIA_DEV} -p | sed -n "s/^- entity [0-9]*: \($1\) (.*/\1/p"; }
CSI=$(entity ".*csi2${PORT}")
AP1302=$(entity "ap1302[^ ]*")
[ -n "${CSI}" ] && [ -n "${AP1302}" ] || { echo "no AP1302 on CSI${PORT}" >&2; exit 1; }

media-ctl -d ${MEDIA_DEV} -r
media-ctl -d ${MEDIA_DEV} -V "'${AP1302}':0 [fmt:${FMT}/${WIDTH}x${HEIGHT} field:none]"
media-ctl -d ${MEDIA_DEV} -V "'${CSI}':1 [fmt:${FMT}/${WIDTH}x${HEIGHT} field:none]"
media-ctl -d ${MEDIA_DEV} -l "'${CSI}':1 -> 'CRU output':0 [1]"
media-ctl -d ${MEDIA_DEV} -l "'${AP1302}':0 -> '${CSI}':0 [1]"
v4l2-ctl -d `media-ctl -d ${MEDIA_DEV} -e "CRU output"` --set-fmt-video=width=${WIDTH},height=${HEIGHT},pixelformat=GRBG
v4l2-ctl -d /dev/video0fr --set-fmt-video=width=${WIDTH},height=${HEIGHT},pixelformat=RGB3
v4l2-ctl -d /dev/video0fr --set-selection target=crop,left=0,top=0,width=${WIDTH},height=${HEIGHT}
