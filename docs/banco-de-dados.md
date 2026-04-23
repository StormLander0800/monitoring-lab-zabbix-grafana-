# Banco de dados do Zabbix

Este documento descreve a configuração do **MariaDB/MySQL** como banco de dados do Zabbix no laboratório.

## Objetivo

Provisionar um banco dedicado para armazenar:

- configuração de hosts, grupos, templates e triggers;
- histórico de métricas e trends;
- eventos, problemas e auditoria;
- parâmetros operacionais do frontend e do servidor.

## Instalação do MariaDB

No Ubuntu 22.04:

```bash
sudo apt update
sudo apt install -y mariadb-server mariadb-client
sudo systemctl enable mariadb
sudo systemctl start mariadb
sudo systemctl status mariadb
```

## Hardening inicial

Opcional, mas recomendado mesmo em laboratório:

```bash
sudo mysql_secure_installation
```

Etapas típicas:

- definir senha do `root` quando aplicável;
- remover usuários anônimos;
- remover base de testes;
- revisar política de acesso remoto do usuário administrativo.

## Criação do banco e do usuário do Zabbix

Acesse o shell do MariaDB:

```bash
sudo mysql -uroot -p
```

Execute:

```sql
CREATE DATABASE zabbix CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER 'zabbix'@'localhost' IDENTIFIED BY '<SENHA_BANCO_ZABBIX>';
GRANT ALL PRIVILEGES ON zabbix.* TO 'zabbix'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

## Importação do schema do Zabbix

Após instalar os pacotes do Zabbix:

```bash
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz |   mysql -uzabbix -p'<SENHA_BANCO_ZABBIX>' zabbix
```

Validação rápida:

```bash
mysql -uzabbix -p'<SENHA_BANCO_ZABBIX>' zabbix -e "show tables;" | head
```

## Teste de conectividade

```bash
mysql -uzabbix -p'<SENHA_BANCO_ZABBIX>' -h localhost zabbix -e "select 1;"
```

Se o retorno for `1`, a conexão base está operacional.

## Ajustes opcionais para ambientes maiores

Arquivo comum de configuração:

```text
/etc/mysql/mariadb.conf.d/50-server.cnf
```

Exemplo de parâmetros que podem ser avaliados em cenários mais robustos:

```ini
[mysqld]
innodb_buffer_pool_size = 1G
innodb_log_file_size    = 256M
max_connections         = 200
```

> Para laboratório, tuning avançado não é obrigatório. Em produção, o sizing deve considerar volume de métricas, retenção, quantidade de hosts e perfil de consulta.

## Backup lógico

Exemplo simples:

```bash
mysqldump -u zabbix -p'<SENHA_BANCO_ZABBIX>' zabbix > /backup/zabbix_$(date +%F).sql
```

## Recomendações de produção

- agendar backups automáticos;
- manter cópia externa/off-site;
- testar restauração regularmente;
- revisar retenção de histórico e trends;
- endurecer autenticação e exposição do banco.
