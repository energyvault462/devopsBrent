# modified from dan9186/docker-dan9186
FROM ubuntu
MAINTAINER brentj433@gmail.com


RUN apt-get update && apt-get -y dist-upgrade && apt-get -y clean && apt-get -y autoremove
RUN apt-get update && apt-get -y install nfs-common ssh build-essential python-dev libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev git curl nano go-dep

ENV GOROOT /goroot
ENV GOPATH /gopath
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

ARG CURRENT_NAME
ARG CURRENT_UID

ARG GOVERSION
RUN mkdir /goroot && curl -O https://storage.googleapis.com/golang/go$GOVERSION.linux-amd64.tar.gz \
 && tar -xvf go$GOVERSION.linux-amd64.tar.gz -C /goroot --strip-components=1 \
 && rm go$GOVERSION.linux-amd64.tar.gz


# Install other packages
RUN apt-get -y install ack autoconf \
     bison bzip2 bzr make man-db \
     maven mercurial nmap nodejs \
     npm net-tools patch python-pip \
     tar unzip vim wget

WORKDIR /tmp

# Upgrade Pip
RUN pip install --upgrade pip

# Install RVM
RUN mkdir ~/.gnupg
RUN echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf
ENV RVM_VERSION 1.29.3
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3 && \
    wget "https://github.com/rvm/rvm/archive/$RVM_VERSION.tar.gz" && \
    tar xvf "$RVM_VERSION.tar.gz" && \
    cd "rvm-$RVM_VERSION" && \
    ./install && \
    cd /tmp && \
    rm -rf "$RVM_VERSION.tar.gz" "rvm-$RVM_VERSION" && \
    echo "bundler" >> /usr/local/rvm/gemsets/global.gems


# Install Packer
RUN wget https://releases.hashicorp.com/packer/0.10.1/packer_0.10.1_linux_amd64.zip -O packer.zip && \
    unzip packer.zip && \
    rm packer.zip && \
    mv packer* /usr/local/bin/


# Install NPM Items
RUN npm install -g bower ember-cli grunt-cli less


RUN apt-get -y install ctags sudo zsh

# Create custom user
RUN useradd -u $CURRENT_UID -m -s /bin/bash $CURRENT_NAME && \
	 echo "$CURRENT_NAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install custom shell
RUN git clone https://github.com/myzsh/myzsh $HOME/.myzsh && \
    git clone https://github.com/myzsh/myzsh-golang $HOME/.myzsh/remotes/golang && \
    git clone https://github.com/myzsh/myzsh-timer $HOME/.myzsh/remotes/timer

#WORKDIR /tmp
# file with all the needed Env. Variables in it.
#COPY environment /tmp/

USER $CURRENT_NAME
ENV USER $CURRENT_NAME
ENV PATH $HOME:$PATH
ENV DOCKER true
WORKDIR  /home/$CURRENT_NAME
#COPY .bashrc /home/$CURRENT_NAME

CMD ["/bin/bash"]
