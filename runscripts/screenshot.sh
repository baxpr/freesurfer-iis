#!/bin/bash

LABEL=$1
AXIS=$2

MRI="${SUBJECTS_DIR}"/"${SUBJECT}"/mri
SURF="${SUBJECTS_DIR}"/"${SUBJECT}"/surf
TMP="${SUBJECTS_DIR}"/"${SUBJECT}"/tmp

# View selected slice on T1, with surfaces
freeview \
    -v "${MRI}"/T1.mgz \
    -viewsize 400 400 --layout 1 --zoom 1.15 --viewport "${AXIS}" \
    -f "${SURF}"/lh.white:edgecolor=turquoise:edgethickness=1 \
    -f "${SURF}"/lh.pial:edgecolor=red:edgethickness=1 \
    -f "${SURF}"/rh.white:edgecolor=turquoise:edgethickness=1 \
    -f "${SURF}"/rh.pial:edgecolor=red:edgethickness=1 \
    -ss "${TMP}"/"${LABEL}".png
