#!/bin/bash

cd "${tmp_dir}"

# Create the aseg without wm or cerebral gm
mri_binarize --i "${mri_dir}"/aseg.mgz --o aseg.sub.mgz \
--replace 2  0 --replace 3 0 --replace 41 0 --replace 42 0

# 3D screenshots
freeview -cmd "${src_dir}"/freeview_batch_3d.txt

# Get brain mask extents
mri_convert "${mri_dir}"/brainmask.mgz brainmask.nii.gz
extents=$(compute_extents.py brainmask.nii.gz)
extents=(${extents// / })
xmin=$((${extents[0]} + 4))
xmax=$((${extents[1]} - 4))
ymin=$((${extents[2]} + 4))
ymax=$((${extents[3]} - 4))
zmin=$((${extents[4]} + 4))
zmax=$((${extents[5]} - 4))

# And center of mass
com=$(fslstats brainmask.nii.gz -c)
com=(${com// / })
comx=$(printf "%.0f" ${com[0]})
comy=$(printf "%.0f" ${com[1]})
comz=$(printf "%.0f" ${com[2]})

# Slice by slice (4mm gap). Even numbered image files are with no overlay, 
# odd with, so we get correct sorting later
function slice {
    local viewport=$1
    local smin=$2
    local smax=$3
    img=0
    for s in $(seq $smin 4 $smax); do
        if [[ "$viewport" == "x" ]]; then local ras="$s $comy $comz"
        elif [[ "$viewport" == "y" ]]; then local ras="$comx $s $comz"
        elif [[ "$viewport" == "z" ]]; then local ras="$comx $comy $s"
        fi
        f1=${viewport}_$(printf "%03d" $img).png
        f2=${viewport}_$(printf "%03d" $((${img}+1))).png
        freeview -v ${mri_dir}/nu.mgz:visible=1:grayscale=0,165 \
            -viewsize 400 400 --layout 1 --zoom 1.15 --viewport ${viewport} \
            -ras $ras -ss ${f1}
        convert ${f1} -pointsize 18 -fill white -annotate +10+20 "${viewport} = ${s} mm" ${f1}
        freeview -v ${mri_dir}/nu.mgz:visible=1:grayscale=0,165 \
            -viewsize 400 400 --layout 1 --zoom 1.15 --viewport ${viewport} \
            -v aseg.sub.mgz:visible=1:colormap=lut \
            -f ${surf_dir}/lh.white:edgecolor=turquoise:edgethickness=1 \
            -f ${surf_dir}/lh.pial:edgecolor=red:edgethickness=1 \
            -f ${surf_dir}/rh.white:edgecolor=turquoise:edgethickness=1 \
            -f ${surf_dir}/rh.pial:edgecolor=red:edgethickness=1 \
            -ras $ras -ss ${f2}
        ((img+=2))
    done
}

slice x $xmin $xmax 
slice y $ymin $ymax
slice z $zmin $zmax 

montage -mode concatenate x_???.png -border 5 -bordercolor white -tile 2x3 -quality 100 x_mont_%03d.png
montage -mode concatenate y_???.png -border 5 -bordercolor white -tile 2x3 -quality 100 y_mont_%03d.png
montage -mode concatenate z_???.png -border 5 -bordercolor white -tile 2x3 -quality 100 z_mont_%03d.png

# Pad and annotate with assessor name
for i in ?_mont_???.png
	do convert -gravity Center ${i} -bordercolor white -border 20x20 \
	-background white -resize 1224x1554 -extent 1224x1554 -gravity NorthWest \
	-splice 0x30 -pointsize 18 -annotate +15+10 "${label_info}" ${i}
done


# Trim 3d screenshots
for i in [lr]h_*.png;do convert $i -fuzz 1% -trim +repage t${i};done

# Create first page, 3Ds
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
"$(cat $FREESURFER_HOME/build-stamp.txt)" \
-gravity NorthWest -background white -splice 0x60 \
-pointsize 24 -annotate +15+35 \
'QA Summary - FreeSurfer recon-all' \
-pointsize 18 -gravity NorthEast -annotate +15+10 \
"${label_info}" \
first_page.png


# Concatenate into PDF
convert \
    first_page.png \
    x_mont_???.png y_mont_???.png z_mont_???.png \
    -page letter \
    freesurfer_detailed.pdf

mkdir "${SUBJECTS_DIR}"/PDF_DETAIL
cp freesurfer_detailed.pdf "${SUBJECTS_DIR}"/PDF_DETAIL
