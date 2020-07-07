FROM debian

LABEL maintainer="k@kalka.io"

RUN apt update

#this is necessary for steamcmd to run
RUN apt install -y software-properties-common

RUN apt install -y sudo git

#create the user we'll be using for steamcmd, and give it privileges to use chmod
RUN useradd -m steam

#let steam use sudo so we can be able to fix permissions when necessary
RUN echo steam ALL=NOPASSWD:ALL > /etc/sudoers.d/steam

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

#invoke this RUN command because we want to cache steamcmd to strategize on faster container deployment. run it once then just quit.
RUN /usr/games/steamcmd +quit

ENTRYPOINT ["/usr/games/steamcmd"]
