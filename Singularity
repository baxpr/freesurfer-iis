Bootstrap: docker
From: centos:7.5.1804

%help

Freesurfer 201811 development version. Runs recon-all plus hippocampus, thalamus, 
brainstem modules. Requires a valid license file at runtime - example:
  --bind /where/is/freesurfer_license.txt:/usr/local/freesurfer/license.txt

Do not use singularity's --contain flag when running, as this will cause problems
with Freesurfer's use of temp storage.


%files

  # Freesurfer development version, if we are going to download manually and 
  # reference a local copy during the build
  # https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/dev/freesurfer-linux-centos7_x86_64-dev.tar.gz
  freesurfer-linux-centos7_x86_64-dev.tar.gz /usr/local

  # Matlab runtime, if we are going to download manually and reference a local 
  # copy during the build
  # http://ssd.mathworks.com/supportfiles/downloads/R2014b/deployment_files/R2014b/installers/glnxa64/MCR_R2014b_glnxa64_installer.zip
  MCR_R2014b_glnxa64_installer.zip /opt

  # Default run scripts
  runscripts /opt


%post
  
  # For installs
  yum -y install unzip wget
  
  # For Freesurfer
  yum -y install tcsh bc mesa-libGLU libgomp perl
  
  # For matlab runtime
  yum -y install java-1.8.0-openjdk
  
  # For X
  yum -y install xorg-x11-server-Xvfb xorg-x11-xauth which
  #xorg-x11-fonts-Type1 xorg-x11-fonts-75dpi
  
  # Install Freesurfer
  #wget -nv -P /usr/local https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/dev/freesurfer-linux-centos7_x86_64-dev.tar.gz
  cd /usr/local
  tar -zxf freesurfer-linux-centos7_x86_64-dev.tar.gz
  rm freesurfer-linux-centos7_x86_64-dev.tar.gz

  # Matlab runtime for brainstem, hippocampus, thalamus modules
  #wget -nv -P /opt http://ssd.mathworks.com/supportfiles/downloads/R2014b/deployment_files/R2014b/installers/glnxa64/MCR_R2014b_glnxa64_installer.zip
  unzip /opt/MCR_R2014b_glnxa64_installer.zip -d /opt/MCR_R2014b_glnxa64_installer > /opt/MCR_unzip.log
  /opt/MCR_R2014b_glnxa64_installer/install -mode silent -agreeToLicense yes
  rm -r /opt/MCR_R2014b_glnxa64_installer
  rm /opt/MCR_R2014b_glnxa64_installer.zip /opt/MCR_unzip.log

  # Tell freesurfer where to find the MCR
  ln -s /usr/local/MATLAB/MATLAB_Compiler_Runtime/v84 /usr/local/freesurfer/MCRv84

  # Create input/output directories for binding
  mkdir /INPUTS && mkdir /OUTPUTS


%environment

  # Freesurfer
  export FREESURFER_HOME=/usr/local/freesurfer


%runscript
  xvfb-run --server-num=$(($$ + 99)) \
  --server-args='-screen 0 1600x1200x24 -ac +extension GLX' \
  bash /opt/runscripts/run_everything.sh "$@"

