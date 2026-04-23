# Integração com LDAP / Active Directory

Este documento descreve a trilha de integração do Zabbix com **Active Directory** para autenticação via **LDAP**.

## Objetivo

Permitir que usuários do domínio autentiquem no Zabbix com credenciais corporativas, aproximando o laboratório de um cenário real de governança e controle de acesso.

## Exemplo de ambiente

- **Controlador de domínio:** `SVR02`
- **Domínio:** `joao23.local`
- **IP do DC:** `<IP_AD>`
- **Usuário de bind:** `zabbix ldap`
- **DN de exemplo:** `CN=zabbix ldap,OU=zabbix,DC=joao23,DC=local`

Usuário de teste:

- `sAMAccountName`: `washington.meireles`
- `userPrincipalName`: `washington.meireles@joao23.local`

## Teste com `ldapsearch`

Instale utilitários:

```bash
sudo apt install -y ldap-utils
```

Exemplo de teste:

```bash
ldapsearch -x -H ldap://<IP_AD>:389   -D "CN=zabbix ldap,OU=zabbix,DC=joao23,DC=local" -W   -b "DC=joao23,DC=local" "(sAMAccountName=washington.meireles)"
```

Retorno esperado:

```text
result: 0 Success
```

## Configuração no Zabbix

Caminho sugerido:

```text
Administração → Autenticação → Servidores LDAP → Criar servidor LDAP
```

### Campos principais

- **Nome:** `SVR02` ou nome lógico do servidor LDAP
- **Host:** `<IP_AD>`
- **Porta:** `389`
- **Base DN:** `DC=joao23,DC=local`
- **Atributo de pesquisa:** `sAMAccountName`
- **Bind DN:** `CN=zabbix ldap,OU=zabbix,DC=joao23,DC=local`
- **Senha do bind:** `<SENHA_ZABBIX_LDAP>`
- **Filtro de busca:** `(&(objectClass=user)(sAMAccountName={user}))`

> Para laboratório, o uso de LDAP simples pode ser suficiente. Para produção, prefira **LDAPS** ou **StartTLS**.

## Habilitação da autenticação LDAP

Ainda em autenticação:

- alterar o tipo de autenticação para **LDAP**;
- selecionar o servidor LDAP cadastrado;
- salvar as configurações.

## Criação de usuários no Zabbix

Mesmo usando LDAP, normalmente é necessário definir usuários/grupos locais no Zabbix para controle de perfil e permissões.

Exemplo:

- usuário: `washington.meireles`
- autenticação: LDAP
- grupo: `Zabbix administrators` ou grupo customizado

## Mapeamento de grupos

Em ambientes mais maduros, o ideal é mapear grupos do AD para grupos do Zabbix, permitindo:

- centralização de acesso;
- delegação de administração por área;
- controle mais limpo de permissões.

## Troubleshooting

### `Can't contact LDAP server`

- validar IP e porta;
- testar conectividade de rede;
- revisar firewall;
- validar nome do host e resolução DNS.

### `Invalid credentials (49)`

- revisar bind DN;
- revisar senha do usuário de bind;
- validar se a conta está ativa.

### Usuário não encontrado

- revisar filtro de busca;
- validar se o login usa `sAMAccountName` ou `userPrincipalName`;
- testar busca manual com `ldapsearch`.

## Recomendação para produção

- usar conta de serviço dedicada;
- restringir permissões da conta de bind;
- preferir LDAPS/StartTLS;
- documentar grupos e perfis;
- auditar acessos e revisões de permissão.
