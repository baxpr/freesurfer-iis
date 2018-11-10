
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

# FS says,
#    Found /dev/shm , will use for temp dir
# But this has only 64MB of space in the docker, don't know about the Sing, and
# it runs out.

exit 0

singularity shell \
--contain --cleanenv \
--bind freesurfer_license.txt:/usr/local/freesurfer/license.txt \
--bind INPUTS:/INPUTS \
--bind OUTPUTS:/OUTPUTS \
test.simg
