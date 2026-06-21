# 12 — ADMIN_FLOWS (Fluxos Administrativos)

**Projeto:** Arpia  
**Versão:** 1.0  
**Data:** 2026-06-21

---

## 1. Dashboard Administrativo

```
┌─────────────────────────────────────────────────────────────┐
│              FLUXO DO DASHBOARD ADMIN                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Admin acessa /admin                                     │
│  2. Visualiza estatísticas:                                 │
│     - Total de usuários                                     │
│     - Usuários pendentes                                    │
│     - Total de livros                                       │
│     - Total de audiolivros                                  │
│     - Total de tópicos no fórum                             │
│     - Total de salas de chat                                │
│     - Total de cartas de tarô                               │
│  3. Visualiza usuários pendentes                            │
│  4. Visualiza atividade recente                             │
│  5. Acessa módulos de gestão                                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Aprovação de Usuários

```
┌─────────────────────────────────────────────────────────────┐
│              FLUXO DE APROVAÇÃO DE USUÁRIOS                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Admin acessa /admin/users                               │
│  2. Visualiza lista de usuários                             │
│  3. Filtra por status: pendente                             │
│  4. Visualiza detalhes do usuário:                          │
│     - Nome                                                  │
│     - Email                                                 │
│     - Data de cadastro                                      │
│  5. Decisão:                                                │
│     a. Aprovar → role = 'approved', status = 'approved'     │
│     b. Rejeitar → status = 'rejected'                       │
│     c. Desativar → status = 'inactive'                      │
│  6. Confirma ação                                           │
│  7. Email é enviado ao usuário                              │
│  8. Lista é atualizada                                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Cadastro de Livro

```
┌─────────────────────────────────────────────────────────────┐
│              FLUXO DE CADASTRO DE LIVRO                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Admin acessa /admin/books                               │
│  2. Clica em "Novo Livro"                                   │
│  3. Preenche formulário:                                    │
│     - Título                                                │
│     - Autor                                                 │
│     - Descrição (Markdown)                                  │
│     - Sinopse (Markdown)                                    │
│     - Categoria (dropdown)                                  │
│     - Tags (seleção múltipla)                               │
│     - Data de publicação                                    │
│     - Número de páginas                                     │
│  4. Upload de capa:                                         │
│     - Seleciona imagem (JPG, PNG, WebP)                     │
│     - Máximo 5MB                                            │
│     - Preview da imagem                                     │
│  5. Opção de conteúdo:                                      │
│     a. Upload de PDF (máx. 50MB)                            │
│     b. Link externo (Google Drive, etc.)                    │
│  6. Validação                                                │
│  7. Upload de arquivos para Supabase Storage                │
│  8. Metadados salvos no banco                               │
│  9. Livro aparece na biblioteca                             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 4. Edição de Livro

```
┌─────────────────────────────────────────────────────────────┐
│              FLUXO DE EDIÇÃO DE LIVRO                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Admin acessa /admin/books                               │
│  2. Seleciona livro para editar                             │
│  3. Acessa /admin/books/[id]/edit                           │
│  4. Visualiza dados atuais                                  │
│  5. Edita campos necessários                                │
│  6. Altera capa (opcional)                                  │
│  7. Altera PDF/link (opcional)                              │
│  8. Validação                                                │
│  9. Atualiza arquivos (se necessário)                       │
│  10. Atualiza metadados                                     │
│  11. Livro é atualizado                                     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 5. Cadastro de Audiolivro

```
┌─────────────────────────────────────────────────────────────┐
│              FLUXO DE CADASTRO DE AUDIOLIVRO                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Admin acessa /admin/audiobooks                          │
│  2. Clica em "Novo Audiolivro"                              │
│  3. Preenche formulário:                                    │
│     - Título                                                │
│     - Autor                                                 │
│     - Descrição (Markdown)                                  │
│     - Categoria (dropdown)                                  │
│  4. Upload de capa                                          │
│  5. Upload de capítulos:                                    │
│     - Seleciona arquivos MP3/OGG                            │
│     - Máximo 100MB por arquivo                              │
│     - Define ordem dos capítulos                            │
│     - Define títulos dos capítulos                          │
│  6. Validação                                                │
│  7. Upload para Supabase Storage                            │
│  8. Metadados salvos                                        │
│  9. Audiolivro aparece na listagem                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 6. Criação de Categoria

```
┌─────────────────────────────────────────────────────────────┐
│              FLUXO DE CRIAÇÃO DE CATEGORIA                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Admin acessa /admin/categories                          │
│  2. Clica em "Nova Categoria"                               │
│  3. Preenche formulário:                                    │
│     - Nome                                                  │
│     - Slug (auto-gerado)                                    │
│     - Descrição                                             │
│     - Tipo (livro, audiolivro, fórum)                       │
│     - Ordem de exibição                                     │
│  4. Validação                                                │
│  5. Categoria é criada                                      │
│  6. Aparece no dropdown correspondente                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 7. Moderação do Fórum

```
┌─────────────────────────────────────────────────────────────┐
│              FLUXO DE MODERAÇÃO DO FÓRUM                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Admin acessa /admin/forum                               │
│  2. Visualiza lista de tópicos                              │
│  3. Ações disponíveis:                                      │
│     a. Fechar tópico                                        │
│     b. Reabrir tópico                                       │
│     c. Mover tópico para outra categoria                    │
│     d. Editar tópico                                        │
│     e. Excluir tópico                                       │
│  4. Para comentários:                                       │
│     a. Editar comentário                                    │
│     b. Excluir comentário                                   │
│  5. Confirma ação                                           │
│  6. Mudança é aplicada                                      │
│  7. Lista é atualizada                                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 8. Gestão de Salas de Chat

```
┌─────────────────────────────────────────────────────────────┐
│              FLUXO DE GESTÃO DE SALAS                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Admin acessa /admin/chat                                │
│  2. Visualiza lista de salas                                │
│  3. Ações:                                                  │
│     a. Criar nova sala                                      │
│     b. Editar sala existente                                │
│     c. Ativar/desativar sala                                │
│     d. Excluir sala                                         │
│  4. Para criar:                                             │
│     - Nome da sala                                          │
│     - Descrição                                             │
│  5. Sala aparece para usuários                              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 9. Cadastro de Cartas de Tarô

```
┌─────────────────────────────────────────────────────────────┐
│              FLUXO DE CADASTRO DE CARTAS                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Admin acessa /admin/tarot                               │
│  2. Clica em "Nova Carta"                                   │
│  3. Preenche formulário:                                    │
│     - Nome                                                  │
│     - Tipo (Maior Arcana / Menor Arcana)                    │
│     - Número                                                │
│     - Interpretação (texto)                                 │
│     - Significado invertido (opcional)                      │
│  4. Upload de imagem:                                       │
│     - JPG, PNG ou WebP                                      │
│     - Máximo 5MB                                            │
│  5. Validação                                                │
│  6. Upload para Supabase Storage                            │
│  7. Carta é criada                                          │
│  8. Aparece no baralho                                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 10. Gestão de Tags

```
┌─────────────────────────────────────────────────────────────┐
│              FLUXO DE GESTÃO DE TAGS                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Admin acessa /admin/books                               │
│  2. Ao criar/editar livro                                   │
│  3. Seleciona tags existentes                               │
│  4. Ou cria nova tag:                                       │
│     - Nome                                                  │
│     - Slug (auto-gerado)                                    │
│  5. Tags são associadas ao livro                            │
│  6. Tags aparecem nos filtros da biblioteca                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 11. Exclusão em Cascata

### 11.1 Exclusão de Livro
- Livro é excluído
- PDF é excluído do Storage
- Capa é excluída do Storage
- Avaliações são excluídas
- Tags são desassociadas

### 11.2 Exclusão de Audiolivro
- Audiolivro é excluído
- MP3s são excluídos do Storage
- Capa é excluída do Storage
- Capítulos são excluídos

### 11.3 Exclusão de Carta
- Carta é excluída
- Imagem é excluída do Storage
- Tiragens mantêm referência (pode quebrar)

### 11.4 Exclusão de Sala de Chat
- Sala é excluída
- Mensagens são excluídas
- Usuários são desconectados

---

## 12. Backup e Restauração

### 12.1 Exportação
- Admin pode exportar dados em CSV/JSON
- Usuários, livros, audiolivros, fórum, tarô

### 12.2 Importação
- Importação de usuários via CSV
- Importação de livros via CSV + upload de PDFs
- Importação de cartas via CSV + upload de imagens

### 12.3 Restauração
- Via backup do Supabase (automático diário)
- Via migrações SQL
