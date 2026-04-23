# Instalação e integração do Grafana

Este documento descreve a instalação do **Grafana** e sua integração com o **Zabbix** no laboratório.

## Objetivo

Adicionar uma camada visual mais flexível para:

- painéis executivos;
- visualização consolidada da infraestrutura;
- leitura histórica de métricas;
- criação de dashboards mais amigáveis para acompanhamento operacional.

## Instalação do Grafana

### 1. Adicionar repositório

```bash
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" |   sudo tee /etc/apt/sources.list.d/grafana.list
sudo apt update
```

### 2. Instalar pacote

```bash
sudo apt install -y grafana
```

### 3. Habilitar serviço

```bash
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
sudo systemctl status grafana-server
```

## Primeiro acesso

```text
http://<IP_ZABBIX>:3000/
```

Credenciais padrão iniciais do Grafana costumam ser:

```text
Usuário: admin
Senha: admin
```

> Na primeira autenticação, altere a senha imediatamente.

## Integração com Zabbix

A integração normalmente é feita por plugin/data source compatível com a API do Zabbix.

### Informações necessárias

- URL do frontend/API do Zabbix;
- usuário com permissão de leitura na API;
- senha do usuário do Zabbix;
- validação de conectividade entre Grafana e Zabbix.

### Exemplo de endpoint da API

```text
http://<IP_ZABBIX>/zabbix/api_jsonrpc.php
```

## Fluxo de uso

1. instalar plugin/data source do Zabbix no Grafana;
2. cadastrar a URL da API;
3. informar credenciais de acesso;
4. validar conexão;
5. importar ou criar dashboards.

## Sugestões de dashboards

- infraestrutura geral;
- consumo de CPU, memória e disco;
- disponibilidade de hosts críticos;
- problemas por severidade;
- visão por grupo de hosts;
- painéis específicos para AD, servidores ou serviços.

## Boas práticas

- criar usuário dedicado do Zabbix para o Grafana;
- evitar uso da conta administrativa padrão;
- restringir acesso à porta 3000;
- aplicar HTTPS em ambientes mais maduros;
- versionar/exportar dashboards importantes.
