#!/bin/bash

LABEL=$1
REGION=$2
AXIS=$3

MRI="${SUBJECTS_DIR}"/"${SUBJECT}"/mri
SURF="${SUBJECTS_DIR}"/"${SUBJECT}"/surf
TMP="${SUBJECTS_DIR}"/"${SUBJECT}"/tmp

# FIXME coords reported by mri_volcluster may be "peak" rather than centroid, i.e.
# meaningless here
mri_volcluster --sum "${TMP}"/"${LABEL}".txt --in "${MRI}"/aseg.mgz --match ${REGION}

# FIXME axes are not these - voxel indices are arbitrary. Somehow use a transform
# and get RAS? mri_info --vox2ras gives us the transform I think, but how to apply?
# fslstats -c seems to give the RAS coords we want eg
#   fslstats aseg.nii.gz -l 16.5 -u 17.5 -c 
#
# https://surfer.nmr.mgh.harvard.edu/fswiki/CoordinateSystems
if [ ${AXIS} = "sagittal" ] ; then 
	SLICE=`grep "^  1 " "${TMP}"/"${LABEL}".txt | awk '{ printf "%d",$4; }'`
elif [ ${AXIS} = "coronal" ] ; then 
	SLICE=`grep "^  1 " "${TMP}"/"${LABEL}".txt | awk '{ printf "%d",$5; }'`
elif [ ${AXIS} = "axial" ] ; then 
	SLICE=`grep "^  1 " "${TMP}"/"${LABEL}".txt | awk '{ printf "%d",$6; }'`
fi

echo $SLICE

freeview \
    -v "${MRI}"/T1.mgz \
    -v "${MRI}"/ThalamicNuclei.v10.T1.FSvoxelSpace.mgz:visible=1:colormap=lut \
    -viewsize 400 400 --layout 1 --zoom 1.15 --viewport "${AXIS}" \
	-slice $SLICE $SLICE $SLICE \
    -f "${SURF}"/lh.white:edgecolor=turquoise:edgethickness=1 \
    -f "${SURF}"/lh.pial:edgecolor=red:edgethickness=1 \
    -f "${SURF}"/rh.white:edgecolor=turquoise:edgethickness=1 \
    -f "${SURF}"/rh.pial:edgecolor=red:edgethickness=1 \
    -ss "${TMP}"/"${LABEL}".png
