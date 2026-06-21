-- Function to handle new user signup
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, email)
  VALUES (NEW.id, NEW.raw_user_meta_data->>'full_name', NEW.email);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create profile after signup
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Add updated_at triggers to all tables
CREATE TRIGGER update_profiles_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_categories_updated_at
  BEFORE UPDATE ON categories
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_books_updated_at
  BEFORE UPDATE ON books
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_book_ratings_updated_at
  BEFORE UPDATE ON book_ratings
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_audiobooks_updated_at
  BEFORE UPDATE ON audiobooks
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_forum_topics_updated_at
  BEFORE UPDATE ON forum_topics
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_forum_comments_updated_at
  BEFORE UPDATE ON forum_comments
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_chat_rooms_updated_at
  BEFORE UPDATE ON chat_rooms
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TRIGGER update_tarot_cards_updated_at
  BEFORE UPDATE ON tarot_cards
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Function to update forum topic comments count
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

-- Trigger to update comments count
CREATE TRIGGER on_forum_comment_change
  AFTER INSERT OR DELETE ON forum_comments
  FOR EACH ROW EXECUTE FUNCTION update_topic_comments_count();
