# 02 — SPEC (Especificação Técnica)

**Projeto:** Arpia  
**Versão:** 1.0  
**Data:** 2026-06-21

---

## 1. Stack Tecnológica

### 1.1 Frontend
| Tecnologia | Versão | Finalidade |
|------------|--------|------------|
| Next.js | 14+ | Framework React (App Router) |
| React | 18+ | UI Library |
| TypeScript | 5+ | Tipagem estática |
| Tailwind CSS | 3+ | Estilização utility-first |
| shadcn/ui | latest | Componentes UI |
| Lucide React | latest | Ícones |
| React Hook Form | latest | Formulários |
| Zod | latest | Validação de schemas |
| date-fns | latest | Manipulação de datas |
| React Player | latest | Player de áudio |
| React Markdown | latest | Renderização Markdown |
| Rehype Sanitize | latest | Sanitização de Markdown |
| TanStack Query | latest | Server state management |

### 1.2 Backend (Supabase)
| Tecnologia | Finalidade |
|------------|------------|
| Supabase Auth | Autenticação |
| Supabase Database | PostgreSQL gerenciado |
| Supabase Storage | Armazenamento de arquivos |
| Supabase Realtime | WebSocket para chat |
| Supabase Edge Functions | Lógica serverless (se necessário) |

### 1.3 DevOps
| Tecnologia | Finalidade |
|------------|------------|
| Vercel | Deploy e hosting |
| GitHub | Versionamento |
| ESLint | Linting |
| Prettier | Formatação |
| Husky | Git hooks |
| lint-staged | Validação pré-commit |
| Vitest | Testes unitários |
| Playwright | Testes E2E |

---

## 2. Arquitetura de Componentes

### 2.1 Estrutura de Pastas

```
src/
├── app/                    # App Router (Next.js 14+)
│   ├── (auth)/             # Rotas de autenticação
│   │   ├── login/
│   │   ├── register/
│   │   ├── pending/
│   │   └── layout.tsx
│   ├── (dashboard)/        # Rotas autenticadas
│   │   ├── layout.tsx
│   │   ├── page.tsx        # Dashboard inicial
│   │   ├── books/
│   │   │   ├── page.tsx
│   │   │   └── [id]/
│   │   ├── audiobooks/
│   │   │   ├── page.tsx
│   │   │   └── [id]/
│   │   ├── forum/
│   │   │   ├── page.tsx
│   │   │   ├── [category]/
│   │   │   └── topic/[id]/
│   │   ├── chat/
│   │   │   ├── page.tsx
│   │   │   └── [roomId]/
│   │   ├── tarot/
│   │   │   ├── page.tsx
│   │   │   ├── draw/
│   │   │   └── history/
│   │   └── profile/
│   ├── (admin)/            # Rotas administrativas
│   │   ├── layout.tsx
│   │   ├── admin/
│   │   │   ├── page.tsx
│   │   │   ├── users/
│   │   │   ├── books/
│   │   │   ├── audiobooks/
│   │   │   ├── categories/
│   │   │   ├── forum/
│   │   │   ├── chat/
│   │   │   └── tarot/
│   ├── layout.tsx          # Root layout
│   ├── page.tsx            # Landing/redirect
│   └── globals.css
├── components/
│   ├── ui/                 # Componentes base (shadcn)
│   ├── layout/             # Header, Sidebar, Footer
│   ├── books/              # Componentes de livros
│   ├── audiobooks/         # Componentes de audiolivros
│   ├── forum/              # Componentes do fórum
│   ├── chat/               # Componentes do chat
│   ├── tarot/              # Componentes do tarô
│   ├── admin/              # Componentes administrativos
│   └── shared/             # Componentes compartilhados
├── lib/
│   ├── supabase/
│   │   ├── client.ts       # Cliente browser
│   │   ├── server.ts       # Cliente server-side
│   │   └── middleware.ts   # Middleware de auth
│   ├── validations/        # Schemas Zod
│   └── utils.ts            # Utilitários
├── hooks/                  # Custom hooks
├── types/                  # Tipagens TypeScript
└── config/                 # Configurações
```

### 2.2 Padrões de Componentes

**Componente Funcional:**
```typescript
interface BookCardProps {
  book: Book
  onSelect?: (id: string) => void
}

export function BookCard({ book, onSelect }: BookCardProps) {
  return (
    <div onClick={() => onSelect?.(book.id)}>
      {/* ... */}
    </div>
  )
}
```

**Componente com Server Action:**
```typescript
export async function BookForm() {
  async function createBook(formData: FormData) {
    'use server'
    // Lógica de criação
  }
  
  return (
    <form action={createBook}>
      {/* ... */}
    </form>
  )
}
```

---

## 3. Estado e Gerenciamento

### 3.1 Estado Local
- React useState/useReducer para estado de componentes
- React Hook Form para formulários
- Context API para estado global mínimo (auth, tema)

### 3.2 Server State
- TanStack Query para cache e gerenciamento de dados do servidor
- Configuração de stale time: 5 minutos
- Refetch em foco da janela
- Retry automático (3 tentativas)

### 3.3 Cache
- Next.js ISR para páginas estáticas
- Supabase client-side caching para dados frequentes
- React Query para gerenciamento de cache de servidor

### 3.4 Realtime
- Supabase Realtime para chat
- Subscriptions para atualização em tempo real
- Fallback para polling se necessário

---

## 4. Autenticação

### 4.1 Fluxo
- Supabase Auth com email/senha
- Middleware Next.js para verificação de sessão
- Cookies httpOnly para refresh tokens
- Server-side rendering com sessão verificada

### 4.2 Sessão
- Access token: 1 hora
- Refresh token: 7 dias
- Rotação automática de tokens
- Logout: limpeza completa de cookies e cache

---

## 5. Validação e Segurança

### 5.1 Frontend
- Zod schemas para todos os formulários
- Sanitização de input do usuário
- Validação de tipo em tempo de compilação

### 5.2 Backend (Supabase)
- RLS (Row Level Security) em todas as tabelas
- Policies baseadas em auth.uid() e roles
- Validação de dados via CHECK constraints
- Triggers para auditoria

### 5.3 API
- Rate limiting via Supabase
- Validação de todas as entradas
- Logs de erro estruturados

---

## 6. Performance

### 6.1 Frontend
- Code splitting automático (App Router)
- Lazy loading de componentes pesados
- Image optimization (Next/Image)
- Font optimization (next/font)
- Prefetch de rotas

### 6.2 Backend
- Índices em colunas frequentemente consultadas
- Paginação em todas as listagens
- Select explícito (não SELECT *)
- Conexões via pool do Supabase

### 6.3 Storage
- CDN via Supabase Storage
- Lazy loading de imagens
- Compressão de áudio (bitrate adaptativo)

---

## 7. Testes

### 7.1 Unitários
- Vitest para testes unitários
- Testes de hooks customizados
- Testes de utilitários

### 7.2 Componentes
- React Testing Library
- Testes de interação
- Snapshot testing

### 7.3 Integração
- Testes de fluxos de usuário
- Testes de API (Supabase)

### 7.4 E2E
- Playwright para testes end-to-end
- Fluxos críticos: cadastro, login, leitura

---

## 8. Acessibilidade

- Semântica HTML correta
- ARIA labels onde necessário
- Navegação por teclado
- Contraste adequado
- Mensagens de erro para leitores de tela
- Skip links para navegação

---

## 9. Internacionalização

- Interface em português (Brasil)
- Preparação futura para i18n
- Formatação de datas localizada
- Formatação de números localizada

---

## 10. Monitoramento

- Vercel Analytics
- Error tracking via Sentry (futuro)
- Logs estruturados no Supabase
- Métricas de performance (Core Web Vitals)
