# Arquitetura do laboratório

Este documento descreve a arquitetura lógica do ambiente de monitoramento construído com **Zabbix**, **Grafana** e **MariaDB**, com trilha planejada de autenticação centralizada via **Active Directory / LDAP**.

## Objetivo arquitetural

O laboratório foi desenhado para simular um cenário realista de monitoramento de infraestrutura, com uma estação central de coleta e visualização, hosts monitorados em sistemas diferentes e possibilidade de integração com diretório corporativo.

## Componentes do ambiente

### Servidor principal de monitoramento

- **Hostname:** `SVR-ZABBIX`
- **Sistema operacional:** Ubuntu Server 22.04
- **Execução:** máquina virtual em VirtualBox
- **Função:** concentrar a pilha principal do ambiente

**Serviços previstos no host:**

- Zabbix Server
- Zabbix Frontend
- Zabbix Agent local
- MariaDB/MySQL
- Grafana
- Apache + PHP

### Hosts monitorados

O ambiente prevê monitoramento de:

- servidores Linux;
- hosts Windows;
- controlador de domínio/serviços AD;
- estações e equipamentos relevantes para demonstração do lab.

### Diretório corporativo

- **Tecnologia:** Active Directory / LDAP
- **Objetivo:** autenticação centralizada de usuários no Zabbix
- **Status:** planejado/documentado para evolução do laboratório

## Fluxos principais de comunicação

### 1. Zabbix Server ↔ Zabbix Agents

- **Protocolo:** TCP
- **Porta padrão:** `10050`
- **Uso:** coleta de métricas, checagem de disponibilidade e leitura de itens configurados

### 2. Zabbix Server ↔ MariaDB

- **Protocolo:** TCP
- **Porta padrão:** `3306`
- **Uso:** persistência de configuração, histórico, eventos, problemas e inventário

### 3. Usuário ↔ Zabbix Frontend

- **Protocolo:** HTTP
- **Porta base do lab:** `80`
- **Uso:** administração do ambiente, hosts, triggers, ações e visualização operacional

### 4. Usuário ↔ Grafana

- **Protocolo:** HTTP
- **Porta base do lab:** `3000`
- **Uso:** dashboards executivos, painéis técnicos e visão consolidada

### 5. Grafana ↔ Zabbix API

- **Protocolo:** HTTP / JSON-RPC
- **Uso:** consulta de dados do Zabbix para painéis e visualizações personalizadas

### 6. Zabbix ↔ AD/LDAP

- **Protocolo:** LDAP ou LDAPS
- **Portas usuais:** `389` / `636`
- **Uso:** autenticação centralizada e futura associação com grupos de permissão

## Diagrama lógico simplificado

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
                               (Linux, Windows, AD)
```

## Decisões de desenho

### Arquitetura monolítica para laboratório

A pilha principal foi consolidada em um único servidor para simplificar implantação, reduzir consumo de recursos e facilitar aprendizado.

### Virtualização em VirtualBox

A escolha favorece reprodutibilidade em ambiente local, especialmente para estudo, demonstração e portfólio técnico.

### Grafana como camada de visualização

O Grafana complementa o frontend do Zabbix com dashboards mais executivos, melhorando apresentação, análise e leitura visual de métricas.

### LDAP/AD como trilha de maturidade

A integração com diretório agrega valor corporativo ao laboratório, aproximando o ambiente de cenários reais de governança e autenticação.

## Riscos e limitações do cenário atual

- único ponto de falha no servidor principal;
- ausência de TLS/HTTPS no fluxo base documentado;
- escalabilidade limitada para ambientes maiores;
- ausência de separação entre aplicação, banco e visualização;
- dependência de ajustes manuais em scripts e credenciais.

## Evolução recomendada para cenário mais maduro

- separar MariaDB, Zabbix e Grafana em camadas dedicadas;
- aplicar HTTPS/LDAPS;
- adicionar backup automatizado e restore testado;
- implementar Zabbix Proxy em redes remotas;
- incluir alta disponibilidade conforme criticidade do ambiente;
- reforçar hardening e monitoração da própria pilha.
