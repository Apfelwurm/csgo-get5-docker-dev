#######################################################
#        csgo-get5-docker-dev Dockerfile              #
#######################################################
##  Dev Docker image containing CSGO srcds with Get5 ##
#######################################################
#    github.com/Apfelwurm/csgo-get5docker-dev         #
#######################################################

FROM debian:buster-slim

###################
# LABELLING #
###################
# Label this image with the image version and installed CSGO version
# To get the version of the latest CSGO patch, run
# curl -s "http://api.steampowered.com/ISteamApps/UpToDateCheck/v1?appid=730&version=0" | jq .response.required_version
ARG CSGO_VERSION=13857
LABEL csgo_version=$CSGO_VERSION
LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.url="https://volzit.de" \
      org.label-schema.vcs-ref=$SOURCE_COMMIT \
      org.label-schema.vendor="volzit" \
      org.label-schema.description="Docker image for deploying a dev CS:GO server for Get5" \
      org.label-schema.vcs-url="https://github.com/Apfelwurm/csgo-get5-docker"

###############
# CREATE USER #
###############
RUN useradd -m user

################
# INSTALL CSGO #
################

ENV HOME_DIR=/home/user \
    STEAMCMD_DIR=/home/user/Steam \
    CSGO_DIR=/home/user/csgo-server \
    STEAMCMD_URL=https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    STEAMWORKS_VER=1.2.3c \
    METAMOD_VER=1.12 \
    SOURCEMOD_VER=1.11 \
    GET5_VER=0.11.0-adeb187 \
    GET5_APISTATS=FALSE

WORKDIR $HOME_DIR
COPY --chown=user --chmod=755 server-scripts/server-update.sh $HOME_DIR/
RUN apt-get -qq update \
    && apt-get -qq install -y --no-install-recommends --no-install-suggests \
        lib32gcc1 \
        ca-certificates \
        wget \
        lib32stdc++6 \
        unzip \
        rsync \
        jq

RUN su user -c " mkdir $STEAMCMD_DIR $CSGO_DIR"
RUN su user -c " wget -q -O - $STEAMCMD_URL | tar -zx -C $STEAMCMD_DIR "
RUN su user -c " bash $HOME_DIR/server-update.sh "

RUN apt-get -qq autoremove -y \
    && apt-get -qq clean \
    && rm -rf /var/lib/apt/lists/*

######################
# COPY LAUNCH SCRIPT #
######################
COPY --chown=user --chmod=755 server-scripts/server-launch.sh $HOME_DIR/

###################
# CHECK LABELLING #
###################
# Check that the installed version of CSGO matches the label of this image
RUN INSTALLED_VERSION="$(sed -rn 's/PatchVersion=([0-9]+).([0-9]+).([0-9]+).([0-9]+)/\1\2\3\4/p' $CSGO_DIR/csgo/steam.inf)" \
    && if [ $INSTALLED_VERSION -ne $CSGO_VERSION ]; then \
       echo "ERROR: Please update the CSGO version label to match the installed version. Labelled: $CSGO_VERSION / Installed: $INSTALLED_VERSION" >&2; \
       exit 1; \
    fi

############
# RUN CSGO #
############
ENV UPDATE_ON_LAUNCH=1
CMD ["bash", "server-launch.sh"]