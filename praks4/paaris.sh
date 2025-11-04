#!/bin/bash
# See skript küsib kasutajalt täisarvu ja kontrollib, kas see on paaris või paaritu.
# Kui sisend ei ole täisarv, kuvatakse veateade.

read -p "Sisesta suvaline täisarv: " arv

# Kontrollime, kas sisend koosneb ainult numbritest (ja võib olla ka miinusmärgiga alguses)
if [[ $arv =~ ^-?[0-9]+$ ]]; then
    if [ $((arv % 2)) -eq 0 ]; then
        echo "Antud arv on paaris"
    else
        echo "Antud arv on paaritu"
    fi
else
    echo "VIGA: Palun sisesta ainult täisarv!"
fi

