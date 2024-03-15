FROM alpine:3.17 AS build-stage

ENV TZ="America/Jamaica"

RUN apk upgrade --no-cache && apk add --no-cache git gcc g++ musl-dev make cmake autoconf automake libtool openssl libssl1.1 libressl-dev linux-headers

WORKDIR /opt/belabox
RUN git clone https://github.com/BELABOX/srt.git
RUN git clone https://github.com/BELABOX/srtla.git

# Build srt and srtla
WORKDIR /opt/belabox/srt
RUN cmake .
RUN make -j $(nproc)

WORKDIR /opt/belabox/srtla
RUN make -j $(nproc)

# Or the latest Alpine version
FROM alpine:3.17

RUN apk upgrade --no-cache && apk add --no-cache libgcc libstdc++ libressl

COPY --from=build-stage /opt/belabox/srt/srt-live-transmit /usr/local/bin/srt-live-transmit
COPY --from=build-stage /opt/belabox/srtla/srtla_rec /usr/local/bin/srtla_rec 

COPY start_app.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start_app.sh 

EXPOSE 5000/udp 5001/udp 

ENTRYPOINT ["/usr/local/bin/start_app.sh"] 