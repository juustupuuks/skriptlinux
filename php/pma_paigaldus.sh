#!/bin/bash
# phpMyAdmin paigaldusskript
# Autor: Joonas Puur 

echo "Kontrollin phpmyadmini olemasolu..."

# Kontrollime, kas phpmyadmin on juba paigaldatud
PMA=$(dpkg-query -W -f='${Status}' phpmyadmin 2>/dev/null | grep -c "ok installed")

if [ $PMA -eq 0 ]; then
    echo "phpMyAdmin ei ole paigaldatud. Paigaldame vajalikud komponendid..."
    apt update
    apt install -y mariadb-server mariadb-client phpmyadmin

    echo "phpMyAdmin on paigaldatud koos vajalike lisadega."
elif [ $PMA -eq 1 ]; then
    echo "phpMyAdmin on juba paigaldatud."
else
    echo "Kontrollimisel tekkis tõrge."
fi

