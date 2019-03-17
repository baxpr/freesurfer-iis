#!/bin/bash
#
# Generate a number of useful extra outputs from Freesurfer results: PDF page,
# regional volumes, and Nifti images.

echo "Generating outputs for ${SUBJECTS_DIR} ${SUBJECT}"

MRI="${SUBJECTS_DIR}"/"${SUBJECT}"/mri
TMP="${SUBJECTS_DIR}"/"${SUBJECT}"/tmp


# STATS
STATS="${SUBJECTS_DIR}"/STATS
mkdir "STATS"
for f in \
  BA_exvivo-area.csv \
  BA_exvivo-thickness.csv \
  BA_exvivo-volume.csv \
  amygdalar-nuclei.T1.v21.stats.csv \
  aparc-area.csv \
  aparc-thickness.csv \
  aparc-volume.csv \
  aparc.DKTatlas-area.csv \
  aparc.DKTatlas-thickness.csv \
  aparc.DKTatlas-volume.csv \
  aparc.a2009s-area.csv \
  aparc.a2009s-thickness.csv \
  aparc.a2009s-volume.csv \
  aparc.pial-area.csv \
  aparc.pial-thickness.csv \
  aparc.pial-volume.csv \
  aseg.csv \
  brainstem.v12.stats.csv \
  hipposubfields-T1.v21.MMAP.csv \
  hipposubfields-T1.v21.MMHBT.csv \
  hipposubfields.T1.v21.MMAP.stats.csv \
  hipposubfields.T1.v21.MMHBT.stats.csv \
  hipposubfields.T1.v21.stats.csv \
  thalamic-nuclei.v10.T1.stats.csv \
  ; do
    cp "${TMP}"/"${f}" "${STATS}"
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
	  mv "${f}" "${NII_HIPP_AMYG}"
done
	  
# Make screenshots and PDFs
mkdir "${SUBJECTS_DIR}"/PDF
/opt/src/page1.sh
/opt/src/page2.sh
/opt/src/page3.sh
convert \
  "${TMP}"/page1.png \
  "${TMP}"/page2.png \
  "${TMP}"/page3.png \
  "${SUBJECTS_DIR}"/PDF/freesurfer_v2.pdf


# Clean up
rm -r "${SUBJECTS_DIR}"/"${SUBJECT}"/tmp
rm -r "${SUBJECTS_DIR}"/"${SUBJECT}"/trash

# Rename subject dir so DAX can find it
mv "${SUBJECTS_DIR}"/"${SUBJECT}" "${SUBJECTS_DIR}"/SUBJECT

