# Arquitetura do Lab de Monitoramento – Zabbix + Grafana

Este documento descreve a arquitetura lógica do ambiente de monitoramento criado com **Zabbix Server** e **Grafana**, utilizando **MariaDB/MySQL** como banco de dados e preparando o terreno para integração com **Active Directory/LDAP**.

---

## 1. Visão Geral do Ambiente

### 1.1. Servidor de Monitoramento

- **Hostname (lab):** `SVR-ZABBIX`
- **Domain Name (lab):** `zabbix.virtualbox.org`
- **Sistema Operacional:** Ubuntu Server 22.04 (VM no VirtualBox)
- **Endereço IP:** `192.168.4.212`

**Serviços principais rodando neste servidor:**

- Zabbix Server  
- Zabbix Frontend (Apache + PHP)  
- Zabbix Agent  
- MariaDB/MySQL (banco de dados `zabbix`)  
- Grafana  

### 1.2. Outros Componentes do Lab

- **Controlador de Domínio / AD (ex.: `SVR02`)**
  - Sistema: Windows Server (AD DS)
  - Serviços: Active Directory, DNS, (opcionalmente) Zabbix Agent
  - Domínio AD de exemplo: `joao23.local`
  - IP: `<IP_DO_AD>` (ex.: `192.168.1.2`)

- **Estações / Notebooks**
  - Windows 10/11 ou Linux
  - Com Zabbix Agent instalado e reportando para o `SVR-ZABBIX`

- **Cliente/Operador**
  - Acessa o ambiente via navegador:
    - Zabbix: `http://192.168.4.212/zabbix`
    - Grafana: `http://192.168.4.212:3000/`

---

## 2. Serviços e Endpoints

### 2.1. Zabbix

- **Frontend Web:**
  - URL: `http://192.168.4.212/zabbix`
- **Backend (zabbix-server):**
  - Serviço responsável por:
    - Coletar dados dos agentes
    - Avaliar triggers
    - Gerenciar eventos, problemas e ações
- **Zabbix Agent (servidor):**
  - Rodando no próprio `SVR-ZABBIX` para monitorar o host de monitoramento

### 2.2. Banco de Dados (MariaDB/MySQL)

- **Banco:** `zabbix`
- **Função:**
  - Armazenar:
    - Configuração (hosts, templates, triggers, macros etc.)
    - Dados históricos (itens, trends)
    - Problemas, eventos, auditoria

### 2.3. Grafana

- **URL:** `http://192.168.4.212:3000/`
- **Função:**
  - Consumir dados do Zabbix via API
  - Exibir dashboards customizados para:
    - Infraestrutura
    - AD
    - Problemas em tempo real
    - Outros cenários

### 2.4. Active Directory / LDAP (Integração Planejada)

- **Domínio:** `joao23.local`
- **Serviço:** LDAP (porta 389, opcional LDAPS 636)
- **Função no contexto do lab:**
  - Autenticação centralizada de usuários no Zabbix usando contas de domínio
  - Possível mapeamento de grupos AD → grupos de permissão no Zabbix

---

## 3. Fluxos de Comunicação

### 3.1. Zabbix Server ↔ Zabbix Agents

- **Protocolo:** TCP
- **Porta padrão do agente:** `10050`
- **Direção:**
  - Zabbix Server → Zabbix Agent (consultas passivas)
  - Zabbix Agent → Zabbix Server (itens ativos, se configurados)

**Exemplos de fluxo:**

- `SVR-ZABBIX` monitora ele mesmo:
  - `zabbix_server` → `zabbix_agentd` (localhost:10050)
- `SVR-ZABBIX` monitora `SVR02`:
  - `192.168.4.212` → `192.168.<IP_DO_AD>:10050`

### 3.2. Zabbix Server ↔ Banco de Dados

- **Protocolo:** TCP
- **Porta padrão:** `3306`
- **Direção:**
  - `zabbix_server` → `mysqld` (MariaDB/MySQL)
- **Uso:**
  - Consulta e gravação de:
    - Itens
    - Histórico
    - Eventos
    - Problemas
    - Configurações

### 3.3. Cliente ↔ Zabbix Frontend

- **Protocolo:** HTTP
- **Porta:** `80`
- **URL:** `http://192.168.4.212/zabbix`

Fluxo:

- Navegador do usuário → Apache → PHP → Zabbix Server (via banco e processos internos)

### 3.4. Cliente ↔ Grafana

- **Protocolo:** HTTP
- **Porta:** `3000`
- **URL:** `http://192.168.4.212:3000/`

Fluxo:

- Navegador → Grafana → (Data source Zabbix) → Zabbix API

### 3.5. Grafana ↔ Zabbix API

- **Protocolo:** HTTP (JSON-RPC)
- **URL:** `http://192.168.4.212/zabbix/api_jsonrpc.php`
- **Autenticação:**
  - Usuário e senha do Zabbix (por exemplo, um usuário dedicado para Grafana)

### 3.6. Zabbix ↔ Active Directory (LDAP) – Planejado

- **Protocolo:** LDAP
- **Porta:** `389` (LDAPS: 636)
- **Fluxo:**
  - Zabbix server → AD:
    - Faz **bind** com usuário de serviço (ex.: `zabbix ldap`)
    - Busca usuário que tenta logar (`sAMAccountName` ou `userPrincipalName`)
    - Valida credenciais

---

## 4. Diagrama Lógico Simplificado

```text
[ Usuário ]
   |                             
   | HTTP 80             HTTP 3000
   |------------------.   .-----------------> [ Grafana ]
                      |   |                        |
                      v   | HTTP API               | (Data source Zabbix)
              [ Zabbix Frontend ]                  |
                      |                            |
                      | PHP / Interno              v
                      |                     [ Zabbix API ]
                      |                            |
                      v                            |
                [ Zabbix Server ]-------------------
                      |
          ---------------------------
          |                        |
     TCP 3306                 TCP 10050
          |                        |
    [ MariaDB ]              [ Zabbix Agents ]
                               (SVR-ZABBIX, SVR02, PCs)

Zabbix Server → AD/LDAP (planejado)
  - TCP 389
  - Autenticação de usuários do domínio

---

## 5. Objetivo da Arquitetura

Esta arquitetura foi pensada para:

Representar um cenário realista de monitoramento:

Servidor dedicado (SVR-ZABBIX) concentrando Zabbix, banco e Grafana.

Hosts Windows/Linux monitorados via agente.

Controlador de domínio (AD) integrado para autenticação.

Servir como lab de estudo e portfólio:

Permite testar:

Coleta de métricas.

Criação de dashboards.

Alertas, triggers e integrações.

Autenticação centralizada com AD/LDAP.

Facilitar futura migração para produção:

Separando funções (banco, aplicação, visualização).

Permitindo escalar (separar MariaDB, Grafana, proxies Zabbix, etc.).

---

## 6. Considerações de Produção (Além do Lab)

Para um ambiente real, a mesma arquitetura pode ser endurecida com:

Zabbix Server em servidor dedicado ou cluster.

Banco de dados em servidor separado, com backup e tuning.

Grafana em instância separada, com HTTPS e autenticação integrada (LDAP/SSO).

Proxies do Zabbix em filiais / redes remotas.

Uso de HTTPS para:

Zabbix Frontend

API do Zabbix (consumida pelo Grafana)

Hardening de firewall:

Expor apenas portas necessárias para redes específicas.

Este documento descreve como o lab está organizado e abre caminho para evolução do ambiente em direção a um cenário de produção mais robusto.


