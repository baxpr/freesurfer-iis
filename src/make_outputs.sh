#!/usr/bin/env bash
#
# Generate a number of useful extra outputs from Freesurfer results: PDF page,
# regional volumes, and Nifti images.

echo "Generating outputs for ${SUBJECTS_DIR}"

# Stats
make_xnat_csvs.sh

# NII_NU_T1
NII_NU_T1="${SUBJECTS_DIR}"/NII_NU_T1
mkdir "${NII_NU_T1}"
mri_convert "${mri_dir}"/nu.mgz "${NII_NU_T1}"/nu.nii.gz

# NII_ASEG
NII_ASEG="${SUBJECTS_DIR}"/NII_ASEG
mkdir "${NII_ASEG}"
mri_convert "${mri_dir}"/aseg.mgz "${NII_ASEG}"/aseg.nii.gz

# NII_WMPARC
NII_WMPARC="${SUBJECTS_DIR}"/NII_WMPARC
mkdir "${NII_WMPARC}"
mri_convert "${mri_dir}"/wmparc.mgz "${NII_WMPARC}"/wmparc.nii.gz

# NII_THALAMUS
NII_THALAMUS="${SUBJECTS_DIR}"/NII_THALAMUS
mkdir "${NII_THALAMUS}"
mri_convert "${mri_dir}"/ThalamicNuclei.v12.T1.FSvoxelSpace.mgz \
    "${NII_THALAMUS}"/ThalamicNuclei.v12.T1.FSvoxelSpace.nii.gz

# NII_BRAINSTEM
NII_BRAINSTEM="${SUBJECTS_DIR}"/NII_BRAINSTEM
mkdir "${NII_BRAINSTEM}"
mri_convert "${mri_dir}"/brainstemSsLabels.v12.FSvoxelSpace.mgz \
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
    mri_convert "${mri_dir}"/"${f}".mgz "${NII_HIPP_AMYG}"/"${f}".nii.gz
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
    mri_convert "${tmp_dir}"/"${f}".mgz "${NII_HIPP_AMYG}"/"${f}".nii.gz
done

for f in \
  hippoLabels-T1.v21.MMAP.csv \
  hippoLabels-T1.v21.MMHBT.csv \
  ; do
	  cp "${tmp_dir}"/"${f}" "${NII_HIPP_AMYG}"
done

# Make screenshots and PDFs
mkdir "${SUBJECTS_DIR}"/PDF
export the_date=$(date)
page1.sh
page2.sh
page3.sh
page4.sh
convert \
  "${tmp_dir}"/page1.png \
  "${tmp_dir}"/page2.png \
  "${tmp_dir}"/page3.png \
  "${tmp_dir}"/page4.png \
  "${SUBJECTS_DIR}"/PDF/freesurfer.pdf

# Detailed PDF
make_slice_screenshots.sh

# Clean up (DAX will ignore these if we move them here)
#mv "${SUBJECTS_DIR}"/SUBJECT/tmp "${SUBJECTS_DIR}"
#mv "${SUBJECTS_DIR}"/SUBJECT/trash "${SUBJECTS_DIR}"


