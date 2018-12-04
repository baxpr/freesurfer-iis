#!/bin/bash

MRI="${SUBJECTS_DIR}"/"${SUBJECT}"/mri
TMP="${SUBJECTS_DIR}"/"${SUBJECT}"/tmp

# Get RAS mm coords of region centroid
# https://surfer.nmr.mgh.harvard.edu/fswiki/CoordinateSystems
#    16   brainstem
RAS=`/usr/local/fsl/bin/fslstats ${SUBJECTS_DIR}/NII_ASEG/aseg.nii.gz -l 15.5 -u 16.5 -c`

# View selected slices on T1, with surfaces
freeview \
    -v "${MRI}"/T1.mgz \
    -v "${MRI}"/brainstemSsLabels.v12.FSvoxelSpace.mgz:visible=1:colormap=lut \
    -viewsize 400 400 --layout 1 --zoom 2.5 --viewport sagittal \
    -ras ${RAS} \
    -ss "${TMP}"/brainstem_sag.png

freeview \
    -v "${MRI}"/T1.mgz \
    -v "${MRI}"/brainstemSsLabels.v12.FSvoxelSpace.mgz:visible=1:colormap=lut \
    -viewsize 400 400 --layout 1 --zoom 2.5 --viewport coronal \
    -ras ${RAS} \
    -ss "${TMP}"/brainstem_cor.png
