#!/bin/bash
# ============================================================================
#  Monochrome - Script de Inicialização para Pterodactyl
#  Este script inicia o PocketBase (banco de dados) e o frontend Monochrome
# ============================================================================

set -e

# --- Cores para o terminal ---
VERDE='\033[0;32m'
AMARELO='\033[1;33m'
VERMELHO='\033[0;31m'
AZUL='\033[0;34m'
CIANO='\033[0;36m'
SEM_COR='\033[0m'

# --- Configurações ---
PORTA_FRONTEND="${MONOCHROME_PORT:-8080}"
PORTA_POCKETBASE="${POCKETBASE_PORT:-7284}"
VERSAO_POCKETBASE="${POCKETBASE_VERSION:-0.25.9}"
DIRETORIO_DADOS_PB="./pb_data"
DIRETORIO_PB="./pocketbase"

echo -e "${CIANO}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                                                              ║"
echo "║    ███╗   ███╗ ██████╗ ███╗   ██╗ ██████╗                    ║"
echo "║    ████╗ ████║██╔═══██╗████╗  ██║██╔═══██╗                   ║"
echo "║    ██╔████╔██║██║   ██║██╔██╗ ██║██║   ██║                   ║"
echo "║    ██║╚██╔╝██║██║   ██║██║╚██╗██║██║   ██║                   ║"
echo "║    ██║ ╚═╝ ██║╚██████╔╝██║ ╚████║╚██████╔╝                   ║"
echo "║    ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝                   ║"
echo "║                                                              ║"
echo "║              🎵 Monochrome Music Player 🎵                   ║"
echo "║                  Servidor Self-Hosted                        ║"
echo "║                                                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${SEM_COR}"

# --- Função para exibir status ---
log_info() {
    echo -e "${AZUL}[INFO]${SEM_COR} $1"
}

log_sucesso() {
    echo -e "${VERDE}[✓]${SEM_COR} $1"
}

log_aviso() {
    echo -e "${AMARELO}[⚠]${SEM_COR} $1"
}

log_erro() {
    echo -e "${VERMELHO}[✗]${SEM_COR} $1"
}

# --- Detectar arquitetura do sistema ---
detectar_arquitetura() {
    local arch=$(uname -m)
    case "$arch" in
        x86_64|amd64)
            echo "amd64"
            ;;
        aarch64|arm64)
            echo "arm64"
            ;;
        armv7l|armhf)
            echo "armv7"
            ;;
        *)
            log_erro "Arquitetura não suportada: $arch"
            exit 1
            ;;
    esac
}

# --- Detectar sistema operacional ---
detectar_so() {
    local os=$(uname -s | tr '[:upper:]' '[:lower:]')
    case "$os" in
        linux)
            echo "linux"
            ;;
        darwin)
            echo "darwin"
            ;;
        *)
            log_erro "Sistema operacional não suportado: $os"
            exit 1
            ;;
    esac
}

# --- Baixar e instalar PocketBase ---
instalar_pocketbase() {
    local ARCH=$(detectar_arquitetura)
    local SO=$(detectar_so)

    log_info "Arquitetura detectada: ${ARCH}"
    log_info "Sistema operacional: ${SO}"

    # Verificar se o PocketBase já existe
    if [ -f "${DIRETORIO_PB}/pocketbase" ]; then
        log_sucesso "PocketBase já instalado em ${DIRETORIO_PB}/pocketbase"
        return 0
    fi

    log_info "Baixando PocketBase v${VERSAO_POCKETBASE} para ${SO}_${ARCH}..."

    mkdir -p "${DIRETORIO_PB}"

    local URL="https://github.com/pocketbase/pocketbase/releases/download/v${VERSAO_POCKETBASE}/pocketbase_${VERSAO_POCKETBASE}_${SO}_${ARCH}.zip"

    # Tentar com curl primeiro, depois wget
    if command -v curl &> /dev/null; then
        curl -fsSL "${URL}" -o /tmp/pocketbase.zip
    elif command -v wget &> /dev/null; then
        wget -q "${URL}" -O /tmp/pocketbase.zip
    else
        log_erro "Nem curl nem wget encontrados. Instale um dos dois."
        exit 1
    fi

    # Extrair
    if command -v unzip &> /dev/null; then
        unzip -o /tmp/pocketbase.zip -d "${DIRETORIO_PB}" > /dev/null 2>&1
    else
        log_erro "Comando 'unzip' não encontrado. Instale o unzip."
        exit 1
    fi

    rm -f /tmp/pocketbase.zip
    chmod +x "${DIRETORIO_PB}/pocketbase"

    log_sucesso "PocketBase v${VERSAO_POCKETBASE} instalado com sucesso!"
}

# --- Iniciar PocketBase em segundo plano ---
iniciar_pocketbase() {
    log_info "Iniciando PocketBase na porta ${PORTA_POCKETBASE}..."

    mkdir -p "${DIRETORIO_DADOS_PB}"

    # Matar qualquer instância anterior do PocketBase
    pkill -f "pocketbase serve" 2>/dev/null || true
    sleep 1

    # Iniciar PocketBase em segundo plano
    "${DIRETORIO_PB}/pocketbase" serve \
        --http="0.0.0.0:${PORTA_POCKETBASE}" \
        --dir="${DIRETORIO_DADOS_PB}" \
        &

    PB_PID=$!

    # Aguardar PocketBase iniciar
    log_info "Aguardando PocketBase inicializar..."
    local tentativas=0
    local max_tentativas=30

    while [ $tentativas -lt $max_tentativas ]; do
        if curl -sf "http://localhost:${PORTA_POCKETBASE}/api/health" > /dev/null 2>&1; then
            log_sucesso "PocketBase iniciado com sucesso! (PID: ${PB_PID})"
            log_sucesso "Painel Admin: http://localhost:${PORTA_POCKETBASE}/_/"
            return 0
        fi
        tentativas=$((tentativas + 1))
        sleep 1
    done

    log_erro "PocketBase não iniciou após ${max_tentativas} segundos"
    exit 1
}

# --- Instalar dependências Node.js ---
instalar_dependencias() {
    if [ -d "node_modules" ]; then
        log_sucesso "Dependências Node.js já instaladas"
        return 0
    fi

    log_info "Instalando dependências Node.js..."

    if command -v bun &> /dev/null; then
        bun install --frozen-lockfile 2>/dev/null || bun install
    elif command -v npm &> /dev/null; then
        npm install
    else
        log_erro "Nem bun nem npm encontrados. Instale o Node.js."
        exit 1
    fi

    log_sucesso "Dependências instaladas com sucesso!"
}

# --- Build do frontend ---
build_frontend() {
    # Verificar se o build já existe
    if [ -d "dist" ] && [ -f "dist/index.html" ]; then
        log_sucesso "Build do frontend já existe"
        return 0
    fi

    log_info "Fazendo build do frontend..."

    if command -v bun &> /dev/null; then
        bun run build 2>/dev/null || npx vite build
    elif command -v npx &> /dev/null; then
        npx vite build
    else
        log_erro "Impossível fazer build. Instale o Node.js."
        exit 1
    fi

    log_sucesso "Build do frontend concluído!"
}

# --- Iniciar frontend ---
iniciar_frontend() {
    log_info "Iniciando frontend Monochrome na porta ${PORTA_FRONTEND}..."

    echo ""
    echo -e "${VERDE}╔══════════════════════════════════════════════════════════════╗${SEM_COR}"
    echo -e "${VERDE}║                                                              ║${SEM_COR}"
    echo -e "${VERDE}║   🎵 Monochrome está rodando!                                ║${SEM_COR}"
    echo -e "${VERDE}║                                                              ║${SEM_COR}"
    echo -e "${VERDE}║   Frontend:        http://localhost:${PORTA_FRONTEND}                     ║${SEM_COR}"
    echo -e "${VERDE}║   PocketBase:      http://localhost:${PORTA_POCKETBASE}                     ║${SEM_COR}"
    echo -e "${VERDE}║   Admin PocketBase: http://localhost:${PORTA_POCKETBASE}/_/                  ║${SEM_COR}"
    echo -e "${VERDE}║                                                              ║${SEM_COR}"
    echo -e "${VERDE}╚══════════════════════════════════════════════════════════════╝${SEM_COR}"
    echo ""

    # Exportar variáveis de ambiente para o Vite
    export POCKETBASE_URL="http://localhost:${PORTA_POCKETBASE}"

    # Iniciar o preview server (produção) - este comando bloqueia (mantém o container vivo)
    if command -v npx &> /dev/null; then
        npx vite preview --host 0.0.0.0 --port "${PORTA_FRONTEND}"
    elif command -v bun &> /dev/null; then
        bun run preview -- --host 0.0.0.0 --port "${PORTA_FRONTEND}"
    else
        log_erro "Impossível iniciar o servidor. Instale o Node.js."
        exit 1
    fi
}

# --- Capturar sinais para encerramento limpo ---
encerrar() {
    echo ""
    log_info "Encerrando Monochrome..."

    # Parar PocketBase
    if [ ! -z "$PB_PID" ]; then
        kill $PB_PID 2>/dev/null || true
        log_sucesso "PocketBase encerrado"
    fi

    log_sucesso "Monochrome encerrado com sucesso. Até mais! 👋"
    exit 0
}

trap encerrar SIGINT SIGTERM EXIT

# ============================================================================
#  EXECUÇÃO PRINCIPAL
# ============================================================================

log_info "Iniciando configuração do Monochrome..."
echo ""

# Passo 1: Instalar PocketBase
log_info "━━━ Passo 1/4: PocketBase ━━━"
instalar_pocketbase

# Passo 2: Iniciar PocketBase
log_info "━━━ Passo 2/4: Iniciar Banco de Dados ━━━"
iniciar_pocketbase

# Passo 3: Instalar dependências
log_info "━━━ Passo 3/4: Dependências Node.js ━━━"
instalar_dependencias

# Passo 4: Build e iniciar frontend
log_info "━━━ Passo 4/4: Frontend ━━━"
build_frontend
iniciar_frontend
