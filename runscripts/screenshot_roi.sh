#!/bin/bash

LABEL=$1
AXIS=$2
ZOOM=$3
REGION=$4

MRI="${SUBJECTS_DIR}"/"${SUBJECT}"/mri
TMP="${SUBJECTS_DIR}"/"${SUBJECT}"/tmp

# Get RAS mm coords of region centroid
# https://surfer.nmr.mgh.harvard.edu/fswiki/CoordinateSystems
LO=`echo ${REGION} - 0.5 | bc`
HI=`echo ${REGION} + 0.5 | bc`
RAS=`/usr/local/fsl/bin/fslstats ${SUBJECTS_DIR}/NII_ASEG/aseg.nii.gz -l ${LO} -u ${HI} -c`

# View selected slice on T1, with surfaces
freeview \
    -v "${MRI}"/T1.mgz \
    -v "${MRI}"/ThalamicNuclei.v10.T1.FSvoxelSpace.mgz:visible=1:colormap=lut \
    -viewsize 400 400 --layout 1 --zoom ${ZOOM} --viewport "${AXIS}" \
    -ras ${RAS} \
    -ss "${TMP}"/"${LABEL}".png
