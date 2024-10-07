#----------
# install base image (ubuntu:22.04)
#----------
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NOWARNINGS=yes
ENV PATH="/usr/local/texlive/bin:$PATH"
ENV LC_ALL=C


#----------
# install packages and clean up
#----------
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    make \
    ca-certificates \
    gnupg2 \
    python3 \
    python3-pip \
    libfreetype6-dev \
    ghostscript \
    perl \
    perl-modules \
    cpanminus \
    git \
    less \
    unzip \
    poppler-utils \
    software-properties-common && \
    # install "GCString" module with cpanm
    cpanm --notest Unicode::GCString && \
    # install "pygments" for minted
    pip3 install --no-cache-dir pygments && \
    # add repository for Node.js & Inkscape
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    NODE_MAJOR=20 && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" > /etc/apt/sources.list.d/nodesource.list && \
    add-apt-repository -y ppa:inkscape.dev/stable && \
    apt-get update && \
    apt-get install -y --no-install-recommends inkscape nodejs && \
    # install textlint with npm
    npm install -g textlint && \
    npm cache clean --force && \
    # clean up unnecessary packages
    apt-get remove -y --purge \
    software-properties-common \
    build-essential \
    unzip \
    make \
    gnupg2 \
    less && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*


#----------
# install TeX Live 2024
#----------
# define TeXLive version and CTAN mirror
ARG TEXLIVE_VERSION=2024
# ARG TEXLIVE_MIRROR="https://ftp.jaist.ac.jp/pub/CTAN/systems/texlive/tlnet/"
ARG TEXLIVE_MIRROR="https://mirror.ctan.org/systems/texlive/tlnet/"

# install TeXLive from CTAN mirror
RUN mkdir /tmp/install-tl-unx && \
    curl -L ${TEXLIVE_MIRROR}/install-tl-unx.tar.gz | tar -xzv -C /tmp/install-tl-unx --strip-components=1 && \
    /bin/echo -e 'selected_scheme scheme-basic\ntlpdbopt_install_docfiles 0\ntlpdbopt_install_srcfiles 0' \
        > /tmp/install-tl-unx/texlive.profile && \
    /tmp/install-tl-unx/install-tl \
        --repository ${TEXLIVE_MIRROR}/ \
        -profile /tmp/install-tl-unx/texlive.profile && \
    rm -r /tmp/install-tl-unx && \
    ln -sf /usr/local/texlive/${TEXLIVE_VERSION}/bin/$(uname -m)-linux /usr/local/texlive/bin


#----------
# install LaTeX collections & packages with tlmgr
#----------
RUN tlmgr update --repository ${TEXLIVE_MIRROR} --self --all && \
    tlmgr --repository ${TEXLIVE_MIRROR} install \
        collection-bibtexextra \
        collection-latexextra \
        collection-latexrecommended \
        collection-luatex \
        collection-langjapanese \
        collection-mathscience \
        collection-pictures \
        latexmk \
        latexdiff \
        latexindent && \
    mktexlsr

#----------
# install create_font_cache.sh
#----------
RUN	curl -L -O https://raw.githubusercontent.com/being24/latex-docker/master/create_font_cache.sh && \
    chmod +x create_font_cache.sh && \
    ./create_font_cache.sh && \
    rm create_font_cache.sh && \
    useradd -m -u 1000 -s /bin/bash latex
        
#----------
# set working directry
#----------
WORKDIR /workdir
