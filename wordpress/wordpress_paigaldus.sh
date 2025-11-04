#!/usr/bin/env bash
set -euo pipefail

# --- Seaded (soovi korral muuda) ---
DB_NAME="wordpress"
DB_USER="wpuser"
DB_PASS="qwerty"
WEBROOT="/var/www/html"
WP_TGZ_URL="https://wordpress.org/latest.tar.gz"

export DEBIAN_FRONTEND=noninteractive

echo "==> 1) Paketid ja teenused (Apache, PHP, MariaDB)…"
apt-get update -y
apt-get install -y apache2 php libapache2-mod-php php-mysql \
                   php-zip php-gd php-curl php-xml php-mbstring \
                   mariadb-server mariadb-client wget tar curl rsync

# Kuula kõigilt aadressidelt 80 peal (väldi ERR_CONNECTION_REFUSED lokaalist väljas)
sed -i 's/^Listen .*/Listen 80/' /etc/apache2/ports.conf || true
sed -i 's#<VirtualHost .*:80>#<VirtualHost *:80>#' /etc/apache2/sites-available/000-default.conf || true

systemctl enable --now apache2
systemctl enable --now mariadb

echo "==> 2) Andmebaas ja kasutaja…"
mysql -u root <<SQL
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
SQL

echo "==> 3) WordPressi allalaadimine ja paigaldus…"
TMPDIR="$(mktemp -d)"
pushd "$TMPDIR" >/dev/null
wget -q "${WP_TGZ_URL}" -O latest.tar.gz
tar xzf latest.tar.gz
# korista vaikimisi Apache index.html (kui on)
rm -f ${WEBROOT}/index.html
rsync -a wordpress/ "${WEBROOT}/"
popd >/dev/null
rm -rf "$TMPDIR"

echo "==> 4) wp-config.php seadistamine sed-iga…"
cd "${WEBROOT}"
[ -f wp-config.php ] || cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/${DB_NAME}/" wp-config.php
sed -i "s/username_here/${DB_USER}/" wp-config.php
sed -i "s/password_here/${DB_PASS}/" wp-config.php
# Host jääb 'localhost' (sobib MariaDB-ga samas masinas)

# Õigused
chown -R www-data:www-data "${WEBROOT}"
find "${WEBROOT}" -type d -exec chmod 755 {} \;
find "${WEBROOT}" -type f -exec chmod 644 {} \;

echo "==> 5) Teenuste restart ja tervisekontroll…"
systemctl restart apache2
systemctl restart mariadb

# Kiire healthcheck: kas localhostilt tuleb HTTP vastus?
if curl -sI http://127.0.0.1 | grep -q "200 OK\|301\|302"; then
  echo "OK: Apache vastab. Ava brauseris: http://$(hostname -I | awk '{print $1}')/"
else
  echo "HOIATUS: Apache ei vasta ootuspäraselt. Kontrolli: systemctl status apache2"
fi
