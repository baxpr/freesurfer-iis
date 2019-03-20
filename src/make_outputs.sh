#!/bin/bash
#
# Generate a number of useful extra outputs from Freesurfer results: PDF page,
# regional volumes, and Nifti images.

echo "Generating outputs for ${SUBJECTS_DIR} ${SUBJECT}"

MRI="${SUBJECTS_DIR}"/"${SUBJECT}"/mri
TMP="${SUBJECTS_DIR}"/"${SUBJECT}"/tmp

# Stats
${SRC}/make_xnat_csvs.sh

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

for f in \
  lh.hippoLabels-T1.v21.MMAP.FSVoxelSpace \
  lh.hippoLabels-T1.v21.MMHBT.FSVoxelSpace \
  rh.hippoLabels-T1.v21.MMAP.FSVoxelSpace \
  rh.hippoLabels-T1.v21.MMHBT.FSVoxelSpace \
  lh.hippoLabels-T1.v21.MMAP \
  lh.hippoLabels-T1.v21.MMHBT \
  rh.hippoLabels-T1.v21.MMAP \
  rh.hippoLabels-T1.v21.MMHBT \
  ; do
    mri_convert "${TMP}"/"${f}".mgz "${NII_HIPP_AMYG}"/"${f}".nii.gz
done

for f in \
  hippoLabels-T1.v21.MMAP.csv \
  hippoLabels-T1.v21.MMHBT.csv \
  ; do
	  mv "${TMP}"/"${f}" "${NII_HIPP_AMYG}"
done

# Make screenshots and PDFs
mkdir "${SUBJECTS_DIR}"/PDF
${SRC}/page1.sh
${SRC}/page2.sh
${SRC}/page3.sh
${SRC}/page4.sh
convert \
  "${TMP}"/page1.png \
  "${TMP}"/page2.png \
  "${TMP}"/page3.png \
  "${TMP}"/page4.png \
  "${SUBJECTS_DIR}"/PDF/freesurfer_v2.pdf

# Detailed PDF
${SRC}/make_slice_screenshots.sh

# Clean up (DAX will ignore these if we move them here)
mv "${SUBJECTS_DIR}"/"${SUBJECT}"/tmp "${SUBJECTS_DIR}"
mv "${SUBJECTS_DIR}"/"${SUBJECT}"/trash "${SUBJECTS_DIR}"

# Rename subject dir so DAX can find it
mv "${SUBJECTS_DIR}"/"${SUBJECT}" "${SUBJECTS_DIR}"/SUBJECT

