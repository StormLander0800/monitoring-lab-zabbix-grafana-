# Instalação do Zabbix Server no Ubuntu 22.04

Este documento descreve a instalação base do **Zabbix Server**, **frontend** e **agent** em um servidor Ubuntu 22.04 utilizado como nó principal do laboratório.

## Escopo

Este guia cobre:

- preparação do sistema operacional;
- instalação do banco MariaDB;
- instalação do Zabbix Server, frontend e agent;
- configuração inicial do `zabbix_server.conf`;
- ajustes básicos de Apache/PHP;
- primeiro acesso via interface web.

## 1. Preparação do sistema

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y vim nano curl wget net-tools sysstat   software-properties-common gnupg2
```

## 2. Locale e timezone

```bash
sudo timedatectl set-timezone America/Sao_Paulo
sudo apt install -y language-pack-pt
sudo locale-gen pt_BR.UTF-8
sudo update-locale
```

## 3. Banco de dados

Instale o MariaDB:

```bash
sudo apt install -y mariadb-server mariadb-client
sudo systemctl enable mariadb
sudo systemctl start mariadb
```

A criação do banco e do usuário está detalhada em [`banco-de-dados.md`](banco-de-dados.md).

## 4. Repositório do Zabbix

Exemplo para Zabbix 7.0 em Ubuntu 22.04:

```bash
cd /tmp
wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_7.0-1+ubuntu22.04_all.deb
sudo dpkg -i zabbix-release_7.0-1+ubuntu22.04_all.deb
sudo apt update
```

## 5. Instalação dos pacotes

```bash
sudo apt install -y zabbix-server-mysql zabbix-frontend-php   zabbix-apache-conf zabbix-sql-scripts zabbix-agent
```

## 6. Importação do schema

```bash
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz |   mysql -uzabbix -p'<SENHA_BANCO_ZABBIX>' zabbix
```

Verifique as tabelas:

```bash
mysql -uzabbix -p'<SENHA_BANCO_ZABBIX>' zabbix -e "show tables;" | head
```

## 7. Configuração do `zabbix_server.conf`

Edite o arquivo:

```bash
sudo nano /etc/zabbix/zabbix_server.conf
```

Ajuste os parâmetros mínimos:

```ini
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=<SENHA_BANCO_ZABBIX>
```

## 8. Configuração do PHP/Apache

Ajuste o timezone do PHP para o frontend do Zabbix:

```ini
php_value date.timezone America/Sao_Paulo
```

Valide o Apache:

```bash
sudo apache2ctl configtest
```

Reinicie os serviços:

```bash
sudo systemctl restart apache2
sudo systemctl enable apache2
sudo systemctl restart zabbix-server zabbix-agent
sudo systemctl enable zabbix-server zabbix-agent
```

## 9. Primeiro acesso

Abra no navegador:

```text
http://<IP_ZABBIX>/zabbix
```

No assistente web:

1. selecione o idioma;
2. valide os pré-requisitos;
3. informe banco, usuário e senha;
4. confirme as configurações;
5. finalize a instalação.

## 10. Credenciais iniciais

```text
Usuário: Admin
Senha: zabbix
```

> Recomenda-se trocar a senha padrão imediatamente.

## Verificações pós-instalação

- `systemctl status zabbix-server`
- `systemctl status zabbix-agent`
- `systemctl status apache2`
- teste de acesso ao frontend;
- teste de coleta do host local.

## Observações

Este guia atende bem o laboratório documentado. Para produção, revisar:

- HTTPS;
- retenção de dados;
- tuning do banco;
- sizing de CPU, RAM e disco;
- permissões e segregação de funções.
