#----------
# install base image (ghcr.io/hirotnk1118/docker-test-base)
#----------
FROM ghcr.io/hirotnk1118/docker-test-base:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NOWARNINGS=yes
ENV PATH="/usr/local/texlive/bin:$PATH"
ENV LC_ALL=C


#----------
# install TeX Live 2024
#----------
# define TeXLive version and CTAN mirror
ARG TEXLIVE_VERSION=2024
ARG TEXLIVE_MIRROR="https://us.mirrors.cicku.me/ctan/systems/texlive/tlnet"
# ARG TEXLIVE_MIRROR="https://mirror.ctan.org/systems/texlive/tlnet"

# install TeXLive from CTAN mirror
RUN mkdir /tmp/install-tl-unx && \
    curl -L ${TEXLIVE_MIRROR}/install-tl-unx.tar.gz | tar -xzv -C /tmp/install-tl-unx --strip-components=1 && \
    /bin/echo -e 'selected_scheme scheme-basic\ntlpdbopt_install_docfiles 0\ntlpdbopt_install_srcfiles 0' \
        > /tmp/install-tl-unx/texlive.profile && \
    /tmp/install-tl-unx/install-tl \
        --repository ${TEXLIVE_MIRROR} \
        -profile /tmp/install-tl-unx/texlive.profile && \
    rm -r /tmp/install-tl-unx && \
    ln -sf /usr/local/texlive/${TEXLIVE_VERSION}/bin/$(uname -m)-linux /usr/local/texlive/bin


#----------
# install LaTeX collections & packages with tlmgr
#----------
RUN tlmgr update --self --all && \
    tlmgr install \
        # collection-bibtexextra \
        collection-latexextra \
        collection-latexrecommended \
        collection-luatex \
        collection-langjapanese \
        collection-mathscience \
        collection-pictures \
        latexmk \
        latexdiff \
        stix2-otf \
        latexindent && \
    mktexlsr


#----------
# install create_font_cache.sh
#----------
RUN	curl -L -O https://raw.githubusercontent.com/being24/latex-docker/master/create_font_cache.sh && \
    chmod +x create_font_cache.sh && \
    ./create_font_cache.sh && \
    rm create_font_cache.sh


#----------
# set user and working directry
#----------
RUN useradd -m -s /bin/bash latex
USER latex
WORKDIR /workdir
