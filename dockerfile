# Docker image file that describes an Ubuntu18.04 image with PowerShell installed from Microsoft APT Repo
ARG fromTag=18.04
ARG imageRepo=ubuntu
ARG RELEASE=latest

# Docker image file that describes an Ubuntu18.04 image with PowerShell installed from Microsoft APT Repo
ARG fromTag=18.04
ARG imageRepo=ubuntu

#FROM ${imageRepo}:${fromTag} AS installer-env
FROM ubuntu:18.04

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
# set TZ to get rid of error in build process
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install tzdata
ENV TZ=America/Chicago
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

RUN export LC_ALL="en_US.UTF-8"

RUN apt-get update && apt-get install -y --no-install-recommends \
    locales \
    locales-all

RUN apt-get update && apt-get install -y \
git make gcc pkg-config autoconf curl g++ && \
apt-get install -y autoconf automake autopoint autotools-dev build-essential chrpath \
cm-super-minimal debhelper dh-autoreconf dh-exec dh-strip-nondeterminism doxygen \
doxygen-latex dpkg-dev fonts-lmodern g++ g++-7 gcc gcc-7 gir1.2-harfbuzz-0.0 graphviz \
icu-devtools libann0 libasan4 libatomic1 libbz2-dev libc-dev-bin libc6-dev \
libcairo-script-interpreter2 libcairo2-dev libcdt5 libcgraph6 libcilkrts5 \
libclang1-6.0 libdjvulibre-dev libexif-dev libexpat1-dev libfftw3-bin libfftw3-dev \
libfftw3-long3 libfftw3-quad3 libfile-stripnondeterminism-perl libfontconfig1-dev \
libfreetype6-dev libgcc-7-dev libgdk-pixbuf2.0-dev libglib2.0-dev libglib2.0-dev-bin \
libgraphite2-dev libgts-0.7-5 libgvc6 libgvpr2 libharfbuzz-dev libharfbuzz-gobject0 \
libice-dev libilmbase-dev \
tex-common texlive-base texlive-binaries texlive-extra-utils texlive-font-utils \
texlive-fonts-recommended texlive-latex-base texlive-latex-extra \
texlive-latex-recommended texlive-pictures \
libitm1 libjbig-dev libjpeg-dev libjpeg-turbo8-dev libjpeg8-dev liblab-gamut1 \
liblcms2-dev liblqr-1-0-dev liblsan0 libltdl-dev liblzma-dev libmime-charset-perl \
libmpx2 libopenexr-dev libpango1.0-dev libpathplan4 libpcre16-3 libpcre3-dev \
libpcre32-3 libpcrecpp0v5 libperl-dev libpixman-1-dev libpng-dev libpotrace0 \
libptexenc1 libpthread-stubs0-dev libquadmath0 librsvg2-bin \
librsvg2-dev libsigsegv2 libsm-dev libsombok3 libstdc++-7-dev \
libtiff-dev libtiff5-dev libtiffxx5 libtool libtool-bin \
libtsan0 libubsan0 libunicode-linebreak-perl libwmf-dev libx11-dev libxau-dev \
libxcb-render0-dev libxcb-shm0-dev libxcb1-dev libxdmcp-dev libxext-dev libxft-dev \
libxml2-dev libxml2-utils libxrender-dev libxt-dev libzzip-0-13 linux-libc-dev m4 \
make pkg-config pkg-kde-tools po-debconf preview-latex-style \
x11proto-core-dev x11proto-dev \
x11proto-xext-dev xorg-sgml-doctools xsltproc xtrans-dev zlib1g-dev \
checkinstall libwebp-dev libopenjp2-7-dev librsvg2-dev libde265-dev libheif-dev \
libapt-pkg5.0 libc-bin libc6 \
cmake yasm 

RUN cd $home 
RUN git clone https://aomedia.googlesource.com/aom && \
mkdir build_aom && \
cd build_aom && \
cmake ../aom/ -DENABLE_TESTS=0 -DBUILD_SHARED_LIBS=1 && make && make install && ldconfig /usr/local/lib && cd .. && \
curl -L https://github.com/strukturag/libheif/releases/download/v1.9.1/libheif-1.9.1.tar.gz -o libheif.tar.gz && \
tar -xzvf libheif.tar.gz && \
cd libheif-1.9.1 && \
./autogen.sh && ./configure && make && make install && cd .. && ldconfig /usr/local/lib

RUN cd $home 
RUN git clone https://github.com/ImageMagick/ImageMagick.git && cd ImageMagick && \
 ls && \
 ./configure --with-rsvg && \
 make && \
 make install && \
 make distclean && \
 ldconfig

# Define args needed only for the labels
ARG VCS_REF="none"
ARG IMAGE_NAME=mcr.microsoft.com/powershell:ubuntu18.04
#ARG IMAGE_NAME=dpokidov/imagemagick
# copy scripts folder in to container
RUN mkdir /scripts
COPY ./scripts /scripts
RUN chmod -r /scripts
#CMD /scripts/pdf-compress.sh
#RUN chmod +x /scripts/pdf-compress.sh
#ENTRYPOINT ["/scripts/pdf-compress.sh"]
ENTRYPOINT ["bash"]