
# Full pipeline
singularity run \
--cleanenv \
--bind freesurfer_license.txt:/usr/local/freesurfer/license.txt \
--bind INPUTS:/INPUTS \
--bind OUTPUTS:/OUTPUTS \
baxpr-freesurfer-singularity-master-dev2.simg \
--outdir /OUTPUTS \
--t1_nii /INPUTS/T1.nii.gz \
--project TESTPROJ \
--subject TESTSUBJ \
--session TESTSESS \
--scan TESTSCAN

#############################################################################
# To test post-recon stuff only

# Shell in
singularity shell \
--cleanenv \
--bind freesurfer_license.txt:/usr/local/freesurfer/license.txt \
--bind INPUTS:/INPUTS \
--bind OUTPUTS:/OUTPUTS \
--bind `pwd`:/opt/wkdir \
baxpr-freesurfer-singularity-master-dev2.simg

# Set up
source "${FREESURFER_HOME}"/SetUpFreeSurfer.sh
export SUBJECTS_DIR=/OUTPUTS
export SUBJECT=SUBJECT

# Location of edited scripts
export SRC=/opt/wkdir/src

# All post-recon stuff
${SRC}/volume_computations.sh
${SRC}/create_MM_labelmaps.sh
xvfb-run --server-num=$(($$ + 99)) \
    --server-args='-screen 0 1600x1200x24 -ac +extension GLX' \
    ${SRC}/make_outputs.sh

# Just the last bit of make_outputs
xvfb-run --server-num=$(($$ + 99)) \
    --server-args='-screen 0 1600x1200x24 -ac +extension GLX' \
    ${SRC}/make_slice_screenshots.sh
