# 05 — API (Mapeamento de Endpoints)

**Projeto:** Arpia  
**Versão:** 1.0  
**Data:** 2026-06-21

---

## 1. Visão Geral

Utiliza Supabase Client SDK para todas as operações. Não há API customizada — todas as chamadas são feitas diretamente via SDK com RLS controlando o acesso.

---

## 2. Autenticação

| Operação | Método Supabase | Descrição |
|----------|-----------------|-----------|
| Cadastro | `supabase.auth.signUp()` | Criar nova conta |
| Login | `supabase.auth.signInWithPassword()` | Autenticar |
| Logout | `supabase.auth.signOut()` | Encerrar sessão |
| Reset senha | `supabase.auth.resetPasswordForEmail()` | Enviar email de reset |
| Atualizar senha | `supabase.auth.updateUser()` | Alterar senha |
| Obter sessão | `supabase.auth.getSession()` | Verificar sessão atual |
| Escuta eventos | `supabase.auth.onAuthStateChange()` | Monitorar estado |

---

## 3. Profiles

| Operação | Query Supabase | Descrição |
|----------|----------------|-----------|
| Obter perfil | `supabase.from('profiles').select('*').eq('id', userId).single()` | Perfil do usuário |
| Atualizar perfil | `supabase.from('profiles').update({ full_name, bio }).eq('id', userId)` | Editar perfil |
| Listar usuários (admin) | `supabase.from('profiles').select('*').order('created_at', { ascending: false })` | Admin: listar todos |
| Aprovar usuário (admin) | `supabase.from('profiles').update({ role: 'approved', status: 'approved' }).eq('id', userId)` | Admin: aprovar |
| Rejeitar usuário (admin) | `supabase.from('profiles').update({ status: 'rejected' }).eq('id', userId)` | Admin: rejeitar |
| Desativar (admin) | `supabase.from('profiles').update({ status: 'inactive' }).eq('id', userId)` | Admin: desativar |

---

## 4. Books

| Operação | Query Supabase | Descrição |
|----------|----------------|-----------|
| Listar livros | `supabase.from('books').select('*, categories(*), book_ratings(rating)').eq('is_active', true).order('created_at', { ascending: false })` | Biblioteca |
| Obter livro | `supabase.from('books').select('*, categories(*), book_tags(tags(*)), book_ratings(*)').eq('id', bookId).single()` | Detalhe |
| Buscar livros | `supabase.from('books').select('*').ilike('title', `%${search}%`).or(`author.ilike.%${search}%`)` | Busca |
| Filtrar por categoria | `supabase.from('books').select('*').eq('category_id', categoryId)` | Filtro |
| Criar livro (admin) | `supabase.from('books').insert({ title, author, ... })` | Admin: criar |
| Atualizar livro (admin) | `supabase.from('books').update({ ... }).eq('id', bookId)` | Admin: editar |
| Excluir livro (admin) | `supabase.from('books').delete().eq('id', bookId)` | Admin: excluir |
| Avaliar livro | `supabase.from('book_ratings').upsert({ book_id, user_id, rating })` | Avaliação |

---

## 5. Audiobooks

| Operação | Query Supabase | Descrição |
|----------|----------------|-----------|
| Listar audiolivros | `supabase.from('audiobooks').select('*, categories(*)').eq('is_active', true)` | Listagem |
| Obter audiolivro | `supabase.from('audiobooks').select('*, categories(*), audiobook_chapters(*)').eq('id', audiobookId).single()` | Detalhe |
| Criar (admin) | `supabase.from('audiobooks').insert({ ... })` | Admin: criar |
| Atualizar (admin) | `supabase.from('audiobooks').update({ ... }).eq('id', audiobookId)` | Admin: editar |
| Excluir (admin) | `supabase.from('audiobooks').delete().eq('id', audiobookId)` | Admin: excluir |

---

## 6. Forum

| Operação | Query Supabase | Descrição |
|----------|----------------|-----------|
| Listar categorias | `supabase.from('categories').select('*').eq('type', 'forum')` | Categorias |
| Listar tópicos | `supabase.from('forum_topics').select('*, profiles(full_name), categories(name)').order('created_at', { ascending: false })` | Listagem |
| Obter tópico | `supabase.from('forum_topics').select('*, profiles(full_name), categories(name)').eq('id', topicId).single()` | Detalhe |
| Criar tópico | `supabase.from('forum_topics').insert({ title, content, category_id, author_id })` | Novo tópico |
| Listar comentários | `supabase.from('forum_comments').select('*, profiles(full_name)').eq('topic_id', topicId).order('created_at')` | Comentários |
| Criar comentário | `supabase.from('forum_comments').insert({ topic_id, content, author_id })` | Novo comentário |
| Editar comentário | `supabase.from('forum_comments').update({ content, is_edited: true }).eq('id', commentId)` | Editar |
| Excluir comentário | `supabase.from('forum_comments').delete().eq('id', commentId)` | Excluir |
| Votar | `supabase.from('forum_votes').upsert({ user_id, target_type, target_id, value })` | Voto |
| Buscar tópicos | `supabase.from('forum_topics').select('*').ilike('title', `%${search}%`)` | Busca |

---

## 7. Chat

| Operação | Query Supabase | Descrição |
|----------|----------------|-----------|
| Listar salas | `supabase.from('chat_rooms').select('*').eq('is_active', true)` | Salas ativas |
| Obter sala | `supabase.from('chat_rooms').select('*').eq('id', roomId).single()` | Detalhe |
| Listar mensagens | `supabase.from('chat_messages').select('*, profiles(full_name)').eq('room_id', roomId).order('created_at', { ascending: false }).limit(500)` | Mensagens |
| Enviar mensagem | `supabase.from('chat_messages').insert({ room_id, author_id, content })` | Nova mensagem |
| Criar sala (admin) | `supabase.from('chat_rooms').insert({ name, description })` | Admin: criar |
| Atualizar sala (admin) | `supabase.from('chat_rooms').update({ ... }).eq('id', roomId)` | Admin: editar |
| Excluir sala (admin) | `supabase.from('chat_rooms').delete().eq('id', roomId)` | Admin: excluir |
| Realtime subscription | `supabase.channel('room-${roomId}').on('postgres_changes', { event: 'INSERT', schema: 'public', table: 'chat_messages', filter: `room_id=eq.${roomId}` })` | Tempo real |

---

## 8. Tarot

| Operação | Query Supabase | Descrição |
|----------|----------------|-----------|
| Listar cartas | `supabase.from('tarot_cards').select('*').eq('is_active', true)` | Baralho |
| Obter carta | `supabase.from('tarot_cards').select('*').eq('id', cardId).single()` | Detalhe |
| Tiragem aleatória | RPC function ou client-side random | Tiragem |
| Histórico de tiragens | `supabase.from('tarot_draws').select('*, tarot_cards(*)').eq('user_id', userId).order('created_at', { ascending: false })` | Histórico |
| Registrar tiragem | `supabase.from('tarot_draws').insert({ user_id, draw_type, cards: JSON.stringify(cards) })` | Nova tiragem |
| Criar carta (admin) | `supabase.from('tarot_cards').insert({ name, arcana_type, ... })` | Admin: criar |
| Atualizar carta (admin) | `supabase.from('tarot_cards').update({ ... }).eq('id', cardId)` | Admin: editar |
| Excluir carta (admin) | `supabase.from('tarot_cards').delete().eq('id', cardId)` | Admin: excluir |

---

## 9. Storage

| Operação | Método Supabase | Descrição |
|----------|-----------------|-----------|
| Upload PDF | `supabase.storage.from('books').upload(path, file)` | Livro |
| Upload MP3 | `supabase.storage.from('audiobooks').upload(path, file)` | Audiolivro |
| Upload imagem | `supabase.storage.from('covers').upload(path, file)` | Capa |
| Upload tarô | `supabase.storage.from('tarot').upload(path, file)` | Carta |
| Obter URL pública | `supabase.storage.from(bucket).getPublicUrl(path)` | URL de acesso |
| Listar arquivos | `supabase.storage.from(bucket).list(path)` | Listagem |
| Deletar arquivo | `supabase.storage.from(bucket).remove([path])` | Excluir |

---

## 10. Categories

| Operação | Query Supabase | Descrição |
|----------|----------------|-----------|
| Listar categorias | `supabase.from('categories').select('*').order('sort_order')` | Listagem |
| Filtrar por tipo | `supabase.from('categories').select('*').eq('type', type)` | Por tipo |
| Criar (admin) | `supabase.from('categories').insert({ name, slug, type })` | Admin: criar |
| Atualizar (admin) | `supabase.from('categories').update({ ... }).eq('id', categoryId)` | Admin: editar |
| Excluir (admin) | `supabase.from('categories').delete().eq('id', categoryId)` | Admin: excluir |

---

## 11. Tags

| Operação | Query Supabase | Descrição |
|----------|----------------|-----------|
| Listar tags | `supabase.from('tags').select('*').order('name')` | Listagem |
| Criar (admin) | `supabase.from('tags').insert({ name, slug })` | Admin: criar |
| Associar a livro | `supabase.from('book_tags').insert({ book_id, tag_id })` | Associar |
| Remover de livro | `supabase.from('book_tags').delete().eq('book_id', bookId).eq('tag_id', tagId)` | Remover |

---

## 12. Erros Padronizados

| Código | Mensagem | Descrição |
|--------|----------|-----------|
| 400 | Bad Request | Dados inválidos |
| 401 | Unauthorized | Não autenticado |
| 403 | Forbidden | Sem permissão |
| 404 | Not Found | Recurso não encontrado |
| 409 | Conflict | Conflito (ex: email duplicado) |
| 413 | Payload Too Large | Arquivo muito grande |
| 429 | Too Many Requests | Rate limit |
| 500 | Internal Server Error | Erro interno |

---

## 13. Rate Limiting

Supabase aplica rate limiting nativo:
- Auth: 30 requests/min por IP
- Database: depende do plano
- Storage: depende do plano

**MVP (Plano Gratuito):**
- 500MB banco
- 1GB storage
- 50K MAU
- Bandwidth: ilimitado
