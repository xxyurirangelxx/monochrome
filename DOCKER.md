# Guia de Deploy com Docker

## Início Rápido

### Apenas Monochrome

```bash
docker compose up -d
```

Acesse `http://localhost:8080`

### Com PocketBase

```bash
cp .env.example .env
# Edite .env -- defina PB_ADMIN_EMAIL e PB_ADMIN_PASSWORD
docker compose --profile pocketbase up -d
```

- Monochrome: `http://localhost:8080`
- Admin PocketBase: `http://localhost:7284/_/`

Configure as coleções do PocketBase conforme [banco-de-dados-self-hosted.md](banco-de-dados-self-hosted.md).

### Desenvolvimento

```bash
docker compose --profile dev up -d
```

Acesse `http://localhost:8080` (hot-reload ativado)

---

## Como Funciona

### Perfis

[Perfis](https://docs.docker.com/compose/how-tos/profiles/) do Docker Compose controlam quais serviços iniciam. Um serviço sem perfil sempre inicia. Um serviço com perfil só inicia quando aquele perfil é ativado.

| Comando                                                   | O que inicia                              |
| --------------------------------------------------------- | ----------------------------------------- |
| `docker compose up -d`                                    | Monochrome                                |
| `docker compose --profile pocketbase up -d`               | Monochrome + PocketBase                   |
| `docker compose --profile dev up -d`                      | Monochrome + Servidor de desenvolvimento  |
| `docker compose --profile dev --profile pocketbase up -d` | Monochrome + Dev + PocketBase             |

No `docker-compose.yml`, fica assim:

```yaml
services:
    monochrome: # sem perfil -- sempre inicia

    pocketbase:
        profiles: ['pocketbase'] # opcional

    monochrome-dev:
        profiles: ['dev'] # opcional
```

### Arquivo Override

O Docker Compose automaticamente mescla o `docker-compose.override.yml` com o `docker-compose.yml` se ele existir no mesmo diretório. Não precisa de flags.

Isso é útil para forks que precisam adicionar serviços personalizados ou configurações (labels do Traefik, containers extras, redes customizadas) sem modificar o `docker-compose.yml` base.

O arquivo override não existe no repositório upstream, não procure por ele!

**Exemplo** -- adicionando labels do Traefik ao PocketBase no seu fork:

```yaml
# docker-compose.override.yml
services:
    pocketbase:
        labels:
            - traefik.enable=true
            - traefik.http.routers.pocketbase.rule=Host(`pocketbase.exemplo.com`)
            - traefik.http.routers.pocketbase.entrypoints=websecure
            - traefik.http.routers.pocketbase.tls.certresolver=letsencrypt
            - traefik.http.services.pocketbase.loadbalancer.server.port=8090
        networks:
            - rede-proxy

networks:
    rede-proxy:
        external: true
```

**Exemplo** -- adicionando um serviço personalizado no seu fork:

```yaml
# docker-compose.override.yml
services:
    minha-api-customizada:
        image: minha-api:latest
        restart: unless-stopped
        ports:
            - '4000:4000'
        networks:
            - monochrome-network
```

Arquivos override podem estender serviços existentes (adicionar labels, variáveis de ambiente, redes) e definir serviços totalmente novos. Veja a [documentação do Docker](https://docs.docker.com/compose/how-tos/multiple-compose-files/merge/) para o comportamento completo de mesclagem.

---

## Deploy no Portainer

O Portainer pode fazer deploy diretamente do seu fork no GitHub com atualizações automáticas a cada push.

### Configuração

1. No Portainer, vá em **Stacks > Add Stack > Repository**
2. Insira a URL do seu fork e a branch
3. Caminho do Compose: `docker-compose.yml`
4. Se o seu fork tiver um `docker-compose.override.yml`, o Portainer carrega automaticamente
5. Em **Variáveis de ambiente**, adicione:
    - `COMPOSE_PROFILES=pocketbase` (para habilitar o PocketBase -- omita se não precisar)
    - `PB_ADMIN_EMAIL=seu@email.com`
    - `PB_ADMIN_PASSWORD=sua_senha_segura`
    - Qualquer outra variável do `.env.example`
6. Ative **Atualizações GitOps** para re-deploy automático a cada push

> **Dica:** `COMPOSE_PROFILES` é uma variável nativa do Docker Compose. Defini-la como `pocketbase` é equivalente a passar `--profile pocketbase` na linha de comando.

> **Aviso:** O perfil `dev` é apenas para **desenvolvimento local**. Ele usa montagem de volumes para hot-reload, o que requer que o código-fonte esteja presente na máquina host. **Não** inclua `dev` em `COMPOSE_PROFILES` em deploys do Portainer via GitHub — vai falhar porque não há código-fonte local para montar.

### Fluxo com Fork

Para adicionar serviços personalizados (Traefik, monitoramento, etc.) ao seu fork:

1. Crie o `docker-compose.override.yml` no seu fork
2. Remova a linha `docker-compose.override.yml` do `.gitignore`
3. Faça commit das duas mudanças no seu fork
4. O Portainer carregará automaticamente o arquivo override junto com o compose base

Ao puxar atualizações do upstream (`git pull upstream main`), não há conflitos -- o repositório upstream não tem um arquivo override.

---

## Operações Comuns

```bash
# Ver logs
docker compose logs -f
docker compose logs -f pocketbase

# Rebuildar após mudanças no código
docker compose up -d --build

# Parar tudo (inclua todos os perfis que você iniciou)
docker compose --profile pocketbase down

# Parar e remover volumes (perde dados!)
docker compose --profile pocketbase down -v

# Backup dos dados do PocketBase
docker compose exec pocketbase tar czf - /pb_data > backup.tar.gz

# Restaurar dados do PocketBase
docker compose exec pocketbase tar xzf - -C / < backup.tar.gz
```

---

## Arquitetura

### Produção (Dockerfile)

Imagem Node.js Alpine (multi-arch: amd64 + arm64). Instala dependências, roda `vite build`, depois serve os arquivos compilados com `vite preview` na porta 8080.

### Desenvolvimento (Dockerfile.dev)

Imagem Node.js Alpine com código-fonte montado como volume para hot-reload.

### Arquivos

| Arquivo                       | Propósito                         | No repositório upstream |
| ----------------------------- | --------------------------------- | :---------------------: |
| `docker-compose.yml`          | Todos os serviços com perfis      |           Sim           |
| `docker-compose.override.yml` | Personalizações do fork           |           Não           |
| `.env.example`                | Template de variáveis de ambiente |           Sim           |
| `.env`                        | Sua configuração local            |           Não           |
| `Dockerfile`                  | Build de produção                 |           Sim           |
| `Dockerfile.dev`              | Build de desenvolvimento          |           Sim           |
| `.dockerignore`               | Exclusões do contexto de build    |           Sim           |
