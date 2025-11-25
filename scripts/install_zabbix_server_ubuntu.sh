#!/usr/bin/env bash
#
# Script de instalação básica do Zabbix Server + MariaDB + Grafana em Ubuntu 22.04
# Para uso em LAB. NÃO usar em produção sem revisar e ajustar.
#

set -e

ZBX_DB_NAME="zabbix"
ZBX_DB_USER="zabbix"
ZBX_DB_PASS="<SENHA_BANCO_ZABBIX>"
ZBX_VERSION="7.0"

echo "=== Atualizando sistema ==="
sudo apt update
sudo apt upgrade -y

echo "=== Instalando pacotes base ==="
sudo apt install -y vim nano curl wget gnupg2 software-properties-common \
  apt-transport-https

echo "=== Instalando MariaDB ==="
sudo apt install -y mariadb-server mariadb-client
sudo systemctl enable mariadb
sudo systemctl start mariadb

echo "=== Criando banco e usuário para o Zabbix ==="
sudo mysql -uroot <<EOF
CREATE DATABASE IF NOT EXISTS ${ZBX_DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER IF NOT EXISTS '${ZBX_DB_USER}'@'localhost' IDENTIFIED BY '${ZBX_DB_PASS}';
GRANT ALL PRIVILEGES ON ${ZBX_DB_NAME}.* TO '${ZBX_DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "=== Adicionando repositório do Zabbix ${ZBX_VERSION} ==="
cd /tmp
wget https://repo.zabbix.com/zabbix/${ZBX_VERSION}/ubuntu/pool/main/z/zabbix-release/zabbix-release_${ZBX_VERSION}-1+ubuntu22.04_all.deb
sudo dpkg -i zabbix-release_${ZBX_VERSION}-1+ubuntu22.04_all.deb
sudo apt update

echo "=== Instalando Zabbix Server, Frontend e Agent ==="
sudo apt install -y zabbix-server-mysql zabbix-frontend-php \
  zabbix-apache-conf zabbix-sql-scripts zabbix-agent

echo "=== Importando schema do Zabbix no banco de dados ==="
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | \
  mysql -u${ZBX_DB_USER} -p${ZBX_DB_PASS} ${ZBX_DB_NAME}

echo "=== Configurando /etc/zabbix/zabbix_server.conf ==="
sudo sed -i "s/^# DBHost=.*/DBHost=localhost/" /etc/zabbix/zabbix_server.conf
sudo sed -i "s/^# DBName=.*/DBName=${ZBX_DB_NAME}/" /etc/zabbix/zabbix_server.conf
sudo sed -i "s/^# DBUser=.*/DBUser=${ZBX_DB_USER}/" /etc/zabbix/zabbix_server.conf
sudo sed -i "s/^# DBPassword=.*/DBPassword=${ZBX_DB_PASS}/" /etc/zabbix/zabbix_server.conf

echo "=== Ajustando timezone PHP para Zabbix ==="
# Ajuste simples; em produção, considerar arquivo específico do PHP
if ! grep -q "date.timezone" /etc/php/*/apache2/php.ini; then
  sudo bash -c "echo 'date.timezone = America/Sao_Paulo' >> /etc/php/*/apache2/php.ini"
fi

echo "=== Reiniciando serviços ==="
sudo systemctl restart apache2
sudo systemctl enable apache2

sudo systemctl restart zabbix-server zabbix-agent
sudo systemctl enable zabbix-server zabbix-agent

echo "=== Instalando Grafana (opcional) ==="
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | \
  sudo tee /etc/apt/sources.list.d/grafana.list

sudo apt update
sudo apt install -y grafana

sudo systemctl enable grafana-server
sudo systemctl start grafana-server

echo "=== Instalação concluída ==="
echo "Acesse o Zabbix em:  http://<IP_ZABBIX>/zabbix"
echo "Acesse o Grafana em: http://<IP_ZABBIX>:3000/"
echo "Lembre-se de trocar senhas padrão e ajustar configurações para produção."
