# !/bin/bash

# Get csvs with truncated filenames to save space when using XNAT -> REDCap

tmp="${SUBJECTS_DIR}"/SUBJECT/tmp

# STATS (human readable)
stats="${SUBJECTS_DIR}"/STATS
mkdir "${stats}"
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
  hipposubfields.T1.v21.MMAP.stats.csv \
  hipposubfields.T1.v21.MMHBT.stats.csv \
  hipposubfields.T1.v21.stats.csv \
  thalamic-nuclei.v10.T1.stats.csv \
  ; do
    cp "${tmp}"/"${f}" "${stats}"
done


# STATS_ABBREV
# Short filenames for REDCap module
st="${SUBJECTS_DIR}"/STATS_ABBREV
mkdir "${st}"
cp "${tmp}"/BA_exvivo-area.csv "${st}"/area_ba.csv
cp "${tmp}"/BA_exvivo-thickness.csv "${st}"/thick_ba.csv
cp "${tmp}"/BA_exvivo-volume.csv "${st}"/vol_ba.csv
cp "${tmp}"/amygdalar-nuclei.T1.v21.stats.csv "${st}"/amyg.csv
cp "${tmp}"/aparc-area.csv "${st}"/area.csv
cp "${tmp}"/aparc-thickness.csv "${st}"/thick.csv
cp "${tmp}"/aparc-volume.csv "${st}"/vol.csv
cp "${tmp}"/aparc.DKTatlas-area.csv "${st}"/area_dkt.csv
cp "${tmp}"/aparc.DKTatlas-thickness.csv "${st}"/thick_dkt.csv
cp "${tmp}"/aparc.DKTatlas-volume.csv "${st}"/vol_dkt.csv
cp "${tmp}"/aparc.a2009s-area.csv "${st}"/area_2009.csv
cp "${tmp}"/aparc.a2009s-thickness.csv "${st}"/thick_2009.csv
cp "${tmp}"/aparc.a2009s-volume.csv "${st}"/vol_2009.csv
cp "${tmp}"/aparc.pial-area.csv "${st}"/area_pial.csv
cp "${tmp}"/aparc.pial-thickness.csv "${st}"/thick_pial.csv
cp "${tmp}"/aparc.pial-volume.csv "${st}"/vol_pial.csv
cp "${tmp}"/aseg.csv "${st}"/subc.csv
cp "${tmp}"/brainstem.v12.stats.csv "${st}"/brainstem.csv
cp "${tmp}"/hipposubfields.T1.v21.MMAP.stats.csv "${st}"/mmhipp_ap.csv
cp "${tmp}"/hipposubfields.T1.v21.MMHBT.stats.csv "${st}"/mmhipp_hbt.csv
cp "${tmp}"/hipposubfields.T1.v21.stats.csv "${st}"/hipp.csv
cp "${tmp}"/thalamic-nuclei.v10.T1.stats.csv "${st}"/thal.csv
