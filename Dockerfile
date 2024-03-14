# Base freesurfer Dockerfile lines from
# https://github.com/jhuguetn/freesurfer/blob/22634439/Dockerfile
# It shows the centos package dependencies, and how to set up the freesurfer
# environment without running the SetUpFreeSurfer.sh script.

# Initial update and utils
FROM centos:7
RUN yum -y update && \
    yum -y install wget tar zip unzip && \
    yum clean all

# Freesurfer
# Also see https://surfer.nmr.mgh.harvard.edu/fswiki/rel7downloads
RUN wget -O /opt/freesurfer.tar.gz \      
    https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/7.4.1/freesurfer-linux-centos7_x86_64-7.4.1.tar.gz && \
    tar --no-same-owner -zxf /opt/freesurfer.tar.gz -C /usr/local && \
    rm /opt/freesurfer.tar.gz
ENV FREESURFER_HOME /usr/local/freesurfer
RUN ${FREESURFER_HOME}/bin/fs_install_mcr R2014b

# fslstats
# Also see https://fsl.fmrib.ox.ac.uk/fsldownloads/manifest.csv
RUN wget -O /opt/fsl.tar.gz \
    https://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-6.0.5.2-centos7_64.tar.gz && \
    tar --no-same-owner -zxf /opt/fsl.tar.gz -C /usr/local fsl/bin/fslstats && \
    rm /opt/fsl.tar.gz

# Remaining utils for freesurfer, FSL, ImageMagick, X. Installed here rather
# than earlier to take advantage of layer caching for debug/dev
# bc libgomp perl tcsh vim-common mesa-libGL libXext libSM libXrender libXmu
# java-1.8.0-openjdk                 reqd for MCR
# mesa-libGLU mesa-dri-drivers       reqd for fs under xvfb
# epel-release must be installed BEFORE openblas
RUN yum -y install epel-release && \
    yum -y install bc libgomp perl tcsh vim-common mesa-libGL && \
    yum -y install libXext libSM libXrender libXmu && \
    yum -y install mesa-libGLU mesa-dri-drivers libxkbcommon-x11 && \
    yum -y install java-1.8.0-openjdk && \
    yum -y install openblas-devel && \
    yum -y install ImageMagick && \
    yum -y install xorg-x11-server-Xvfb xorg-x11-xauth which && \
    yum clean all

# Install python3 and add needed modules. Note that making python3 
# the system default breaks yum, so we won't do that. Rather, spec
# python3 in the first line of python scripts
RUN yum -y install python3 && \
    yum clean all && \
    pip3 install pandas numpy nibabel

# setup fs env
ENV OS Linux
ENV FREESURFER_HOME /usr/local/freesurfer
ENV FREESURFER /usr/local/freesurfer
ENV SUBJECTS_DIR /usr/local/freesurfer/subjects
ENV LOCAL_DIR /usr/local/freesurfer/local
ENV FSFAST_HOME /usr/local/freesurfer/fsfast
ENV FMRI_ANALYSIS_DIR /usr/local/freesurfer/fsfast
ENV FUNCTIONALS_DIR /usr/local/freesurfer/sessions

# set default fs options
ENV FS_OVERRIDE 0
ENV FIX_VERTEX_AREA ""
ENV FSF_OUTPUT_FORMAT nii.gz

# Quiet warnings
ENV XDG_RUNTIME_DIR /tmp

# mni env requirements
ENV MINC_BIN_DIR /usr/local/freesurfer/mni/bin
ENV MINC_LIB_DIR /usr/local/freesurfer/mni/lib
ENV MNI_DIR /usr/local/freesurfer/mni
ENV MNI_DATAPATH /usr/local/freesurfer/mni/data
ENV MNI_PERL5LIB /usr/local/freesurfer/mni/share/perl5
ENV PERL5LIB /usr/local/freesurfer/mni/share/perl5

# Path
ENV PATHEXT /opt/fs-extensions/src
ENV PATHFSL /usr/local/fsl/bin
ENV PATHFS1 /usr/local/freesurfer/bin:/usr/local/freesurfer/fsfast/bin
ENV PATHFS2 /usr/local/freesurfer/tktools:/usr/local/freesurfer/mni/bin
ENV PATHSYS /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PATH ${PATHEXT}:${PATHFSL}:${PATHFS1}:${PATHFS2}:${PATHSYS}

# Additional code for generating outputs
COPY README.md /opt/fs-extensions/
COPY src /opt/fs-extensions/src

# Entrypoint
ENTRYPOINT ["xwrapper.sh","run_everything.sh"]
