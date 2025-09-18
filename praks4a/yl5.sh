#!/bin/bash

# Küsi kasutajalt kataloogi nimi
echo -n "Sisesta kataloogi nimi: "
read kataloog

# Kontrolli, kas kataloog eksisteerib
if [ ! -d "$kataloog" ]; then
    echo "Viga: kataloogi '$kataloog' ei leitud."
    exit 1
fi

# Kuupäeva määramine vormingus: päevkuu-aasta (nt 18sept2025)
kuupaev=$(date +"%d%b%Y" | tr '[:upper:]' '[:lower:]')

# Defineeri backup faili nimi koos kuupäevaga
backup_fail="${kataloog##*/}.backup.${kuupaev}.tar.gz"

# Teavita kasutajat tegevusest
echo "Varundatakse kataloogi '$kataloog'"
echo "Varukoopia salvestatakse faili '$backup_fail'"

# Tee varukoopia
tar -czf "$backup_fail" -C "$(dirname "$kataloog")" "$(basename "$kataloog")"

# Kontrolli, kas varundamine õnnestus
if [ $? -eq 0 ]; then
    echo "Varundamine edukalt lõpetatud."
else
    echo "Varundamine ebaõnnestus."
    exit 1
fi
