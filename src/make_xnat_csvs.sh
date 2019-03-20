# !/bin/bash

# Get csvs with truncated filenames to save space when using XNAT -> REDCap

TMP="${SUBJECTS_DIR}"/"${SUBJECT}"/tmp

# STATS (human readable)
STATS="${SUBJECTS_DIR}"/STATS
mkdir "${STATS}"
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
    cp "${TMP}"/"${f}" "${STATS}"
done


# STATS_ABBREV
# Short filenames for REDCap module
ST="${SUBJECTS_DIR}"/STATS_ABBREV
mkdir "${ST}"
cp "${TMP}"/BA_exvivo-area.csv "${ST}"/area_ba.csv
cp "${TMP}"/BA_exvivo-thickness.csv "${ST}"/thick_ba.csv
cp "${TMP}"/BA_exvivo-volume.csv "${ST}"/vol_ba.csv
cp "${TMP}"/amygdalar-nuclei.T1.v21.stats.csv "${ST}"/amyg.csv
cp "${TMP}"/aparc-area.csv "${ST}"/area.csv
cp "${TMP}"/aparc-thickness.csv "${ST}"/thick.csv
cp "${TMP}"/aparc-volume.csv "${ST}"/vol.csv
cp "${TMP}"/aparc.DKTatlas-area.csv "${ST}"/area_dkt.csv
cp "${TMP}"/aparc.DKTatlas-thickness.csv "${ST}"/thick_dkt.csv
cp "${TMP}"/aparc.DKTatlas-volume.csv "${ST}"/vol_dkt.csv
cp "${TMP}"/aparc.a2009s-area.csv "${ST}"/area_2009.csv
cp "${TMP}"/aparc.a2009s-thickness.csv "${ST}"/thick_2009.csv
cp "${TMP}"/aparc.a2009s-volume.csv "${ST}"/vol_2009.csv
cp "${TMP}"/aparc.pial-area.csv "${ST}"/area_pial.csv
cp "${TMP}"/aparc.pial-thickness.csv "${ST}"/thick_pial.csv
cp "${TMP}"/aparc.pial-volume.csv "${ST}"/vol_pial.csv
cp "${TMP}"/aseg.csv "${ST}"/subc.csv
cp "${TMP}"/brainstem.v12.stats.csv "${ST}"/brainstem.csv
cp "${TMP}"/hipposubfields.T1.v21.MMAP.stats.csv "${ST}"/mmhipp_ap.csv
cp "${TMP}"/hipposubfields.T1.v21.MMHBT.stats.csv "${ST}"/mmhipp_hbt.csv
cp "${TMP}"/hipposubfields.T1.v21.stats.csv "${ST}"/hipp.csv
cp "${TMP}"/thalamic-nuclei.v10.T1.stats.csv "${ST}"/thal.csv
