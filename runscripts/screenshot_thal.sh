#!/bin/bash

MRI="${SUBJECTS_DIR}"/"${SUBJECT}"/mri
TMP="${SUBJECTS_DIR}"/"${SUBJECT}"/tmp


# Get RAS mm coords of region centroid, averaging over two regions
# https://surfer.nmr.mgh.harvard.edu/fswiki/CoordinateSystems
#    10   L thalamus
#    49   R thalamus
RASL=`/usr/local/fsl/bin/fslstats ${SUBJECTS_DIR}/NII_ASEG/aseg.nii.gz -l 9.5 -u 10.5 -c`
RL=`echo "${RASL}" | awk '{printf "%d",$1}'`
AL=`echo "${RASL}" | awk '{printf "%d",$2}'`
SL=`echo "${RASL}" | awk '{printf "%d",$3}'`

RASR=`/usr/local/fsl/bin/fslstats ${SUBJECTS_DIR}/NII_ASEG/aseg.nii.gz -l 48.5 -u 49.5 -c`
RR=`echo "${RASR}" | awk '{printf "%d",$1}'`
AR=`echo "${RASR}" | awk '{printf "%d",$2}'`
SR=`echo "${RASR}" | awk '{printf "%d",$3}'`

R=`echo "(${RL} + ${RR}) / 2" | bc`
A=`echo "(${AL} + ${AR}) / 2" | bc`
S=`echo "(${SL} + ${SR}) / 2" | bc`


# View selected slices on T1, with surfaces

# L sag
freeview \
    -v "${MRI}"/T1.mgz \
    -v "${MRI}"/ThalamicNuclei.v10.T1.FSvoxelSpace.mgz:visible=1:colormap=lut \
    -viewsize 400 400 --layout 1 --zoom 3 --viewport sagittal \
	-ras "${RL}" "${AL}" "${SL}" \
    -ss "${TMP}"/Lthal_sag.png

# R sag
freeview \
    -v "${MRI}"/T1.mgz \
    -v "${MRI}"/ThalamicNuclei.v10.T1.FSvoxelSpace.mgz:visible=1:colormap=lut \
    -viewsize 400 400 --layout 1 --zoom 3 --viewport sagittal \
	-ras "${RR}" "${AR}" "${SR}" \
    -ss "${TMP}"/Rthal_sag.png

# axi
freeview \
    -v "${MRI}"/T1.mgz \
    -v "${MRI}"/ThalamicNuclei.v10.T1.FSvoxelSpace.mgz:visible=1:colormap=lut \
    -viewsize 400 400 --layout 1 --zoom 3 --viewport axial \
	-ras "${R}" "${A}" "${S}" \
    -ss "${TMP}"/thal_axi.png

# cor
freeview \
    -v "${MRI}"/T1.mgz \
    -v "${MRI}"/ThalamicNuclei.v10.T1.FSvoxelSpace.mgz:visible=1:colormap=lut \
    -viewsize 400 400 --layout 1 --zoom 3 --viewport coronal \
	-ras "${R}" "${A}" "${S}" \
    -ss "${TMP}"/thal_cor.png

