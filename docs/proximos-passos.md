
---

### `docs/proximos-passos.md`

```markdown
# Próximos Passos e Evolução do Lab

Este documento lista melhorias e próximos passos para evoluir o lab de monitoramento com Zabbix + Grafana.

## 1. LDAP / Active Directory

- [ ] Finalizar e validar autenticação LDAP no Zabbix:
  - Confirmar login de usuários do domínio.
  - Mapear grupos do AD para grupos do Zabbix.
- [ ] Criar grupos específicos:
  - `TI-Monitoramento`
  - `Infraestrutura`
  - `Desenvolvimento`
- [ ] Definir permissões por grupo (read-only, admin, etc.).

## 2. Hosts e Descoberta de Rede

- [ ] Listar todos os servidores e estações críticos:
  - Controladores de domínio
  - Servidores de arquivos
  - Aplicações internas
  - Estações de trabalho-chave
- [ ] Implantações em massa do Zabbix Agent:
  - Via GPO (MSI em estações Windows).
  - Via scripts/Ansible/SSH para Linux.
- [ ] Configurar descoberta de rede (Discovery):
  - Descoberta por ICMP (ping).
  - Descoberta de serviços (ports scan leve).
  - Descoberta SNMP para switches/routers.

## 3. Templates e Itens

- [ ] Revisar templates oficiais Zabbix:
  - `Template OS Linux`
  - `Template OS Windows`
  - Templates de rede/snmp
- [ ] Criar templates customizados:
  - Aplicações internas (por exemplo, sistemas acadêmicos, ERPs, etc.).
  - Serviços específicos (HTTP, DB, SMTP, etc.).
- [ ] Habilitar e ajustar **Inventário Automático** para todos os hosts:
  - Serial, modelo, SO, localização, responsável, etc.

## 4. Dashboards no Grafana

- [ ] Dashboard “Infraestrutura”:
  - CPU/Memória/Disco de servidores principais.
  - Status dos agentes.
- [ ] Dashboard “AD / Autenticação”:
  - Monitorar DCs, logs (se integrados), uso de CPU/memória.
- [ ] Dashboard “Rede”:
  - Latência/ping para gateways, cloud, serviços externos.
- [ ] Painel “Problemas em Tempo Real”:
  - Baseado em `Problems` do datasource Zabbix
  - Filtrado por severidade e grupos.

## 5. Alertas e Notificações

- [ ] Configurar media types:
  - E-mail (SMTP).
  - Eventualmente Telegram/Slack.
- [ ] Criar actions:
  - Host down (ping e agente).
  - Disco acima de X%.
  - Memória/CPU em uso alto.
- [ ] Ajustar tempo de repetição e escalonamento:
  - Alertas para N1, escalando para N2 após X minutos.

## 6. Segurança e Hardening

- [ ] Trocar senhas padrão (`Admin` no Zabbix, `admin` no Grafana).
- [ ] Habilitar HTTPS no Zabbix e Grafana.
  - Certificados (autoassinado em lab, AC válida em produção).
- [ ] Restringir portas em firewall:
  - Permitir acesso a 80/443/3000 apenas de redes autorizadas.
- [ ] Revisar permissões de usuários:
  - Princípio do menor privilégio.

## 7. Backup e Recuperação

- [ ] Criar rotina de backup do banco `zabbix`.
- [ ] Backup de configurações:
  - Export de templates.
  - Export de hosts/grupos (quando aplicável).
  - Backup de `/etc/zabbix/` e configs do Grafana.
- [ ] Testar restauração:
  - Restaurar dump do banco em ambiente de teste.
  - Validar se dados e configurações voltam corretamente.

## 8. Documentação

- [ ] Atualizar documentação conforme ambiente evolui.
- [ ] Incluir prints de dashboards principais (para portfólio).
- [ ] Registrar problemas encontrados e soluções (troubleshooting log).

Este lab foi construído para ser base de estudo, portfólio e prova de conceito.  
Os próximos passos permitem aproximar o ambiente de um cenário de produção real, com governança, segurança, alertas e visualização profissional.
