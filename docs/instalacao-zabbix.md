
---

### `docs/instalacao-zabbix.md`

```markdown
# Instalação e Configuração do Zabbix Server (Ubuntu 22.04)

Este documento descreve o processo de instalação do **Zabbix Server**, **Frontend** e **Agent** em uma VM Ubuntu Server 22.04 (SVR-ZABBIX).

## 1. Preparação do Sistema

Atualizar pacotes:

```bash
sudo apt update
sudo apt upgrade -y
Instalar utilitários básicos:

sudo apt install -y vim nano curl wget net-tools sysstat \
  software-properties-common gnupg2
2. Configurar Locale e Timezone
Timezone:

sudo timedatectl set-timezone America/Sao_Paulo
Locales (português Brasil):

sudo apt install -y language-pack-pt
sudo locale-gen pt_BR.UTF-8
sudo update-locale
3. Instalação do Banco de Dados (MariaDB/MySQL)
Instalar servidor de banco:

sudo apt install -y mariadb-server mariadb-client
sudo systemctl enable mariadb
sudo systemctl start mariadb
(Detalhes de criação do banco e usuário no arquivo banco-de-dados.md.)

4. Adicionar Repositório do Zabbix
Exemplo usando Zabbix 7.0 em Ubuntu 22.04:


cd /tmp
wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_7.0-1+ubuntu22.04_all.deb

sudo dpkg -i zabbix-release_7.0-1+ubuntu22.04_all.deb
sudo apt update
5. Instalar Zabbix Server, Frontend e Agent

sudo apt install -y zabbix-server-mysql zabbix-frontend-php \
  zabbix-apache-conf zabbix-sql-scripts zabbix-agent
6. Importar Schema do Zabbix no Banco
Após criar o banco e o usuário (ver banco-de-dados.md):

zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | \
  mysql -uzabbix -p'<SENHA_BANCO_ZABBIX>' zabbix
Verificar se as tabelas foram criadas:


mysql -uzabbix -p'<SENHA_BANCO_ZABBIX>' zabbix -e "show tables;" | head
7. Configurar zabbix_server.conf
Editar:


sudo nano /etc/zabbix/zabbix_server.conf
Ajustar:

DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=<SENHA_BANCO_ZABBIX>
Salvar e sair.

8. Configurar PHP/Apache para o Zabbix
O pacote zabbix-apache-conf normalmente cria /etc/apache2/conf-enabled/zabbix.conf.

Pontos importantes:

Timezone PHP:

Dentro de zabbix.conf (ou outro arquivo de PHP do Zabbix):


php_value date.timezone America/Sao_Paulo
Validar configuração do Apache:


sudo apache2ctl configtest
# Deve retornar "Syntax OK"
Reiniciar Apache:


sudo systemctl restart apache2
sudo systemctl enable apache2
9. Iniciar Serviços do Zabbix

sudo systemctl restart zabbix-server zabbix-agent
sudo systemctl enable zabbix-server zabbix-agent
sudo systemctl status zabbix-server
O zabbix-server deve ficar active (running).

10. Primeiro Acesso ao Zabbix
No navegador:

http://<IP_ZABBIX>/zabbix
Seguir o wizard:

Escolher idioma (Português).

Validar pré-requisitos.

Configurar DB:

Tipo: MySQL

Host: localhost

DB: zabbix

Usuário: zabbix

Senha: <SENHA_BANCO_ZABBIX>

Confirmar configurações.

Finalizar instalação.

Login inicial:

Usuário: Admin

Senha padrão: zabbix (recomendado trocar em seguida).


Em lab, pode ser mudada para outra senha forte, documentada fora do repositório ou usando placeholders neste projeto.
