#This is a sample Image
FROM ubuntu
MAINTAINER brentj433@gmail.com


RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get -y install open-vm-tools nfs-common ssh build-essential python-dev libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev git curl

# Create custom user
RUN useradd -u 1001 -ms /bin/bash brent && \
	 echo "brent ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER brent
ENV USER brent
ENV PATH $HOME:$PATH
ENV DOCKER true
WORKDIR  /home/brent

CMD ["/bin/bash"]
