# Webcam USB → Stream RTSP (Versione leggera)

Questa soluzione permette di trasformare una webcam USB in uno stream RTSP utilizzando GStreamer con il minor consumo possibile di risorse.

## Caratteristiche

- Basato su Debian (immagine slim)
- Implementazione in bash (senza Python)
- Ottimizzato per basso consumo di CPU e RAM
- Personalizzabile tramite variabili d'ambiente

## Prerequisiti

- Docker installato sul sistema
- Una webcam USB collegata
- Permessi per accedere alla webcam

## File inclusi

1. `Dockerfile` - Configurazione per creare l'immagine Docker basata su Debian slim
2. `start-rtsp-server.sh` - Script bash leggero che implementa lo streaming
3. `rtsp-minimal.sh` - Versione ultra-minima per casi d'uso con risorse molto limitate

## Utilizzo con Docker

### 1. Creare l'immagine Docker

```bash
docker build -t webcam-rtsp-minimal .
```

### 2. Eseguire il container

```bash
docker run --device=/dev/video0:/dev/video0 -p 8554:8554 -p 5000:5000/udp webcam-rtsp-minimal
```

### 3. Personalizzazione con variabili d'ambiente

```bash
docker run --device=/dev/video0:/dev/video0 -p 8554:8554 -p 5000:5000/udp \
  -e WEBCAM_DEVICE=/dev/video0 \
  -e VIDEO_WIDTH=1280 \
  -e VIDEO_HEIGHT=720 \
  -e VIDEO_FRAMERATE=15 \
  -e RTSP_PORT=8554 \
  -e RTSP_MOUNT_POINT=/camera \
  webcam-rtsp-minimal
```

## Utilizzo senza Docker

Se preferisci non utilizzare Docker, puoi eseguire direttamente lo script bash:

1. Installa le dipendenze minime:

```bash
sudo apt-get update
sudo apt-get install -y gstreamer1.0-tools gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad
```

2. Esegui lo script:

```bash
chmod +x start-rtsp-server.sh
./start-rtsp-server.sh
```

## Soluzione ultra-minima

Per sistemi con risorse estremamente limitate, è inclusa anche una versione ultra-minima che implementa solo uno streaming RTP (più leggero di RTSP completo):

```bash
chmod +x rtsp-minimal.sh
./rtsp-minimal.sh
```

## Connessione allo stream

### Versione RTSP completa
```
rtsp://IP_SERVER:8554/webcam
```

### Versione RTP minima
Per la versione ultra-minima (RTP), il client deve usare questo comando:

```bash
gst-launch-1.0 udpsrc port=5000 caps="application/x-rtp,media=video,encoding-name=H264" ! rtph264depay ! h264parse ! avdec_h264 ! autovideosink
```

## Risoluzioni dei problemi

- **Errore di accesso alla webcam**: Verifica che il dispositivo `/dev/video0` esista e sia accessibile. Puoi cambiare il dispositivo con la variabile `WEBCAM_DEVICE`.
- **Problemi di performance**: Riduci la risoluzione o il framerate usando le variabili d'ambiente.
- **Ritardo (latenza)**: La pipeline è già ottimizzata per bassa latenza, ma puoi ridurre ulteriormente la risoluzione o il framerate.