# 01 — PRD (Product Requirements Document)

**Projeto:** Arpia  
**Versão:** 1.0  
**Data:** 2026-06-21  
**Status:** Planejamento

---

## 1. Visão do Produto

Arpia é uma plataforma web dedicada ao estudo de conhecimento esotérico. Oferece uma experiência imersiva e organizada para leitura, audição, discussão e exploração de conteúdos esotéricos, funcionando como uma biblioteca digital premium com recursos comunitários.

**Missão:** Democratizar o acesso ao conhecimento esotérico de qualidade, proporcionando um ambiente seguro, organizado e agradável para estudo e discussão.

---

## 2. Objetivos

### 2.1 Objetivos do Produto
- Consolidar conteúdos esotéricos diversificados em uma única plataforma
- Fornecer experiência de leitura de qualidade (estilo Kindle)
- Permitir discussão comunitária organizada por categorias
- Oferecer recursos interativos (tarô) como ferramenta de estudo
- Manter total controle administrativo sobre conteúdo e usuários

### 2.2 Objetivos de Negócio
- Estabelecer referência em plataforma de estudos esotéricos
- Construir comunidade engajada e moderada
- Escalar para milhares de usuários simultâneos
- Manter custos de infraestrutura controlados

### 2.3 Métricas de Sucesso (KPIs)
- **Mês 1:** 100 usuários aprovados, 50 livros catalogados
- **Mês 3:** 500 usuários, 100 livros, 200 discussões no fórum
- **Mês 6:** 2000 usuários, 300 livros, 500 discussões
- **Engajamento:** >60% dos usuários ativos mensalmente
- **Retenção:** >40% dos usuários retornando após 30 dias

---

## 3. Público-Alvo

### 3.1 Usuários Primários
- Estudantes de esoterismo (iniciantes a avançados)
- Practicantes de tradições esotéricas
- Pesquisadores acadêmicos de ocultismo
- Curiosos sobre espiritualidade alternativa

### 3.2 Perfil Demográfico
- Idade: 18-65 anos
- Interesse: esoterismo, ocultismo, espiritualidade, filosofia
- Dispositivos: desktop, tablet, mobile
- Nível técnico: variado

---

## 4. Funcionalidades

### 4.1 Autenticação e Acesso (P0)

**Regras:**
- Cadastro livre para qualquer pessoa
- Após cadastro → status "Pendente"
- Aprovação apenas por administrador
- Sem aprovação → sem acesso ao sistema
- Logout seguro com limpeza de sessão
- Reset de senha via email

**Fluxo:**
1. Usuário acessa página de cadastro
2. Preenche: nome, email, senha
3. Envia formulário
4. Recebe confirmação de envio
5. Admin revisa e aprova/rejeita
6. Se aprovado → recebe email de boas-vindas
7. Se rejeitado → recebe email de notificação

**Campos obrigatórios:**
- Nome completo
- Email (único)
- Senha (mínimo 8 caracteres)

### 4.2 Dashboard Inicial (P0)

**Conteúdo:**
- **Livros recentes:** Últimos 10 livros adicionados (cards com capa, título, autor)
- **Audiolivros recentes:** Últimos 5 audiolivros (cards com capa, título)
- **Discussões recentes:** Últimas 5 discussões do fórum (título, categoria, autor, data)
- **Tarô do dia:** Carta sorteada aleatoriamente (imagem, nome, interpretação curta)

**Comportamento:**
- Atualização automática ao carregar a página
- Cards clicáveis redirecionam para o conteúdo
- Layout responsivo (grid adaptativo)
- Loader skeletons durante carregamento

### 4.3 Biblioteca Digital (P0)

**Layout:** Inspirado no Kindle — grid de cards com capa, limpo e organizado.

**Card do Livro:**
- Capa (imagem)
- Título
- Autor
- Avaliação (estrelas 1-5)

**Página do Livro:**
- Capa grande
- Título e autor
- Sinopse completa (renderizada em Markdown)
- Categoria
- Tags
- Avaliação média
- Botão "Ler" ou link externo
- Informações adicionais (data de publicação, páginas)

**Funcionalidades:**
- Busca por título, autor, categoria, tags
- Filtro por categoria
- Ordenação: mais recentes, mais avaliados, alfabético
- Paginação por página (20 itens)
- Visualização em grid ou lista

**Conteúdo:**
- PDF enviado pelo administrador → visualização embutida
- Link externo (Google Drive, etc.) → abertura em nova aba

**Restrições:**
- Somente administrador cadastra livros
- Usuários podem avaliar (1-5 estrelas)
- Uma avaliação por usuário por livro
- Permite edição de avaliação
- Média visível publicamente

### 4.4 Audiolivros (P1)

**Card do Audiolivro:**
- Capa (imagem)
- Título
- Autor
- Duração

**Página do Audiolivro:**
- Capa
- Título e autor
- Descrição (Markdown)
- Categoria
- Player de áudio embutido (React Player)
- Playlist (se múltiplos capítulos)

**Player de Áudio (React Player):**
- Play/Pause
- Volume
- Progresso (barra de progresso)
- Tempo atual / duração total
- Retry automático em caso de falha
- Modo contínuo (próximo audiolivro)
- Suporte a MP3, OGG
- Controles acessíveis (keyboard shortcuts)

**Restrições:**
- Somente administrador cadastra audiolivros
- Arquivos MP3 via Supabase Storage
- Limite de 100MB por arquivo

### 4.5 Fórum (P1)

**Estrutura:** Estilo Reddit com categorias.

**Editor:** Markdown com renderização via react-markdown.

**Componentes:**
- **Categorias:** Definidas pelo administrador (ex: Tarô, Numerologia, Alquimia, etc.)
- **Tópicos:** Criados por usuários aprovados
- **Comentários:** Respostas aos tópicos
- **Respostas a comentários:** Sub-respostas (thread)

**Tópico:**
- Título
- Categoria
- Conteúdo (Markdown)
- Autor
- Data de criação
- Data de última resposta
- Contagem de respostas
- Status (aberto, resolvido, fechado)

**Comentário:**
- Conteúdo (Markdown)
- Autor
- Data de criação
- Edição (se editado)
- Respostas (sub-comentários)

**Funcionalidades:**
- Criar tópico
- Responder tópico
- Editar próprios comentários
- Excluir próprios comentários
- Busca em tópicos
- Filtro por categoria
- Ordenação: mais recentes, mais comentados, mais votados
- Paginação

**Moderação (Admin):**
- Editar qualquer tópico/comentário
- Excluir qualquer tópico/comentário
- Fechar tópicos
- Mover tópicos entre categorias

### 4.6 Chats (P2)

**Estrutura:** Salas de texto em tempo real via Supabase Realtime.

**Sala:**
- Nome
- Descrição
- Data de criação
- Status (ativa, inativa)
- Mensagens

**Mensagem:**
- Conteúdo (texto)
- Autor
- Data/hora de envio
- Edição (se editado)

**Funcionalidades:**
- Listar salas ativas
- Entrar em sala
- Enviar mensagem
- Histórico de mensagens (permanente, últimas 500 visíveis)
- Scroll automático para baixo
- Indicador de "digitando"
- Notificação de novas mensagens

**Restrições:**
- Somente administrador cria/edita/exclui salas
- Usuários apenas participam
- Mensagens permanentes
- Limite de 500 mensagens por sala visíveis

### 4.7 Tarô (P2)

**Estrutura:** Sistema manual sem IA.

**Carta:**
- Imagem
- Nome
- Tipo (Maior Arcana / Menor Arcana)
- Número
- Interpretação (texto manual)
- Significado invertido (opcional)

**Funcionalidades:**
- Visualizar baralho completo
- Tiragem do dia (1 carta aleatória)
- Tiragem de 3 cartas (passado, presente, futuro)
- Tiragem de 5 cartas (situação, desafio, conselho, resultado, síntese)
- Histórico de tiragens do usuário
- Significado de cada carta

**Restrições:**
- Somente administrador cadastra cartas e interpretações
- Tiragem aleatória real (crypto random)
- Sem interpretação por IA — apenas texto cadastrado
- Máximo 10 tiragens por usuário por dia

### 4.8 Administração (P0)

**Dashboard Admin:**
- Estatísticas: usuários, livros, audiolivros, tópicos, salas
- Usuários pendentes de aprovação
- Atividade recente

**Gestão de Usuários:**
- Listar todos os usuários
- Aprovar/rejeitar pendentes
- Desativar usuários
- Alterar role (admin/usuário)
- Busca e filtro

**Gestão de Livros:**
- CRUD completo
- Upload de PDF (máx. 50MB)
- Link externo
- Categorias e tags
- Avaliações

**Gestão de Audiolivros:**
- CRUD completo
- Upload de MP3 (máx. 100MB)
- Categorias

**Gestão de Categorias:**
- Criar/editar/excluir categorias (fórum, livros, audiolivros)
- Ordem de exibição
- Status (ativa/inativa)

**Gestão de Fórum:**
- Moderar tópicos e comentários
- Fechar/reabrir tópicos
- Mover tópicos

**Gestão de Salas:**
- CRUD de salas de chat
- Ativar/desativar salas

**Gestão de Tarô:**
- CRUD de cartas
- Upload de imagens
- Edição de interpretações

---

## 5. Restrições Não-Funcionais

### 5.1 Performance
- Tempo de carregamento inicial: <3 segundos
- Tempo de resposta da API: <500ms
- Suporte a 1000 usuários simultâneos
- Lazy loading de imagens e componentes

### 5.2 Disponibilidade
- Uptime: 99.5%
- Backup diário automático
- Recovery Point Objective (RPO): 24 horas
- Recovery Time Objective (RTO): 4 horas

### 5.3 Compatibilidade
- Chrome, Firefox, Safari, Edge (2 últimas versões)
- iOS Safari, Chrome Android
- Resolução mínima: 320px (mobile)
- Resolução máxima: 2560px (4K)

### 5.4 Acessibilidade
- WCAG 2.1 nível AA
- Contraste mínimo 4.5:1
- Navegação por teclado
- Labels em todos os campos de formulário
- Mensagens de erro claras

---

## 6. Premissas

1. Administradores terão disponibilidade para moderar conteúdo
2. Conteúdo esotérico será fornecido pelos administradores
3. Plataforma será usada predominantemente em português
4. Usuários possuem conexão estável com a internet
5. Supabase gratuito é suficiente para MVP

---

## 7. Fora do Escopo (v1)

- Sistema de pagamentos/assinatura
- App mobile nativo
- Sistema de tradução automática
- Streaming ao vivo
- Sistema de gamificação
- Integração com redes sociais
- Notificações push
- Chat por áudio/vídeo
- Sistema de cursos
- Marketplace de conteúdo

---

## 8. Referências

- Kindle (experiência de leitura)
- Reddit (estrutura de fórum)
- Discord (sistema de salas)
- Labyrinthos (app de tarô)
- Obsidian (estética minimalista)
