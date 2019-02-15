# Make a container we can play with
#sudo singularity build --sandbox sandbox Singularity.dev.local

# Get into it. Get X11 with
#    export DISPLAY=host.docker.internal:0
singularity shell \
--cleanenv \
--bind freesurfer_license.txt:/usr/local/freesurfer/license.txt \
--bind INPUTS:/INPUTS \
--bind OUTPUTS:/OUTPUTS \
sandbox
