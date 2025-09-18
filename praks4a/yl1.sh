#!/bin/bash
# See skript küsib kasutaja nime ja sünniaasta ning arvutab tema vanuse.

# Küsi kasutajalt nimi
read -p "Sisesta oma nimi: " nimi

# Tervita kasutajat
echo "Tere tulemast, $nimi!"

# Küsi sünniaasta
read -p "Sisesta oma sünniaasta: " synniaasta

# Leia praegune aasta (kasutame `date` käsku)
praegune_aasta=$(date +%Y)

# Arvuta vanus
vanus=$((praegune_aasta - synniaasta))

# Kuva tulemus
echo "$nimi, sina oled $vanus aasta vana."

