#!/bin/bash

MRI="${SUBJECTS_DIR}"/"${SUBJECT}"/mri
TMP="${SUBJECTS_DIR}"/"${SUBJECT}"/tmp

# Get RAS mm coords of region centroid
# https://surfer.nmr.mgh.harvard.edu/fswiki/CoordinateSystems
#    17   L hippocampus
#    53   R hippocampus
RASL=`/usr/local/fsl/bin/fslstats ${SUBJECTS_DIR}/NII_ASEG/aseg.nii.gz -l 16.5 -u 17.5 -c`
RASR=`/usr/local/fsl/bin/fslstats ${SUBJECTS_DIR}/NII_ASEG/aseg.nii.gz -l 52.5 -u 53.5 -c`

# View selected slices on T1, with surfaces
freeview \
    -v "${MRI}"/T1.mgz \
    -v "${MRI}"/lh.hippoAmygLabels-T1.v21.FSvoxelSpace.mgz:visible=1:colormap=lut \
    -viewsize 400 400 --layout 1 --zoom 2.5 --viewport sag \
    -ras ${RASL} \
    -ss "${TMP}"/Lhipp_sag.png

freeview \
    -v "${MRI}"/T1.mgz \
    -v "${MRI}"/rh.hippoAmygLabels-T1.v21.FSvoxelSpace.mgz:visible=1:colormap=lut \
    -viewsize 400 400 --layout 1 --zoom 2.5 --viewport sag \
    -ras ${RASR} \
    -ss "${TMP}"/Rhipp_sag.png
