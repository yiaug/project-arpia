# 03 — ARCHITECTURE (Arquitetura do Sistema)

**Projeto:** Arpia  
**Versão:** 1.0  
**Data:** 2026-06-21

---

## 1. Visão Geral

```
┌─────────────────────────────────────────────────────────────────┐
│                         CLIENTE (Browser)                       │
├─────────────────────────────────────────────────────────────────┤
│  Next.js App (SSR/SSG/CSR)                                     │
│  ├── React Components (shadcn/ui + Tailwind)                   │
│  ├── Client-side State (React State/Context)                    │
│  ├── TanStack Query (Server State)                              │
│  └── Supabase Client SDK                                        │
└─────────────────────┬───────────────────────────────────────────┘
                      │ HTTPS / WebSocket
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│                      VERCEL (Edge Network)                      │
├─────────────────────────────────────────────────────────────────┤
│  ├── Edge Functions (Middleware)                                │
│  ├── Serverless Functions (API Routes)                          │
│  └── Static Assets (CDN)                                        │
└─────────────────────┬───────────────────────────────────────────┘
                      │ HTTPS
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│                       SUPABASE                                  │
├─────────────────────────────────────────────────────────────────┤
│  ├── Auth (Email/Password, JWT)                                 │
│  ├── Database (PostgreSQL + RLS)                                │
│  ├── Storage (Buckets: books, audiobooks, covers, tarot)        │
│  ├── Realtime (WebSocket subscriptions)                         │
│  └── Edge Functions (se necessário)                             │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. Módulos do Sistema

### 2.1 Módulo de Autenticação
```
┌─────────────────────────────────────────────────────┐
│                  AUTH MODULE                        │
├─────────────────────────────────────────────────────┤
│  Frontend           │  Supabase                    │
│  ├── Register Form  │  ├── Auth.signUp()          │
│  ├── Login Form     │  ├── Auth.signIn()          │
│  ├── Auth Guard     │  ├── Auth.getSession()      │
│  └── Middleware      │  └── RLS Policies           │
└─────────────────────────────────────────────────────┘
```

**Fluxo de Dados:**
1. Usuário submete formulário → Supabase Auth.signUp()
2. Trigger cria registro na tabela `profiles` com status 'pending'
3. Admin aprova → status muda para 'approved'
4. Middleware verifica status antes de permitir acesso

### 2.2 Módulo de Biblioteca
```
┌─────────────────────────────────────────────────────┐
│                  BOOKS MODULE                       │
├─────────────────────────────────────────────────────┤
│  Frontend           │  Supabase                    │
│  ├── BookList       │  ├── books (table)           │
│  ├── BookDetail     │  ├── book_covers (bucket)    │
│  ├── BookReader     │  └── book_ratings (table)    │
│  └── BookSearch     │                              │
└─────────────────────────────────────────────────────┘
```

### 2.3 Módulo de Audiolivros
```
┌─────────────────────────────────────────────────────┐
│              AUDIOBOOKS MODULE                      │
├─────────────────────────────────────────────────────┤
│  Frontend           │  Supabase                    │
│  ├── AudiobookList  │  ├── audiobooks (table)      │
│  ├── AudiobookDetail│  ├── audiobook_files (bucket)│
│  └── AudioPlayer    │  └── audiobook_chapters (tbl)│
└─────────────────────────────────────────────────────┘
```

### 2.4 Módulo de Fórum
```
┌─────────────────────────────────────────────────────┐
│                  FORUM MODULE                       │
├─────────────────────────────────────────────────────┤
│  Frontend           │  Supabase                    │
│  ├── TopicList      │  ├── forum_topics (table)    │
│  ├── TopicDetail    │  ├── forum_comments (table)  │
│  ├── CreateTopic    │  ├── forum_categories (table)│
│  └── CommentForm    │  └── forum_votes (table)     │
└─────────────────────────────────────────────────────┘
```

### 2.5 Módulo de Chat
```
┌─────────────────────────────────────────────────────┐
│                  CHAT MODULE                        │
├─────────────────────────────────────────────────────┤
│  Frontend           │  Supabase                    │
│  ├── RoomList       │  ├── chat_rooms (table)      │
│  ├── RoomView       │  ├── chat_messages (table)   │
│  └── MessageInput   │  └── Realtime subscription   │
└─────────────────────────────────────────────────────┘
```

### 2.6 Módulo de Tarô
```
┌─────────────────────────────────────────────────────┐
│                 TAROT MODULE                        │
├─────────────────────────────────────────────────────┤
│  Frontend           │  Supabase                    │
│  ├── TarotDeck      │  ├── tarot_cards (table)     │
│  ├── TarotDraw      │  ├── tarot_draws (table)     │
│  └── TarotHistory   │  └── tarot_images (bucket)   │
└─────────────────────────────────────────────────────┘
```

### 2.7 Módulo Administrativo
```
┌─────────────────────────────────────────────────────┐
│                  ADMIN MODULE                       │
├─────────────────────────────────────────────────────┤
│  Frontend           │  Supabase                    │
│  ├── Dashboard      │  ├── All tables (CRUD)       │
│  ├── UserManagement │  ├── Storage (uploads)       │
│  ├── ContentMgmt    │  └── RLS (admin policies)    │
│  └── Analytics      │                              │
└─────────────────────────────────────────────────────┘
```

---

## 3. Fluxos de Dados

### 3.1 Fluxo de Autenticação
```
Browser → Vercel (Middleware) → Supabase Auth → JWT → Cookies
                                    ↓
                              profiles table
                              (status: pending/approved)
```

### 3.2 Fluxo de Leitura
```
Browser → Next.js (SSR) → Supabase DB → Dados
                ↓
        Supabase Storage → PDF/Image
```

### 3.3 Fluxo de Chat
```
Browser ←→ Supabase Realtime ←→ Database
                ↓
          WebSocket Connection
```

### 3.4 Fluxo de Upload (Admin)
```
Admin → Next.js Form → Supabase Storage → URL
                                    ↓
                              Database (metadata)
```

---

## 4. Deployment

### 4.1 Vercel
- **Branch principal:** main → produção
- **Branch de desenvolvimento:** develop → preview
- **PRs:** deploy automático de preview
- **Variáveis de ambiente:** configuradas no painel Vercel

### 4.2 Supabase
- **Projeto único:** produção
- **Migrations:** via CLI do Supabase
- **Backups:** automático diário (plano gratuito)

### 4.3 Fluxo de Deploy
```
Developer → Push to GitHub → Vercel Build → Deploy
                          ↓
                    Supabase Migrations
```

---

## 5. Escalabilidade

### 5.1 Horizontal
- Vercel: auto-scaling serverless
- Supabase: connection pooling (PgBouncer)

### 5.2 Vertical
- Supabase: upgrade de plano (CPU, RAM, Storage)
- Vercel: upgrade de plano (bandwidth, builds)

### 5.3 Limites
| Recurso | Limite Gratuito | Limite Pago |
|---------|-----------------|-------------|
| Supabase DB | 500MB | 8GB+ |
| Supabase Storage | 1GB | 100GB+ |
| Supabase Auth | 50K MAU | 100K+ |
| Vercel Bandwidth | 100GB | 1TB+ |
| Vercel Builds | 6K min/mês | 24K+ |

---

## 6. Segurança

### 6.1 Camadas
```
┌─────────────────────────────────┐
│  1. CDN (Vercel Edge)          │  DDoS, WAF básico
├─────────────────────────────────┤
│  2. Middleware (Next.js)       │  Auth check, rate limiting
├─────────────────────────────────┤
│  3. RLS (Supabase)            │  Row-level security
├─────────────────────────────────┤
│  4. Database (PostgreSQL)      │  CHECK constraints, triggers
├─────────────────────────────────┤
│  5. Storage Policies          │  Upload/download rules
└─────────────────────────────────┘
```

### 6.2 Princípios
- Menor privilégio: RLS em todas as tabelas
- Nunca confiar no cliente: validação server-side
- Defence in depth: múltiplas camadas
- Zero trust: cada requisição autenticada

---

## 7. Monitoramento

### 7.1 Métricas
- Vercel Analytics (Core Web Vitals)
- Supabase Dashboard (DB performance)
- Logs estruturados

### 7.2 Alertas
- Erros 5xx (Vercel)
- Latência alta (Supabase)
- Storage quase cheio
- Auth failures

---

## 8. Backup e Recuperação

### 8.1 Estratégia
- **Database:** Backup automático diário (Supabase)
- **Storage:** Versionamento de arquivos
- **Código:** GitHub (versionamento completo)
- **Configurações:** Documentadas em repositório

### 8.2 RPO/RTO
- **RPO:** 24 horas
- **RTO:** 4 horas

---

## 9. Trade-offs

### 9.1 Supabase vs Custom Backend
| Aspecto | Supabase | Custom Backend |
|---------|----------|----------------|
| Velocidade de dev | ✅ Rápido | ❌ Lento |
| Controle | ⚠️ Limitado | ✅ Total |
| Custo inicial | ✅ Baixo | ❌ Alto |
| Escalabilidade | ✅ Gerenciado | ⚠️ Manual |

**Decisão:** Supabase — velocidade de MVP, custo baixo, escalabilidade gerenciada.

### 9.2 App Router vs Pages Router
| Aspecto | App Router | Pages Router |
|---------|------------|--------------|
| SSR avançado | ✅ | ⚠️ Limitado |
| Server Components | ✅ | ❌ |
| Cache granular | ✅ | ❌ |

**Decisão:** App Router — features modernas, melhor performance.

### 9.3 Tailwind vs CSS Modules
| Aspecto | Tailwind | CSS Modules |
|---------|----------|-------------|
| Velocidade | ✅ Rápido | ⚠️ Médio |
| Consistência | ✅ Design system | ⚠️ Manual |
| Bundle size | ✅ Purgeável | ⚠️ Por arquivo |

**Decisão:** Tailwind — produtividade, design system integrado.
