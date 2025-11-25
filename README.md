# monitoring-lab-zabbix-grafana-
Lab de monitoramento com Zabbix + Grafana, MariaDB e integração com AD/LDAP.

# Lab de Monitoramento – Zabbix + Grafana

Projeto de laboratório para implantação de um ambiente completo de monitoramento
utilizando **Zabbix Server 7.x**, **Grafana** e **MariaDB/MySQL**, rodando em servidor
Linux (Ubuntu) virtualizado.

## Objetivos

- Configurar Zabbix Server com banco dedicado e agente local.
- Monitorar hosts Linux e Windows (inclusive controlador de domínio).
- Integrar Zabbix com Grafana via API para criação de dashboards.
- Iniciar integração de autenticação com Active Directory/LDAP.

## Tecnologias

- Ubuntu Server 22.04
- Zabbix Server 7.x + Zabbix Agent
- MariaDB/MySQL
- Grafana
- Active Directory / LDAP (em progresso)

## Documentação

Toda a documentação detalhada está na pasta [`docs/`](docs/):

- [Arquitetura do ambiente](docs/arquitetura.md)
- [Instalação e configuração do Zabbix](docs/instalacao-zabbix.md)
- [Configuração do banco de dados](docs/banco-de-dados.md)
- [Integração com Grafana](docs/instalacao-grafana.md)
- [Integração com LDAP/Active Directory](docs/ldap-ad.md)
- [Próximos passos e melhorias](docs/proximos-passos.md)

## Scripts

Todos os Scripsts de instalação zabbix estão na pasta [`scripts/`](scripts/)

- [Instalador Zabbix Agent Windowss](scripts/innstall_zabbix_agent_windows.ps1)
- [Instalador Zabbix Agent Ubuntu](scripts/innstall_zabbix_agent_ubuntu.sh)

## Status

- ✅ Zabbix Server instalado e operando
- ✅ Agentes configurados (servidor e host Windows)
- ✅ Grafana integrado ao Zabbix
- 🔧 LDAP/AD em configuração
- 🔧 Dashboards adicionais em construção

# Como reproduzir o lab de monitoramento (Zabbix + Grafana)

Este documento descreve, passo a passo, como recriar o laboratório utilizado neste projeto, usando **VirtualBox** e **Ubuntu Server 22.04**.

---

## 1. Pré-requisitos

### Hardware sugerido

- 8 GB de RAM (mínimo recomendado)
- Processador com suporte a virtualização (Intel VT-x / AMD-V)
- Espaço em disco livre: pelo menos 40 GB
- Conexão com a internet

### Software necessário

- Oracle **VirtualBox**
- ISO do **Ubuntu Server 22.04 (64-bit)**
- Acesso ao GitHub:
  - Repositório:
    https://github.com/StormLander0800/monitoring-lab-zabbix-grafana-

---

## 2. Criando a VM `SVRZABBIX` no VirtualBox

1. Abra o VirtualBox e clique em **Novo**.
2. Configure:
   - **Nome:** `SVRZABBIX`
   - **Tipo:** Linux
   - **Versão:** Ubuntu (64-bit)
3. Defina os recursos da VM:
   - **Memória RAM:** 2048 MB (2 GB)
   - **Processadores:** 4 vCPUs
4. Crie o disco rígido virtual:
   - Tipo: VDI
   - Alocação: Dinamicamente alocado
   - Tamanho: 25 GB
5. Ajustes finos (Configurações da VM):
   - **Sistema → Ordem de boot:** Disco rígido primeiro
   - **Tela:** configurações padrão (16 MB vídeo são suficientes)
   - **Rede → Adaptador 1:**
     - Habilitar placa de rede
     - Conectado a: **Placa em modo Bridge**
       - Assim a VM recebe IP na mesma rede que sua máquina física.
   - Demais opções (USB, Áudio etc.) podem permanecer padrão.

---

## 3. Instalação do Ubuntu Server 22.04

1. Inicie a VM `SVRZABBIX` usando a ISO do Ubuntu Server.
2. Siga o instalador e defina:
   - Idioma / Layout de teclado conforme preferência
   - **Hostname:** `svrzabbix`
   - Usuário e senha (ex.: `zabbixadm`)
3. Quando o instalador perguntar por **serviços adicionais**, marque:
   - **OpenSSH Server** (para poder acessar via SSH)
4. Configure rede:
   - Você pode deixar DHCP durante a instalação e depois fixar o IP,
     ou já configurar IP estático.
   - Exemplo de IP estático:
     - IP: `192.168.4.212`
     - Máscara: `255.255.255.0`
     - Gateway: IP do seu roteador
     - DNS: gateway ou servidor DNS público

Após finalizar, reinicie a VM e faça login com o usuário criado.

---

## 4. Preparando o ambiente na VM

Atualize o sistema e instale o Git:

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git
```
## Dashboards

![Visão global do Zabbix](images/dashboard-global-view.png)

![Dashboard no Grafana](images/grafana-dashboard.png)

## Arquitetura
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
```
