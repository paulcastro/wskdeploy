FROM golang:1.7

# Install zip
RUN apt-get -y update && \
    apt-get -y install zip emacs

ENV GOPATH=/

# Download and install tools
RUN echo "Installing the godep tool"
RUN go get github.com/tools/godep

ADD . /src/github.com/openwhisk/openwhisk-wskdeploy

# Load all of the dependencies from the previously generated/saved godep generated godeps.json file
RUN echo "Restoring Go dependencies"
RUN cd /src/github.com/openwhisk/openwhisk-wskdeploy && /bin/godep restore -v

# All of the Go CLI binaries will be placed under a build folder
RUN mkdir /src/github.com/openwhisk/openwhisk-wskdeploy/build

ARG WSKDEPLOY_OS
ARG WSKDEPLOY_ARCH

# Build the Go wsk CLI binaries and compress resultant binaries
RUN chmod +x /src/github.com/openwhisk/openwhisk-wskdeploy/build.sh
RUN cd /src/github.com/openwhisk/openwhisk-wskdeploy/ && ./build.sh
