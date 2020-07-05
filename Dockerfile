FROM debian

LABEL maintainer="k@kalka.io"

RUN apt update

#this is necessary for steamcmd to run
RUN apt install -y software-properties-common

#create the user we'll be using for steamcmd
RUN useradd -m steam

#a hacky way of telling steam that we agree to its ToS
RUN echo steam steam/question select "I AGREE" | debconf-set-selections

RUN add-apt-repository non-free && \
    dpkg --add-architecture i386 && \
    apt update && \
    DEBIAN_FRONTEND=noninteractive apt -y install lib32gcc1 steamcmd libncurses5:i386 libcurl3-gnutls:i386

#clean everything
RUN apt clean

USER steam

WORKDIR /home/steam

RUN /usr/games/steamcmd +quit

ENTRYPOINT ["/usr/games/steamcmd"]
