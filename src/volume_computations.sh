#!/bin/bash
#
# Compute and reformat regional volume/area/thickness measures

OUTDIR="${SUBJECTS_DIR}/${SUBJECT}/tmp"


# Subcortical regions, aseg
# This provides our eTIV
asegstats2table --delimiter comma -m volume \
-s "${SUBJECT}" -t "${OUTDIR}"/aseg.csv


# Surface parcels
#    aparc, aparc.pial, aparc.a2009s, aparc.DKTatlas, BA_exvivo
#    lh, rh
#    volume, area, thickness
for APARC in aparc aparc.a2009s aparc.pial aparc.DKTatlas BA_exvivo ; do
	for MEAS in volume area thickness ; do
		for HEMI in lh rh ; do
			aparcstats2table --delimiter comma \
			-m $MEAS --hemi $HEMI -s "${SUBJECT}" --parc $APARC \
			-t "${OUTDIR}"/"${HEMI}-${APARC}-${MEAS}.csv"
		done
	done
done


# MM computations
python volume_computations.py "${SUBJECTS_DIR}/${SUBJECT}/stats" "${OUTDIR}"


# Reformat CSVs
python reformat_csvs.py "${OUTDIR}"
