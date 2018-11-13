
singularity run \
--cleanenv \
--bind freesurfer_license.txt:/usr/local/freesurfer/license.txt \
--bind INPUTS:/INPUTS \
--bind OUTPUTS:/OUTPUTS \
test.simg \
--outdir /OUTPUTS \
--t1_nii /INPUTS/T1.nii.gz \
--project TESTPROJ \
--subject TESTSUBJ \
--session TESTSESS \
--scan TESTSCAN


exit 0

singularity shell \
--cleanenv \
--bind freesurfer_license.txt:/usr/local/freesurfer/license.txt \
--bind INPUTS:/INPUTS \
--bind OUTPUTS_tess_error:/OUTPUTS \
test.simg
