FROM registry.redhat.io/devspaces/udi-rhel9:3.25.0-1765582207

USER root

# Set Env Vars
ENV RUBY_MAJOR_VERSION=3 \
    RUBY_MINOR_VERSION=3

ENV RUBY_VERSION="${RUBY_MAJOR_VERSION}.${RUBY_MINOR_VERSION}" \
    RUBY_SCL_NAME_VERSION="${RUBY_MAJOR_VERSION}${RUBY_MINOR_VERSION}"

ENV RUBY_SCL="ruby-${RUBY_SCL_NAME_VERSION}" \
    IMAGE_NAME="ubi9/ruby-${RUBY_SCL_NAME_VERSION}" \
    SUMMARY="Platform for building and running Ruby $RUBY_VERSION applications" \
    DESCRIPTION="Ruby $RUBY_VERSION available as container is a base platform for \
building and running various Ruby $RUBY_VERSION applications and frameworks. \
Ruby is the interpreted scripting language for quick and easy object-oriented programming. \
It has many features to process text files and to do system management tasks (as in Perl). \
It is simple, straight-forward, and extensible."

# Install Ruby
RUN dnf -y module enable ruby:$RUBY_VERSION && \
    INSTALL_PKGS=" \
    libyaml-devel \
    libffi-devel \
    ruby \
    ruby-devel \
    rubygem-rake \
    rubygem-bundler \
    ruby-bundled-gems \
    redhat-rpm-config \
    " && \
    dnf install -y --setopt=tsflags=nodocs ${INSTALL_PKGS} && \
    dnf -y clean all --enablerepo='*' && \
    ruby -v | grep -qe "^ruby $RUBY_VERSION\." && echo "Found VERSION $RUBY_VERSION" && \
    rpm -V ${INSTALL_PKGS}

# Fix Java and point to Java 21 instead of 17
RUN ln -sf /usr/lib/jvm/java-21-openjdk/* ${HOME}/.java/current

USER 10001

# Intall Quarkus CLI
RUN curl -s "https://get.sdkman.io" | bash && \
    source "$HOME/.sdkman/bin/sdkman-init.sh" && \
    sdk install quarkus 3.30.6
