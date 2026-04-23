# Próximos passos do laboratório

Este documento organiza a evolução desejada do lab em blocos técnicos, ajudando a transformar o ambiente de estudo em uma prova de conceito mais madura.

## 1. Identidade e autenticação

- [ ] Finalizar autenticação LDAP no Zabbix
- [ ] Validar login com contas reais do domínio
- [ ] Estruturar grupos por função
- [ ] Mapear grupos AD → grupos do Zabbix
- [ ] Revisar privilégios segundo menor privilégio

## 2. Cobertura de monitoramento

- [ ] Inventariar hosts prioritários
- [ ] Expandir agentes Windows e Linux
- [ ] Criar política de templates por tipo de host
- [ ] Habilitar descoberta controlada de rede
- [ ] Avaliar SNMP para switches, roteadores e appliances

## 3. Dashboards e visualização

- [ ] Criar dashboard executivo
- [ ] Criar painel técnico por sistema operacional
- [ ] Criar painel para controladores de domínio
- [ ] Criar visão de problemas em tempo real
- [ ] Padronizar nomenclatura e organização dos painéis

## 4. Alertas e resposta

- [ ] Definir severidades e critérios de trigger
- [ ] Configurar notificações por e-mail
- [ ] Avaliar integrações com mensageria
- [ ] Ajustar escalonamento e repetição de alertas
- [ ] Registrar playbooks básicos de resposta

## 5. Segurança e hardening

- [ ] Trocar todas as senhas padrão
- [ ] Habilitar HTTPS no Zabbix e no Grafana
- [ ] Restringir acesso por firewall
- [ ] Revisar exposição de portas
- [ ] Proteger segredos e credenciais fora do repositório

## 6. Continuidade e recuperação

- [ ] Automatizar backup do banco
- [ ] Exportar templates e dashboards críticos
- [ ] Versionar configurações relevantes
- [ ] Testar restauração em ambiente separado
- [ ] Definir procedimento de recuperação do lab

## 7. Documentação e portfólio

- [ ] Registrar troubleshooting recorrente
- [ ] Adicionar screenshots adicionais
- [ ] Publicar changelog técnico do projeto
- [ ] Documentar decisões arquiteturais
- [ ] Incluir topologia e inventário do ambiente

## Prioridade sugerida

### Curto prazo

- finalizar LDAP;
- reforçar dashboards;
- trocar senhas padrão;
- validar backup básico.

### Médio prazo

- aplicar HTTPS;
- expandir descoberta e templates;
- organizar alertas por criticidade.

### Longo prazo

- separar camadas;
- avaliar proxy/escala;
- transformar o lab em ambiente de demonstração mais próximo de produção.
