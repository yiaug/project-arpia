-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create profiles table
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

-- Create indexes for profiles
CREATE INDEX idx_profiles_role ON profiles(role);
CREATE INDEX idx_profiles_status ON profiles(status);
CREATE INDEX idx_profiles_email ON profiles(email);

-- Create categories table
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

-- Create indexes for categories
CREATE INDEX idx_categories_type ON categories(type);
CREATE INDEX idx_categories_slug ON categories(slug);
CREATE INDEX idx_categories_sort ON categories(sort_order);

-- Create tags table
CREATE TABLE tags (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  slug TEXT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create indexes for tags
CREATE INDEX idx_tags_slug ON tags(slug);

-- Create books table
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

-- Create indexes for books
CREATE INDEX idx_books_category ON books(category_id);
CREATE INDEX idx_books_author ON books(author);
CREATE INDEX idx_books_active ON books(is_active);
CREATE INDEX idx_books_created ON books(created_at DESC);

-- Create book_tags table (N:N relationship)
CREATE TABLE book_tags (
  book_id UUID REFERENCES books(id) ON DELETE CASCADE,
  tag_id UUID REFERENCES tags(id) ON DELETE CASCADE,
  PRIMARY KEY (book_id, tag_id)
);

-- Create book_ratings table
CREATE TABLE book_ratings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  book_id UUID NOT NULL REFERENCES books(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(book_id, user_id)
);

-- Create indexes for book_ratings
CREATE INDEX idx_book_ratings_book ON book_ratings(book_id);
CREATE INDEX idx_book_ratings_user ON book_ratings(user_id);

-- Create audiobooks table
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

-- Create indexes for audiobooks
CREATE INDEX idx_audiobooks_category ON audiobooks(category_id);
CREATE INDEX idx_audiobooks_active ON audiobooks(is_active);
CREATE INDEX idx_audiobooks_created ON audiobooks(created_at DESC);

-- Create audiobook_chapters table
CREATE TABLE audiobook_chapters (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  audiobook_id UUID NOT NULL REFERENCES audiobooks(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  file_url TEXT NOT NULL,
  duration_seconds INTEGER,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create indexes for audiobook_chapters
CREATE INDEX idx_audiobook_chapters_audiobook ON audiobook_chapters(audiobook_id);
CREATE INDEX idx_audiobook_chapters_sort ON audiobook_chapters(sort_order);

-- Create forum_topics table
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

-- Create indexes for forum_topics
CREATE INDEX idx_forum_topics_category ON forum_topics(category_id);
CREATE INDEX idx_forum_topics_author ON forum_topics(author_id);
CREATE INDEX idx_forum_topics_status ON forum_topics(status);
CREATE INDEX idx_forum_topics_created ON forum_topics(created_at DESC);
CREATE INDEX idx_forum_topics_last_comment ON forum_topics(last_comment_at DESC);

-- Create forum_comments table
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

-- Create indexes for forum_comments
CREATE INDEX idx_forum_comments_topic ON forum_comments(topic_id);
CREATE INDEX idx_forum_comments_parent ON forum_comments(parent_id);
CREATE INDEX idx_forum_comments_author ON forum_comments(author_id);
CREATE INDEX idx_forum_comments_created ON forum_comments(created_at);

-- Create forum_votes table
CREATE TABLE forum_votes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  target_type TEXT NOT NULL CHECK (target_type IN ('topic', 'comment')),
  target_id UUID NOT NULL,
  value INTEGER NOT NULL CHECK (value IN (-1, 1)),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, target_type, target_id)
);

-- Create indexes for forum_votes
CREATE INDEX idx_forum_votes_target ON forum_votes(target_type, target_id);
CREATE INDEX idx_forum_votes_user ON forum_votes(user_id);

-- Create chat_rooms table
CREATE TABLE chat_rooms (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create indexes for chat_rooms
CREATE INDEX idx_chat_rooms_active ON chat_rooms(is_active);

-- Create chat_messages table
CREATE TABLE chat_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  room_id UUID NOT NULL REFERENCES chat_rooms(id) ON DELETE CASCADE,
  author_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  is_edited BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create indexes for chat_messages
CREATE INDEX idx_chat_messages_room ON chat_messages(room_id);
CREATE INDEX idx_chat_messages_author ON chat_messages(author_id);
CREATE INDEX idx_chat_messages_created ON chat_messages(created_at DESC);

-- Create tarot_cards table
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

-- Create indexes for tarot_cards
CREATE INDEX idx_tarot_cards_arcana ON tarot_cards(arcana_type);
CREATE INDEX idx_tarot_cards_active ON tarot_cards(is_active);

-- Create tarot_draws table
CREATE TABLE tarot_draws (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  draw_type TEXT NOT NULL CHECK (draw_type IN ('daily', 'three_cards', 'five_cards')),
  cards JSONB NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create indexes for tarot_draws
CREATE INDEX idx_tarot_draws_user ON tarot_draws(user_id);
CREATE INDEX idx_tarot_draws_created ON tarot_draws(created_at DESC);
