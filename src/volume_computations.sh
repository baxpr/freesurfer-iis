#!/usr/bin/env bash
#
# Compute and reformat regional volume/area/thickness measures

# Subcortical regions, aseg
# This provides our eTIV
asegstats2table --delimiter comma -m volume \
-s SUBJECT -t "${tmp_dir}"/aseg.csv


# Surface parcels
#    aparc, aparc.pial, aparc.a2009s, aparc.DKTatlas, BA_exvivo
#    lh, rh
#    volume, area, thickness
for aparc in aparc aparc.a2009s aparc.pial aparc.DKTatlas BA_exvivo ; do
	for meas in volume area thickness ; do
		for hemi in lh rh ; do
			aparcstats2table --delimiter comma \
			-m $meas --hemi $hemi -s SUBJECT --parc $aparc \
			-t "${tmp_dir}"/"${hemi}-${aparc}-${meas}.csv"
		done
	done
done


# MM computations
echo "MM volume computations"
volume_computations.py "${SUBJECTS_DIR}/SUBJECT/stats" "${tmp_dir}"


# Reformat CSVs
echo "Reformatting CSVs"
reformat_csvs.py "${tmp_dir}"
