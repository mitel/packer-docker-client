FROM hashicorp/packer

ENV DOCKER_CHANNEL stable
ENV DOCKER_VERSION 17.06.2-ce
ENV CLOUD_SDK_VERSION 170.0.1
ENV PATH /google-cloud-sdk/bin:$PATH

RUN apk update && apk upgrade && \
    apk add --no-cache \
    make \
    gcc \
    g++ \
    python \
    py-crcmod \
    bash \
    libc6-compat \
    openssh-client \
    git \
    curl \
    tar \
    gzip \
    jq

# Docker client
RUN set -x && \
    # curl -L -o /tmp/docker-$DOCKER_VERSION.tgz https://get.docker.com/builds/Linux/x86_64/docker-$DOCKER_VERSION.tgz && \
    curl -fL -o /tmp/docker-$DOCKER_VERSION.tgz "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/${dockerArch}/docker-${DOCKER_VERSION}.tgz" && \
    # tar -x -C /tmp -f /tmp/docker-$DOCKER_VERSION.tgz && \
    tar --extract \
    	--file /tmp/docker-$DOCKER_VERSION.tgz \
	--strip-components 1 \
	--directory /usr/local/bin/ && \
    rm /tmp/docker-$DOCKER_VERSION.tgz
    # mv /tmp/docker/* /usr/bin
    
# google cloud sdk
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    ln -s /lib /lib64 && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image
    
VOLUME ["/root/.config"]
