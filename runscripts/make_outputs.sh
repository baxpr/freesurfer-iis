#!/bin/bash
#
# Generate a number of useful extra outputs from Freesurfer results: PDF page,
# regional volumes, and Nifti images.

echo "Generating outputs for ${SUBJECTS_DIR} ${SUBJECT}"

MRI="${SUBJECTS_DIR}"/"${SUBJECT}"/mri


# VOLUMES
VOLUMES="${SUBJECTS_DIR}"/VOLUMES
mkdir "${VOLUMES}"
for f in \
  ThalamicNuclei.v10.T1.volumes.txt \
  brainstemSsVolumes.v12.txt \
  lh.amygNucVolumes-T1.v21.txt \
  lh.hippoSfVolumes-T1.v21.txt \
  rh.amygNucVolumes-T1.v21.txt \
  rh.hippoSfVolumes-T1.v21.txt \
  ; do
    cp "${MRI}"/"${f}" "${VOLUMES}"
done

# NII_T1
NII_T1="${SUBJECTS_DIR}"/NII_T1
mkdir "${NII_T1}"
mri_convert "${MRI}"/T1.mgz "${NII_T1}"/T1.nii.gz

# NII_ASEG
NII_ASEG="${SUBJECTS_DIR}"/NII_ASEG
mkdir "${NII_ASEG}"
mri_convert "${MRI}"/aseg.mgz "${NII_ASEG}"/aseg.nii.gz

# NII_WMPARC
NII_WMPARC="${SUBJECTS_DIR}"/NII_WMPARC
mkdir "${NII_WMPARC}"
mri_convert "${MRI}"/wmparc.mgz "${NII_WMPARC}"/wmparc.nii.gz

# NII_THALAMUS
NII_THALAMUS="${SUBJECTS_DIR}"/NII_THALAMUS
mkdir "${NII_THALAMUS}"
mri_convert "${MRI}"/ThalamicNuclei.v10.T1.FSvoxelSpace.mgz \
    "${NII_THALAMUS}"/ThalamicNuclei.v10.T1.FSvoxelSpace.nii.gz

# NII_BRAINSTEM
NII_BRAINSTEM="${SUBJECTS_DIR}"/NII_BRAINSTEM
mkdir "${NII_BRAINSTEM}"
mri_convert "${MRI}"/brainstemSsLabels.v12.FSvoxelSpace.mgz \
    "${NII_BRAINSTEM}"/brainstemSsLabels.v12.FSvoxelSpace.nii.gz

# NII_HIPP_AMYG
NII_HIPP_AMYG="${SUBJECTS_DIR}"/NII_HIPP_AMYG
mkdir "${NII_HIPP_AMYG}"
for f in \
  lh.hippoAmygLabels-T1.v21.FSvoxelSpace \
  rh.hippoAmygLabels-T1.v21.FSvoxelSpace \
  lh.hippoAmygLabels-T1.v21.HBT.FSvoxelSpace \
  rh.hippoAmygLabels-T1.v21.HBT.FSvoxelSpace \
  lh.hippoAmygLabels-T1.v21.FS60.FSvoxelSpace \
  rh.hippoAmygLabels-T1.v21.FS60.FSvoxelSpace \
  lh.hippoAmygLabels-T1.v21.CA.FSvoxelSpace \
  rh.hippoAmygLabels-T1.v21.CA.FSvoxelSpace \
  ; do
    mri_convert "${MRI}"/"${f}".mgz "${NII_HIPP_AMYG}"/"${f}".nii.gz
done


# Make screenshots and PDFs
/opt/runscripts/make_all_screenshots.sh
/opt/runscripts/make_slice_screenshots.sh


# Clean up
rm -r "${SUBJECTS_DIR}"/"${SUBJECT}"/tmp
rm -r "${SUBJECTS_DIR}"/"${SUBJECT}"/trash

# Rename subject dir so DAX can find it
mv "${SUBJECTS_DIR}"/"${SUBJECT}" "${SUBJECTS_DIR}"/SUBJECT

