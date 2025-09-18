#!/bin/bash
# See skript küsib kasutajalt kataloogi, pakib selle kokku
# ja salvestab ./backup kataloogi nimega <katalooginimi>.backup.tar.gz

read -p "Sisesta kataloogi tee, mida soovid varundada: " allikas

if [ ! -d "$allikas" ]; then
    echo "Viga: kataloogi '$allikas' ei eksisteeri!"
    exit 1
fi

siht="./backup"
[ ! -d "$siht" ] && mkdir -p "$siht"

katalooginimi=$(basename "$allikas")
failinimi="${katalooginimi}.backup.tar.gz"

# Liigu kataloogi, kus asub allikas ja paki seal
cd "$(dirname "$allikas")"
tar -czf "$OLDPWD/$siht/$failinimi" "$katalooginimi"

# Naase eelmisse kataloogi
cd "$OLDPWD"

printf "Kataloogi %s backupi nimi on %s ja ta asub %s kataloogis.\n" \
       "$(realpath "$allikas")" "$failinimi" "$(realpath "$siht")"
