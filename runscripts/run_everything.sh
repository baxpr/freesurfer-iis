#!/bin/bash
#
# Full T1 pipeline:
#    recon-all
#    segmentThalamicNuclei.sh
#    segmentHA_T1.sh
#    segmentBS.sh

# Defaults
export T1_NII=/INPUTS/T1.nii.gz
export PROJECT=UNK_PROJ
export SUBJECT=UNK_SUBJ
export SESSION=UNK_SESS
export SCAN=UNK_SCAN
export OUTDIR=/OUTPUTS

# Parse inputs
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
    --t1_nii)
        T1_NII="$2"
        shift; shift
        ;;
    --project)
        PROJECT="$2"
        shift; shift
        ;;
    --subject)
        SUBJECT="$2"
        shift; shift
        ;;
    --session)
        SESSION="$2"
        shift; shift
        ;;
    --scan)
        SCAN="$2"
        shift; shift
        ;;
    --outdir)
        OUTDIR="$2"
        shift; shift
        ;;
    *)
        shift
        ;;
  esac
done

# See what we got
echo T1_NII      = "${T1_NII}"
echo PROJECT     = "${PROJECT}"
echo SUBJECT     = "${SUBJECT}"
echo SESSION     = "${SESSION}"
echo SCAN        = "${SCAN}"
echo OUTDIR      = "${OUTDIR}"

# Freesurfer setup
source "${FREESURFER_HOME}"/SetUpFreeSurfer.sh
export SUBJECTS_DIR="${OUTDIR}"
export SUBJECT="${PROJECT}-x-${SUBJECT}-x-${SESSION}-x-${SCAN}"

# recon-all
recon-all -all -i "${T1_NII}" -s "${SUBJECT}"

# Thalamus
segmentThalamicNuclei.sh "${SUBJECT}" "${SUBJECTS_DIR}"

# Hippocampus/amygdala
segmentHA_T1.sh "${SUBJECT}" "${SUBJECTS_DIR}"

# Brainstem
segmentBS.sh "${SUBJECT}" "${SUBJECTS_DIR}"

# Main output resource will be the freesurfer subject dir to keep its 
# structure in case needed. Put in SUBJECT resource

# Convert some key outputs to nifti and pull to separate resources e.g.
# T1_CORTEX_SURF, T1_SEG, THAL_SEG, etc ? Could be confusing if we ever do 
# manual edit steps. It would be helpful to have some things in nifti, but also 
# any following spiders could (should?) just do that conversion themselves.

# Create output PDF https://github.com/bud42/FS6/tree/master/src

