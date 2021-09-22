# Base freesurfer Dockerfile lines from
# https://github.com/jhuguetn/freesurfer/blob/22634439/Dockerfile
# It shows the centos package dependencies, and how to set up the freesurfer
# environment without running the SetUpFreeSurfer.sh script.

# Use multi-stage build to let us install things from local .tar.gz files
# without blowing up the size of the final container

# Initial update and utils
FROM centos:7 AS init
RUN yum -y update && \
    yum -y install wget tar zip unzip && \
    yum clean all

# Freesurfer
# https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/7.2.0/freesurfer-linux-centos7_x86_64-7.2.0.tar.gz
FROM init AS freesurfer
COPY external/freesurfer-linux-centos7_x86_64-7.2.0.tar.gz /opt/freesurfer.tar.gz
RUN tar -zxf /opt/freesurfer.tar.gz -C /usr/local
RUN /usr/local/freesurfer/bin/fs_install_mcr R2014b

# fslstats
# https://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-6.0.4-centos7_64.tar.gz
FROM init AS fsl
COPY external/fsl-6.0.4-centos7_64.tar.gz /opt/fsl.tar.gz
RUN tar -zxf /opt/fsl.tar.gz -C /usr/local fsl/bin/fslstats


# Everything else
FROM init
COPY --from=freesurfer /usr/local/freesurfer /usr/local/
COPY --from=fsl /usr/local/fsl /usr/local/


# freesurfer
#RUN wget https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/7.2.0/freesurfer-linux-centos7_x86_64-7.2.0.tar.gz -O fs.tar.gz && \
#    tar -zxf fs.tar.gz -C /usr/local && \
#    rm fs.tar.gz

# setup fs env
ENV OS Linux
ENV PATH /opt/fs-extensions/src:/usr/local/freesurfer/bin:/usr/local/freesurfer/fsfast/bin:/usr/local/freesurfer/tktools:/usr/local/freesurfer/mni/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
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

# mni env requirements
ENV MINC_BIN_DIR /usr/local/freesurfer/mni/bin
ENV MINC_LIB_DIR /usr/local/freesurfer/mni/lib
ENV MNI_DIR /usr/local/freesurfer/mni
ENV MNI_DATAPATH /usr/local/freesurfer/mni/data
ENV MNI_PERL5LIB /usr/local/freesurfer/mni/share/perl5
ENV PERL5LIB /usr/local/freesurfer/mni/share/perl5

# Matlab runtime for freesurfer
#RUN fs_install_mcr R2014b

# fslstats
#RUN wget -nv https://fsl.fmrib.ox.ac.uk/fsldownloads/fsl-6.0.4-centos7_64.tar.gz -O fsl.tar.gz && \
#    tar -zxf fsl.tar.gz -C /usr/local fsl/bin/fslstats && \
#    rm fsl.tar.gz


# fs?
# bc libgomp perl tcsh vim-common mesa-libGL libXext libSM libXrender libXmu
#   or
# tcsh bc mesa-libGLU libgomp perl mesa-dri-drivers libicu java-1.8.0-openjdk

# Remaining utils for freesurfer, FSL, ImageMagick, X
RUN yum -y install tcsh bc mesa-libGLU libgomp perl mesa-dri-drivers libicu java-1.8.0-openjdk && \
    yum -y install epel-release openblas-devel && \
    yum -y install ImageMagick && \
    yum -y install xorg-x11-server-Xvfb xorg-x11-xauth which && \
    yum clean all


# Additional code for generating PDF etc
COPY README.md /opt/fs-extensions/
COPY src /opt/fs-extensions/
 