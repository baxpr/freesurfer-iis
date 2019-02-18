#!/bin/sh

# Parcellation on pial surface
# Parcellation on white matter surface
# "Scaled CNR" on white matter surface


export FREESURFER_HOME=/usr/local/freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh

#export SDIR="${SUBJECTS_DIR}"/"${SUBJECT}"
export SDIR=../OUTPUTS/SUBJECT

# Get Freesurfer screenshots
CDIR=`pwd`
cd ${SDIR}
freeview -cmd ${CDIR}/page1_cmd.txt &&
cd ${CDIR}
mv ${SDIR}/*.png ${CDIR}

# Trim, change background to white, resize
for p in \
lh_lat_pial lh_med_pial rh_lat_pial rh_med_pial \
lh_lat_white lh_med_white rh_lat_white rh_med_white \
; do
	convert ${p}.png \
	-fill none -draw "color 0,0 floodfill" -background white \
	-trim -bordercolor white -border 20x20 -resize 400x400 \
	${p}.png
done
