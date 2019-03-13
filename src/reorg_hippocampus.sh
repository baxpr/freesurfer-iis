# MM reorg of hippocampus regions
#
# We have to get these from the hires resampled images:
#     lh.hippoAmygLabels-T1.v21.mgz
#     rh.hippoAmygLabels-T1.v21.mgz
# Both hemispheres are labeled with the same codes.
#
# Label info is in $FREESURFER_HOME/FreeSurferColorLUT.txt

# Resample with https://surfer.nmr.mgh.harvard.edu/fswiki/mri_vol2vol ?


# MMAP anterior/posterior
#
#   Anterior
#        235  subiculum-head
#        233  presubiculum-head
#        237  CA1-head
#        239  CA3-head
#        241  CA4-head
#        243  GC-ML-DG-head
#        245  molecular_layer_HP-head
#
#   Posterior
#        226  Hippocampal_tail   
#        234  presubiculum-body
#        236  subiculum-body
#        238  CA1-body
#        240  CA3-body
#        242  CA4-body
#        244  GC-ML-DG-body
#        246  molecular_layer_HP-body
#
#   Discard
#        203  parasubiculum
#        211  HATA
#        212  fimbria
#        215  hippocampal-fissure



# MMHBT head/body/tail
#
#  Head-CA
#        237  CA1-head
#        239  CA3-head
#        235  subiculum-head
#        245  molecular_layer_HP-head
#
#  Head-DG
#        241  CA4-head
#        243  GC-ML-DG-head
#
#  Head-subiculum
#        233  presubiculum-head
#
#  Body-CA
#        238  CA1-body
#        240  CA3-body
#        236  subiculum-body
#        246  molecular_layer_HP-body
#
#  Body-DG
#        242  CA4-body
#        244  GC-ML-DG-body
#
#  Body-subiculum
#        234  presubiculum-body
#
#  Tail
#        226  Hippocampal_tail   
#
#   Discard
#        203  parasubiculum
#        211  HATA
#        212  fimbria
#        215  hippocampal-fissure


