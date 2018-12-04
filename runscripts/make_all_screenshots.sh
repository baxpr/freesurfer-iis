#!/bin/bash

TMP="${SUBJECTS_DIR}"/"${SUBJECT}"/tmp

RSCR=/opt/runscripts

###############################################################################
# Screenshots

# Whole brain
"${RSCR}"/screenshot.sh brain_axi axial
"${RSCR}"/screenshot.sh brain_sag sagittal
"${RSCR}"/screenshot.sh brain_cor coronal

# Screenshots for ROIs
"${RSCR}"/screenshot_thal.sh
"${RSCR}"/screenshot_hipp.sh
"${RSCR}"/screenshot_brainstem.sh


###############################################################################
# Stitch together to make PDF
cd "${TMP}"

# Page 1, whole brain
montage -mode concatenate \
brain_axi.png brain_cor.png brain_sag.png \
-tile 2x -quality 100 -background black -gravity center \
-trim -border 10 -bordercolor black -resize 300x page1.png

convert page1.png \
-background white -resize 1194x1479 -extent 1194x1479 -bordercolor white \
-border 15 -gravity SouthEast -background white -splice 0x15 -pointsize 24 \
-annotate +15+10 "$(date)" \
-gravity SouthWest -annotate +15+10 \
`cat $FREESURFER_HOME/build-stamp.txt` \
-gravity NorthWest -background white -splice 0x60 -pointsize 24 -annotate +15+10 \
'FreeSurfer recon-all' \
-gravity NorthEast -pointsize 24 -annotate +15+10 \
"${SUBJECT}" \
page1.png

# Page 2 thalamus
montage -mode concatenate \
Lthal_sag.png Rthal_sag.png thal_axi.png thal_cor.png \
-tile 2x -quality 100 -background black -gravity center \
-trim -border 10 -bordercolor black -resize 300x page2.png

convert page2.png \
-background white -resize 1194x1479 -extent 1194x1479 -bordercolor white \
-border 15 -gravity SouthEast -background white -splice 0x15 -pointsize 24 \
-annotate +15+10 "$(date)" \
-gravity SouthWest -annotate +15+10 \
`cat $FREESURFER_HOME/build-stamp.txt` \
-gravity NorthWest -background white -splice 0x60 -pointsize 24 -annotate +15+10 \
'FreeSurfer segmentThalamicNuclei.sh' \
-gravity NorthEast -pointsize 24 -annotate +15+10 \
"${SUBJECT}" \
page2.png

# Page 3 hippocampus and brainstem
montage -mode concatenate \
Lhipp_sag.png Rhipp_sag.png brainstem_sag.png brainstem_cor.png \
-tile 2x -quality 100 -background black -gravity center \
-trim -border 10 -bordercolor black -resize 300x page3.png

convert page3.png \
-background white -resize 1194x1479 -extent 1194x1479 -bordercolor white \
-border 15 -gravity SouthEast -background white -splice 0x15 -pointsize 24 \
-annotate +15+10 "$(date)" \
-gravity SouthWest -annotate +15+10 \
`cat $FREESURFER_HOME/build-stamp.txt` \
-gravity NorthWest -background white -splice 0x60 -pointsize 24 -annotate +15+0 \
'FreeSurfer segmentBS.sh' \
-gravity NorthWest -background white -splice 0x60 -pointsize 24 -annotate +15+10 \
'FreeSurfer segmentHA_T1.sh' \
-gravity NorthEast -pointsize 24 -annotate +15+10 \
"${SUBJECT}" \
page3.png

# Final PDF
mkdir "${SUBJECTS_DIR}"/PDF
convert page1.png page2.png page3.png -page letter \
    "${SUBJECTS_DIR}"/PDF/freesurfer_report.pdf
