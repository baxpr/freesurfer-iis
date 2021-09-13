
singularity shell \
    --contain \
    --cleanenv \
    --bind freesurfer_license.txt:/usr/local/freesurfer/license.txt \
    --bind INPUTS:/INPUTS \
    --bind OUTPUTS:/OUTPUTS \
    --bind OUTPUTS:/tmp \
    test.simg

