# Base image
FROM ubuntu:22.04 AS build-stage

ENV TZ="America/Jamaica"

# Update package lists
RUN apt update
RUN apt install -y git build-essential cmake git 
RUN DEBIAN_FRONTEND=noninteractive apt install -y tcl 

RUN apt install -y libssl-dev
RUN apt install -y libgstreamer1.0-dev
RUN apt install -y libgstreamer-plugins-base1.0-dev
RUN apt clean autoremove -y

# Clone and build belabox's srt
WORKDIR /opt/srt
RUN git clone https://github.com/BELABOX/srt.git .
RUN cmake . && make -j $(nproc)

# Clone and build srtla
WORKDIR /opt/srtla
RUN git clone https://github.com/BELABOX/srtla.git .
RUN make

FROM ubuntu:22.04
# Copy binaries to container path
COPY --from=build-stage /opt/srt/srt-live-transmit /usr/local/bin/srt/srt-live-transmit
COPY --from=build-stage /opt/srtla/srtla_rec /usr/local/bin/srtla/srtla_rec

# Copy the Bash script into the container
COPY start_app.sh /usr/local/bin/

# Expose SRT port
EXPOSE 5000 5001

# Set the script as the ENTRYPOINT
ENTRYPOINT ["/usr/local/bin/start_app.sh"] 