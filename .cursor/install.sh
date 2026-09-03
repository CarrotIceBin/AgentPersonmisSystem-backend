#!/usr/bin/env bash
# Idempotent Cloud Agent install/bootstrap for the Personmis backend.
# Prepares durable state that is captured in the environment snapshot:
#   - system toolchains (JDK 17, Maven, MariaDB)
#   - Python dependencies for the agent server
#   - the built Spring Boot jar
#   - an initialized + seeded MariaDB data directory
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export DEBIAN_FRONTEND=noninteractive

# 1. System packages (guarded so re-runs on a warm snapshot are fast) -----------
if ! command -v mvn >/dev/null 2>&1 \
   || ! command -v mariadbd >/dev/null 2>&1 \
   || [ ! -d "$JAVA_HOME" ]; then
  sudo apt-get update -y
  sudo apt-get install -y --no-install-recommends \
    openjdk-17-jdk maven mariadb-server mariadb-client
fi
sudo update-alternatives --set java "$JAVA_HOME/bin/java" >/dev/null 2>&1 || true

# 2. Python dependencies for the FastAPI agent server ---------------------------
pip3 install --break-system-packages --quiet \
  fastapi "uvicorn[standard]" pymysql openai

# 3. Build the Spring Boot backend ----------------------------------------------
mvn -B -DskipTests clean package

# 4. Initialize + seed MariaDB (data dir persists in the snapshot) ---------------
# The admin connection tolerates either a fresh install (root@localhost on the
# unix_socket plugin, reachable via sudo) or a warm snapshot (root secured with
# a password), so the script is safe to re-run.
db_up() {
  sudo mysql -e "SELECT 1" >/dev/null 2>&1 \
    || mysql -h 127.0.0.1 -uroot -p2003 -e "SELECT 1" >/dev/null 2>&1
}
db_admin() {
  if sudo mysql -e "SELECT 1" >/dev/null 2>&1; then
    sudo mysql "$@"
  else
    mysql -h 127.0.0.1 -uroot -p2003 "$@"
  fi
}

sudo mkdir -p /var/run/mysqld
sudo chown mysql:mysql /var/run/mysqld

if [ ! -d /var/lib/mysql/mysql ]; then
  sudo mariadb-install-db --user=mysql --datadir=/var/lib/mysql >/dev/null
fi

if ! db_up; then
  sudo mysqld_safe --datadir=/var/lib/mysql >/tmp/mariadb-install.log 2>&1 &
  for _ in $(seq 1 60); do db_up && break; sleep 1; done
fi

# Create the TCP root users the apps authenticate with (root/2003).
db_admin <<'SQL'
CREATE USER IF NOT EXISTS 'root'@'127.0.0.1' IDENTIFIED BY '2003';
CREATE USER IF NOT EXISTS 'root'@'%'         IDENTIFIED BY '2003';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'         WITH GRANT OPTION;
SET PASSWORD FOR 'root'@'127.0.0.1' = PASSWORD('2003');
SET PASSWORD FOR 'root'@'%'         = PASSWORD('2003');
FLUSH PRIVILEGES;
SQL

# Seed the schema only when it is missing so re-runs never wipe existing data.
if ! mysql -h 127.0.0.1 -uroot -p2003 -e "USE personmis; SELECT 1 FROM post LIMIT 1;" >/dev/null 2>&1; then
  mysql -h 127.0.0.1 -uroot -p2003 < "$REPO_ROOT/.cursor/db/personmis.sql"
fi

# Leave the data dir in a clean, consistent state for the snapshot; the runtime
# server is owned by start.sh on each boot. Wait for a full shutdown so a
# subsequent start does not race a still-terminating process.
sudo mysqladmin shutdown >/dev/null 2>&1 \
  || mysqladmin -h 127.0.0.1 -uroot -p2003 shutdown >/dev/null 2>&1 \
  || true
for _ in $(seq 1 30); do
  db_up || break
  sleep 1
done

echo "install.sh complete"
