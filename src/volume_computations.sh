
SUBJECTS_DIR=`pwd`/../OUTPUTS
SUBJECT=SUBJECT
TMP=.

# TODO Hippocampus, amygdala, brainstem, thalamus

# TODO MM re-org of hippocampus

# Subcortical regions, aseg
asegstats2table --delimiter comma --no-vol-extras -m volume \
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

