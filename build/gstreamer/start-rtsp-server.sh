#!/bin/bash

# Parametri configurabili con valori predefiniti
DEVICE=${WEBCAM_DEVICE:-/dev/video0}
WIDTH=${VIDEO_WIDTH:-640}
HEIGHT=${VIDEO_HEIGHT:-480}
FRAMERATE=${VIDEO_FRAMERATE:-30}
PORT=${RTSP_PORT:-8554}
MOUNT_POINT=${RTSP_MOUNT_POINT:-/webcam}

# Verifica se la webcam è disponibile
if [ ! -e "$DEVICE" ]; then
    echo "Errore: dispositivo webcam $DEVICE non trovato!"
    exit 1
fi

# Verifica che le impostazioni video siano supportate
v4l2-ctl --device=$DEVICE --list-formats-ext

echo "Avvio server RTSP con le seguenti impostazioni:"
echo "Dispositivo: $DEVICE"
echo "Risoluzione: ${WIDTH}x${HEIGHT}"
echo "Framerate: $FRAMERATE fps"
echo "Porta RTSP: $PORT"
echo "Mount point: $MOUNT_POINT"
echo "URL completo: rtsp://IP_SERVER:$PORT$MOUNT_POINT"

# Avvia il server RTSP utilizzando gst-launch-1.0
# Questa è la versione più leggera che non utilizza Python
gst-launch-1.0 -v \
    rtpbin name=rtpbin \
    v4l2src device=$DEVICE ! \
    video/x-raw,width=$WIDTH,height=$HEIGHT,framerate=$FRAMERATE/1 ! \
    videoconvert ! \
    x264enc tune=zerolatency bitrate=1000 speed-preset=superfast ! \
    rtph264pay name=pay0 pt=96 ! \
    udpsink host=0.0.0.0 port=5000 sync=false \
    &

# In alternativa, se disponibile rtsp-server
if command -v test-launch &> /dev/null; then
    test-launch "( v4l2src device=$DEVICE ! video/x-raw,width=$WIDTH,height=$HEIGHT,framerate=$FRAMERATE/1 ! videoconvert ! x264enc tune=zerolatency speed-preset=superfast ! rtph264pay name=pay0 pt=96 )"
    exit 0
fi

# Mantieni il container in esecuzione
echo "Server RTSP avviato. Accedi con: rtsp://IP_SERVER:$PORT$MOUNT_POINT"
echo "Premi CTRL+C per terminare"

# Attendi che l'utente interrompa il processo
wait