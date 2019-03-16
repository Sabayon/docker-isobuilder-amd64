# Sabayon ISO Builder image
ARG USER=sabayon
ARG CUSTOM_IMAGE_PREFIX=

# Set arch
ARG TARGET_ARCH=amd64
FROM ${USER}/${CUSTOM_IMAGE_PREFIX}base-${TARGET_ARCH}

LABEL maintainer="Daniele Rondina <geaaru@sabayonlinux.org>"

# Add sabayon-stuff files
ADD ./scripts/sabayon_molecules.sh /sabayon_molecules.sh

# Set locales to en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

ARG SABAYON_MOLECULES_DIR=/sabayon
ENV SABAYON_MOLECULES_DIR=${SABAYON_MOLECULES_DIR}
ARG SABAYON_MOLECULES_GITURL=https://github.com/Sabayon/molecules.git
ENV SABAYON_MOLECULES_GITURL=${SABAYON_MOLECULES_GITURL}
ARG SABAYON_MOLECULES_GIT_OPTS=
ENV SABAYON_MOLECULES_GIT_OPTS=${SABAYON_MOLECULES_GIT_OPTS}
ARG SABAYON_MOLECULES_ENVFILE=
ENV SABAYON_MOLECULES_ENVFILE=${SABAYON_MOLECULES_ENVFILE}

ARG CACHEBUST=1
RUN chmod a+x /sabayon_molecules.sh && \
      /sabayon_molecules.sh init && \
      /sabayon_molecules.sh phase1 && \
      /sabayon_molecules.sh clean

# Set environment variables.
ENV HOME ${SABAYON_MOLECULES_DIR}

# Define working directory.
WORKDIR ${SABAYON_MOLECULES_DIR}

# Docker service requirement for systemd mode.
#VOLUME ["/sys/fs/cgroup"]

# Define default command.
ENTRYPOINT ["/usr/bin/tini", "-s", "--", "/sabayon_molecules.sh", "run"]

