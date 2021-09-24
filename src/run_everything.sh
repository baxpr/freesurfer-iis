#!/bin/bash
#
# Full T1 pipeline:
#    recon-all
#    volume computations/reformatting
#    PDF creation

# Defaults
export t1_niigz="/INPUTS/t1.nii.gz"
export recon_opts="-hires"
export label_info="UNKNOWN SCAN"
export out_dir="/OUTPUTS"
export src_dir="/opt/fs-extensions/src"
export edits_dir=""

# Parse inputs
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
    --t1_niigz)
        export t1_niigz="$2"; shift; shift;;
    --recon_opts)
        export recon_opts="$2"; shift; shift;;
    --label_info)
        export label_info="$2"; shift; shift;;
    --out_dir)
        export out_dir="$2"; shift; shift;;
    --src_dir)
        export src_dir="$2"; shift; shift;;
    --edits_dir)
        export edits_dir="$2"; shift; shift;;
    *)
		echo "Unknown argument $key"; shift;;
  esac
done

# Show what we got
echo t1_niigz    = "${t1_niigz}"
echo label_info  = "${label_info}"
echo out_dir     = "${out_dir}"

# Set freesurfer subjects dir
export SUBJECTS_DIR="${out_dir}"

# recon-all
if [ -z "${edits_dir}" ]; then
    # Complete recon
    recon-all -all -i "${t1_niigz}" -s SUBJECT ${recon_opts}
else
    # Redo with edits
    cp -R "${edits_dir}" "${SUBJECTS_DIR}"/SUBJECT
    if [ -f "${SUBJECTS_DIR}"/SUBJECT/tmp/control.dat ]; then
        recon-all -autorecon2-cp -autorecon3 -s SUBJECT ${recon_opts}
    else
        recon-all -autorecon2-wm -autorecon3 -s SUBJECT ${recon_opts}
fi

# Subregion modules (xvfb needed)
segmentBS.sh SUBJECT
segmentHA_T1.sh SUBJECT
segmentThalamicNuclei.sh SUBJECT

# Produce additional outputs and organize
volume_computations.sh
create_MM_labelmaps.sh
make_outputs.sh
