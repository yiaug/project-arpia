# PROJECT ARPIA — CONTEXT

## Visão do Projeto

Arpia é uma plataforma web de estudos esotéricos com biblioteca digital, audiolivros, fórum, chats comunitários, sistema de tarô e administração centralizada.

## Stack Tecnológica

- Frontend: Next.js 14+ (App Router)
- Backend: Supabase (PostgreSQL, Auth, Storage, Realtime)
- Estilo: Tailwind CSS + shadcn/ui
- Deploy: Vercel
- Versionamento: GitHub

## Funcionalidades

| Módulo | Prioridade | Status |
|--------|------------|--------|
| Autenticação + Aprovação | P0 | ✅ Implementado |
| Biblioteca Digital | P0 | Planejado |
| Audiolivros | P1 | Planejado |
| Fórum | P1 | Planejado |
| Chats | P2 | Planejado |
| Tarô | P2 | Planejado |
| Admin Dashboard | P0 | ✅ Implementado |

## Decisões Tomadas

1. **Backend:** Supabase (velocidade, custo, escala gerenciada)
2. **Frontend:** Next.js App Router (SSR moderno, performance)
3. **Estilo:** Tailwind CSS (produtividade, design system)
4. **Componentes:** shadcn/ui (acessibilidade, customização)
5. **Auth:** Supabase Auth (integrado, JWT, RLS)
6. **Storage:** Supabase Storage (integrado, CDN, policies)
7. **Realtime:** Supabase Realtime (WebSocket nativo)
8. **Deploy:** Vercel (auto-scale, preview, analytics)
9. **Player de áudio:** React Player (simples, confiável)
10. **Editor de conteúdo:** Markdown (simples, estilo esotérico)
11. **Chat:** Mensagens permanentes (histórico completo)
12. **Avaliações:** 1-5 estrelas (padrão do mercado)
13. **State management:** TanStack Query (cache + server state)
14. **Formulários:** React Hook Form (performance)

## Infraestrutura Implementada

### ✅ Next.js Setup
- Next.js 14.2.13 com App Router
- TypeScript configurado
- ESLint + Prettier configurados
- Tailwind CSS com tema dark/light

### ✅ Supabase Configuration
- Cliente browser (`src/lib/supabase/client.ts`)
- Cliente server (`src/lib/supabase/server.ts`)
- Cliente middleware (`src/lib/supabase/middleware.ts`)
- Tipagens do banco (`src/types/database.ts`)

### ✅ Autenticação
- Formulário de login (`src/components/auth/login-form.tsx`)
- Formulário de cadastro (`src/components/auth/register-form.tsx`)
- Provider de autenticação (`src/components/auth/auth-provider.tsx`)
- Hook de autenticação (`src/hooks/use-auth.ts`)
- Validações com Zod (`src/lib/validations/auth.ts`)

### ✅ Sistema de Roles
- Roles: pending, approved, admin
- Middleware de proteção de rotas
- Redirecionamento baseado em status

### ✅ Design System
- Tema dark/light (`src/components/theme-provider.tsx`)
- Componentes shadcn/ui (button, input, label, card, sheet)
- Paleta de cores configurada

### ✅ Layout
- Header com navegação
- Sidebar com menu
- Mobile navigation (responsivo)
- Layout principal (`src/components/layout/main-layout.tsx`)

### ✅ Páginas
- Login (`/login`)
- Cadastro (`/register`)
- Pendência (`/pending`)
- Dashboard (`/dashboard`)
- Admin (`/admin`)
- Redirect root (`/`)

## Pendências

- [x] Configurar Supabase (URL e API Key) - Ver SETUP.md
- [x] Configurar Vercel - Ver SETUP.md
- [x] Criar repositório GitHub - Git inicializado, push manual necessário
- [x] Migrations do banco criadas (001, 002, 003)
- [ ] Implementar Biblioteca Digital
- [ ] Implementar Audiolivros
- [ ] Implementar Fórum
- [ ] Implementar Chat
- [ ] Implementar Tarô

## Riscos

- Custo do Supabase Storage para PDFs/MP3 grandes
- Performance com muitos usuários simultâneos no chat
- Moderacão de conteúdo no fórum
- Backup e recuperação de dados

## Documentação Criada

| Documento | Status |
|-----------|--------|
| PRD.md | ✅ Criado |
| SPEC.md | ✅ Criado |
| ARCHITECTURE.md | ✅ Criado |
| DATABASE.md | ✅ Criado |
| API.md | ✅ Criado |
| AUTH.md | ✅ Criado |
| PERMISSIONS.md | ✅ Criado |
| STORAGE.md | ✅ Criado |
| UI_UX.md | ✅ Criado |
| PAGES.md | ✅ Criado |
| USER_FLOWS.md | ✅ Criado |
| ADMIN_FLOWS.md | ✅ Criado |
| SECURITY.md | ✅ Criado |
| RISKS.md | ✅ Criado |
| ROADMAP.md | ✅ Criado |

## Próximos Passos

1. Configurar Supabase (criar projeto, obter URL e API Key)
2. Criar repositório GitHub
3. Configurar Vercel
4. Criar migration do banco de dados
5. Iniciar implementação da Biblioteca Digital

## Convenções

- TypeScript em todo o projeto
- Componentes funcionais com hooks
- Estilização: Tailwind CSS
- Testes: Vitest + Testing Library + Playwright
- Linting: ESLint + Prettier
- Commits: Conventional Commits

## Estrutura de Pastas

```
src/
├── app/
│   ├── (auth)/           # Rotas de autenticação
│   ├── (dashboard)/      # Rotas autenticadas
│   ├── (admin)/          # Rotas administrativas
│   ├── layout.tsx        # Root layout
│   ├── page.tsx          # Redirect para /login
│   └── globals.css       # Estilos globais
├── components/
│   ├── ui/               # Componentes shadcn/ui
│   ├── layout/           # Header, Sidebar, MobileNav
│   └── auth/             # Formulários e Provider de auth
├── lib/
│   ├── supabase/         # Clientes Supabase
│   ├── validations/      # Schemas Zod
│   └── utils.ts          # Utilitários (cn)
├── hooks/                # Custom hooks
├── types/                # Tipagens TypeScript
└── config/               # Constantes
```
