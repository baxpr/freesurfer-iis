# MM reorg of hippocampus regions
#
# We have to get these from the hires resampled images:
#     lh.hippoAmygLabels-T1.v21.mgz
#     rh.hippoAmygLabels-T1.v21.mgz
# Both hemispheres are labeled with the same codes.
#
# Label info is in $FREESURFER_HOME/FreeSurferColorLUT.txt

# Resample with https://surfer.nmr.mgh.harvard.edu/fswiki/mri_vol2vol ?


SUBJECTS_DIR=`pwd`/../OUTPUTS
SUBJECT=SUBJECT
TMP=.


# MMAP anterior/posterior
#
#   Anterior (1)
#        233  presubiculum-head
#        235  subiculum-head
#        237  CA1-head
#        239  CA3-head
#        241  CA4-head
#        243  GC-ML-DG-head
#        245  molecular_layer_HP-head
#
#   Posterior (2)
#        226  Hippocampal_tail   
#        234  presubiculum-body
#        236  subiculum-body
#        238  CA1-body
#        240  CA3-body
#        242  CA4-body
#        244  GC-ML-DG-body
#        246  molecular_layer_HP-body
#
#   Discard (0)
#        203  parasubiculum
#        211  HATA
#        212  fimbria
#        215  hippocampal-fissure
#       7...  amygdala
for hemi in lh rh ; do
mri_binarize \
--i "${SUBJECTS_DIR}/${SUBJECT}/mri/${hemi}.hippoAmygLabels-T1.v21.mgz" \
\
--replace 233 1 \
--replace 235 1 \
--replace 237 1 \
--replace 239 1 \
--replace 241 1 \
--replace 243 1 \
--replace 245 1 \
\
--replace 226 2 \
--replace 234 2 \
--replace 236 2 \
--replace 238 2 \
--replace 240 2 \
--replace 242 2 \
--replace 244 2 \
--replace 246 2 \
\
--replace 203 0 \
--replace 211 0 \
--replace 212 0 \
--replace 215 0 \
\
--replace 7001 0 \
--replace 7003 0 \
--replace 7005 0 \
--replace 7006 0 \
--replace 7007 0 \
--replace 7008 0 \
--replace 7009 0 \
--replace 7010 0 \
--replace 7015 0 \
\
--o "${TMP}"/${hemi}.hippoLabels-T1.v21.MMAP.mgz
done



# MMHBT head/body/tail
#
#  Head-CA (1)
#        235  subiculum-head
#        237  CA1-head
#        239  CA3-head
#        245  molecular_layer_HP-head
#
#  Head-DG (2)
#        241  CA4-head
#        243  GC-ML-DG-head
#
#  Head-subiculum (3)
#        233  presubiculum-head
#
#  Body-CA (4)
#        236  subiculum-body
#        238  CA1-body
#        240  CA3-body
#        246  molecular_layer_HP-body
#
#  Body-DG (5)
#        242  CA4-body
#        244  GC-ML-DG-body
#
#  Body-subiculum (6)
#        234  presubiculum-body
#
#  Tail (7)
#        226  Hippocampal_tail   
#
#  Discard (0)
#        203  parasubiculum
#        211  HATA
#        212  fimbria
#        215  hippocampal-fissure
#       7...  amygdala
for hemi in lh rh ; do
mri_binarize \
--i "${SUBJECTS_DIR}/${SUBJECT}/mri/${hemi}.hippoAmygLabels-T1.v21.mgz" \
\
--replace 235 1 \
--replace 237 1 \
--replace 239 1 \
--replace 245 1 \
\
--replace 241 2 \
--replace 243 2 \
\
--replace 233 3 \
\
--replace 236 4 \
--replace 238 4 \
--replace 240 4 \
--replace 246 4 \
\
--replace 242 5 \
--replace 244 5 \
\
--replace 234 6 \
\
--replace 226 7 \
\
--replace 203 0 \
--replace 211 0 \
--replace 212 0 \
--replace 215 0 \
\
--replace 7001 0 \
--replace 7003 0 \
--replace 7005 0 \
--replace 7006 0 \
--replace 7007 0 \
--replace 7008 0 \
--replace 7009 0 \
--replace 7010 0 \
--replace 7015 0 \
\
--o "${TMP}"/${hemi}.hippoLabels-T1.v21.MMHBT.mgz
done


