FROM anapsix/alpine-java
LABEL maintainer="Avinash Kumar <avirias@live.com>"

ENV LANG "en_US.UTF-8"
ENV LANGUAGE "en_US.UTF-8"
ENV LC_ALL "en_US.UTF-8"

ENV ANDROID_HOME "/android-sdk"
ENV ANDROID_COMPILE_SDK "31"
ENV ANDROID_BUILD_TOOLS "31.0.3"
ENV PATH "$PATH:${ANDROID_HOME}/platform-tools"

RUN apk update && \
    apk add --no-cache \
        git \
        bash \
        curl \
        wget \
        zip \
        unzip \
        ruby \
        ruby-rdoc \
        ruby-irb \
        ruby-dev \
        openssh \
        g++ \
        make \
    && rm -rf /tmp/* /var/tmp/*

RUN apk --no-cache add ca-certificates wget

RUN gem install fastlane -NV

ADD https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_TOOLS}.zip sdk-tools-linux.zip

RUN unzip sdk-tools-linux.zip -d ${ANDROID_HOME} && \
    rm sdk-tools-linux.zip && \
    echo y | ${ANDROID_HOME}/tools/bin/sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" "build-tools;${ANDROID_BUILD_TOOLS}"

ADD https://github.com/firebase/firebase-tools/releases/download/v11.0.1/firebase-tools-linux firebase-tools-linux
RUN chmod +x firebase-tools-linux
RUN ./firebase-tools-linux --open-sesame appdistribution
