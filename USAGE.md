# Running the singularity image

Here is the singularity command line to run the processing pipeline. 

    singularity run \
        --cleanenv \
        --contain \
        --bind <freesurfer_license_file>:/usr/local/freesurfer/license.txt \
        --bind <inputs_dir>:/INPUTS \
        --bind <outputs_dir>:/OUTPUTS \
        <container_path> \
        --t1_niigz /INPUTS/T1.nii.gz \
        --label_info "Session label" \
        --out_dir /OUTPUTS


## Options line by line

`--contain`

*   Avoid referencing the host filesystem.

`--cleanenv`

*   Avoid any confusion caused by host environment variables, especially if any 
    of Freesurfer, FSL, Matlab runtime are installed on the host.

`--bind <freesurfer_license_file>:/usr/local/freesurfer/license.txt`

*   Freesurfer will not run without a license file present, and no license file is
    provided in the container. A license file on the host must be bound to this
    location in the container.

`--bind <inputs_dir>:/INPUTS`, `--bind <outputs_dir>:/OUTPUTS`

*   The expected way of passing files in and retrieving outputs is to create 
    these two directories on the host and bind them like so. The /INPUTS and 
    /OUTPUTS directories are created in the container filesystem at build time.

`--t1_niigz /INPUTS/t1.nii.gz`

*   The T1 weighted image that will be processed. The full path in the container 
    filesystem must be specified. Only the compressed Nifti format is supported. 
    This argument is optional; if not supplied, the default is the path shown here.

`--label_info "Project/Subject/Session label"`

*   Label containing XNAT info, if desired. Optional, does not
    affect processing, but does appear on the PDF report pages.

`--out_dir /OUTPUTS`

*   All outputs will be stored in this location in the container filesystem. They 
    can be accessed from the host assuming this directory is bound as shown above. 
    This argument is optional, with the default shown here.


## Inputs

See `--t1_niigz` above.


## Outputs

All outputs are stored in `out_dir` in these subdirectories:

```
PDF             At-a-glance report
PDF_DETAIL      Slice-by-slice view of surfaces
SUBJECT         Freesurfer "subject" directory with all Freesurfer outputs
STATS           Volume measurements for all structures in csv format
NII_T1          T1.mgz scaled structural image converted to Nifti
NII_ASEG        aseg.mgz segmentation (Nifti)
NII_WMPARC      wmparc.mgz full volumetric parcellation (Nifti)
NII_THALAMUS    thalamus parcellation (Nifti)
NII_BRAINSTEM   brainstem parcellation (Nifti)
NII_HIPP_AMYG   hippocampus/amygdala parcellations (Nifti)
```

