# Guia de Configuração do Banco de Dados Self-Hosted

Este guia mostra como configurar seu próprio sistema de autenticação e banco de dados para contas do Monochrome.

> ⚠️ **Nota:** Você precisará inserir as mesmas configurações em cada dispositivo onde deseja usar seu banco de dados personalizado.

---

## Índice

- [Pré-requisitos](#pré-requisitos)
- [Passo 1: Configurar Autenticação Firebase](#passo-1-configurar-autenticação-firebase)
- [Passo 2: Configuração do PocketBase](#passo-2-configuração-do-pocketbase)
- [Passo 3: Configuração do Túnel Cloudflare](#passo-3-configuração-do-túnel-cloudflare)
- [Passo 4: Obtendo as Configurações](#passo-4-obtendo-as-configurações)
- [Passo 5: Vinculando ao Monochrome](#passo-5-vinculando-ao-monochrome)
- [Solução de Problemas](#solução-de-problemas)

---

## Pré-requisitos

Antes de começar, certifique-se de ter:

- Um computador para hospedar o banco de dados (também pode usar um VPS)
- Uma conta no [Firebase](https://firebase.google.com) (apenas para autenticação)
- [PocketBase](https://pocketbase.io) instalado na sua máquina host
- Um nome de domínio (opções gratuitas disponíveis no [DigitalPlat](https://domain.digitalplat.org/))

> 💡 **Este guia assume que você está configurando tudo na sua máquina local. O processo é idêntico para um VPS.**

---

## Passo 1: Configurar Autenticação Firebase

### 1.1 Criar um Projeto Firebase

1. Acesse o [Console Firebase](https://console.firebase.google.com)
2. Crie um novo projeto
3. Na barra lateral esquerda, clique em **Build** → **Authentication**
4. Clique em **Get Started**

### 1.2 Habilitar Métodos de Login

1. Vá na aba **Sign-in method**
2. Habilite os provedores **Google** e **Email**
3. Configure o email de suporte do projeto
4. Clique em **Save**

### 1.3 Autorizar Seu Domínio

O Firebase exige domínios autorizados para autenticação:

1. Em **Authentication** → **Settings** → **Authorized domains**
2. Clique em **Add domain**
3. Adicione seu domínio de hospedagem:
    - Se usando o site oficial do Monochrome: `monochrome.samidy.com` ou seu mirror preferido (ex: `monochrome.tf`)
    - Se fazendo self-hosting do site: adicione seu domínio personalizado

> 💡 `localhost` geralmente é adicionado por padrão para testes locais. Pode deixar habilitado.

---

## Passo 2: Configuração do PocketBase

### O que é PocketBase?

**PocketBase** é um banco de dados open-source leve e completo em um único arquivo executável. Ele fornece:

- 📦 **Banco de dados SQLite embutido** — sem precisar instalar MySQL, PostgreSQL ou MongoDB
- 🔐 **Sistema de autenticação integrado** — gerencia usuários nativamente
- 📡 **API REST automática** — cria endpoints automaticamente para cada coleção
- 📊 **Painel de administração web** — interface gráfica para gerenciar dados
- ⚡ **Super leve** — um único binário de ~15MB que roda em qualquer lugar
- 🔄 **Tempo real** — suporte a subscriptions em tempo real via SSE

Pense nele como um "Firebase self-hosted" — você tem as mesmas funcionalidades, mas tudo roda na **sua máquina**, sem depender de serviços na nuvem.

### 2.1 Instalar e Configurar

1. Baixe o [PocketBase](https://pocketbase.io) e siga o guia de configuração
2. Acesse a interface Admin do PocketBase (normalmente em `http://127.0.0.1:7284/_/`)

### 2.2 Criar Coleções

Crie duas coleções: `DB_users` e `public_playlists` (NÃO use a coleção "users" padrão)

#### Campos de DB_users

| Nome do Campo       | Tipo       | Descrição                                |
| ------------------- | ---------- | ---------------------------------------- |
| `firebase_id`       | Texto      | Vincula ao ID do usuário no Firebase     |
| `lastUpdated`       | Número     | Timestamp da última atualização          |
| `history`           | JSON       | Histórico de músicas ouvidas             |
| `library`           | JSON       | Biblioteca salva do usuário              |
| `user_playlists`    | JSON       | Playlists personalizadas do usuário      |
| `user_folders`      | JSON       | Pastas de playlists do usuário           |
| `deleted_playlists` | JSON       | Playlists removidas (soft-delete)        |

#### Campos de public_playlists

| Nome do Campo    | Tipo       | Descrição                                |
| ---------------- | ---------- | ---------------------------------------- |
| `firebase_id`    | Texto      | ID Firebase do criador                   |
| `addedAt`        | Número     | Timestamp de criação                     |
| `numberOfTracks` | Número     | Quantidade total de faixas               |
| `OriginalId`     | Texto      | ID original da playlist                  |
| `publishedAt`    | Número     | Timestamp de publicação                  |
| `title`          | Texto      | Título da playlist                       |
| `uid`            | Texto      | Identificador único                      |
| `uuid`           | Texto      | UUID da playlist                         |
| `tracks`         | JSON       | Dados das faixas da playlist             |
| `image`          | URL        | Imagem de capa da playlist               |

### 2.3 Configurar Regras de API

Defina as regras de API para ambas as coleções permitirem acesso de leitura/escrita:

**Regras de API de DB_users:**

- Regra de Listagem/Pesquisa: `firebase_id = @request.query.f_id`
- Regra de Visualização: `firebase_id = @request.query.f_id`
- Regra de Criação: `firebase_id = @request.query.f_id`
- Regra de Atualização: `firebase_id = @request.query.f_id`
- Regra de Exclusão: `firebase_id = @request.query.f_id`

**Regras de API de public_playlists:**

- Regra de Listagem/Pesquisa: `uuid = @request.query.p_id`
- Regra de Visualização: `id != ""`
- Regra de Criação: `firebase_id = @request.query.f_id`
- Regra de Atualização: `uid = @request.query.f_id`
- Regra de Exclusão: `uid = @request.query.f_id`

---

## Passo 3: Configuração do Túnel Cloudflare

Para tornar sua instância do PocketBase acessível de outros dispositivos com segurança:

### 3.1 Criar uma Conta Cloudflare

1. Cadastre-se no [Painel Cloudflare](https://dash.cloudflare.com)
2. Configure o **Zero Trust** (plano gratuito disponível)

### 3.2 Criar um Túnel

1. No painel da Cloudflare, vá em **Zero Trust** → **Networks** → **Connectors**
2. Selecione **Cloudflared**
3. Dê um nome ao seu túnel (ex: `monochrome-database`)
4. Siga o guia de instalação para o seu sistema operacional

### 3.3 Configurar Hostname

1. Na configuração do túnel, adicione um **Public Hostname**
2. **Subdomínio:** Escolha um subdomínio (ex: `db` para `db.seudominio.com`)
3. **Domínio:** Selecione seu domínio no dropdown
4. **Serviço:** Selecione **HTTP**
5. **URL:** Insira o endereço local do PocketBase (ex: `127.0.0.1:7284`)

> ⚠️ **Nota:** A Cloudflare exige um domínio válido. Domínios `.pages.dev` gratuitos não funcionam para isso. Obtenha um domínio gratuito no [DigitalPlat](https://domain.digitalplat.org/).

6. Salve a configuração

Seu banco de dados agora estará acessível no domínio escolhido!

---

## Passo 4: Obtendo as Configurações

### 4.1 Obter Configuração do Firebase

1. No [Console Firebase](https://console.firebase.google.com), abra seu projeto
2. Clique no ícone **⚙️ Configurações** ao lado de "Project Overview"
3. Selecione **Project settings**
4. Na aba **General**, role até "Your apps"
5. Clique no **ícone Web** (`</>`)
6. Registre seu app (ex: "Monochrome Auth")
7. Copie o objeto `firebaseConfig`:

```javascript
const firebaseConfig = {
    apiKey: 'AIzaSy...',
    authDomain: 'seu-projeto.firebaseapp.com',
    databaseURL: 'https://seu-projeto.firebaseio.com',
    projectId: 'seu-projeto',
    storageBucket: 'seu-projeto.appspot.com',
    messagingSenderId: '...',
    appId: '...',
};
```

> ⚠️ **Copie apenas o conteúdo do objeto dentro das chaves `{ ... }`**

### 4.2 Obter URL do Banco de Dados

Simplesmente copie seu domínio do PocketBase da Cloudflare (ex: `https://db.seudominio.com`)

---

## Passo 5: Vinculando ao Monochrome

Agora configure o Monochrome para usar seu backend personalizado:

1. Abra o Monochrome no seu navegador
2. Vá em **Configurações** (ícone de engrenagem)
3. Clique em **AVANÇADO: Banco de Dados de Conta Personalizado**
4. Insira suas configurações:
    - **Configuração do Banco de Dados:** Seu domínio do PocketBase (ex: `https://db.seudominio.com`)
    - **Configuração de Autenticação:** O objeto JSON de configuração do Firebase do Passo 4.1
5. Clique em **Salvar**

✅ **Pronto!** Sua instância do Monochrome agora está conectada ao seu banco de dados personalizado.

> 📝 **Importante:** Repita o Passo 5 em cada dispositivo onde deseja usar seu banco de dados personalizado.

---

## Solução de Problemas

### Não consigo fazer login

- Garanta que seu domínio está adicionado aos domínios autorizados do Firebase
- Verifique se o JSON de configuração do Firebase está formatado corretamente

### Erros de conexão com o banco de dados

- Verifique se seu túnel da Cloudflare está rodando
- Confirme que o PocketBase está acessível no seu domínio
- Garanta que as regras de API estão configuradas corretamente

### Dados não sincronizando

- Certifique-se de que está logado com a mesma conta em todos os dispositivos
- Verifique o console do navegador por mensagens de erro
- Confirme que suas coleções do banco de dados têm os campos corretos

---

## Dicas de Segurança

- Mantenha sua chave de API do Firebase segura (é ok expô-la para auth do lado do cliente, mas não compartilhe desnecessariamente)
- Faça backup regularmente do seu banco de dados PocketBase
- Use senhas fortes e únicas para suas contas da Cloudflare e Firebase
- Considere habilitar autenticação de dois fatores (2FA) em todas as contas

---

## Precisa de Ajuda?

- Entre na nossa [comunidade Discord](https://monochrome.tf/discord) (se disponível)
- Abra uma issue no [GitHub](https://github.com/monochrome-music/monochrome/issues)
- Verifique [issues existentes](https://github.com/monochrome-music/monochrome/issues) do GitHub por soluções
