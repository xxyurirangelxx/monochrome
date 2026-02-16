# Portão de Autenticação Global

Este documento explica o portão de login server-side opcional e o que ele implica para o seu site.

## Visão Geral

- Quando ativado, todas as rotas HTML exigem login.
- O login usa Firebase Auth (Google ou email) e troca um token de ID do Firebase por uma sessão no servidor.
- A sessão é armazenada em um cookie assinado e verificada em cada requisição.

## Onde funciona

- O portão funciona apenas no `vite preview` (servidor semelhante à produção).
- O servidor de desenvolvimento do Vite (`vite dev`) não ativa o portão.
- Hospedagem estática não pode forçar o portão, pois não há servidor para verificar tokens ou definir cookies.

## Fluxo

1. Usuário acessa `/` ou qualquer rota HTML.
2. Servidor verifica o cookie `mono_session`.
3. Se ausente, redireciona para `/login`.
4. Página de login faz login com Firebase e envia POST para `/api/auth/login`.
5. Servidor verifica o token de ID e define um cookie de sessão.
6. Usuário é redirecionado de volta para `/`.

## Configuração

- `AUTH_ENABLED=true` ativa o portão (padrão é false).
- `AUTH_SECRET` é obrigatório quando o portão está ativado. Ele assina o cookie de sessão.
- `AUTH_GOOGLE_ENABLED` habilita/desabilita login com Google em `/login` (padrão true).
- `AUTH_EMAIL_ENABLED` habilita/desabilita login com email/senha em `/login` (padrão true).
- `FIREBASE_PROJECT_ID` define o projeto Firebase usado para verificar tokens.
- `FIREBASE_CONFIG` (JSON) injeta configuração na página de login.
- `POCKETBASE_URL` oculta o campo de configuração de BD customizado nas configurações.
- `SESSION_MAX_AGE` define tempo de vida do cookie em ms (padrão 7 dias).

## Implicações para o site

- Requer um runtime de servidor. Hospedagem estática pura não forçará login.
- Requisições não autenticadas para assets não-HTML retornam 401.
- `/login` e `/login.html` permanecem acessíveis para iniciar o fluxo.
- Fazer logout limpa a sessão e redireciona para `/login`.
- Visitas autenticadas a `/login` redirecionam de volta para `/`.

## Ativar (Docker)

1. `cp .env.example .env`
2. Defina `AUTH_ENABLED=true` e `AUTH_SECRET=...`
3. Opcionalmente defina `FIREBASE_CONFIG` e `FIREBASE_PROJECT_ID`
4. `docker compose up -d`
5. Acesse `http://localhost:8080`

## Ativar (preview local)

1. `npm run build`
2. Defina variáveis de ambiente no seu shell ou no `.env`
3. `npm run preview`
