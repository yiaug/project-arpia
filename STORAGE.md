# 08 — STORAGE (Estratégia de Arquivos)

**Projeto:** Arpia  
**Versão:** 1.0  
**Data:** 2026-06-21

---

## 1. Visão Geral

Armazenamento de arquivos via Supabase Storage com buckets isolados por tipo de conteúdo. Políticas de acesso baseadas em RLS.

---

## 2. Buckets

| Bucket | Tipo | Limite | Descrição |
|--------|------|--------|-----------|
| `books` | PDF | 50MB | Livros da biblioteca |
| `audiobooks` | MP3, OGG | 100MB | Arquivos de áudio |
| `covers` | JPG, PNG, WebP | 5MB | Capas de livros/audiolivros |
| `tarot` | JPG, PNG, WebP | 5MB | Imagens de cartas |

---

## 3. Estrutura de Pastas

```
books/
├── {book-id}/
│   ├── {filename}.pdf

audiobooks/
├── {audiobook-id}/
│   ├── chapter-01.mp3
│   ├── chapter-02.mp3
│   └── ...

covers/
├── books/
│   ├── {book-id}.jpg
├── audiobooks/
│   ├── {audiobook-id}.jpg
├── tarot/
│   ├── {card-id}.jpg

tarot/
├── cards/
│   ├── {card-id}.jpg
```

---

## 4. Políticas de Acesso

### 4.1 books
```sql
-- Leitura: usuários aprovados e admins
CREATE POLICY "books_storage_select" ON storage.objects
  FOR SELECT USING (
    bucket_id = 'books' AND
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE id = auth.uid() 
      AND role IN ('approved', 'admin')
    )
  );

-- Upload: apenas admin
CREATE POLICY "books_storage_insert" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'books' AND
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE id = auth.uid() 
      AND role = 'admin'
    )
  );

-- Delete: apenas admin
CREATE POLICY "books_storage_delete" ON storage.objects
  FOR DELETE USING (
    bucket_id = 'books' AND
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE id = auth.uid() 
      AND role = 'admin'
    )
  );
```

### 4.2 audiobooks
```sql
-- Mesmo padrão de books
-- Leitura: aprovados e admins
-- Upload/Delete: apenas admin
```

### 4.3 covers
```sql
-- Leitura: todos autenticados
CREATE POLICY "covers_storage_select" ON storage.objects
  FOR SELECT USING (
    bucket_id = 'covers' AND
    auth.role() = 'authenticated'
  );

-- Upload/Delete: apenas admin
CREATE POLICY "covers_storage_insert" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'covers' AND
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE id = auth.uid() 
      AND role = 'admin'
    )
  );
```

### 4.4 tarot
```sql
-- Leitura: aprovados e admins
-- Upload/Delete: apenas admin
```

---

## 5. Upload

### 5.1 Frontend

```typescript
async function uploadFile(file: File, bucket: string, path: string) {
  const { data, error } = await supabase.storage
    .from(bucket)
    .upload(path, file, {
      cacheControl: '3600',
      upsert: false
    })
  
  if (error) throw error
  return data
}
```

### 5.2 Validações

| Bucket | Tipos Permitidos | Tamanho Máximo |
|--------|------------------|----------------|
| books | .pdf | 50MB |
| audiobooks | .mp3, .ogg | 100MB |
| covers | .jpg, .jpeg, .png, .webp | 5MB |
| tarot | .jpg, .jpeg, .png, .webp | 5MB |

### 5.3 Naming Convention

```
{entity-type}/{entity-id}/{filename}.{ext}

Exemplos:
books/550e8400-e29b-41d4-a716-446655440000/o-alquimista.pdf
audiobooks/660e8400-e29b-41d4-a716-446655440001/chapter-01.mp3
covers/books/550e8400-e29b-41d4-a716-446655440000.jpg
tarot/cards/770e8400-e29b-41d4-a716-446655440002.jpg
```

---

## 6. URLs Públicas

### 6.1 Obter URL
```typescript
function getPublicUrl(bucket: string, path: string) {
  const { data } = supabase.storage
    .from(bucket)
    .getPublicUrl(path)
  
  return data.publicUrl
}
```

### 6.2 URLs de Exemplo
```
https://{project-ref}.supabase.co/storage/v1/object/public/books/550e8400/...
https://{project-ref}.supabase.co/storage/v1/object/public/covers/books/550e8400.jpg
```

---

## 7. Exclusão

### 7.1 Exclusão em Cascata
- Quando um livro é excluído, seu PDF e capa também são excluídos
- Quando um audiolivro é excluído, seus MP3 e capa também são excluídos
- Quando uma carta de tarô é excluída, sua imagem também é excluída

### 7.2 Implementação
```typescript
async function deleteFile(bucket: string, paths: string[]) {
  const { data, error } = await supabase.storage
    .from(bucket)
    .remove(paths)
  
  if (error) throw error
  return data
}
```

---

## 8. Performance

### 8.1 CDN
- Supabase Storage usa CDN automático
- Cache de 1 hora para assets estáticos
- Headers de cache configuráveis

### 8.2 Otimização
- Compressão automática de imagens
- Lazy loading no frontend
- Tamanhos de thumbnail configuráveis

---

## 9. Limites do Plano Gratuito

| Recurso | Limite |
|---------|--------|
| Storage total | 1GB |
| Bandwidth | Ilimitado |
| Tamanho máximo por arquivo | 50MB (configurável) |
| Buckets | 1 (gratuito) / Ilimitado (pago) |

**Nota:** Para MVP, 1GB pode ser insuficiente com PDFs grandes. Considerar upgrade para plano pago ($25/mês) se necessário.

---

## 10. Backup

### 10.1 Estratégia
- Supabase Storage não possui backup automático no plano gratuito
- Recomendação: backup manual periódico para storage externo
- Futuro: automação via Edge Functions

### 10.2 Recuperação
- Arquivos podem ser re-uploadados se necessário
- Metadados mantidos no banco de dados
- URLs podem ser regeneradas
