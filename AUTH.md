# 06 — AUTH (Fluxos de Autenticação)

**Projeto:** Arpia  
**Versão:** 1.0  
**Data:** 2026-06-21

---

## 1. Visão Geral

Autenticação gerenciada pelo Supabase Auth com email/senha. Controle de acesso via RLS policies baseadas no campo `role` da tabela `profiles`.

---

## 2. Fluxos

### 2.1 Cadastro

```
┌─────────────────────────────────────────────────────────────┐
│                    FLUXO DE CADASTRO                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Usuário acessa /register                                │
│  2. Preenche: nome, email, senha, confirmar senha           │
│  3. Validação frontend (Zod)                                │
│  4. Envia para supabase.auth.signUp()                       │
│  5. Supabase cria usuário em auth.users                     │
│  6. Trigger cria profile com status = 'pending'             │
│  7. Supabase envia email de confirmação                     │
│  8. Usuário é redirecionado para /pending                   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Campos validados:**
- `full_name`: mínimo 3 caracteres
- `email`: formato válido, único
- `password`: mínimo 8 caracteres
- `confirm_password`: deve coincidir com password

**Mensagens de erro:**
- "Email já cadastrado" (409 Conflict)
- "Senha deve ter pelo menos 8 caracteres"
- "Senhas não coincidem"

### 2.2 Login

```
┌─────────────────────────────────────────────────────────────┐
│                     FLUXO DE LOGIN                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Usuário acessa /login                                   │
│  2. Preenche: email, senha                                  │
│  3. Envia para supabase.auth.signInWithPassword()           │
│  4. Supabase valida credenciais                             │
│  5. Retorna access_token + refresh_token                    │
│  6. Middleware verifica role do profile                      │
│  7. Se 'approved' ou 'admin' → /dashboard                   │
│  8. Se 'pending' → /pending                                 │
│  9. Se 'rejected' → mensagem de erro                        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 2.3 Página de Pendência

```
┌─────────────────────────────────────────────────────────────┐
│              FLUXO DE PENDÊNCIA                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Usuário com status 'pending' acessa o sistema           │
│  2. Middleware redireciona para /pending                     │
│  3. Página exibe:                                           │
│     - "Seu cadastro está pendente de aprovação"             │
│     - "Você receberá um email quando for aprovado"          │
│     - Botão "Sair"                                          │
│  4. Usuário não pode acessar nenhuma funcionalidade         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 2.4 Aprovação (Admin)

```
┌─────────────────────────────────────────────────────────────┐
│              FLUXO DE APROVAÇÃO                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Admin acessa /admin/users                               │
│  2. Visualiza lista de usuários pendentes                   │
│  3. Clica em "Aprovar" ou "Rejeitar"                        │
│  4. Atualiza profile:                                       │
│     - role = 'approved'                                     │
│     - status = 'approved'                                   │
│  5. Supabase envia email de boas-vindas                     │
│  6. Usuário pode agora acessar o sistema                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 2.5 Logout

```
┌─────────────────────────────────────────────────────────────┐
│                     FLUXO DE LOGOUT                         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Usuário clica em "Sair"                                 │
│  2. supabase.auth.signOut()                                 │
│  3. Tokens são invalidados                                  │
│  4. Cookies são limpos                                      │
│  5. Cache do React Query é limpo                            │
│  6. Redireciona para /login                                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 2.6 Reset de Senha

```
┌─────────────────────────────────────────────────────────────┐
│              FLUXO DE RESET DE SENHA                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Usuário acessa /forgot-password                         │
│  2. Insere email                                            │
│  3. supabase.auth.resetPasswordForEmail(email)              │
│  4. Supabase envia email com link de reset                  │
│  5. Usuário clica no link                                   │
│  6. Redirecionado para /reset-password                      │
│  7. Insere nova senha                                       │
│  8. supabase.auth.updateUser({ password })                  │
│  9. Senha atualizada com sucesso                            │
│  10. Redireciona para /login                                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Gerenciamento de Sessão

### 3.1 Tokens
- **Access Token:** Expira em 1 hora
- **Refresh Token:** Expira em 7 dias
- **Armazenamento:** Cookies httpOnly (não acessíveis via JavaScript)

### 3.2 Rotação
- Rotação automática de access tokens via refresh token
- Refresh token é renovado a cada uso
- Sessão expira após 7 dias de inatividade

### 3.3 Middleware
```typescript
// src/lib/supabase/middleware.ts
// Verifica sessão em cada requisição
// Redireciona para /login se não autenticado
// Redireciona para /pending se status = 'pending'
// Redireciona para /login se status = 'rejected'
```

---

## 4. Segurança

### 4.1 Senha
- Mínimo 8 caracteres
- Armazenada com bcrypt (Supabase)
- Nunca exposta em logs ou URLs

### 4.2 Tokens
- Armazenados em cookies httpOnly
- Não acessíveis via JavaScript
- Domínio restrito

### 4.3 Rate Limiting
- Login: 5 tentativas por minuto
- Cadastro: 3 por minuto
- Reset de senha: 3 por hora

### 4.4 Validação
- Email validado no cadastro
- Senha validada no frontend e backend
- CSRF protection via tokens

---

## 5. Páginas de Autenticação

| Rota | Descrição | Acesso |
|------|-----------|--------|
| `/register` | Cadastro | Público |
| `/login` | Login | Público |
| `/pending` | Aguardando aprovação | Autenticado (pending) |
| `/forgot-password` | Esqueci minha senha | Público |
| `/reset-password` | Redefinir senha | Público (com token) |

---

## 6. Erros Comuns

| Erro | Causa | Solução |
|------|-------|---------|
| "Invalid login credentials" | Email/senha incorretos | Verificar credenciais |
| "Email already registered" | Email duplicado | Usar outro email |
| "User not found" | Email não cadastrado | Criar conta |
| "Email not confirmed" | Email não confirmado | Confirmar email |
| "Password too short" | Senha < 8 caracteres | Usar senha maior |
| "Token expired" | Token expirado | Fazer login novamente |
