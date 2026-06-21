-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE books ENABLE ROW LEVEL SECURITY;
ALTER TABLE book_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE book_ratings ENABLE ROW LEVEL SECURITY;
ALTER TABLE audiobooks ENABLE ROW LEVEL SECURITY;
ALTER TABLE audiobook_chapters ENABLE ROW LEVEL SECURITY;
ALTER TABLE forum_topics ENABLE ROW LEVEL SECURITY;
ALTER TABLE forum_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE forum_votes ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE tarot_cards ENABLE ROW LEVEL SECURITY;
ALTER TABLE tarot_draws ENABLE ROW LEVEL SECURITY;

-- Profiles policies
CREATE POLICY "profiles_select" ON profiles
  FOR SELECT USING (
    auth.uid() = id OR
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "profiles_update" ON profiles
  FOR UPDATE USING (
    auth.uid() = id OR
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "profiles_insert" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Categories policies (public read, admin write)
CREATE POLICY "categories_select" ON categories
  FOR SELECT USING (true);

CREATE POLICY "categories_insert" ON categories
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "categories_update" ON categories
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "categories_delete" ON categories
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- Tags policies (public read, admin write)
CREATE POLICY "tags_select" ON tags
  FOR SELECT USING (true);

CREATE POLICY "tags_insert" ON tags
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- Books policies
CREATE POLICY "books_select" ON books
  FOR SELECT USING (
    is_active = true AND
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('approved', 'admin'))
  );

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

-- Book tags policies
CREATE POLICY "book_tags_select" ON book_tags
  FOR SELECT USING (true);

CREATE POLICY "book_tags_insert" ON book_tags
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "book_tags_delete" ON book_tags
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- Book ratings policies
CREATE POLICY "book_ratings_select" ON book_ratings
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('approved', 'admin'))
  );

CREATE POLICY "book_ratings_insert" ON book_ratings
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "book_ratings_update" ON book_ratings
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "book_ratings_delete" ON book_ratings
  FOR DELETE USING (
    auth.uid() = user_id OR
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- Audiobooks policies
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

-- Audiobook chapters policies
CREATE POLICY "audiobook_chapters_select" ON audiobook_chapters
  FOR SELECT USING (true);

CREATE POLICY "audiobook_chapters_insert" ON audiobook_chapters
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "audiobook_chapters_update" ON audiobook_chapters
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "audiobook_chapters_delete" ON audiobook_chapters
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- Forum topics policies
CREATE POLICY "forum_topics_select" ON forum_topics
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('approved', 'admin'))
  );

CREATE POLICY "forum_topics_insert" ON forum_topics
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('approved', 'admin'))
  );

CREATE POLICY "forum_topics_update" ON forum_topics
  FOR UPDATE USING (
    auth.uid() = author_id OR
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "forum_topics_delete" ON forum_topics
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- Forum comments policies
CREATE POLICY "forum_comments_select" ON forum_comments
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('approved', 'admin'))
  );

CREATE POLICY "forum_comments_insert" ON forum_comments
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('approved', 'admin'))
  );

CREATE POLICY "forum_comments_update" ON forum_comments
  FOR UPDATE USING (
    auth.uid() = author_id OR
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "forum_comments_delete" ON forum_comments
  FOR DELETE USING (
    auth.uid() = author_id OR
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- Forum votes policies
CREATE POLICY "forum_votes_select" ON forum_votes
  FOR SELECT USING (true);

CREATE POLICY "forum_votes_insert" ON forum_votes
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "forum_votes_delete" ON forum_votes
  FOR DELETE USING (auth.uid() = user_id);

-- Chat rooms policies
CREATE POLICY "chat_rooms_select" ON chat_rooms
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('approved', 'admin'))
  );

CREATE POLICY "chat_rooms_insert" ON chat_rooms
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "chat_rooms_update" ON chat_rooms
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "chat_rooms_delete" ON chat_rooms
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- Chat messages policies
CREATE POLICY "chat_messages_select" ON chat_messages
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('approved', 'admin'))
  );

CREATE POLICY "chat_messages_insert" ON chat_messages
  FOR INSERT WITH CHECK (
    auth.uid() = author_id AND
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('approved', 'admin'))
  );

CREATE POLICY "chat_messages_update" ON chat_messages
  FOR UPDATE USING (
    auth.uid() = author_id OR
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "chat_messages_delete" ON chat_messages
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- Tarot cards policies
CREATE POLICY "tarot_cards_select" ON tarot_cards
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role IN ('approved', 'admin'))
  );

CREATE POLICY "tarot_cards_insert" ON tarot_cards
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "tarot_cards_update" ON tarot_cards
  FOR UPDATE USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "tarot_cards_delete" ON tarot_cards
  FOR DELETE USING (
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

-- Tarot draws policies
CREATE POLICY "tarot_draws_select" ON tarot_draws
  FOR SELECT USING (
    auth.uid() = user_id OR
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );

CREATE POLICY "tarot_draws_insert" ON tarot_draws
  FOR INSERT WITH CHECK (auth.uid() = user_id);
