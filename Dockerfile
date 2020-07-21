FROM ubuntu

LABEL maintainer="k@kalka.io"

#this is necessary for steamcmd to run

#create the user we'll be using for steamcmd, and give it privileges to use chmod
RUN dpkg --add-architecture i386 && \
    apt update && \
    echo steam steam/question select "I AGREE" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt -y install lib32gcc1 steamcmd libncurses5:i386 libcurl3-gnutls:i386 sudo git && \
    useradd -m steam

#let steam use sudo so we can be able to fix permissions when necessary
RUN echo steam ALL=NOPASSWD:ALL > /etc/sudoers.d/steam

#clean everything
RUN apt clean

USER steam

WORKDIR /home/steam

#invoke this RUN command because we want to cache steamcmd to strategize on faster container deployment. run it once then just quit.
RUN bash -c "/usr/games/steamcmd +quit &> /dev/null"

CMD ["/usr/games/steamcmd"]
