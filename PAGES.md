# 10 — PAGES (Mapa Completo de Páginas)

**Projeto:** Arpia  
**Versão:** 1.0  
**Data:** 2026-06-21

---

## 1. Mapa de Rotas

### 1.1 Rotas Públicas

| Rota | Página | Descrição |
|------|--------|-----------|
| `/` | Landing/Redirect | Redireciona para /login ou /dashboard |
| `/login` | Login | Formulário de login |
| `/register` | Cadastro | Formulário de cadastro |
| `/forgot-password` | Esqueci Senha | Solicitação de reset |
| `/reset-password` | Redefinir Senha | Nova senha |

### 1.2 Rotas de Pendência

| Rota | Página | Descrição |
|------|--------|-----------|
| `/pending` | Pendente | Aguardando aprovação |

### 1.3 Rotas Autenticadas (Approved)

| Rota | Página | Descrição |
|------|--------|-----------|
| `/dashboard` | Dashboard | Página inicial com conteúdo recente |
| `/books` | Biblioteca | Lista de livros |
| `/books/[id]` | Detalhe do Livro | Informações do livro |
| `/audiobooks` | Audiolivros | Lista de audiolivros |
| `/audiobooks/[id]` | Detalhe do Audiolivro | Player e informações |
| `/forum` | Fórum | Lista de tópicos |
| `/forum/[category]` | Categoria | Tópicos da categoria |
| `/forum/topic/[id]` | Tópico | Comentários do tópico |
| `/chat` | Salas de Chat | Lista de salas |
| `/chat/[roomId]` | Sala | Mensagens da sala |
| `/tarot` | Tarô | Baralho completo |
| `/tarot/draw` | Tiragem | Nova tiragem |
| `/tarot/history` | Histórico | Tiragens anteriores |
| `/profile` | Perfil | Edição do perfil |

### 1.4 Rotas Administrativas

| Rota | Página | Descrição |
|------|--------|-----------|
| `/admin` | Dashboard Admin | Estatísticas e pendências |
| `/admin/users` | Usuários | Gestão de usuários |
| `/admin/books` | Livros | Gestão de livros |
| `/admin/books/new` | Novo Livro | Formulário de criação |
| `/admin/books/[id]/edit` | Editar Livro | Formulário de edição |
| `/admin/audiobooks` | Audiolivros | Gestão de audiolivros |
| `/admin/audiobooks/new` | Novo Audiolivro | Formulário de criação |
| `/admin/audiobooks/[id]/edit` | Editar Audiolivro | Formulário de edição |
| `/admin/categories` | Categorias | Gestão de categorias |
| `/admin/categories/new` | Nova Categoria | Formulário de criação |
| `/admin/forum` | Fórum | Moderação do fórum |
| `/admin/chat` | Chat | Gestão de salas |
| `/admin/chat/new` | Nova Sala | Formulário de criação |
| `/admin/tarot` | Tarô | Gestão de cartas |
| `/admin/tarot/new` | Nova Carta | Formulário de criação |
| `/admin/tarot/[id]/edit` | Editar Carta | Formulário de edição |

---

## 2. Layouts

### 2.1 Root Layout
```typescript
// src/app/layout.tsx
// - Fonte Inter
// - Tema escuro
// - Metadados globais
// - Analytics
```

### 2.2 Auth Layout
```typescript
// src/app/(auth)/layout.tsx
// - Layout centralizado
// - Sem sidebar
// - Sem header
// - Fundo com gradiente
```

### 2.3 Dashboard Layout
```typescript
// src/app/(dashboard)/layout.tsx
// - Header com busca e perfil
// - Sidebar com navegação
// - Conteúdo principal
```

### 2.4 Admin Layout
```typescript
// src/app/(admin)/layout.tsx
// - Header administrativo
// - Sidebar administrativa
// - Conteúdo principal
// - Guard de admin
```

---

## 3. Componentes por Página

### 3.1 Dashboard (`/dashboard`)

| Componente | Descrição |
|------------|-----------|
| `DashboardHeader` | Título e Saudação |
| `RecentBooks` | Grid de livros recentes (10) |
| `RecentAudiobooks` | Lista de audiolivros recentes (5) |
| `RecentDiscussions` | Lista de discussões recentes (5) |
| `TarotOfTheDay` | Carta do dia |

### 3.2 Biblioteca (`/books`)

| Componente | Descrição |
|------------|-----------|
| `BooksHeader` | Título e contagem |
| `BooksSearch` | Campo de busca |
| `BooksFilters` | Filtros por categoria |
| `BooksSort` | Ordenação |
| `BooksGrid` | Grid de cards |
| `BookCard` | Card individual |
| `BooksPagination` | Paginação |

### 3.3 Detalhe do Livro (`/books/[id]`)

| Componente | Descrição |
|------------|-----------|
| `BookCover` | Capa grande |
| `BookInfo` | Título, autor, metadados |
| `BookSynopsis` | Sinopse (Markdown) |
| `BookRating` | Avaliação média |
| `BookRatingForm` | Formulário de avaliação |
| `BookActions` | Botões de ação (Ler, Link Externo) |
| `BookTags` | Tags do livro |

### 3.4 Fórum (`/forum`)

| Componente | Descrição |
|------------|-----------|
| `ForumHeader` | Título e botão "Novo Tópico" |
| `ForumCategories` | Lista de categorias |
| `ForumTopics` | Lista de tópicos |
| `TopicCard` | Card do tópico |
| `ForumPagination` | Paginação |

### 3.5 Tópico (`/forum/topic/[id]`)

| Componente | Descrição |
|------------|-----------|
| `TopicHeader` | Título, autor, data |
| `TopicContent` | Conteúdo (Markdown) |
| `TopicActions` | Editar, Excluir, Fechar |
| `CommentsList` | Lista de comentários |
| `CommentCard` | Comentário individual |
| `CommentForm` | Formulário de comentário |

### 3.6 Chat (`/chat/[roomId]`)

| Componente | Descrição |
|------------|-----------|
| `ChatHeader` | Nome da sala |
| `MessagesList` | Lista de mensagens |
| `MessageCard` | Mensagem individual |
| `MessageInput` | Campo de envio |
| `TypingIndicator` | Indicador de digitando |

### 3.7 Tarô (`/tarot`)

| Componente | Descrição |
|------------|-----------|
| `TarotHeader` | Título |
| `TarotDeck` | Grid de cartas |
| `CardCard` | Card da carta |
| `DrawOptions` | Opções de tiragem |
| `DrawResult` | Resultado da tiragem |

### 3.8 Admin Dashboard (`/admin`)

| Componente | Descrição |
|------------|-----------|
| `AdminStats` | Estatísticas gerais |
| `PendingUsers` | Usuários pendentes |
| `RecentActivity` | Atividade recente |

---

## 4. SEO Metadata

### 4.1 Páginas Principais

| Página | Title | Description |
|--------|-------|-------------|
| `/` | Arpia | Plataforma de Estudos Esotéricos |
| `/login` | Login - Arpia | Acesse sua conta |
| `/register` | Cadastro - Arpia | Crie sua conta |
| `/dashboard` | Dashboard - Arpia | Bem-vindo |
| `/books` | Biblioteca - Arpia | Explore nossa coleção |
| `/audiobooks` | Audiolivros - Arpia | Ouça nossos audiolivros |
| `/forum` | Fórum - Arpia | Participe das discussões |
| `/chat` | Chat - Arpia | Salas de conversa |
| `/tarot` | Tarô - Arpia | Explore o tarô |
| `/admin` | Admin - Arpia | Painel administrativo |

### 4.2 Implementação

```typescript
export const metadata: Metadata = {
  title: 'Página - Arpia',
  description: 'Descrição da página',
  openGraph: {
    title: 'Página - Arpia',
    description: 'Descrição da página',
    type: 'website',
  }
}
```

---

## 5. Guard de Rotas

### 5.1 Middleware

```typescript
// src/middleware.ts
// Verifica autenticação
// Verifica role
// Redireciona conforme necessário
```

### 5.2 Fluxo

```
Requisição → Middleware
  ├── Não autenticado → /login
  ├── Status pending → /pending
  ├── Status rejected → /login (erro)
  ├── Rota admin + não admin → /dashboard
  └── Autenticado → Rota solicitada
```

---

## 6. Navegação

### 6.1 Sidebar (Dashboard)

```
├── Dashboard (Home)
├── Biblioteca (BookOpen)
├── Audiolivros (Headphones)
├── Fórum (MessageSquare)
├── Chat (MessageCircle)
├── Tarô (Sparkles)
└── Perfil (User)
```

### 6.2 Sidebar (Admin)

```
├── Dashboard (LayoutDashboard)
├── Usuários (Users)
├── Livros (BookOpen)
├── Audiolivros (Headphones)
├── Categorias (Tag)
├── Fórum (MessageSquare)
├── Chat (MessageCircle)
└── Tarô (Sparkles)
```

### 6.3 Header

```
├── Logo/Nome
├── Busca (Search)
├── Notificações (Bell) [futuro]
└── Perfil (User)
    ├── Meu Perfil
    ├── Configurações
    └── Sair
```
