
SUBJECTS_DIR=`pwd`/../OUTPUTS
SUBJECT=SUBJECT
OUTDIR=./out

# Would be clearest to keep these all in separate outputs that go to separate
# instruments in REDCap. Then we can include the eTIV and so on in each case, 
# and it'll show up in the corresponding REDCap report.

# TODO Reformatting freesurfer's csvs 
#   Combine the lh+rh, handling extras BrainSegVolNotVent,eTIV
#   Remove first column
#   Remove special chars in region names
#       aseg.csv   : -, capitals
#       a2009s     : &, -, capitals
#       BA1_exvivo : capitals
#       DKTatlas   : capitals


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
