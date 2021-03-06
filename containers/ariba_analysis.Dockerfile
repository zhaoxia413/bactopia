FROM nfcore/base:1.12.1

LABEL base.image="nfcore/base:1.12.1"
LABEL software="Bactopia - ariba_analysis"
LABEL software.version="1.6.0"
LABEL description="A flexible pipeline for complete analysis of bacterial genomes"
LABEL website="https://bactopia.github.io/"
LABEL license="https://github.com/bactopia/bactopia/blob/master/LICENSE"
LABEL maintainer="Robert A. Petit III"
LABEL maintainer.email="robert.petit@emory.edu"
LABEL conda.env="bactopia/conda/linux/ariba_analysis.yml"
LABEL conda.md5="54d138b3a3e063df6be719e10d3522cd"

COPY conda/linux/ariba_analysis.yml /
RUN conda env create -q -f ariba_analysis.yml && conda clean -y -a
ENV PATH /opt/conda/envs/bactopia-ariba_analysis/bin:$PATH
