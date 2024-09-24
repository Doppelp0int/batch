#!/bin/bash
# System aktualisieren
apt-get update && apt-get upgrade -y

# Docker installieren
apt-get install ca-certificates curl -y
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
if [ $? -ne 0 ]; then
  echo "Fehler beim Herunterladen des Docker GPG-Schlüssels."
  exit 1
fi
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin net-tools -y
sleep 5
service docker start
sleep 5
# Portainer Installation (kein sudo erforderlich, da du als root arbeitest)
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

# Prüfen, ob Portainer läuft
sleep 5  # Kurze Wartezeit, um den Container zu starten
if docker ps | grep -q portainer; then
  echo "********************************************************************"
  echo "Portainer ist gestartet und erreichbar unter: https://localhost:9443"
  echo "********************************************************************"
else
  echo "********************************************************************"
  echo "Portainer konnte nicht gefunden werden. Installation wird erneut versucht."
  echo "********************************************************************"
  docker rm -f portainer
  docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
fi

# Abschließende Nachricht
echo "Docker und Portainer wurden installiert."
