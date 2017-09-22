FROM debian
EXPOSE 8303/udp
#ENV PATH="/usr/games/XXLDDRACE:$PATH"
LABEL idea "https://hub.docker.com/r/xxltomate/xxlddrace/builds/bsv3gbwmlbhgaveqkpsicec/"

# ------ BUILD -----
# install dependencies
RUN apt-get -qq update && apt-get -qq install -y \
    bam \
    build-essential \
    python \
    git
WORKDIR /usr/games/XXLDDRACE
ARG repo="https://github.com/ftk/XXLDDRace"
ARG threads="0"
RUN git clone "$repo" . \
    && bam -a -j "$threads" server_release \
    && rm -rd bam.lua storage.cfg common.mk Makefile* \
    datasrc/ src/ objs/ other/ scripts/ tools/ \
    && echo add_path /usr/games/XXLDDRACE/config >> storage.cfg \
    && echo add_path /usr/games/XXLDDRACE/config/data >> storage.cfg
# ------ Output -----
FROM debian
WORKDIR /usr/games/XXLDDRACE
ENTRYPOINT ["./XXLDDRace-Server_64"]
COPY --from=0 /usr/games/XXLDDRACE /usr/games/XXLDDRACE
