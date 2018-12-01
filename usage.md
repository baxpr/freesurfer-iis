# Running the singularity image

Here is the singularity command line to run the processing pipeline. 

```
singularity run \
  --cleanenv \
  --bind <freesurfer_license_file>:/usr/local/freesurfer/license.txt \
  --home <inputs_dir> \
  --bind <inputs_dir>:/INPUTS \
  --bind <outputs_dir>:/OUTPUTS \
  <container_path> \
  --t1_nii /INPUTS/T1.nii.gz \
  --project UNK_PROJ \
  --subject UNK_PROJ \
  --session UNK_PROJ \
  --scan UNK_PROJ \
  --outdir /OUTPUTS
```

## Options line by line

```
--contain
--containall
```
Do NOT use these options. Freesurfer uses temporary space in /dev/shm in the 
container filesystem. The container itself does not have enough free space, so 
this must be bound to a location on the host. Typical install of singularity 
do this by default behind the scenes.

`--cleanenv`
Avoid any confusion caused by host environment variables, especially if any of 
Freesurfer, FSL, Matlab runtime are installed on the host.

`--bind <freesurfer_license_file>:/usr/local/freesurfer/license.txt`
Freesurfer will not run without a license file present, and no license file is
provided in the container. A license file on the host must be bound to this
location in the container.

`--home <inputs_dir>`
The Matlab runtime will use the home directory in the container for temporary 
files. There is not enough headroom for this in the container itself, so we 
provide a location on the host. If two running containers use the same 
location, there will be collisions, so <inputs_dir> should be unique for each 
running container.

```
--bind <inputs_dir>:/INPUTS
--bind <outputs_dir>:/OUTPUTS
```
Default means of passing files in and retrieving outputs is to create these two
directories on the host and bind them like so.

`--t1_nii /INPUTS/T1.nii.gz`
The T1 weighted image that will be processed, in the container filesystem. Only 
the compressed Nifti format is supported. This argument is optional - if not 
supplied, the default is the path shown here.

```
--project UNK_PROJ
--subject UNK_PROJ
--session UNK_PROJ
--scan UNK_PROJ
```
Labels for project, subject, session, and scan which are useful in the context
of XNAT. These are optional, with the default values shown here. They do not
affect processing but do appear on the PDF report pages.

`--outdir /OUTPUTS`
All outputs will be stored in this location in the container filesystem. They 
can be accessed from the host assuming this directory is bound as shown above. 
This argument is optional, with the default shown here.


## Inputs

See `--t1_nii` above.


## Outputs

All outputs are stored in <outputs_dir>.

PDF
PDF_DETAIL
SUBJECT
NII_NU
NII_ASEG
NII_WMPARC
NII_THALAMUS
NII_BRAINSTEM
NII_HIPP_AMYG

