#!/bin/bash

# Defaults
export T1_NII=/INPUTS/T1.nii.gz
export PROJECT=UNK_PROJ
export SUBJECT=UNK_SUBJ
export SESSION=UNK_SESS
export SCAN=UNK_SCAN
export OUT_DIR=/OUTPUTS

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

# Run Freesurfer recon
recon-all \
-all \
-i "${T1_NII}" \
-s "${PROJECT}-x-${SUBJECT}-x-${SESSION}-x-${SCAN}" \
"${OUTDIR}"

# Create an output PDF

