#!/bin/bash
# ---------------------------------------------
# Skript: apache_paigaldus.sh
# Autor: J. V.
# Kirjeldus:
# Kontrollib, kas apache2 teenus on paigaldatud.
# Kui ei ole, paigaldab selle automaatselt.
# Kui on, kuvab teate ja näitab teenuse staatust.
# ---------------------------------------------

# Kontrollime, kas skripti käivitatakse root kasutajana
if [ "$EUID" -ne 0 ]; then
  echo "Palun käivita skript root kasutajana (kasuta: sudo bash apache_paigaldus.sh)"
  exit 1
fi

# Kontrollime, kas Apache2 on paigaldatud
echo "Kontrollin, kas apache2 teenus on paigaldatud..."
dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -q "ok installed"

if [ $? -eq 0 ]; then
    echo "Apache2 on juba paigaldatud!"
    echo
    echo "Teenuse olek:"
    systemctl status apache2 --no-pager
else
    echo "Apache2 ei ole paigaldatud. Paigaldan nüüd..."
    apt update -y
    apt install apache2 -y

    # Kontrollime, kas paigaldus õnnestus
    if [ $? -eq 0 ]; then
        echo "Apache2 paigaldus õnnestus!"
        systemctl enable apache2
        systemctl start apache2
        echo "Teenuse olek:"
        systemctl status apache2 --no-pager
    else
        echo "Viga: Apache2 paigaldamine ebaõnnestus."
        exit 2
    fi
fi

