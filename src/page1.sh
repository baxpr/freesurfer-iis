#!/bin/sh

# Parcellation on pial surface
# Parcellation on white matter surface
# "Scaled CNR" on white matter surface


# Script location
RSCR=/opt/src

# Working directory
TMP="${SUBJECTS_DIR}"/"${SUBJECT}"/tmp

# Get Freesurfer screenshots
cd "${SUBJECTS_DIR}"/"${SUBJECT}"
freeview -cmd ${RSCR}/page1_cmd.txt
mv *.png ${TMP}
cd ${TMP}

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

# Get CNR
mri_cnr "${SUBJECTS_DIR}"/"${SUBJECT}"/surf \
"${SUBJECTS_DIR}"/"${SUBJECT}"/mri/T1.mgz \
| tr -d '\t' > t1_cnr.txt
CNRTXT=`cat t1_cnr.txt`

# Make montage
montage -mode concatenate \
lh_lat_pial.png lh_med_pial.png rh_lat_pial.png rh_med_pial.png \
lh_lat_white.png lh_med_white.png rh_lat_white.png rh_med_white.png \
-tile 2x -quality 100 -background white -gravity center \
-trim -border 20 -bordercolor white -resize 600x eight.png

# Add info
# 8.5 x 11 at 144dpi is 1224 x 1584
# inside 15px border is 1194 x 1554
convert \
-size 1224x1584 xc:white \
-gravity South \( eight.png -resize 1194x1354 \) -geometry +0+60 -composite \
-gravity NorthEast -pointsize 24 -annotate +15+10 "${CNRTXT}" \
-gravity SouthEast -pointsize 24 -annotate +15+10 "$(date)" \
-gravity SouthWest -annotate +15+10 `cat $FREESURFER_HOME/build-stamp.txt` \
-gravity NorthWest -pointsize 24 -annotate +15+10 "${SUBJECT}" \
page1.png

