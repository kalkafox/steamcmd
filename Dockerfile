FROM ubuntu

LABEL maintainer="k@kalka.io"

#this is necessary for steamcmd to run

#create the user we'll be using for steamcmd, and give it privileges to use chmod
RUN dpkg --add-architecture i386 && \
    apt update && \
    DEBIAN_FRONTEND=noninteractive apt -y install lib32gcc1 steamcmd libncurses5:i386 libcurl3-gnutls:i386 && \
    useradd -m steam

#let steam use sudo so we can be able to fix permissions when necessary
#a hacky way of telling steam that we agree to its ToS
RUN echo steam ALL=NOPASSWD:ALL > /etc/sudoers.d/steam && echo steam steam/question select "I AGREE" | debconf-set-selections

#clean everything
RUN apt clean

USER steam

WORKDIR /home/steam

#invoke this RUN command because we want to cache steamcmd to strategize on faster container deployment. run it once then just quit.
RUN /usr/games/steamcmd +quit

CMD ["/usr/games/steamcmd"]
