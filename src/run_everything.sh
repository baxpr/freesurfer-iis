#!/bin/bash
#
# Full T1 pipeline:
#    recon-all
#    volume computations/reformatting
#    PDF creation

# Defaults
export t1_niigz=/INPUTS/t1.nii.gz
export label_info="UNKNOWN SCAN"
export out_dir=/OUTPUTS

# Parse inputs
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
    --t1_niigz)
        export t1_niigz="$2"; shift; shift;;
    --label_info)
        export label_info="$2"; shift; shift;;
    --out_dir)
        export out_dir="$2"; shift; shift;;
    *)
		echo "Unknown argument $key"; shift;;
  esac
done

# See what we got
echo t1_niigz    = "${t1_niigz}"
echo label_info  = "${label_info}"
echo out_dir     = "${out_dir}"

# Freesurfer setup
source "${FREESURFER_HOME}"/SetUpFreeSurfer.sh
export SUBJECTS_DIR="${out_dir}"

# recon-all
recon-all -all -i "${t1_niigz}" -s SUBJECT

# Produce additional outputs and organize
volume_computations.sh
create_MM_labelmaps.sh
make_outputs.sh
