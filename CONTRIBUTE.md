# Contribuindo para o Monochrome

Obrigado pelo seu interesse em contribuir com o Monochrome! Este guia vai ajudá-lo a começar com o desenvolvimento, entender nossa base de código e seguir nosso fluxo de contribuição.

---

## Índice

- [Configuração de Desenvolvimento](#configuração-de-desenvolvimento)
- [Qualidade de Código](#qualidade-de-código)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Fluxo de Contribuição](#fluxo-de-contribuição)
- [Diretrizes de Mensagens de Commit](#diretrizes-de-mensagens-de-commit)
- [Deploy](#deploy)
- [Dúvidas?](#dúvidas)

---

## Configuração de Desenvolvimento

### Pré-requisitos

- [Node.js](https://nodejs.org/) (Versão 20+ ou 22+ recomendada)
- [Bun](https://bun.sh/) (preferido) ou [npm](https://www.npmjs.com/)

### Início Rápido

1. **Faça fork e clone o repositório:**

    ```bash
    git clone https://github.com/SEU_USUARIO/monochrome.git
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

---

## Qualidade de Código

Mantemos altos padrões de qualidade de código. Todo código deve passar nas verificações de linting antes de ser mergeado.

### Nossas Ferramentas

| Ferramenta                         | Propósito              | Arquivos |
| ---------------------------------- | ---------------------- | -------- |
| [ESLint](https://eslint.org/)      | Linting de JavaScript  | `*.js`   |
| [Stylelint](https://stylelint.io/) | Linting de CSS         | `*.css`  |
| [HTMLHint](https://htmlhint.com/)  | Validação de HTML      | `*.html` |
| [Prettier](https://prettier.io/)   | Formatação de código   | Todos    |

### Comandos Disponíveis

```bash
# Verificar tudo (executa todos os linters)
bun run lint

# Auto-formatar todo o código
bun run format

# Corrigir problemas de JavaScript automaticamente
bun run lint:js -- --fix

# Corrigir problemas de CSS automaticamente
bun run lint:css -- --fix

# Verificar HTML
bun run lint:html

# Verificar tipos de arquivo específicos
bun run lint:js
bun run lint:css
```

> ⚠️ **Importante:** Uma GitHub Action executa automaticamente `bun run lint` em cada push e pull request. Por favor, garanta que todas as verificações passem antes de commitar.

---

## Estrutura do Projeto

```
monochrome/
├── 📁 js/                    # Código fonte da aplicação
│   ├── components/          # Componentes de UI
│   ├── utils/               # Funções utilitárias
│   ├── api/                 # Integração com API
│   └── ...
├── 📁 public/               # Assets estáticos
│   ├── assets/             # Imagens, ícones, fontes
│   ├── manifest.json       # Manifesto PWA
│   └── instances.json      # Configuração de instâncias da API
├── 📄 index.html           # Ponto de entrada da aplicação
├── 📄 vite.config.js       # Configuração de build e PWA
├── 📄 package.json         # Dependências e scripts
├── 📄 start.sh             # Script de inicialização para Pterodactyl
└── 📄 README.md            # Documentação do projeto
```

### Diretórios Principais

- **`/js`** - Todo o código fonte JavaScript
    - Mantenha módulos focados e com propósito único
    - Use recursos ES6+
    - Adicione comentários JSDoc para funções complexas

- **`/public`** - Assets estáticos copiados diretamente para o build
    - Imagens devem ser otimizadas antes de adicionar
    - Mantenha tamanhos de arquivo razoáveis
    - Use formatos apropriados (WebP quando possível)

---

## Fluxo de Contribuição

### 1. Crie uma Branch

```bash
git checkout -b feature/nome-da-sua-funcionalidade
# ou
git checkout -b fix/descrição-da-correção
```

### 2. Faça Suas Alterações

- Siga o estilo de código existente
- Escreva código claro e auto-documentável
- Adicione comentários para lógica complexa
- Atualize a documentação se necessário

### 3. Teste Suas Alterações

```bash
# Execute todos os linters
bun run lint

# Teste o build
bun run build
```

### 4. Faça Commit das Suas Alterações

Siga nossas [diretrizes de mensagens de commit](#diretrizes-de-mensagens-de-commit).

```bash
git add .
git commit -m "feat(player): adicionar atalho de teclado para alternar loop"
```

### 5. Faça Push e Crie um Pull Request

```bash
git push origin feature/nome-da-sua-funcionalidade
```

Então abra um pull request no GitHub com:

- Título claro descrevendo a mudança
- Descrição detalhada do que mudou e por quê
- Referências a issues relacionadas

---

## Diretrizes de Mensagens de Commit

Usamos [Conventional Commits](https://www.conventionalcommits.org/) para mensagens de commit claras e estruturadas.

### Formato

```
<tipo>(<escopo>): <descrição>

[corpo opcional]

[rodapé opcional]
```

### Tipos

| Tipo       | Descrição                                              |
| ---------- | ------------------------------------------------------ |
| `feat`     | Nova funcionalidade                                    |
| `fix`      | Correção de bug                                        |
| `docs`     | Mudanças na documentação                               |
| `style`    | Mudanças de estilo de código (formatação, ponto e vírgula, etc.) |
| `refactor` | Refatoração de código sem mudar comportamento          |
| `perf`     | Melhorias de desempenho                                |
| `test`     | Adição ou atualização de testes                        |
| `chore`    | Tarefas de manutenção (dependências, build, etc.)      |

### Escopos

Escopos comuns no nosso projeto:

- `player` - Funcionalidade do player de áudio
- `ui` - Componentes de interface
- `api` - Integração com API
- `library` - Gerenciamento de biblioteca
- `playlists` - Funcionalidade de playlists
- `lyrics` - Exibição de letras
- `downloads` - Funcionalidade de downloads
- `auth` - Autenticação
- `pwa` - Funcionalidades de Progressive Web App
- `settings` - Configurações/preferências
- `theme` - Sistema de temas

### Exemplos

```bash
# Adição de funcionalidade
feat(playlists): adicionar botão de embaralhar playlist

# Correção de bug
fix(metadata): resolver problema de metadados Hi-res corrompidos

# Refatoração
refactor(downloads): simplificar lógica de cancelar download

# Documentação
docs(README): melhorar instruções de instalação

# Manutenção
chore(deps): atualizar pacote de letras para corrigir vulnerabilidade

# Mudanças de estilo
style(player): corrigir indentação nos controles de áudio
```

### Dicas

- Use o tempo presente ("adicionar funcionalidade" e não "adicionou funcionalidade")
- Use modo imperativo ("mover cursor para..." e não "move cursor para...")
- Não coloque letra maiúscula na primeira letra
- Sem ponto final no final
- Mantenha a primeira linha com menos de 72 caracteres

📋 **Cola Rápida:** [Conventional Commits Cheat Sheet](https://gist.github.com/Zekfad/f51cb06ac76e2457f11c80ed705c95a3)

---

## Deploy

O deploy é totalmente automatizado via **Cloudflare Pages**.

### Como Funciona

1. Faça push das mudanças para a branch `main`
2. A Cloudflare automaticamente compila e faz deploy
3. As mudanças ficam online em minutos

### Notas de Configuração

O projeto usa um **caminho base relativo** (`./`) no `vite.config.js`. Isso permite que o mesmo artefato de build funcione em ambos:

- **Cloudflare Pages** (servido da raiz)
- **GitHub Pages** (servido de `/monochrome/`)

Roteamento por hash é usado para garantir compatibilidade em todas as plataformas de hospedagem.

### Deploy Manual

Se precisar fazer deploy manualmente:

```bash
# Build para produção
bun run build

# A pasta `dist/` contém os arquivos para deploy
```

---

## Dúvidas?

- 💬 Participe das discussões da comunidade
- 🐛 Abra uma issue para bugs ou pedidos de funcionalidades
- 📧 Entre em contato com os mantenedores

---

## Código de Conduta

- Seja respeitoso e inclusivo
- Acolha novatos e ajude-os a aprender
- Foque em feedback construtivo
- Respeite diferentes pontos de vista e experiências

Obrigado por contribuir com o Monochrome!
