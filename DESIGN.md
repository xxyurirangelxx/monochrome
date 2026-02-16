# Sistema de Design do Monochrome

Uma linguagem de design abrangente para UI/UX consistente em toda a aplicação de streaming de música Monochrome.

## Tokens de Design

### Escala Tipográfica

| Token         | Valor           | Uso                              |
| ------------- | --------------- | -------------------------------- |
| `--text-xs`   | 0.75rem (12px)  | Legendas, badges, timestamps     |
| `--text-sm`   | 0.875rem (14px) | Texto secundário, rótulos        |
| `--text-base` | 1rem (16px)     | Texto do corpo (padrão)          |
| `--text-md`   | 1.125rem (18px) | Parágrafos de destaque           |
| `--text-lg`   | 1.25rem (20px)  | Títulos pequenos                 |
| `--text-xl`   | 1.5rem (24px)   | H4, títulos de cards             |
| `--text-2xl`  | 1.875rem (30px) | H3                               |
| `--text-3xl`  | 2.25rem (36px)  | H2                               |
| `--text-4xl`  | 3rem (48px)     | H1                               |
| `--text-5xl`  | 3.75rem (60px)  | Texto display                    |

### Pesos de Fonte

| Token             | Valor |
| ----------------- | ----- |
| `--font-normal`   | 400   |
| `--font-medium`   | 500   |
| `--font-semibold` | 600   |
| `--font-bold`     | 700   |

### Escala de Espaçamento

| Token        | Valor   | Pixels |
| ------------ | ------- | ------ |
| `--space-1`  | 0.25rem | 4px    |
| `--space-2`  | 0.5rem  | 8px    |
| `--space-3`  | 0.75rem | 12px   |
| `--space-4`  | 1rem    | 16px   |
| `--space-5`  | 1.25rem | 20px   |
| `--space-6`  | 1.5rem  | 24px   |
| `--space-8`  | 2rem    | 32px   |
| `--space-10` | 2.5rem  | 40px   |
| `--space-12` | 3rem    | 48px   |
| `--space-16` | 4rem    | 64px   |

### Escala de Borda Arredondada

| Token           | Valor  | Uso                          |
| --------------- | ------ | ---------------------------- |
| `--radius-none` | 0      | Cantos retos                 |
| `--radius-xs`   | 2px    | Badges pequenos, tags        |
| `--radius-sm`   | 4px    | Inputs, botões pequenos      |
| `--radius-md`   | 8px    | Cards, painéis (padrão)      |
| `--radius-lg`   | 12px   | Cards grandes, modais        |
| `--radius-xl`   | 16px   | Elementos hero               |
| `--radius-2xl`  | 24px   | Elementos extra grandes      |
| `--radius-full` | 9999px | Círculos, pills              |

### Temporização de Transições

| Token                | Valor |
| -------------------- | ----- |
| `--duration-instant` | 0ms   |
| `--duration-fast`    | 150ms |
| `--duration-normal`  | 300ms |
| `--duration-slow`    | 500ms |

### Funções de Easing

| Token             | Valor                                   | Uso                     |
| ----------------- | --------------------------------------- | ----------------------- |
| `--ease-linear`   | linear                                  | Animações contínuas     |
| `--ease-in`       | cubic-bezier(0.4, 0, 1, 1)              | Elementos entrando      |
| `--ease-out`      | cubic-bezier(0, 0, 0.2, 1)              | Elementos saindo        |
| `--ease-in-out`   | cubic-bezier(0.4, 0, 0.2, 1)            | Transições padrão       |
| `--ease-out-back` | cubic-bezier(0.34, 1.56, 0.64, 1)       | Efeitos de quique       |
| `--ease-elastic`  | cubic-bezier(0.68, -0.55, 0.265, 1.55)  | Animações divertidas    |
| `--ease-spring`   | cubic-bezier(0.175, 0.885, 0.32, 1.275) | Interações ágeis        |

### Sombras

| Token            | Valor                                                               |
| ---------------- | ------------------------------------------------------------------- |
| `--shadow-none`  | none                                                                |
| `--shadow-xs`    | 0 1px 2px 0 rgb(0 0 0 / 0.05)                                       |
| `--shadow-sm`    | 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1)       |
| `--shadow-md`    | 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)    |
| `--shadow-lg`    | 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)  |
| `--shadow-xl`    | 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1) |
| `--shadow-2xl`   | 0 25px 50px -12px rgb(0 0 0 / 0.25)                                 |
| `--shadow-inner` | inset 0 2px 4px 0 rgb(0 0 0 / 0.05)                                 |
| `--shadow-glow`  | 0 0 20px rgb(var(--highlight-rgb) / 0.5)                            |

### Escala de Z-Index

| Token          | Valor | Uso                |
| -------------- | ----- | ------------------ |
| `--z-hide`     | -1    | Elementos ocultos  |
| `--z-base`     | 0     | Padrão             |
| `--z-docked`   | 10    | Elementos fixados  |
| `--z-dropdown` | 1000  | Dropdowns          |
| `--z-sticky`   | 1100  | Cabeçalhos fixos   |
| `--z-banner`   | 1200  | Banners            |
| `--z-overlay`  | 1300  | Overlays           |
| `--z-modal`    | 1400  | Modais             |
| `--z-popover`  | 1500  | Popovers           |
| `--z-tooltip`  | 1600  | Tooltips           |
| `--z-toast`    | 1700  | Toasts             |

## Tokens de Componentes

### Botões

| Token              | Valor                         |
| ------------------ | ----------------------------- |
| `--btn-height-sm`  | 32px                          |
| `--btn-height-md`  | 40px                          |
| `--btn-height-lg`  | 48px                          |
| `--btn-padding-sm` | var(--space-2) var(--space-3) |
| `--btn-padding-md` | var(--space-3) var(--space-4) |
| `--btn-padding-lg` | var(--space-4) var(--space-6) |

### Inputs

| Token             | Valor                         |
| ----------------- | ----------------------------- |
| `--input-height`  | 40px                          |
| `--input-padding` | var(--space-3) var(--space-4) |

### Cards

| Token            | Valor            |
| ---------------- | ---------------- |
| `--card-padding` | var(--space-4)   |
| `--card-gap`     | var(--space-4)   |
| `--card-radius`  | var(--radius-lg) |

### Modais

| Token                  | Valor            |
| ---------------------- | ---------------- |
| `--modal-padding`      | var(--space-6)   |
| `--modal-radius`       | var(--radius-xl) |
| `--modal-max-width-sm` | 400px            |
| `--modal-max-width-md` | 500px            |
| `--modal-max-width-lg` | 600px            |
| `--modal-max-width-xl` | 800px            |

## Classes Utilitárias

### Tipografia

```css
.text-xs, .text-sm, .text-base, .text-md, .text-lg, .text-xl, .text-2xl, .text-3xl, .text-4xl
.font-normal, .font-medium, .font-semibold, .font-bold
.leading-none, .leading-tight, .leading-snug, .leading-normal, .leading-relaxed
```

### Espaçamento

```css
.m-0, .m-1, .m-2, .m-3, .m-4, .m-6, .m-8
.mt-0, .mt-1, .mt-2, .mt-3, .mt-4, .mt-6
.mb-0, .mb-1, .mb-2, .mb-3, .mb-4, .mb-6
.ml-0, .ml-2, .ml-4
.mr-0, .mr-2, .mr-4
.mx-0, .mx-2, .mx-4
.my-0, .my-2, .my-4
.p-0, .p-1, .p-2, .p-3, .p-4, .p-6
.px-0, .px-2, .px-3, .px-4
.py-0, .py-1, .py-2, .py-3
.gap-0, .gap-1, .gap-2, .gap-3, .gap-4, .gap-6
```

### Borda Arredondada

```css
.rounded-none, .rounded-xs, .rounded-sm, .rounded-md, .rounded-lg, .rounded-xl, .rounded-full
```

### Sombras

```css
.shadow-none, .shadow-xs, .shadow-sm, .shadow-md, .shadow-lg, .shadow-xl
```

### Display e Flex

```css
.block, .inline-block, .inline, .flex, .inline-flex, .grid, .hidden
.flex-row, .flex-col, .flex-wrap, .flex-nowrap
.items-start, .items-center, .items-end
.justify-start, .justify-center, .justify-end, .justify-between
.flex-1, .flex-auto, .flex-none
```

### Texto

```css
.text-left, .text-center, .text-right
.truncate
.line-clamp-2, .line-clamp-3
.text-muted, .text-highlight
```

### Outros

```css
.cursor-pointer, .cursor-default
.transition-fast, .transition-normal, .transition-slow
```

## Boas Práticas

### FAÇA:

- Use tokens de design para todos os valores
- Use classes utilitárias para padrões comuns
- Mantenha estilos de componentes no CSS, não inline no JS
- Use elementos HTML semânticos
- Mantenha espaçamento consistente usando a escala de espaçamento

### NÃO FAÇA:

- Usar valores de pixel fixos
- Usar estilos inline no JavaScript
- Misturar diferentes valores de border-radius arbitrariamente
- Pular a escala de espaçamento com valores customizados
- Usar tamanhos de fonte arbitrários fora da escala tipográfica

## Guia de Migração

### De valores fixos:

```css
/* Antes */
.element {
    padding: 16px;
    font-size: 14px;
    border-radius: 4px;
    margin-bottom: 24px;
}

/* Depois */
.element {
    padding: var(--space-4);
    font-size: var(--text-sm);
    border-radius: var(--radius-sm);
    margin-bottom: var(--space-6);
}
```

### De estilos inline:

```javascript
// Antes
element.style.cssText = 'display: flex; gap: 8px; padding: 16px;';

// Depois
element.classList.add('flex', 'gap-2', 'p-4');
```

## Temas

O sistema de design suporta múltiplos temas. Cada tema define variáveis de cor enquanto mantém espaçamento, tipografia e outros tokens de design consistentes.

Temas disponíveis:

- `monochrome` (padrão)
- `dark`
- `ocean`
- `purple`
- `forest`
- `mocha`
- `machiatto`
- `frappe`
- `latte`
- `white`

## Observações

- A variável `--highlight-rgb` deve estar no formato RGB separado por vírgulas (ex: `245, 245, 245`) para uso com a função `rgb()`
- Todos os valores de espaçamento estão em unidades rem para acessibilidade
- O sistema de design é mobile-first e responsivo
