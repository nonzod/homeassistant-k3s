FROM debian:bullseye-slim

# Evita prompt interattivi durante l'installazione
ENV DEBIAN_FRONTEND=noninteractive

# Installa le dipendenze necessarie minime per GStreamer e RTSP
RUN apt-get update && apt-get install -y --no-install-recommends \
    gstreamer1.0-tools \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-rtsp \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav \
    v4l-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Crea directory per lo script
WORKDIR /app

# Copia lo script di avvio
COPY start-rtsp-server.sh /app/
RUN chmod +x /app/start-rtsp-server.sh

# Espone la porta RTSP standard
EXPOSE 8554

# ENV DEVICE=${WEBCAM_DEVICE:-/dev/video0}
# ENV WIDTH=${VIDEO_WIDTH:-640}
# ENV HEIGHT=${VIDEO_HEIGHT:-480}
# ENV FRAMERATE=${VIDEO_FRAMERATE:-30}
# ENV PORT=${RTSP_PORT:-8554}
# ENV MOUNT_POINT=${RTSP_MOUNT_POINT:-/webcam}

# Imposta l'avvio del server al lancio del container
CMD ["/app/start-rtsp-server.sh"]