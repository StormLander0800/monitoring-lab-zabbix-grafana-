---

### `docs/ldap-ad.md`

```markdown
# Integração Zabbix com Active Directory / LDAP

Este documento descreve como integrar o Zabbix com um domínio **Active Directory** para autenticação via LDAP.

## 1. Ambiente AD (Exemplo)

- Controlador de domínio: `SVR02`
- Domínio: `joao23.local`
- IP do DC: `<IP_AD>`
- Usuário de serviço (bind):
  - `zabbix ldap`
  - DN: `CN=zabbix ldap,OU=zabbix,DC=joao23,DC=local`

Usuário de teste:

- `sAMAccountName`: `washington.meireles`
- `userPrincipalName`: `washington.meireles@joao23.local`

## 2. Ferramentas de Teste (ldapsearch)

Instalar:

```bash
sudo apt install -y ldap-utils
Teste de bind + busca:

bash
Copiar código
ldapsearch -x -H ldap://<IP_AD>:389 \
  -D "CN=zabbix ldap,OU=zabbix,DC=joao23,DC=local" -W \
  -b "DC=joao23,DC=local" "(sAMAccountName=washington.meireles)"
Resultado esperado:

result: 0 Success

Atributos do usuário retornados (sAMAccountName, CN, UPN, etc.)

Se retornar Invalid credentials (49):

Verificar:

DN do usuário de bind.

Senha.

Se conta está bloqueada/desabilitada.

3. Configuração no Zabbix
No Zabbix:

Administração → Autenticação → Servidores LDAP → Criar servidor LDAP

Preencher:

Nome: SVR02 (exemplo)

Host: <IP_AD>

Porta: 389

Base DN: DC=joao23,DC=local

Atributo de pesquisa: sAMAccountName

Bind DN:
CN=zabbix ldap,OU=zabbix,DC=joao23,DC=local

Senha para o Bind: <SENHA_ZABBIX_LDAP>

StartTLS: desmarcado (para lab; em produção usar LDAPS/TLS)

Filtro de busca:
(&(objectClass=user)(sAMAccountName={user}))

Clicar em Adicionar.

Testar conexão

Botão Testar

No popup:

Login: washington.meireles

Senha do usuário: senha real deste usuário no AD

Se tudo estiver correto, o teste deve passar.

4. Habilitar Autenticação LDAP
Ainda em Administração → Autenticação:

Na aba Geral:

Tipo de autenticação: LDAP

Servidor LDAP: SVR02

Salvar.

5. Usuários no Zabbix
Criar usuários vinculados ao AD:

Administração → Utilizadores → Criar usuário

Campos principais:

Alias/Username: washington.meireles

Tipo de autenticação: LDAP

Grupos de utilizadores: por exemplo, Zabbix administrators (ou grupo customizado)

Salvar.

Agora, o login no Zabbix pode ser feito com:

Usuário: washington.meireles

Senha: senha do domínio (AD).

6. Mapeamento de Grupos
Em produção, é comum:

Criar grupos no AD (ex.: TI-Monitoramento).

Criar grupos de utilizadores equivalentes no Zabbix (ex.: TI-Monitoramento).

Utilizar as opções de integração do Zabbix (versões mais recentes) para mapear grupos AD → grupos Zabbix.

Isso permite:

Controle de acesso centralizado (perfis diferentes por área).

Gerenciamento simples via AD.

7. Troubleshooting
Problemas comuns:

“Can't contact LDAP server”

IP/porta incorretos.

Firewall bloqueando porta 389.

“Invalid credentials (49)”

Bind DN ou senha errados.

Conta bloqueada/expirada.

Usuário não encontrado

Filtro de busca não bate com atributo usado (ex.: login é UPN, mas filtro usa sAMAccountName).

Ajustar Atributo de pesquisa e Filtro de busca:

Para login via UPN (e-mail):

Atributo: userPrincipalName

Filtro: (&(objectClass=user)(userPrincipalName={user}))