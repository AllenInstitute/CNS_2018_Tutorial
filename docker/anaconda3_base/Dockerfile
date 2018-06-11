FROM continuumio/anaconda3
MAINTAINER Kael Dai <kaeld@alleninstitute.org>


# TODO: look into getting ARCH from 'arch' command
ARG ARCH=x86_64
ARG PY_VER=3.6

RUN apt-get update && apt-get install -y -qq \ 
		automake \ 
		libtool \
		build-essential \
		libncurses5-dev

# Place for source code and scripts
ENV BUILD_DIR=/home/build
RUN mkdir -p ${BUILD_DIR}

# Place for binaries and libraries
ENV INSTALL_DIR=/home/shared
RUN mkdir -p ${INSTALL_DIR}

WORKDIR ${BUILD_DIR}
COPY build_scripts/*.sh ./
RUN chmod +x *.sh

RUN conda create -y -q --name bmtk python=$PY_VER pandas h5py


# Install NEURON 
RUN ./build_NEURON.sh --build-path ${BUILD_DIR} --install-path ${INSTALL_DIR} --conda-env bmtk --nrn-latest
ENV PATH="${PATH}:${INSTALL_DIR}/$ARCH/bin"


# Install NEST
RUN ./build_NEST.sh --build-path ${BUILD_DIR} --install-path ${INSTALL_DIR} --with-nest_vars --conda-env bmtk


# Install Dipde
RUN ./build_DiPDE.sh --conda-env bmtk


# Install Tensorflow
# RUN ./build_Tensorflow.sh --conda-env bmtk


# Install bmtk
ENV BMTK_HOME=${BUILD_DIR}/bmtk
RUN mkdir -p ${BMTK_HOME}
COPY ./bmtk*.tar.gz ${BMTK_HOME}/bmtk.tar.gz


# Installs API in python
RUN /bin/bash --login -c "source activate bmtk; \
	cd ${BMTK_HOME}; \
    tar xfz bmtk.tar.gz --strip-components 1; \
    python setup.py develop"

# Compiles the neuron mechanisms for the bionet examples. May be better to let users do this step???    
# RUN /bin/bash --login -c "source activate bmtk; \
#	cd ${BMTK_HOME}/docs/examples/simulator/bionet/components/mechanisms; \
#	/home/shared/x86_64/bin/nrnivmodl modfiles"

# Tests for bmtk
#COPY test_msdk.sh .
#RUN chmod +x test_msdk.sh
#CMD ["/home/build/test_msdk.sh"]
