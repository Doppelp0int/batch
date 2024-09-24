#!/bin/bash
# System aktualisieren
sudo apt-get update && sudo apt-get upgrade -y

# Docker installieren
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin net-tools -y
# Benutzer zur Docker-Gruppe hinzufügen
sudo usermod -aG docker $USER

# Prüfen, ob Portainer läuft
if sudo docker ps | grep -q portainer; then
  echo "Portainer ist gestartet und erreichbar unter: https://localhost:9443"
else
  echo "Portainer konnte nicht gefunden werden. portainer wird installiert"
  # Portainer installieren
sudo docker volume create portainer_data
sudo docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
fi

# Hinweis für Neustart oder Abmeldung
echo "Docker und Portainer wurden installiert. Ab- und wieder anmelden oder ein Neustart ist erforderlich, um die Docker-Gruppenänderung zu übernehmen."
