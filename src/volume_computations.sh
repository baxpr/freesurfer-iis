
SUBJECTS_DIR=`pwd`/../OUTPUTS
SUBJECT=SUBJECT
TMP=.

# Would be clearest to keep these all in separate outputs that go to separate
# instruments in REDCap. Then we can include the eTIV and so on in each case, 
# and it'll show up in the corresponding REDCap report.
#
# Although, we could consider combining the lh+rh ?

# TODO Remove capital letters, special chars, hyphen from region names


# Subcortical regions, aseg
asegstats2table --delimiter comma -m volume \
-s "${SUBJECT}" -t "${TMP}"/aseg.csv


# Surface parcels
#    aparc, aparc.pial, aparc.a2009s, aparc.DKTatlas, BA_exvivo
#    lh, rh
#    volume, area, thickness
# These also store BrainSegVolNotVent and eTIV which will need to be handled
for APARC in aparc aparc.a2009s aparc.pial aparc.DKTatlas BA_exvivo ; do
	for MEAS in volume area thickness ; do
		for HEMI in lh rh ; do
			aparcstats2table --delimiter comma \
			-m $MEAS --hemi $HEMI -s "${SUBJECT}" --parc $APARC \
			-t "${TMP}"/"${HEMI}-${APARC}-${MEAS}.csv"
		done
	done
done


# MM computations
python volume_computations.py "${SUBJECTS_DIR}/${SUBJECT}/stats" "${TMP}"

