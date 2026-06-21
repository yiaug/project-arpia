# 07 — PERMISSIONS (RBAC)

**Projeto:** Arpia  
**Versão:** 1.0  
**Data:** 2026-06-21

---

## 1. Visão Geral

Sistema de controle de acesso baseado em funções (Role-Based Access Control) implementado via RLS policies no Supabase.

---

## 2. Roles

| Role | Descrição | Exemplo |
|------|-----------|---------|
| `admin` | Controle total da plataforma | Administrador do sistema |
| `approved` | Usuário com acesso ao conteúdo | Usuário aprovado |
| `pending` | Aguardando aprovação | Usuário recém-cadastrado |

---

## 3. Matriz de Permissões

### 3.1 Autenticação

| Ação | pending | approved | admin |
|------|---------|----------|-------|
| Criar conta | ✅ | ✅ | ✅ |
| Fazer login | ✅ | ✅ | ✅ |
| Ver dashboard | ❌ | ✅ | ✅ |
| Acessar conteúdo | ❌ | ✅ | ✅ |

### 3.2 Biblioteca

| Ação | pending | approved | admin |
|------|---------|----------|-------|
| Ver lista de livros | ❌ | ✅ | ✅ |
| Ver detalhe do livro | ❌ | ✅ | ✅ |
| Ler PDF | ❌ | ✅ | ✅ |
| Acessar link externo | ❌ | ✅ | ✅ |
| Avaliar livro (1-5) | ❌ | ✅ | ✅ |
| Editar avaliação | ❌ | ✅ | ✅ |
| Criar livro | ❌ | ❌ | ✅ |
| Editar livro | ❌ | ❌ | ✅ |
| Excluir livro | ❌ | ❌ | ✅ |

### 3.3 Audiolivros

| Ação | pending | approved | admin |
|------|---------|----------|-------|
| Ver lista de audiolivros | ❌ | ✅ | ✅ |
| Ver detalhe do audiolivro | ❌ | ✅ | ✅ |
| Ouvir audiolivro | ❌ | ✅ | ✅ |
| Criar audiolivro | ❌ | ❌ | ✅ |
| Editar audiolivro | ❌ | ❌ | ✅ |
| Excluir audiolivro | ❌ | ❌ | ✅ |

### 3.4 Fórum

| Ação | pending | approved | admin |
|------|---------|----------|-------|
| Ver categorias | ❌ | ✅ | ✅ |
| Ver tópicos | ❌ | ✅ | ✅ |
| Ver comentários | ❌ | ✅ | ✅ |
| Criar tópico | ❌ | ✅ | ✅ |
| Responder tópico | ❌ | ✅ | ✅ |
| Editar próprio comentário | ❌ | ✅ | ✅ |
| Excluir próprio comentário | ❌ | ✅ | ✅ |
| Votar em tópico/comentário | ❌ | ✅ | ✅ |
| Editar qualquer conteúdo | ❌ | ❌ | ✅ |
| Excluir qualquer conteúdo | ❌ | ❌ | ✅ |
| Fechar tópico | ❌ | ❌ | ✅ |
| Mover tópico | ❌ | ❌ | ✅ |
| Criar categoria | ❌ | ❌ | ✅ |
| Editar categoria | ❌ | ❌ | ✅ |
| Excluir categoria | ❌ | ❌ | ✅ |

### 3.5 Chat

| Ação | pending | approved | admin |
|------|---------|----------|-------|
| Ver salas | ❌ | ✅ | ✅ |
| Ver mensagens | ❌ | ✅ | ✅ |
| Enviar mensagem | ❌ | ✅ | ✅ |
| Editar própria mensagem | ❌ | ✅ | ✅ |
| Criar sala | ❌ | ❌ | ✅ |
| Editar sala | ❌ | ❌ | ✅ |
| Excluir sala | ❌ | ❌ | ✅ |
| Excluir qualquer mensagem | ❌ | ❌ | ✅ |

### 3.6 Tarô

| Ação | pending | approved | admin |
|------|---------|----------|-------|
| Ver baralho | ❌ | ✅ | ✅ |
| Ver detalhe da carta | ❌ | ✅ | ✅ |
| Fazer tiragem | ❌ | ✅ | ✅ |
| Ver histórico próprio | ❌ | ✅ | ✅ |
| Ver histórico de todos | ❌ | ❌ | ✅ |
| Criar carta | ❌ | ❌ | ✅ |
| Editar carta | ❌ | ❌ | ✅ |
| Excluir carta | ❌ | ❌ | ✅ |

### 3.7 Administração

| Ação | pending | approved | admin |
|------|---------|----------|-------|
| Ver dashboard admin | ❌ | ❌ | ✅ |
| Gerenciar usuários | ❌ | ❌ | ✅ |
| Aprovar/rejeitar usuários | ❌ | ❌ | ✅ |
| Desativar usuários | ❌ | ❌ | ✅ |
| Alterar roles | ❌ | ❌ | ✅ |
| Gerenciar categorias | ❌ | ❌ | ✅ |
| Gerenciar conteúdo | ❌ | ❌ | ✅ |
| Ver estatísticas | ❌ | ❌ | ✅ |

---

## 4. Implementação

### 4.1 Verificação no Frontend

```typescript
// Hook para verificar role
function useRole() {
  const { profile } = useProfile()
  
  return {
    isAdmin: profile?.role === 'admin',
    isApproved: profile?.role === 'approved',
    isPending: profile?.role === 'pending',
    hasAccess: profile?.role === 'approved' || profile?.role === 'admin'
  }
}

// Componente de proteção
function ProtectedRoute({ children, requiredRole }) {
  const { hasAccess, isAdmin } = useRole()
  
  if (requiredRole === 'admin' && !isAdmin) {
    return <AccessDenied />
  }
  
  if (!hasAccess) {
    return <PendingApproval />
  }
  
  return children
}
```

### 4.2 Verificação no Backend (RLS)

Todas as tabelas possuem RLS policies que verificam o role do usuário:

```sql
-- Exemplo: livros só podem ser vistos por aprovados e admins
CREATE POLICY "books_select" ON books
  FOR SELECT USING (
    is_active = true AND
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE id = auth.uid() 
      AND role IN ('approved', 'admin')
    )
  );
```

### 4.3 Verificação no Middleware

```typescript
// src/lib/supabase/middleware.ts
// Verifica se o usuário está autenticado
// Verifica se o status é 'approved' ou 'admin'
// Redireciona para /pending se status = 'pending'
// Redireciona para /login se não autenticado
```

---

## 5. Aprovação de Usuários

### 5.1 Processo

1. Usuário se cadastra → status = 'pending', role = 'pending'
2. Admin visualiza lista de pendentes
3. Admin aprova → status = 'approved', role = 'approved'
4. Usuário recebe email de boas-vindas
5. Usuário pode acessar o sistema

### 5.2 Rejeição

1. Admin rejeita → status = 'rejected'
2. Usuário recebe email de notificação
3. Usuário não pode acessar o sistema

### 5.3 Desativação

1. Admin desativa → status = 'inactive'
2. Usuário perde acesso
3. Pode ser reativado pelo admin

---

## 6. Hierarquia de Roles

```
admin
  └── Controle total

approved
  └── Acesso ao conteúdo
  └── Participação no fórum
  └── Participação no chat
  └── Tiragem de tarô
  └── Avaliação de livros

pending
  └── Sem acesso ao conteúdo
  └── Apenas página de pendência
```

---

## 7. Casos Especiais

### 7.1 Primeiro Admin
- Criado manualmente via SQL ou Supabase Dashboard
- Não há fluxo de auto-promoção

### 7.2 Admin Desativado
- Admin pode desativar a si mesmo
- Se único admin, sistema entra em estado de erro
- Necessário intervention manual

### 7.3 Usuário Reativado
- Admin pode reativar usuário desativado
- Status volta para 'approved'
- Usuário pode acessar novamente

---

## 8. Auditoria

### 8.1 Log de Mudanças
- Todas as mudanças de role são logadas
- Quem fez a mudança (admin_id)
- Quando foi feita (timestamp)
- Qual era o estado anterior

### 8.2 Tabela de Auditoria (futuro)
```sql
CREATE TABLE audit_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES profiles(id),
  action TEXT NOT NULL,
  details JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```
