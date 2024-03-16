# !/usr/bin/env bash

# Get csvs with truncated filenames to save space when using XNAT -> REDCap

# STATS (human readable)
stats="${SUBJECTS_DIR}"/STATS
mkdir "${stats}"
for f in \
  BA_exvivo-area.csv \
  BA_exvivo-thickness.csv \
  BA_exvivo-volume.csv \
  amygdalar-nuclei.T1.v22.stats.csv \
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
  brainstem.v13.stats.csv \
  hipposubfields.T1.v22.MMAP.stats.csv \
  hipposubfields.T1.v22.MMHBT.stats.csv \
  hipposubfields.T1.v22.stats.csv \
  thalamic-nuclei.v13.T1.stats.csv \
  ; do
    cp "${tmp_dir}"/"${f}" "${stats}"
done


# STATS_ABBREV
# Short filenames for REDCap module
st="${SUBJECTS_DIR}"/STATS_ABBREV
mkdir "${st}"
cp "${tmp_dir}"/BA_exvivo-area.csv "${st}"/area_ba.csv
cp "${tmp_dir}"/BA_exvivo-thickness.csv "${st}"/thick_ba.csv
cp "${tmp_dir}"/BA_exvivo-volume.csv "${st}"/vol_ba.csv
cp "${tmp_dir}"/amygdalar-nuclei.T1.v22.stats.csv "${st}"/amyg.csv
cp "${tmp_dir}"/aparc-area.csv "${st}"/area.csv
cp "${tmp_dir}"/aparc-thickness.csv "${st}"/thick.csv
cp "${tmp_dir}"/aparc-volume.csv "${st}"/vol.csv
cp "${tmp_dir}"/aparc.DKTatlas-area.csv "${st}"/area_dkt.csv
cp "${tmp_dir}"/aparc.DKTatlas-thickness.csv "${st}"/thick_dkt.csv
cp "${tmp_dir}"/aparc.DKTatlas-volume.csv "${st}"/vol_dkt.csv
cp "${tmp_dir}"/aparc.a2009s-area.csv "${st}"/area_2009.csv
cp "${tmp_dir}"/aparc.a2009s-thickness.csv "${st}"/thick_2009.csv
cp "${tmp_dir}"/aparc.a2009s-volume.csv "${st}"/vol_2009.csv
cp "${tmp_dir}"/aparc.pial-area.csv "${st}"/area_pial.csv
cp "${tmp_dir}"/aparc.pial-thickness.csv "${st}"/thick_pial.csv
cp "${tmp_dir}"/aparc.pial-volume.csv "${st}"/vol_pial.csv
cp "${tmp_dir}"/aseg.csv "${st}"/subc.csv
cp "${tmp_dir}"/brainstem.v13.stats.csv "${st}"/brainstem.csv
cp "${tmp_dir}"/hipposubfields.T1.v22.MMAP.stats.csv "${st}"/mmhipp_ap.csv
cp "${tmp_dir}"/hipposubfields.T1.v22.MMHBT.stats.csv "${st}"/mmhipp_hbt.csv
cp "${tmp_dir}"/hipposubfields.T1.v22.stats.csv "${st}"/hipp.csv
cp "${tmp_dir}"/thalamic-nuclei.v13.T1.stats.csv "${st}"/thal.csv
