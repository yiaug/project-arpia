# 09 — UI_UX (Sistema de Design)

**Projeto:** Arpia  
**Versão:** 1.0  
**Data:** 2026-06-21

---

## 1. Visão Geral

Design system inspirado em Kindle (leitura), Notion (organização), Obsidian (estética) e bibliotecas digitais premium. Visual limpo, elegante e focado no conteúdo.

---

## 2. Paleta de Cores

### 2.1 Cores Principais

| Cor | HEX | Uso |
|-----|-----|-----|
| Primary | `#1a1a2e` | Fundo principal, headers |
| Secondary | `#16213e` | Cards, sidebars |
| Accent | `#e94560` | Ações, botões, destaques |
| Background | `#0f0f23` | Fundo da página |
| Surface | `#1a1a3e` | Cards, superfícies |
| Text Primary | `#ffffff` | Texto principal |
| Text Secondary | `#a0a0b0` | Texto secundário |
| Border | `#2a2a4a` | Bordas, divisórias |

### 2.2 Cores de Estado

| Cor | HEX | Uso |
|-----|-----|-----|
| Success | `#4ade80` | Sucesso, aprovado |
| Warning | `#fbbf24` | Atenção, pendente |
| Error | `#ef4444` | Erro, rejeitado |
| Info | `#60a5fa` | Informação |

### 2.3 Gradientes

```css
--gradient-primary: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
--gradient-accent: linear-gradient(135deg, #e94560 0%, #c73e54 100%);
--gradient-card: linear-gradient(145deg, #1a1a3e 0%, #16213e 100%);
```

---

## 3. Tipografia

### 3.1 Fontes

| Uso | Fonte | Peso |
|-----|-------|------|
| Títulos | Inter | 600, 700 |
| Corpo | Inter | 400, 500 |
| Código | JetBrains Mono | 400 |

### 3.2 Escala

| Elemento | Tamanho | Peso | Line Height |
|----------|---------|------|-------------|
| H1 | 2.5rem (40px) | 700 | 1.2 |
| H2 | 2rem (32px) | 700 | 1.3 |
| H3 | 1.5rem (24px) | 600 | 1.4 |
| H4 | 1.25rem (20px) | 600 | 1.4 |
| Body | 1rem (16px) | 400 | 1.6 |
| Small | 0.875rem (14px) | 400 | 1.5 |
| Tiny | 0.75rem (12px) | 400 | 1.4 |

---

## 4. Espaçamento

### 4.1 Sistema de Espaçamento

| Token | Valor |
|-------|-------|
| xs | 0.25rem (4px) |
| sm | 0.5rem (8px) |
| md | 1rem (16px) |
| lg | 1.5rem (24px) |
| xl | 2rem (32px) |
| 2xl | 3rem (48px) |
| 3xl | 4rem (64px) |

### 4.2 Grid

- Container: max-width 1280px
- Colunas: 12
- Gap: 1rem (16px)
- Breakpoints:
  - sm: 640px
  - md: 768px
  - lg: 1024px
  - xl: 1280px
  - 2xl: 1536px

---

## 5. Componentes

### 5.1 Botões

```css
/* Primário */
.btn-primary {
  background: var(--gradient-accent);
  color: white;
  padding: 0.75rem 1.5rem;
  border-radius: 0.5rem;
  font-weight: 600;
  transition: all 0.2s;
}

.btn-primary:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(233, 69, 96, 0.3);
}

/* Secundário */
.btn-secondary {
  background: transparent;
  border: 1px solid var(--border);
  color: var(--text-primary);
  padding: 0.75rem 1.5rem;
  border-radius: 0.5rem;
  font-weight: 500;
}

/* Fantasma */
.btn-ghost {
  background: transparent;
  color: var(--text-secondary);
  padding: 0.5rem 1rem;
}
```

### 5.2 Cards

```css
.card {
  background: var(--gradient-card);
  border: 1px solid var(--border);
  border-radius: 0.75rem;
  padding: 1.5rem;
  transition: all 0.2s;
}

.card:hover {
  border-color: var(--accent);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.3);
}
```

### 5.3 Inputs

```css
.input {
  background: var(--surface);
  border: 1px solid var(--border);
  border-radius: 0.5rem;
  padding: 0.75rem 1rem;
  color: var(--text-primary);
  transition: border-color 0.2s;
}

.input:focus {
  outline: none;
  border-color: var(--accent);
  box-shadow: 0 0 0 3px rgba(233, 69, 96, 0.1);
}
```

### 5.4 Sidebar

```css
.sidebar {
  width: 280px;
  background: var(--secondary);
  border-right: 1px solid var(--border);
  height: 100vh;
  position: fixed;
  left: 0;
  top: 0;
  overflow-y: auto;
}
```

### 5.5 Header

```css
.header {
  height: 64px;
  background: var(--primary);
  border-bottom: 1px solid var(--border);
  display: flex;
  align-items: center;
  padding: 0 1.5rem;
  position: sticky;
  top: 0;
  z-index: 50;
}
```

---

## 6. Layout

### 6.1 Layout Principal

```
┌─────────────────────────────────────────────────────────────┐
│                        HEADER (64px)                        │
├──────────┬──────────────────────────────────────────────────┤
│          │                                                  │
│ SIDEBAR  │                   CONTEÚDO                       │
│ (280px)  │                                                  │
│          │                                                  │
│          │                                                  │
│          │                                                  │
│          │                                                  │
│          │                                                  │
│          │                                                  │
└──────────┴──────────────────────────────────────────────────┘
```

### 6.2 Layout Admin

```
┌─────────────────────────────────────────────────────────────┐
│                        HEADER (64px)                        │
├──────────┬──────────────────────────────────────────────────┤
│          │                                                  │
│ SIDEBAR  │                   CONTEÚDO                       │
│  ADMIN   │                                                  │
│ (240px)  │                                                  │
│          │                                                  │
│          │                                                  │
│          │                                                  │
│          │                                                  │
│          │                                                  │
└──────────┴──────────────────────────────────────────────────┘
```

### 6.3 Layout Auth

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│                                                             │
│                    ┌─────────────────┐                      │
│                    │                 │                      │
│                    │    FORMULÁRIO   │                      │
│                    │                 │                      │
│                    │                 │                      │
│                    └─────────────────┘                      │
│                                                             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 7. Responsividade

### 7.1 Breakpoints

| Breakpoint | Largura | Comportamento |
|------------|---------|---------------|
| Mobile | < 640px | Sidebar oculta, menu hamburger |
| Tablet | 640px - 1024px | Sidebar colapsada |
| Desktop | > 1024px | Sidebar completa |

### 7.2 Grid Responsivo

```css
/* Mobile: 1 coluna */
.grid-books {
  grid-template-columns: 1fr;
}

/* Tablet: 2 colunas */
@media (min-width: 768px) {
  .grid-books {
    grid-template-columns: repeat(2, 1fr);
  }
}

/* Desktop: 3-4 colunas */
@media (min-width: 1024px) {
  .grid-books {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (min-width: 1280px) {
  .grid-books {
    grid-template-columns: repeat(4, 1fr);
  }
}
```

---

## 8. Animações

### 8.1 Transições

```css
/* Básica */
transition: all 0.2s ease;

/* Suave */
transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
```

### 8.2 Hover Effects

```css
/* Elevação */
.card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 24px rgba(0, 0, 0, 0.3);
}

/* Brilho */
.btn:hover {
  box-shadow: 0 0 20px rgba(233, 69, 96, 0.4);
}
```

### 8.3 Loading States

```css
/* Skeleton */
.skeleton {
  background: linear-gradient(
    90deg,
    var(--surface) 25%,
    var(--border) 50%,
    var(--surface) 75%
  );
  background-size: 200% 100%;
  animation: skeleton-loading 1.5s infinite;
}

@keyframes skeleton-loading {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
```

---

## 9. Ícones

### 9.1 Biblioteca
- Lucide React para ícones

### 9.2 Ícones Principais

| Uso | Ícone |
|-----|-------|
| Home | Home |
| Livros | BookOpen |
| Audiolivros | Headphones |
| Fórum | MessageSquare |
| Chat | MessageCircle |
| Tarô | Sparkles |
| Configurações | Settings |
| Perfil | User |
| Busca | Search |
| Sair | LogOut |

---

## 10. Acessibilidade

### 10.1 Contraste
- Texto principal: 7:1 (AAA)
- Texto secundário: 4.5:1 (AA)
- Botões: 4.5:1 (AA)

### 10.2 Focus States

```css
:focus-visible {
  outline: 2px solid var(--accent);
  outline-offset: 2px;
}
```

### 10.3 Screen Readers

- Labels em todos os inputs
- aria-hidden em ícones decorativos
- aria-live para mensagens dinâmicas
- Skip links para navegação

---

## 11. Tema

### 11.1 Tema Escuro (Padrão)

Tema padrão é escuro, inspirado em Obsidian.

### 11.2 Tema Claro (Futuro)

- Inversão de cores
- Fundo branco
- Texto escuro
- Mesmos acentos

### 11.3 Implementação

```css
:root {
  --background: #0f0f23;
  --surface: #1a1a3e;
  --text: #ffffff;
  /* ... */
}

[data-theme="light"] {
  --background: #ffffff;
  --surface: #f5f5f5;
  --text: #1a1a2e;
  /* ... */
}
```

---

## 12. Referências

- **Kindle:** Experiência de leitura imersiva
- **Notion:** Organização e limpeza visual
- **Obsidian:** Estética escura e minimalista
- **Medium:** Tipografia e espaçamento
- **Discord:** Layout de chat e comunidade
