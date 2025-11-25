
---

### `docs/banco-de-dados.md`

```markdown
# Banco de Dados – MariaDB/MySQL para Zabbix

Este documento descreve a configuração do banco de dados **MariaDB/MySQL** utilizado pelo Zabbix.

## 1. Instalação do MariaDB/MySQL

No Ubuntu 22.04:

```bash
sudo apt update
sudo apt install -y mariadb-server mariadb-client
sudo systemctl enable mariadb
sudo systemctl start mariadb
sudo systemctl status mariadb
2. Configuração Básica de Segurança
Opcional, mas recomendado:

bash
Copiar código
sudo mysql_secure_installation
Passos típicos:

Definir senha para o usuário root.

Remover usuários anônimos.

Remover banco de teste.

Desabilitar login remoto do root (conforme necessidade do lab/produção).

3. Criação do Banco e Usuário para o Zabbix
Acessar o MySQL/MariaDB:

bash
Copiar código
sudo mysql -uroot -p
Dentro do shell:

sql
Copiar código
CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;

CREATE USER 'zabbix'@'localhost' IDENTIFIED BY '<SENHA_BANCO_ZABBIX>';

GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';

FLUSH PRIVILEGES;
EXIT;
Banco: zabbix

Usuário: zabbix@localhost

Senha: <SENHA_BANCO_ZABBIX>

4. Importar Schema do Zabbix
Após instalar pacotes do Zabbix:

bash
Copiar código
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | \
  mysql -uzabbix -p'<SENHA_BANCO_ZABBIX>' zabbix
Verificar:

bash
Copiar código
mysql -uzabbix -p'<SENHA_BANCO_ZABBIX>' zabbix -e "show tables;" | head
5. Ajustes de Configuração (opcional)
Arquivo principal do MariaDB (varia de distro):

/etc/mysql/mariadb.conf.d/50-server.cnf
ou equivalente.

Parâmetros comuns para ambientes maiores (não crítico em lab):

ini
Copiar código
[mysqld]
innodb_buffer_pool_size = 1G
innodb_log_file_size    = 256M
max_connections         = 200
Em laboratório, ajustes finos não são obrigatórios, mas em produção é importante calibrar memória, logs e conexões conforme tamanho do ambiente.

6. Testes de Conectividade
Testar acesso com usuário do Zabbix:

bash
Copiar código
mysql -uzabbix -p'<SENHA_BANCO_ZABBIX>' -h localhost zabbix -e "select 1;"
Se retornar 1, a conexão está OK.

7. Backup (conceito)
Sugestão simples de backup lógico:

bash
Copiar código
mysqldump -u zabbix -p'<SENHA_BANCO_ZABBIX>' zabbix > /backup/zabbix_$(date +%F).sql
Em produção, considerar:

Backups agendados (cron).

Backup off-site.

Testes regulares de restauração.

