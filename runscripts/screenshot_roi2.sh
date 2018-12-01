#!/bin/bash

LABEL=$1
AXIS=$2
ZOOM=$3
REGION1=$4
REGION2=$5

MRI="${SUBJECTS_DIR}"/"${SUBJECT}"/mri
TMP="${SUBJECTS_DIR}"/"${SUBJECT}"/tmp

# Get RAS mm coords of region centroid, averaging over two regions
# https://surfer.nmr.mgh.harvard.edu/fswiki/CoordinateSystems
LO1=`echo ${REGION1} - 0.5 | bc`
HI1=`echo ${REGION1} + 0.5 | bc`
RAS1=`/usr/local/fsl/bin/fslstats ${MRI}/aseg.nii.gz -l ${LO1} -u ${HI1} -c`
R1=`echo "${RAS1}" | awk '{printf "%d",$1}'`
A1=`echo "${RAS1}" | awk '{printf "%d",$2}'`
S1=`echo "${RAS1}" | awk '{printf "%d",$3}'`

LO2=`echo ${REGION2} - 0.5 | bc`
HI2=`echo ${REGION2} + 0.5 | bc`
RAS2=`/usr/local/fsl/bin/fslstats ${MRI}/aseg.nii.gz -l ${LO2} -u ${HI2} -c`
R2=`echo "${RAS2}" | awk '{printf "%d",$1}'`
A2=`echo "${RAS2}" | awk '{printf "%d",$2}'`
S2=`echo "${RAS2}" | awk '{printf "%d",$3}'`

R=`echo "(${R1} + ${R2}) / 2" | bc`
A=`echo "(${A1} + ${A2}) / 2" | bc`
S=`echo "(${S1} + ${S2}) / 2" | bc`

# View selected slice on T1, with surfaces
freeview \
    -v "${MRI}"/T1.mgz \
    -v "${MRI}"/ThalamicNuclei.v10.T1.FSvoxelSpace.mgz:visible=1:colormap=lut \
    -viewsize 400 400 --layout 1 --zoom ${ZOOM} --viewport "${AXIS}" \
	-ras "${R} ${A} ${S}" \
    -ss "${TMP}"/"${LABEL}".png
