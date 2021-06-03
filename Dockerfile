FROM ubuntu:18.04

### SYSTEM DEPENDENCIES

ENV DEBIAN_FRONTEND="noninteractive" \
  LC_ALL="en_US.UTF-8" \
  LANG="en_US.UTF-8"

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y --no-install-recommends \
    build-essential \
    dirmngr \
    git \
    bzr \
    mercurial \
    gnupg2 \
    curl \
    wget \
    file \
    zlib1g-dev \
    liblzma-dev \
    tzdata \
    zip \
    unzip \
    locales \
    openssh-client \
  && locale-gen en_US.UTF-8


### RUBY

# Install Ruby 2.6.6, update RubyGems, and install Bundler
ENV BUNDLE_SILENCE_ROOT_WARNING=1
RUN apt-get install -y software-properties-common \
  && apt-add-repository ppa:brightbox/ruby-ng \
  && apt-get update \
  && apt-get install -y ruby2.6 ruby2.6-dev \
  && gem update --system 3.0.3 \
  && gem install bundler -v 1.17.3 --no-document

### DART

# Install Dart 
ENV PUB_CACHE=/opt/dart-sdk/.pub-cache \
  PUB_ENVIRONMENT="dependabot" \
  PATH="${PATH}:/opt/dart-sdk/.pub-cache/bin" \
  PATH="${PATH}:/opt/dart-sdk/bin"
RUN curl --connect-timeout 15 --retry 5 "https://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-linux-x64-release.zip" > "${HOME}/dartsdk.zip" \
  && unzip "${HOME}/dartsdk.zip" -d "/opt" > /dev/null \
  && rm "${HOME}/dartsdk.zip" \
  && dart --version
  
# Install Flutter
ENV PATH="${PATH}:/opt/flutter/bin"
RUN git clone https://github.com/flutter/flutter.git -b stable "/opt/flutter" && flutter precache && flutter --version

### PUB

# Clone Dependabot Pub

RUN git clone --branch project/pub-dart https://github.com/simpleclub-extended/dependabot-core /home/app/dependabot-core

# Setup Update Script

COPY update-pub.rb /home/app/dependabot-pub-runner/update-pub.rb
COPY Gemfile /home/app/dependabot-pub-runner/Gemfile
WORKDIR /home/app/dependabot-pub-runner
RUN bundle install --path vendor

# Action Entrypoint

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
