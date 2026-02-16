<p align="center">
  <a href="https://monochrome.tf">
    <img src="https://github.com/monochrome-music/monochrome/blob/main/public/assets/512.png?raw=true" alt="Logo Monochrome" width="150px">
  </a>
</p>

<h1 align="center">Monochrome</h1>

<p align="center">
  <strong>Um app de música open-source, que respeita sua privacidade e sem anúncios.</strong>
</p>

<p align="center">
  <a href="https://monochrome.tf">Website</a> •
  <a href="https://ko-fi.com/monochromemusic">Doar</a> •
  <a href="#funcionalidades">Funcionalidades</a> •
  <a href="#instalação">Instalação</a> •
  <a href="#como-usar">Como Usar</a> •
  <a href="#self-hosting">Self-Hosting</a> •
  <a href="CONTRIBUTE.md">Contribuir</a>
</p>

<p align="center">
  <a href="https://github.com/monochrome-music/monochrome/stargazers">
    <img src="https://img.shields.io/github/stars/monochrome-music/monochrome?style=for-the-badge&color=ffffff&labelColor=000000" alt="Estrelas no GitHub">
  </a>
  <a href="https://github.com/monochrome-music/monochrome/forks">
    <img src="https://img.shields.io/github/forks/monochrome-music/monochrome?style=for-the-badge&color=ffffff&labelColor=000000" alt="Forks no GitHub">
  </a>
  <a href="https://github.com/monochrome-music/monochrome/issues">
    <img src="https://img.shields.io/github/issues/monochrome-music/monochrome?style=for-the-badge&color=ffffff&labelColor=000000" alt="Issues no GitHub">
  </a>
</p>

---

## O que é o Monochrome?

**Monochrome** é uma interface web open-source, que respeita sua privacidade e sem anúncios para [TIDAL](https://tidal.com), construída sobre o [Hi-Fi](https://github.com/binimum/hifi-api). Ele oferece uma interface bonita e minimalista para streaming de música em alta qualidade, sem a poluição visual das plataformas de streaming tradicionais.

<p align="center">
  <a href="https://monochrome.tf/#album/90502209">
    <img width="2559" height="1439" alt="imagem" src="https://github.com/user-attachments/assets/7973ea9f-c4aa-4c12-b476-f388f614db38"  alt="Interface do Monochrome" width="800">
  </a>
</p>

---

## Funcionalidades

### Qualidade de Áudio

- Streaming de áudio Hi-Res/lossless de alta qualidade
- Suporte para arquivos de música locais
- Cache inteligente de API para melhor desempenho

### Interface

- Interface escura e minimalista otimizada para foco
- Temas personalizáveis
- Visualizador de áudio preciso e único
- Progressive Web App (PWA) com capacidade offline
- Integração com Media Session API para controles do sistema

### Biblioteca e Organização

- Rastreamento de Tocadas Recentemente para acesso fácil ao histórico
- Biblioteca Pessoal completa para favoritos
- Gerenciamento de fila com modos aleatório e repetição
- Importação de playlists de outras plataformas
- Playlists públicas para compartilhamento social
- Recomendações inteligentes para novas músicas, álbuns e artistas

### Letras e Metadados

- Suporte a letras com modo karaokê
- Integração com Genius para letras
- Downloads de faixas com incorporação automática de metadados

### Integrações

- Sistema de contas para sincronização entre dispositivos
- Integração com Last.fm e ListenBrainz para scrobbling
- Músicas não lançadas via [ArtistGrid](https://artistgrid.cx)
- Embeds dinâmicos do Discord
- Suporte a múltiplas instâncias de API com failover

### Funcionalidades Avançadas

- Atalhos de teclado para usuários avançados

---

## Início Rápido

### Instância Online

Nossa forma recomendada de usar o Monochrome é através da nossa instância oficial:

**[monochrome.tf](https://monochrome.tf)**

Para instâncias alternativas, veja [INSTANCES.md](INSTANCES.md).

---

## Self-Hosting

NOTA: Contas não funcionam em instâncias self-hosted.

### Opção 1: Docker (Recomendado)

```bash
git clone https://github.com/monochrome-music/monochrome.git
cd monochrome
docker compose up -d
```

Acesse `http://localhost:8080`

Para PocketBase, modo de desenvolvimento e configurações avançadas, veja [DOCKER.md](DOCKER.md).

### Opção 2: Instalação Manual

#### Pré-requisitos

- [Node.js](https://nodejs.org/) (Versão 20+ ou 22+ recomendada)
- [Bun](https://bun.sh/) ou [npm](https://www.npmjs.com/)

#### Desenvolvimento Local

1. **Clone o repositório:**

    ```bash
    git clone https://github.com/monochrome-music/monochrome.git
    cd monochrome
    ```

2. **Instale as dependências:**

    ```bash
    bun install
    # ou
    npm install
    ```

3. **Inicie o servidor de desenvolvimento:**

    ```bash
    bun run dev
    # ou
    npm run dev
    ```

4. **Abra seu navegador:**
   Acesse `http://localhost:8080/`

#### Build para Produção

```bash
bun run build
# ou
npm run build
```

### Opção 3: Pterodactyl

Use o script `start.sh` incluído para deploy no Pterodactyl:

```bash
chmod +x start.sh
./start.sh
```

O script automaticamente:
1. Baixa e instala o PocketBase
2. Inicia o banco de dados na porta 7284
3. Instala dependências Node.js
4. Faz o build e serve o frontend na porta 8080

---

## Como Usar

### Uso Básico

1. Acesse o [Website](https://monochrome.tf) ou seu servidor de desenvolvimento local
2. Pesquise seus artistas, álbuns ou faixas favoritos
3. Clique em play para começar a ouvir
4. Use os controles de mídia para gerenciar reprodução, fila e volume

### Atalhos de Teclado

| Atalho   | Ação              |
| -------- | ----------------- |
| `Espaço` | Play/Pausa        |
| `→`      | Próxima faixa     |
| `←`      | Faixa anterior    |
| `↑`      | Aumentar volume   |
| `↓`      | Diminuir volume   |
| `M`      | Mutar/Desmutar    |
| `L`      | Alternar letras   |
| `F`      | Tela cheia        |
| `/`      | Focar na pesquisa |

### Funcionalidades de Conta

Para sincronizar sua biblioteca, histórico e playlists entre dispositivos:

1. Clique na seção "Contas"
2. Faça login com Google ou Email
3. Seus dados serão sincronizados automaticamente em todos os dispositivos

---

## Contribuindo

Nós aceitamos contribuições da comunidade! Veja nosso [Guia de Contribuição](CONTRIBUTE.md) para:

- Configuração do ambiente de desenvolvimento
- Estilo de código e linting
- Estrutura do projeto
- Convenções de mensagens de commit
- Informações de deploy

---

<p align="center">
  <a href="https://fmhy.net/audio#streaming-sites">
    <img src="https://raw.githubusercontent.com/monochrome-music/monochrome/refs/heads/main/public/assets/asseenonfmhy880x310.png" alt="Visto no FMHY" height="50">
  </a>
</p>

<p align="center">
  Feito com ❤️ pelo time Monochrome
</p>
