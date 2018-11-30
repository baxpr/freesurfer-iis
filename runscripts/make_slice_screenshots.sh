#!/bin/bash

TMP="${SUBJECTS_DIR}"/"${SUBJECT}"/tmp
MRI="${SUBJECTS_DIR}"/"${SUBJECT}"/mri
RSCR=/opt/runscripts

cd "${TMP}"

# Create the aseg without wm or cerebral gm
mri_binarize --i "${MRI}"/aseg.mgz --o "${TMP}"/aseg.sub.mgz \
--replace 2  0 --replace 3 0 --replace 41 0 --replace 42 0

# Create the screenshots
freeview -cmd "${RSCR}"/freeview_batch_3d.txt
freeview -cmd "${RSCR}"/freeview_batch_axl.txt
freeview -cmd "${RSCR}"/freeview_batch_cor.txt
freeview -cmd "${RSCR}"/freeview_batch_sag.txt

# Trim 3d screenshots
for i in [lr]h_*.png;do convert $i -fuzz 1% -trim +repage t${i};done

# Trim top/bottom, annotate with slice numbers, add bottom border
for i in *[0-9][0-9][0-9]*.png
	do 
		convert ${i} \
		-gravity South -background white -splice 0x1 -fuzz 1% -trim +repage -chop 0x1 \
		-gravity North -background white -splice 0x1 -fuzz 1% -trim +repage -chop 0x1 \
		-background black -gravity center -resize 400x345 -extent 400x345 +repage \
		-pointsize 18 -fill yellow -gravity southeast -annotate +5+5 ${i:3:3} \
		-background white -splice 0x5 ${i}
done

# Create first page
montage -mode concatenate \
tlh_lat_aparc.png tlh_lat_pial.png tlh_lat_thick.png \
trh_lat_aparc.png trh_lat_pial.png trh_lat_thick.png \
tlh_med_aparc.png tlh_med_pial.png tlh_med_thick.png \
trh_med_aparc.png trh_med_pial.png trh_med_thick.png \
-tile 3x -quality 100 -background black -gravity center \
-trim -border 5 -bordercolor black -resize 300x first_page.png

convert first_page.png \
-background white -resize 1194x1479 \
-extent 1194x1479 -bordercolor white -border 15 \
-gravity SouthEast -background white -splice 0x15 -pointsize 16 \
-annotate +15+10 "$(date)" -gravity SouthWest -annotate +15+10 \
`cat $FREESURFER_HOME/build-stamp.txt` \
-gravity NorthWest -background white -splice 0x60 \
-pointsize 24 -annotate +15+35 \
'QA Summary - FreeSurfer recon-all' \
-pointsize 18 -gravity NorthEast -annotate +15+10 \
"${SUBJECT}" \
first_page.png

# Create montages
montage -mode concatenate \
axl193_a.png axl193_b.png \
axl189_a.png axl189_b.png \
axl185_a.png axl185_b.png \
-tile 2x -quality 100 axl_mont1.png

montage -mode concatenate \
axl181_a.png axl181_b.png \
axl177_a.png axl177_b.png \
axl173_a.png axl173_b.png \
-tile 2x -quality 100 axl_mont2.png

montage -mode concatenate \
axl169_a.png axl169_b.png \
axl165_a.png axl165_b.png \
axl161_a.png axl161_b.png \
-tile 2x -quality 100 axl_mont3.png

montage -mode concatenate \
axl157_a.png axl157_b.png \
axl153_a.png axl153_b.png \
axl149_a.png axl149_b.png \
-tile 2x -quality 100 axl_mont4.png

montage -mode concatenate \
axl145_a.png axl145_b.png \
axl141_a.png axl141_b.png \
axl137_a.png axl137_b.png \
-tile 2x -quality 100 axl_mont5.png

montage -mode concatenate \
axl133_a.png axl133_b.png \
axl129_a.png axl129_b.png \
axl125_a.png axl125_b.png \
-tile 2x -quality 100 axl_mont6.png

montage -mode concatenate \
axl121_a.png axl121_b.png \
axl117_a.png axl117_b.png \
axl113_a.png axl113_b.png \
-tile 2x -quality 100 axl_mont7.png

montage -mode concatenate \
axl109_a.png axl109_b.png \
axl105_a.png axl105_b.png \
axl101_a.png axl101_b.png \
-tile 2x -quality 100 axl_mont8.png

montage -mode concatenate \
axl097_a.png axl097_b.png \
axl093_a.png axl093_b.png \
axl089_a.png axl089_b.png \
-tile 2x -quality 100 axl_mont9.png

montage -mode concatenate \
axl085_a.png axl085_b.png \
axl081_a.png axl081_b.png \
axl077_a.png axl077_b.png \
-tile 2x -quality 100 axl_mont10.png

montage -mode concatenate \
axl073_a.png axl073_b.png \
axl069_a.png axl069_b.png \
axl065_a.png axl065_b.png \
-tile 2x -quality 100 axl_mont11.png

montage -mode concatenate \
axl061_a.png axl061_b.png \
axl057_a.png axl057_b.png \
axl053_a.png axl053_b.png \
-tile 2x -quality 100 axl_mont12.png

montage -mode concatenate \
cor205_a.png cor205_b.png \
cor201_a.png cor201_b.png \
cor197_a.png cor197_b.png \
-tile 2x -quality 100 cor_mont1.png

montage -mode concatenate \
cor193_a.png cor193_b.png \
cor189_a.png cor189_b.png \
cor185_a.png cor185_b.png \
-tile 2x -quality 100 cor_mont2.png

montage -mode concatenate \
cor181_a.png cor181_b.png \
cor177_a.png cor177_b.png \
cor173_a.png cor173_b.png \
-tile 2x -quality 100 cor_mont3.png

montage -mode concatenate \
cor169_a.png cor169_b.png \
cor165_a.png cor165_b.png \
cor161_a.png cor161_b.png \
-tile 2x -quality 100 cor_mont4.png

montage -mode concatenate \
cor157_a.png cor157_b.png \
cor153_a.png cor153_b.png \
cor149_a.png cor149_b.png \
-tile 2x -quality 100 cor_mont5.png

montage -mode concatenate \
cor145_a.png cor145_b.png \
cor141_a.png cor141_b.png \
cor137_a.png cor137_b.png \
-tile 2x -quality 100 cor_mont6.png

montage -mode concatenate \
cor133_a.png cor133_b.png \
cor129_a.png cor129_b.png \
cor125_a.png cor125_b.png \
-tile 2x -quality 100 cor_mont7.png

montage -mode concatenate \
cor121_a.png cor121_b.png \
cor117_a.png cor117_b.png \
cor113_a.png cor113_b.png \
-tile 2x -quality 100 cor_mont8.png

montage -mode concatenate \
cor109_a.png cor109_b.png \
cor105_a.png cor105_b.png \
cor101_a.png cor101_b.png \
-tile 2x -quality 100 cor_mont9.png

montage -mode concatenate \
cor097_a.png cor097_b.png \
cor093_a.png cor093_b.png \
cor089_a.png cor089_b.png \
-tile 2x -quality 100 cor_mont10.png

montage -mode concatenate \
cor085_a.png cor085_b.png \
cor081_a.png cor081_b.png \
cor077_a.png cor077_b.png \
-tile 2x -quality 100 cor_mont11.png

montage -mode concatenate \
cor073_a.png cor073_b.png \
cor069_a.png cor069_b.png \
cor065_a.png cor065_b.png \
-tile 2x -quality 100 cor_mont12.png

montage -mode concatenate \
cor061_a.png cor061_b.png \
cor057_a.png cor057_b.png \
cor053_a.png cor053_b.png \
-tile 2x -quality 100 cor_mont13.png

montage -mode concatenate \
cor049_a.png cor049_b.png \
cor045_a.png cor045_b.png \
cor041_a.png cor041_b.png \
-tile 2x -quality 100 cor_mont14.png

montage -mode concatenate \
sag193_a.png sag193_b.png \
sag189_a.png sag189_b.png \
sag185_a.png sag185_b.png \
-tile 2x -quality 100 sag_mont1.png

montage -mode concatenate \
sag181_a.png sag181_b.png \
sag177_a.png sag177_b.png \
sag173_a.png sag173_b.png \
-tile 2x -quality 100 sag_mont2.png

montage -mode concatenate \
sag169_a.png sag169_b.png \
sag165_a.png sag165_b.png \
sag161_a.png sag161_b.png \
-tile 2x -quality 100 sag_mont3.png

montage -mode concatenate \
sag157_a.png sag157_b.png \
sag153_a.png sag153_b.png \
sag149_a.png sag149_b.png \
-tile 2x -quality 100 sag_mont4.png

montage -mode concatenate \
sag145_a.png sag145_b.png \
sag141_a.png sag141_b.png \
sag137_a.png sag137_b.png \
-tile 2x -quality 100 sag_mont5.png

montage -mode concatenate \
sag133_a.png sag133_b.png \
sag129_a.png sag129_b.png \
sag125_a.png sag125_b.png \
-tile 2x -quality 100 sag_mont6.png

montage -mode concatenate \
sag121_a.png sag121_b.png \
sag117_a.png sag117_b.png \
sag113_a.png sag113_b.png \
-tile 2x -quality 100 sag_mont7.png

montage -mode concatenate \
sag109_a.png sag109_b.png \
sag105_a.png sag105_b.png \
sag101_a.png sag101_b.png \
-tile 2x -quality 100 sag_mont8.png

montage -mode concatenate \
sag097_a.png sag097_b.png \
sag093_a.png sag093_b.png \
sag089_a.png sag089_b.png \
-tile 2x -quality 100 sag_mont9.png

montage -mode concatenate \
sag085_a.png sag085_b.png \
sag081_a.png sag081_b.png \
sag077_a.png sag077_b.png \
-tile 2x -quality 100 sag_mont10.png

montage -mode concatenate \
sag073_a.png sag073_b.png \
sag069_a.png sag069_b.png \
sag065_a.png sag065_b.png \
-tile 2x -quality 100 sag_mont11.png

# Pad and annotate with assessor name
for i in *_mont*.png
	do convert ${i} -bordercolor white -border 13x1 \
	-background white -resize 1224x1554 -extent 1224x1554 -gravity NorthEast \
	-splice 0x30 -pointsize 16 -annotate +15+10 "${SUBJECT}" ${i}
done

# Concatenate into PDF
convert \
first_page.png \
axl_mont1.png axl_mont2.png axl_mont3.png axl_mont4.png axl_mont5.png \
axl_mont6.png axl_mont7.png axl_mont8.png axl_mont9.png axl_mont10.png \
axl_mont11.png axl_mont12.png \
cor_mont1.png cor_mont2.png cor_mont3.png cor_mont4.png cor_mont5.png \
cor_mont6.png cor_mont7.png cor_mont8.png cor_mont9.png cor_mont10.png \
cor_mont11.png cor_mont12.png cor_mont13.png cor_mont14.png \
sag_mont1.png sag_mont2.png sag_mont3.png sag_mont4.png sag_mont5.png \
sag_mont6.png sag_mont7.png sag_mont8.png sag_mont9.png sag_mont10.png \
sag_mont11.png \
-page letter -compress jpeg \
freesurfer_detailed.pdf

mkdir "${SUBJECTS_DIR}"/PDF_DETAIL
mv freesurfer_detailed.pdf "${SUBJECTS_DIR}"/PDF_DETAIL
