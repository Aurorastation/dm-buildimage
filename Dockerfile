FROM i386/ubuntu:focal.

ARG BYOND_VERSION
ARG SPACEMANDMM_VERSION
ARG RUSTG_VERSION
ARG FLYWAY_VERSION

# Install byond
RUN export BYOND_MAJOR=$(echo $BYOND_VERSION | cut -d'.' -f1) \
    && export BYOND_MINOR=$(echo $BYOND_VERSION | cut -d'.' -f2) \
    && echo "Installing BYOND ${BYOND_VERSION}, SPACEMANDMM ${SPACEMANDMM_VERSION}, RUSTG ${RUSTG_VERSION}, FLYWAY ${FLYWAY_VERSION}" \
    && apt-get update \
    && apt-get install -y curl unzip make libstdc++6 \
    && curl -L "http://www.byond.com/download/build/${BYOND_MAJOR}/${BYOND_MAJOR}.${BYOND_MINOR}_byond_linux.zip" -o byond.zip \
    && unzip byond.zip \
    && rm byond.zip \
    && cd byond \
    && sed -i 's|install:|&\n\tmkdir -p $(MAN_DIR)/man6|' Makefile \
    && make install \
    && chmod 644 /usr/local/byond/man/man6/* \
    #&& cd "$HOME" \
    #&& curl "https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}.tar.gz" -o flyway.tar.gz \
    #&& tar -xf flyway.tar.gz \
    #&& rm flyway.tar.gz \
    #&& mv "${HOME}/flyway-${FLYWAY_VERSION}" "${HOME}/flyway" \
    #&& chmod +x "${HOME}/flyway/flyway" \
    && curl -L "https://github.com/SpaceManiac/SpacemanDMM/releases/download/${SPACEMANDMM_VERSION}/dreamchecker" -o /opt/dreamchecker \
    && chmod +x /opt/dreamchecker \
    && mkdir -p $HOME/.byond/bin \
    && curl -L "https://github.com/Aurorastation/rust-g/releases/download/${RUSTG_VERSION}/librust_g.so" -o $HOME/.byond/bin/librust_g.so \
    && chmod +x $HOME/.byond/bin/librust_g.so \
    && ln -s $HOME/.byond/bin/librust_g.so /usr/local/lib/librust_g.so \
    && apt-get purge -y --auto-remove unzip make \
    && cd .. \
    && rm -rf byond byond.zip /var/lib/apt/lists/*
