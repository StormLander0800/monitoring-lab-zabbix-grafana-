
---

### `docs/instalacao-grafana.md`

```markdown
# Instalação e Integração do Grafana com Zabbix

Este documento descreve a instalação do **Grafana** e a configuração da integração com o **Zabbix** via API.

## 1. Instalação do Grafana (Ubuntu 22.04)

Adicionar repositório oficial:

```bash
sudo apt install -y apt-transport-https software-properties-common wget

wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

echo "deb https://packages.grafana.com/oss/deb stable main" | \
  sudo tee /etc/apt/sources.list.d/grafana.list

sudo apt update
sudo apt install -y grafana
Habilitar e iniciar serviço:

bash
Copiar código
sudo systemctl enable grafana-server
sudo systemctl start grafana-server
sudo systemctl status grafana-server
2. Primeiro Acesso ao Grafana
No navegador:

text
Copiar código
http://<IP_ZABBIX>:3000/
Credenciais padrão:

Usuário: admin

Senha: admin

No primeiro login, Grafana solicita a troca da senha.
No repositório, use placeholders:

Nova senha: <SENHA_ADMIN_GRAFANA>

3. Instalar Plugin Zabbix no Grafana
No servidor (opcional, se não vier no pacote):

bash
Copiar código
sudo grafana-cli plugins install alexanderzobnin-zabbix-app
sudo systemctl restart grafana-server
Ou utilizar plugins disponíveis via interface web (Admin → Plugins).

4. Configurar Fonte de Dados Zabbix
No Grafana (PT-BR):

Menu lateral → Conexões → Fontes de dados.

Clique em Adicionar fonte de dados.

Selecione Zabbix.

Configuração principal:

Name / Nome: Zabbix

URL:
http://<IP_ZABBIX>/zabbix/api_jsonrpc.php

Access: Server (recomendado quando Grafana e Zabbix estão no mesmo host).

Seção Zabbix API details:

User: usuário do Zabbix com permissão de leitura (ex.: grafana-api ou Admin em lab).

Password: <SENHA_USUARIO_ZABBIX_PARA_GRAFANA>

Salvar e testar:

Botão Save & Test → Deve retornar algo como “Data source is working”.

5. Criar Dashboards Básicos
5.1. Dashboard de Infraestrutura
Menu → Painéis de controle → Novo painel.

Fonte de dados: Zabbix.

Modo de consulta: Metrics.

Selecionar:

Group: Servidores Linux, Servidores Windows, etc.

Host: Zabbix server, SVR02, etc.

Application: CPU, Memory, Filesystem.

Item: CPU utilization, Memory utilization, Free disk space, etc.

5.2. Dashboard de Problemas em Tempo Real
Novo painel.

Fonte de dados: Zabbix.

Modo de consulta: Problems.

Filtrar:

Severidade mínima (Warning, Average, High, etc.).

Groups de hosts específicos (Infra, AD, Rede, etc.).

Este painel pode ser usado como visão geral em TV/monitor na sala de TI.

6. Boas Práticas
Criar um usuário específico no Zabbix para o Grafana (ex.: grafana-api).

Atribuir apenas permissões necessárias (somente leitura).

Trocar a senha padrão do admin do Grafana assim que o ambiente estiver funcional.

Em produção, utilizar HTTPS no Grafana e no Zabbix.