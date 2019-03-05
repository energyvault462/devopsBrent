FROM ubuntu
MAINTAINER brentj433@gmail.com


RUN apt-get update && apt-get -y dist-upgrade && apt-get -y clean
RUN apt-get -y install open-vm-tools nfs-common ssh build-essential python-dev libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev git curl nano

ENV GOROOT /goroot
ENV GOPATH /gopath
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin


ARG GOVERSION
RUN mkdir /goroot && curl -O https://storage.googleapis.com/golang/go$GOVERSION.linux-amd64.tar.gz \
 && tar -xvf go$GOVERSION.linux-amd64.tar.gz -C /goroot --strip-components=1 \
 && rm go$GOVERSION.linux-amd64.tar.gz

# Create custom user
RUN useradd -u 1001 -ms /bin/bash brent && \
	 echo "brent ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER brent
ENV USER brent
ENV PATH $HOME:$PATH
ENV DOCKER true
WORKDIR  /home/brent

CMD ["/bin/bash"]
