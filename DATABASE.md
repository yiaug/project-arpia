# 04 — DATABASE (Modelagem do Banco de Dados)

**Projeto:** Arpia  
**Versão:** 1.0  
**Data:** 2026-06-21

---

## 1. Visão Geral

Banco PostgreSQL gerenciado pelo Supabase com Row Level Security (RLS) habilitado em todas as tabelas.

**Convenções:**
- IDs: UUID (gerado automaticamente via `gen_random_uuid()`)
- Timestamps: `created_at`, `updated_at` com timezone UTC
- Soft delete: coluna `deleted_at` onde aplicável
- Nomes de tabelas: snake_case, plural
- Nomes de colunas: snake_case

---

## 2. Tabelas

### 2.1 profiles

Extensão do perfil do usuário (complementa auth.users).

```sql
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name TEXT NOT NULL,
  email TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'pending' CHECK (role IN ('pending', 'approved', 'admin')),
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'inactive')),
  avatar_url TEXT,
  bio TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_profiles_role ON profiles(role);
CREATE INDEX idx_profiles_status ON profiles(status);
CREATE INDEX idx_profiles_email ON profiles(email);
```

### 2.2 categories

Categorias para livros, audiolivros e fórum.

```sql
CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  description TEXT,
  type TEXT NOT NULL CHECK (type IN ('book', 'audiobook', 'forum')),
  sort_order INTEGER NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_categories_type ON categories(type);
CREATE INDEX idx_categories_slug ON categories(slug);
CREATE INDEX idx_categories_sort ON categories(sort_order);
```

### 2.3 tags

Tags predefinidas para livros.

```sql
CREATE TABLE tags (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  slug TEXT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_tags_slug ON tags(slug);
```

### 2.4 books

Livros da biblioteca digital.

```sql
CREATE TABLE books (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  author TEXT NOT NULL,
  description TEXT,
  synopsis TEXT,
  category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
  cover_url TEXT,
  pdf_url TEXT,
  external_link TEXT,
  pages INTEGER,
  publication_date DATE,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_by UUID REFERENCES profiles(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_books_category ON books(category_id);
CREATE INDEX idx_books_author ON books(author);
CREATE INDEX idx_books_active ON books(is_active);
CREATE INDEX idx_books_created ON books(created_at DESC);
```

### 2.5 book_tags

Relacionamento N:N entre livros e tags.

```sql
CREATE TABLE book_tags (
  book_id UUID REFERENCES books(id) ON DELETE CASCADE,
  tag_id UUID REFERENCES tags(id) ON DELETE CASCADE,
  PRIMARY KEY (book_id, tag_id)
);
```

### 2.6 book_ratings

Avaliações dos usuários nos livros.

```sql
CREATE TABLE book_ratings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  book_id UUID NOT NULL REFERENCES books(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(book_id, user_id)
);

CREATE INDEX idx_book_ratings_book ON book_ratings(book_id);
CREATE INDEX idx_book_ratings_user ON book_ratings(user_id);
```

### 2.7 audiobooks

Audiolivros da plataforma.

```sql
CREATE TABLE audiobooks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  author TEXT NOT NULL,
  description TEXT,
  category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
  cover_url TEXT,
  duration_seconds INTEGER,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_by UUID REFERENCES profiles(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_audiobooks_category ON audiobooks(category_id);
CREATE INDEX idx_audiobooks_active ON audiobooks(is_active);
CREATE INDEX idx_audiobooks_created ON audiobooks(created_at DESC);
```

### 2.8 audiobook_chapters

Capítulos de audiolivros.

```sql
CREATE TABLE audiobook_chapters (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  audiobook_id UUID NOT NULL REFERENCES audiobooks(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  file_url TEXT NOT NULL,
  duration_seconds INTEGER,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_audiobook_chapters_audiobook ON audiobook_chapters(audiobook_id);
CREATE INDEX idx_audiobook_chapters_sort ON audiobook_chapters(sort_order);
```

### 2.9 forum_topics

Tópicos do fórum.

```sql
CREATE TABLE forum_topics (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  author_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'resolved', 'closed')),
  comments_count INTEGER NOT NULL DEFAULT 0,
  last_comment_at TIMESTAMPTZ,
  is_pinned BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_forum_topics_category ON forum_topics(category_id);
CREATE INDEX idx_forum_topics_author ON forum_topics(author_id);
CREATE INDEX idx_forum_topics_status ON forum_topics(status);
CREATE INDEX idx_forum_topics_created ON forum_topics(created_at DESC);
CREATE INDEX idx_forum_topics_last_comment ON forum_topics(last_comment_at DESC);
```

### 2.10 forum_comments

Comentários nos tópicos.

```sql
CREATE TABLE forum_comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  topic_id UUID NOT NULL REFERENCES forum_topics(id) ON DELETE CASCADE,
  parent_id UUID REFERENCES forum_comments(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  author_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  is_edited BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_forum_comments_topic ON forum_comments(topic_id);
CREATE INDEX idx_forum_comments_parent ON forum_comments(parent_id);
CREATE INDEX idx_forum_comments_author ON forum_comments(author_id);
CREATE INDEX idx_forum_comments_created ON forum_comments(created_at);
```

### 2.11 forum_votes

Votos em tópicos e comentários.

```sql
CREATE TABLE forum_votes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  target_type TEXT NOT NULL CHECK (target_type IN ('topic', 'comment')),
  target_id UUID NOT NULL,
  value INTEGER NOT NULL CHECK (value IN (-1, 1)),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, target_type, target_id)
);

CREATE INDEX idx_forum_votes_target ON forum_votes(target_type, target_id);
CREATE INDEX idx_forum_votes_user ON forum_votes(user_id);
```

### 2.12 chat_rooms

Salas de chat.

```sql
CREATE TABLE chat_rooms (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_chat_rooms_active ON chat_rooms(is_active);
```

### 2.13 chat_messages

Mensagens de chat.

```sql
CREATE TABLE chat_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  room_id UUID NOT NULL REFERENCES chat_rooms(id) ON DELETE CASCADE,
  author_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  is_edited BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_chat_messages_room ON chat_messages(room_id);
CREATE INDEX idx_chat_messages_author ON chat_messages(author_id);
CREATE INDEX idx_chat_messages_created ON chat_messages(created_at DESC);
```

### 2.14 tarot_cards

Cartas de tarô.

```sql
CREATE TABLE tarot_cards (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  arcana_type TEXT NOT NULL CHECK (arcana_type IN ('major', 'minor')),
  number INTEGER,
  image_url TEXT,
  interpretation TEXT NOT NULL,
  reversed_interpretation TEXT,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_tarot_cards_arcana ON tarot_cards(arcana_type);
CREATE INDEX idx_tarot_cards_active ON tarot_cards(is_active);
```

### 2.15 tarot_draws

Tiragens de tarô dos usuários.

```sql
CREATE TABLE tarot_draws (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  draw_type TEXT NOT NULL CHECK (draw_type IN ('daily', 'three_cards', 'five_cards')),
  cards JSONB NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_tarot_draws_user ON tarot_draws(user_id);
CREATE INDEX idx_tarot_draws_created ON tarot_draws(created_at DESC);
```

---

## 3. Relacionamentos

```
auth.users ──1:1── profiles
profiles ──1:N── books (created_by)
profiles ──1:N── book_ratings
profiles ──1:N── audiobooks (created_by)
profiles ──1:N── forum_topics (author_id)
profiles ──1:N── forum_comments (author_id)
profiles ──1:N── forum_votes
profiles ──1:N── chat_messages (author_id)
profiles ──1:N── tarot_draws

categories ──1:N── books
categories ──1:N── audiobooks
categories ──1:N── forum_topics

books ──N:N── tags (via book_tags)
books ──1:N── book_ratings

audiobooks ──1:N── audiobook_chapters

forum_topics ──1:N── forum_comments
forum_topics ──1:N── forum_votes
forum_comments ──1:N── forum_comments (parent_id)
forum_comments ──1:N── forum_votes

chat_rooms ──1:N── chat_messages

tarot_cards ──1:N── tarot_draws
```

---

## 4. RLS Policies

### 4.1 profiles
```sql
-- Leitura: próprio perfil ou admin
CREATE POLICY "profiles_select" ON profiles
  FOR SELECT USING (
    auth.uid() = id OR
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- Atualização: próprio perfil ou admin
CREATE POLICY "profiles_update" ON profiles
  FOR UPDATE USING (
    auth.uid() = id OR
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- Inserção: apenas via trigger (após signup)
CREATE POLICY "profiles_insert" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);
```

### 4.2 books
```sql
-- Leitura: usuários aprovados e admins
CREATE POLICY "books_select" ON books
  FOR SELECT USING (
    is_active = true AND
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('approved', 'admin'))
  );

-- Insert/Update/Delete: apenas admin
CREATE POLICY "books_insert" ON books
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "books_update" ON books
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "books_delete" ON books
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );
```

### 4.3 book_ratings
```sql
-- Leitura: todos os aprovados
CREATE POLICY "book_ratings_select" ON book_ratings
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('approved', 'admin'))
  );

-- Insert/Update: próprio rating
CREATE POLICY "book_ratings_insert" ON book_ratings
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "book_ratings_update" ON book_ratings
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "book_ratings_delete" ON book_ratings
  FOR DELETE USING (
    auth.uid() = user_id OR
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );
```

### 4.4 audiobooks
```sql
-- Mesmo padrão de books
CREATE POLICY "audiobooks_select" ON audiobooks
  FOR SELECT USING (
    is_active = true AND
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('approved', 'admin'))
  );

CREATE POLICY "audiobooks_insert" ON audiobooks
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "audiobooks_update" ON audiobooks
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "audiobooks_delete" ON audiobooks
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );
```

### 4.5 forum_topics
```sql
-- Leitura: aprovados e admins
CREATE POLICY "forum_topics_select" ON forum_topics
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('approved', 'admin'))
  );

-- Insert: aprovados
CREATE POLICY "forum_topics_insert" ON forum_topics
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('approved', 'admin'))
  );

-- Update: autor ou admin
CREATE POLICY "forum_topics_update" ON forum_topics
  FOR UPDATE USING (
    auth.uid() = author_id OR
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- Delete: admin apenas
CREATE POLICY "forum_topics_delete" ON forum_topics
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );
```

### 4.6 forum_comments
```sql
-- Leitura: aprovados
CREATE POLICY "forum_comments_select" ON forum_comments
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('approved', 'admin'))
  );

-- Insert: aprovados
CREATE POLICY "forum_comments_insert" ON forum_comments
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('approved', 'admin'))
  );

-- Update: autor ou admin
CREATE POLICY "forum_comments_update" ON forum_comments
  FOR UPDATE USING (
    auth.uid() = author_id OR
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- Delete: autor ou admin
CREATE POLICY "forum_comments_delete" ON forum_comments
  FOR DELETE USING (
    auth.uid() = author_id OR
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );
```

### 4.7 chat_messages
```sql
-- Leitura/Insert: aprovados
CREATE POLICY "chat_messages_select" ON chat_messages
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('approved', 'admin'))
  );

CREATE POLICY "chat_messages_insert" ON chat_messages
  FOR INSERT WITH CHECK (
    auth.uid() = author_id AND
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('approved', 'admin'))
  );

-- Update: próprio ou admin
CREATE POLICY "chat_messages_update" ON chat_messages
  FOR UPDATE USING (
    auth.uid() = author_id OR
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- Delete: admin apenas
CREATE POLICY "chat_messages_delete" ON chat_messages
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );
```

### 4.8 tarot_draws
```sql
-- Leitura: próprio ou admin
CREATE POLICY "tarot_draws_select" ON tarot_draws
  FOR SELECT USING (
    auth.uid() = user_id OR
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- Insert: próprio
CREATE POLICY "tarot_draws_insert" ON tarot_draws
  FOR INSERT WITH CHECK (auth.uid() = user_id);
```

---

## 5. Triggers e Functions

### 5.1 Auto-criar profile após signup
```sql
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, email)
  VALUES (NEW.id, NEW.raw_user_meta_data->>'full_name', NEW.email);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();
```

### 5.2 Atualizar updated_at
```sql
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar em todas as tabelas relevantes
CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_books_updated_at
  BEFORE UPDATE ON books
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- (repetir para outras tabelas)
```

### 5.3 Atualizar comments_count no forum
```sql
CREATE OR REPLACE FUNCTION update_topic_comments_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE forum_topics
    SET comments_count = comments_count + 1,
        last_comment_at = NEW.created_at
    WHERE id = NEW.topic_id;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE forum_topics
    SET comments_count = comments_count - 1
    WHERE id = OLD.topic_id;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_forum_comment_change
  AFTER INSERT OR DELETE ON forum_comments
  FOR EACH ROW EXECUTE FUNCTION update_topic_comments_count();
```

### 5.4 Calcular média de ratings
```sql
CREATE OR REPLACE FUNCTION calculate_book_average_rating()
RETURNS TRIGGER AS $$
BEGIN
  -- Implementar se necessário
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;
```

---

## 6. Storage Buckets

```sql
-- Criar buckets via Supabase Dashboard ou CLI
-- books: PDFs de livros (máx 50MB)
-- audiobooks: arquivos MP3 (máx 100MB)
-- covers: capas de livros/audiolivros (máx 5MB)
-- tarot: imagens de cartas (máx 5MB)
```

---

## 7. Migrations

Estrutura de migrations:
```
supabase/
├── migrations/
│   ├── 001_create_profiles.sql
│   ├── 002_create_categories.sql
│   ├── 003_create_tags.sql
│   ├── 004_create_books.sql
│   ├── 005_create_book_tags.sql
│   ├── 006_create_book_ratings.sql
│   ├── 007_create_audiobooks.sql
│   ├── 008_create_audiobook_chapters.sql
│   ├── 009_create_forum_topics.sql
│   ├── 010_create_forum_comments.sql
│   ├── 011_create_forum_votes.sql
│   ├── 012_create_chat_rooms.sql
│   ├── 013_create_chat_messages.sql
│   ├── 014_create_tarot_cards.sql
│   ├── 015_create_tarot_draws.sql
│   ├── 016_create_rls_policies.sql
│   ├── 017_create_triggers.sql
│   └── 018_create_indexes.sql
```
