#!/bin/bash
# --- Automaatne kõigi kasutajate HOME BACKUP skript ---

# Kuupäev varukoopia failide nimeks
kuupaev=$(date +"%Y-%m-%d_%H-%M")

# Lähtekataloog, kust kasutajate kodud võetakse
lahtekaust="/home"

# Sihtkataloog, kuhu BACKUPid salvestatakse
sihtkaust="/home/home_bcp"

echo "-------------------------------------------"
echo "  AUTOMATNE KASUTAJATE BACKUP SKRIPT"
echo "-------------------------------------------"
echo "Backup tehakse kataloogist: $lahtekaust"
echo "Salvestuskoht: $sihtkaust"
echo

# Kontrolli, kas sihtkataloog eksisteerib, kui ei – loo see
if [ ! -d "$sihtkaust" ]; then
    echo "Loon sihtkataloogi: $sihtkaust"
    mkdir -p "$sihtkaust"
    echo "-> Kataloog loodud."
    echo
fi

# Läbi kõik /home kataloogis olevad kasutajad
for kasutaja in "$lahtekaust"/*; do
    # Kontrolli, kas tegemist on kataloogiga
    if [ -d "$kasutaja" ]; then
        kasutajanimi=$(basename "$kasutaja")
        backupfail="${kasutajanimi}_${kuupaev}.tar.gz"
        backuptee="${sihtkaust}/${backupfail}"

        echo "📦 Teen BACKUPi kasutajale: $kasutajanimi"
        echo " -> Fail: $backuptee"

        # Tee varukoopia ja paki kokku
        tar -czf "$backuptee" -C "$lahtekaust" "$kasutajanimi"

        # Kontrolli, kas backup õnnestus
        if [ $? -eq 0 ]; then
            echo "   ✅ Backup õnnestus kasutajale: $kasutajanimi"
        else
            echo "   ❌ Backup ebaõnnestus kasutajale: $kasutajanimi"
        fi
        echo
    fi
done

echo "-------------------------------------------"
echo "Kõik kasutajate BACKUPid on lõpetatud."
echo "Varukoopiad asuvad: $sihtkaust"
echo "-------------------------------------------"
