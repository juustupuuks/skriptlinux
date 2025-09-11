#!/bin/bash
# See skript küsib kasutajalt täisarvu ja kontrollib, kas see on paaris või paaritu.

read -p "Sisesta suvaline täisarv: " arv

# Tingimus
if [ $((arv % 2)) -eq 0 ]; then
    echo "Antud arv on paaris"
else
    echo "Antud arv on paaritu"
fi
