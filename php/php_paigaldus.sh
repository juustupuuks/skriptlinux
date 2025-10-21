#!/bin/bash
# ----------------------------------------------
# php_paigaldus.sh
# Autor: [Sinu Nimi]
# Kuupäev: $(date)
# Kirjeldus: PHP 7.0 ja vajalike moodulite paigaldus Debian 10 süsteemi
# Eeldus: Apache2 on juba paigaldatud
# ----------------------------------------------

echo "--------------------------------------------"
echo "PHP teenuse paigaldamine algab..."
echo "--------------------------------------------"

# Kontroll, kas skript on käivitatud root kasutajana
if [ "$EUID" -ne 0 ]; then
  echo "VIGA: Palun käivita skript root kasutajana (kasuta: sudo bash php_paigaldus.sh)"
  exit 1
fi

# Süsteemi paketiloendi uuendamine
echo "Uuendan süsteemi paketiloendit..."
apt-get update -y

# Kontrollime, kas PHP 7.0 on üldse saadaval
echo "Kontrollin PHP 7.0 paketi olemasolu..."
if ! apt-cache search php7.0 | grep -q php7.0; then
  echo "PHP 7.0 pakette ei leitud ametlikest hoidlatest."
  echo "Lisame vanema PHP hoidla (surõ)."
  apt-get install -y apt-transport-https lsb-release ca-certificates curl
  curl -sSL https://packages.sury.org/php/README.txt | bash
  apt-get update -y
fi

# Paigaldame vajalikud PHP paketid
echo "Paigaldan PHP 7.0 ja vajalikud moodulid..."
apt-get install -y php7.0 libapache2-mod-php7.0 php7.0-mysql

# Kontrollime, kas PHP paigaldus õnnestus
if ! command -v php >/dev/null 2>&1; then
  echo "VIGA: PHP ei paigaldunud korrektselt!"
  exit 1
fi

# Kuvame PHP versiooni kontrolliks
echo "--------------------------------------------"
echo "PHP on edukalt paigaldatud:"
php -v
echo "--------------------------------------------"

# Lubame Apache PHP mooduli
echo "Lubame Apache PHP mooduli ja taaskäivitame Apache teenuse..."
a2enmod php7.0 >/dev/null 2>&1
systemctl restart apache2

# Testfaili loomine
echo "Loon testfaili /var/www/html/test.php..."
cat <<EOF > /var/www/html/test.php
<?php
phpinfo();
?>
EOF

# Õiguste seadmine
chown www-data:www-data /var/www/html/test.php

# Lõpusõnum
echo "--------------------------------------------"
echo "PHP 7.0 paigaldus on lõpetatud!"
echo "Testi seda brauseris: http://localhost/test.php"
echo "--------------------------------------------"

