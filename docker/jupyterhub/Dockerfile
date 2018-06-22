FROM bmtk/anaconda3
MAINTAINER Kael Dai <kaeld@alleninstitute.org>

ENV PYTHON_ENV=python3.6

RUN /bin/bash --login -c "source activate bmtk; \
    wget https://github.com/AllenInstitute/AllenSDK/archive/v0.13.1.tar.gz; \
    tar xvzf v0.13.1.tar.gz; \
    mv AllenSDK-0.13.1 allensdk; \
    cd allensdk; \
    python setup.py develop"


RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs; \
    npm install n -g; \
    n 8.11.2; \
    npm install -g configurable-http-proxy; \
    pip install jupyterhub oauthenticator; \
    jupyterhub --generate-config; \
    cat "c.JupyterHub.spawner_class = 'dockerspawner.SystemUserSpawner'" >> jupyterhub_config.py; \
    cat 'c.DockerSpawner.container_ip = "0.0.0.0"' >> jupyterhub_config.py; \
    git clone https://github.com/jupyterhub/dockerspawner.git; \
    cd dockerspawner; \
    pip install -r requirements.txt; \
    pip install .

# Create a user
RUN useradd user; \
    echo 'user:user' | chpasswd; \
    mkdir /home/user; \
    mkdir /home/user/workdir; \
    mkdir /home/user/workdir/saved; \
    cp -R /home/build/allensdk/doc_template/examples /home/user/workdir/allensdk_examples; \
    chown -R user.user /home/user

# Need to import mod files and compile NEURON mechanisms
RUN mkdir -p /home/user/workdir/neuron_mechanisms/modfiles

# TODO: Change kaeldai repo to appropiate one
RUN cd /home/shared; \
    git clone https://github.com/kaeldai/CNS_2018_Tutorial; \
    cp -r CNS_2018_Tutorial/bmtk /home/user/workdir; \
    cp -r CNS_2018_Tutorial/resources /home/user/workdir; \
    chown -R user.user /home/user/workdir/bmtk

RUN /bin/bash --login -c "source activate bmtk; \
    cd /home/user/workdir/bmtk/biophysical_notebook/components/mechanisms; \
    /home/shared/x86_64/bin/nrnivmodl modfiles"

# For testing and development, should remove
COPY ./mechanisms/modfiles/*.mod /home/user/workdir/neuron_mechanisms/modfiles/
RUN /bin/bash --login -c "source activate bmtk; \
    cd /home/user/workdir/neuron_mechanisms; \
    /home/shared/x86_64/bin/nrnivmodl modfiles"

# Install bmtk environment kernel
RUN conda install nb_conda
RUN /bin/bash --login -c "source activate bmtk; \
    conda install -y jupyter ipython ipykernel; \
    python -m ipykernel install --user --name bmkt --display-name 'bmtk'"

EXPOSE 8888

# Taken from /home/shared/nest/bin/nest_vars.sh, needed to run nest and pynest in jupyter
ENV NEST_INSTALL_DIR=/home/shared/nest
ENV NEST_DATA_DIR=${NEST_INSTALL_DIR}/share/nest
ENV NEST_DOC_DIR=${NEST_INSTALL_DIR}/share/doc/nest
ENV NEST_MODULE_PATH=${NEST_INSTALL_DIR}/lib/nest
ENV NEST_PYTHON_PREFIX=${NEST_INSTALL_DIR}/lib/${PYTHON_ENV}/site-packages
ENV PYTHONPATH=${NEST_PYTHON_PREFIX}:${PYTHONPATH}
ENV PATH=${NEST_INSTALL_DIR}/bin:$PATH

CMD ["jupyterhub", "--ip=0.0.0.0", "--Spawner.notebook_dir=workdir"]