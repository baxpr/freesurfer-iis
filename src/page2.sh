#!/bin/sh

# Slices with surface - series of coronal, series of axial.
#
# Subcortical also.

# Create the aseg without wm or cerebral gm
mri_binarize --i "${mri_dir}"/aseg.mgz --o "${tmp_dir}"/aseg.sub.mgz \
--replace 2  0 --replace 3 0 --replace 4 0 \
--replace 41 0 --replace 42 0 --replace 43 0

cd "${tmp_dir}"

# Axial slices
for S in 080 100 120 140 160 180 ; do
    freeview \
    -viewsize 800 800 --layout 1 --zoom 1 --viewport axial \
    -v "${mri_dir}"/nu.mgz \
    -v "${tmp_dir}"/aseg.sub.mgz:visible=1:colormap=lut \
    -f "${surf_dir}"/lh.white:edgecolor=turquoise:edgethickness=1 \
    -f "${surf_dir}"/lh.pial:edgecolor=red:edgethickness=1 \
    -f "${surf_dir}"/rh.white:edgecolor=turquoise:edgethickness=1 \
    -f "${surf_dir}"/rh.pial:edgecolor=red:edgethickness=1 \
    -slice  "$S" "$S" "$S" -ss axi_"$S".png
done

# Coronal slices
for S in 050 075 100 125 150 175 ; do
    freeview \
    -viewsize 800 800 --layout 1 --zoom 1 --viewport coronal \
    -v "${mri_dir}"/nu.mgz \
    -v "${tmp_dir}"/aseg.sub.mgz:visible=1:colormap=lut \
    -f "${surf_dir}"/lh.white:edgecolor=turquoise:edgethickness=1 \
    -f "${surf_dir}"/lh.pial:edgecolor=red:edgethickness=1 \
    -f "${surf_dir}"/rh.white:edgecolor=turquoise:edgethickness=1 \
    -f "${surf_dir}"/rh.pial:edgecolor=red:edgethickness=1 \
    -slice  "$S" "$S" "$S" -ss cor_"$S".png
done

# Trim, change background to white, resize
for p in axi_*png cor_*png ; do
	convert ${p} \
	-fuzz 5% -fill none -draw "color 0,0 floodfill" -background white \
	${p}
done

# Layout
montage -mode concatenate \
axi_080.png axi_100.png axi_120.png \
axi_140.png axi_160.png axi_180.png \
cor_050.png cor_075.png cor_100.png \
cor_125.png cor_150.png cor_175.png \
-tile 3x4 -quality 100 -background white -gravity center \
-trim -border 10 -bordercolor white -resize 600x twelve.png



# Add info
# 8.5 x 11 at 144dpi is 1224 x 1584
# inside 15px border is 1194 x 1554
convert \
-size 1224x1584 xc:white \
-gravity center \( twelve.png -resize 1194x1454 \) -geometry +0+0 -composite \
-gravity NorthEast -pointsize 24 -annotate +15+10 "recon-all" \
-gravity SouthEast -pointsize 24 -annotate +15+10 "$(date)" \
-gravity SouthWest -annotate +15+10 "$(cat $FREESURFER_HOME/build-stamp.txt)" \
-gravity NorthWest -pointsize 24 -annotate +15+10 "${label_info}" \
page2.png


