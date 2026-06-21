# 11 — USER_FLOWS (Fluxos do Usuário)

**Projeto:** Arpia  
**Versão:** 1.0  
**Data:** 2026-06-21

---

## 1. Fluxo de Cadastro e Primeiro Acesso

```
┌─────────────────────────────────────────────────────────────┐
│              FLUXO DE CADASTRO → PRIMEIRO ACESSO            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Usuário acessa a plataforma                             │
│  2. Clica em "Criar Conta"                                  │
│  3. Preenche formulário:                                    │
│     - Nome completo                                         │
│     - Email                                                 │
│     - Senha                                                 │
│     - Confirmar senha                                       │
│  4. Validação frontend (Zod)                                │
│  5. Envia formulário                                        │
│  6. Supabase cria conta                                     │
│  7. Trigger cria profile (status: pending)                  │
│  8. Redireciona para /pending                               │
│  9. Mensagem: "Aguardando aprovação"                        │
│  10. Usuário faz logout                                     │
│                                                             │
│  ... tempo de espera ...                                    │
│                                                             │
│  11. Admin aprova usuário                                   │
│  12. Usuário recebe email de boas-vindas                    │
│  13. Usuário faz login                                      │
│  14. Acessa /dashboard                                      │
│  15. Primeira experiência:                                  │
│     - Livros recentes                                       │
│     - Audiolivros recentes                                  │
│     - Discussões recentes                                   │
│     - Tarô do dia                                           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Fluxo de Busca e Leitura de Livro

```
┌─────────────────────────────────────────────────────────────┐
│              FLUXO DE BUSCA E LEITURA                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Usuário acessa /books                                   │
│  2. Visualiza grid de livros                                │
│  3. Opções de busca:                                        │
│     a. Busca por título/autor                               │
│     b. Filtro por categoria                                 │
│     c. Ordenação (recentes, avaliados, alfabético)          │
│  4. Clica em um livro                                       │
│  5. Acessa /books/[id]                                      │
│  6. Visualiza:                                              │
│     - Capa grande                                           │
│     - Título e autor                                        │
│     - Sinopse (Markdown)                                    │
│     - Categoria e tags                                      │
│     - Avaliação média                                       │
│  7. Avalia o livro (1-5 estrelas)                           │
│  8. Clica em "Ler"                                          │
│  9. Opções:                                                 │
│     a. PDF embutido → visualização inline                   │
│     b. Link externo → nova aba                              │
│  10. Lê o conteúdo                                          │
│  11. Volta para a biblioteca                                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Fluxo de Audição de Audiolivro

```
┌─────────────────────────────────────────────────────────────┐
│              FLUXO DE AUDIÇÃO                               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Usuário acessa /audiobooks                              │
│  2. Visualiza grid de audiolivros                           │
│  3. Clica em um audiolivro                                  │
│  4. Acessa /audiobooks/[id]                                 │
│  5. Visualiza:                                              │
│     - Capa                                                  │
│     - Título e autor                                        │
│     - Descrição (Markdown)                                  │
│     - Categoria                                             │
│  6. Player de áudio (React Player):                         │
│     - Play/Pause                                            │
│     - Volume                                                │
│     - Barra de progresso                                    │
│     - Tempo atual / duração total                           │
│  7. Ouve o audiolivro                                       │
│  8. Se múltiplos capítulos:                                 │
│     - Lista de capítulos                                    │
│     - Seleciona capítulo                                    │
│     - Modo contínuo (próximo capítulo)                      │
│  9. Pausa e retoma depois                                   │
│  10. Volta para a lista                                     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 4. Fluxo de Criação de Tópico no Fórum

```
┌─────────────────────────────────────────────────────────────┐
│              FLUXO DE CRIAÇÃO DE TÓPICO                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Usuário acessa /forum                                   │
│  2. Visualiza categorias e tópicos                          │
│  3. Clica em "Novo Tópico"                                  │
│  4. Preenche formulário:                                    │
│     - Título                                                │
│     - Categoria (dropdown)                                  │
│     - Conteúdo (editor Markdown)                            │
│  5. Visualiza preview do Markdown                           │
│  6. Validação frontend                                      │
│  7. Envia formulário                                        │
│  8. Tópico é criado                                         │
│  9. Redireciona para /forum/topic/[id]                      │
│  10. Visualiza o tópico criado                              │
│  11. Aguarda respostas                                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 5. Fluxo de Resposta a Tópico

```
┌─────────────────────────────────────────────────────────────┐
│              FLUXO DE RESPOSTA A TÓPICO                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Usuário acessa /forum/topic/[id]                        │
│  2. Lê o tópico original                                    │
│  3. Lê comentários existentes                              │
│  4. Clica em "Responder"                                    │
│  5. Escreve comentário (Markdown)                           │
│  6. Visualiza preview                                       │
│  7. Envia comentário                                        │
│  8. Comentário aparece na lista                             │
│  9. Outros usuários podem responder                         │
│  10. Thread de discussão se forma                           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 6. Fluxo de Participação no Chat

```
┌─────────────────────────────────────────────────────────────┐
│              FLUXO DE PARTICIPAÇÃO NO CHAT                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Usuário acessa /chat                                    │
│  2. Visualiza salas ativas                                  │
│  3. Seleciona uma sala                                      │
│  4. Acessa /chat/[roomId]                                   │
│  5. Visualiza:                                              │
│     - Nome da sala                                          │
│     - Histórico de mensagens (últimas 500)                  │
│     - Campo de envio                                        │
│  6. Conexão WebSocket é estabelecida                        │
│  7. Mensagens em tempo real aparecem                        │
│  8. Usuário digita mensagem                                 │
│  9. Indicador "digitando" aparece para outros               │
│  10. Usuário envia mensagem                                 │
│  11. Mensagem aparece para todos                            │
│  12. Usuário pode editar própria mensagem                   │
│  13. Scroll automático para baixo                           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 7. Fluxo de Tiragem de Tarô

```
┌─────────────────────────────────────────────────────────────┐
│              FLUXO DE TIRAGEM DE TARÔ                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Usuário acessa /tarot                                   │
│  2. Visualiza baralho completo                              │
│  3. Opções de tiragem:                                      │
│     a. Tiragem do dia (1 carta)                             │
│     b. Tiragem de 3 cartas                                 │
│     c. Tiragem de 5 cartas                                 │
│  4. Seleciona tipo de tiragem                               │
│  5. Clica em "Tirar Cartas"                                 │
│  6. Cartas são sorteadas aleatoriamente                     │
│     (crypto random)                                         │
│  7. Visualiza resultado:                                    │
│     - Imagem da carta                                       │
│     - Nome da carta                                         │
│     - Interpretação                                         │
│     - Significado invertido (se aplicável)                  │
│  8. Para tiragem de 3:                                      │
│     - Passado                                               │
│     - Presente                                              │
│     - Futuro                                                │
│  9. Para tiragem de 5:                                      │
│     - Situação                                              │
│     - Desafio                                               │
│     - Conselho                                              │
│     - Resultado                                             │
│     - Síntese                                               │
│  10. Tiragem é registrada no histórico                      │
│  11. Usuário pode consultar histórico em /tarot/history     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 8. Fluxo de Avaliação de Livro

```
┌─────────────────────────────────────────────────────────────┐
│              FLUXO DE AVALIAÇÃO                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Usuário acessa /books/[id]                              │
│  2. Visualiza avaliação média atual                         │
│  3. Clica nas estrelas para avaliar                         │
│  4. Seleciona nota (1-5)                                    │
│  5. Avaliação é registrada                                  │
│  6. Média é recalculada automaticamente                     │
│  7. Usuário pode editar avaliação posteriormente            │
│  8. Avaliação aparece no card do livro                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 9. Fluxo de Edição de Perfil

```
┌─────────────────────────────────────────────────────────────┐
│              FLUXO DE EDIÇÃO DE PERFIL                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Usuário acessa /profile                                 │
│  2. Visualiza dados atuais:                                 │
│     - Nome completo                                         │
│     - Email                                                 │
│     - Bio (opcional)                                        │
│  3. Edita campos                                            │
│  4. Validação frontend                                      │
│  5. Envia formulário                                        │
│  6. Dados são atualizados                                   │
│  7. Mensagem de sucesso                                     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 10. Fluxo de Logout

```
┌─────────────────────────────────────────────────────────────┐
│              FLUXO DE LOGOUT                                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Usuário clica no perfil                                 │
│  2. Seleciona "Sair"                                        │
│  3. Confirma logout                                         │
│  4. Tokens são invalidados                                  │
│  5. Cookies são limpos                                      │
│  6. Cache do React Query é limpo                            │
│  7. Redireciona para /login                                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 11. Fluxo de Reset de Senha

```
┌─────────────────────────────────────────────────────────────┐
│              FLUXO DE RESET DE SENHA                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Usuário clica em "Esqueci minha senha"                  │
│  2. Acessa /forgot-password                                 │
│  3. Insere email                                            │
│  4. Envia formulário                                        │
│  5. Mensagem: "Email enviado"                               │
│  6. Usuário recebe email                                    │
│  7. Clica no link                                           │
│  8. Acessa /reset-password                                  │
│  9. Insere nova senha                                       │
│  10. Confirma senha                                         │
│  11. Senha é atualizada                                     │
│  12. Redireciona para /login                                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```
