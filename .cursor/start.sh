#!/usr/bin/env bash
# Per-boot startup: bring MariaDB up and wait until it is ready to serve.
# The application servers themselves run as visible `terminals` processes.
set -euo pipefail

db_up() {
  sudo mysql -e "SELECT 1" >/dev/null 2>&1 \
    || mysql -h 127.0.0.1 -uroot -p2003 -e "SELECT 1" >/dev/null 2>&1
}

sudo mkdir -p /var/run/mysqld
sudo chown mysql:mysql /var/run/mysqld

if ! db_up; then
  sudo mysqld_safe --datadir=/var/lib/mysql >/tmp/mariadb.log 2>&1 &
fi

for _ in $(seq 1 60); do
  if db_up; then
    echo "MariaDB is ready"
    exit 0
  fi
  sleep 1
done

echo "MariaDB failed to become ready" >&2
exit 1
