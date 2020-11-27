# Docker image file that describes an Ubuntu18.04 image with PowerShell installed from Microsoft APT Repo
ARG fromTag=18.04
ARG imageRepo=ubuntu
ARG RELEASE=latest

# Docker image file that describes an Ubuntu18.04 image with PowerShell installed from Microsoft APT Repo
ARG fromTag=18.04
ARG imageRepo=ubuntu

#FROM ${imageRepo}:${fromTag} AS installer-env
FROM dpokidov/imagemagick

ARG PS_VERSION=6.2.0
ARG PS_PACKAGE=powershell_${PS_VERSION}-1.ubuntu.18.04_amd64.deb
ARG PS_PACKAGE_URL=https://github.com/PowerShell/PowerShell/releases/download/v${PS_VERSION}/${PS_PACKAGE}

# Define ENVs for Localization/Globalization
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    # set a fixed location for the Module analysis cache
    PSModuleAnalysisCachePath=/var/cache/microsoft/powershell/PSModuleAnalysisCache/ModuleAnalysisCache \
    POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-Ubuntu-18.04

# Install dependencies and clean up
#RUN apt-get update \
#    && apt-get install --no-install-recommends -y \
#    ghostscript

# Define args needed only for the labels
ARG VCS_REF="none"
ARG IMAGE_NAME=mcr.microsoft.com/powershell:ubuntu18.04
#ARG IMAGE_NAME=dpokidov/imagemagick
# copy scripts folder in to container
RUN mkdir /scripts
COPY ./scripts /scripts
#CMD /scripts/pdf-compress.sh
#RUN chmod +x /scripts/pdf-compress.sh
#ENTRYPOINT ["/scripts/pdf-compress.sh"]
ENTRYPOINT ["bash"]