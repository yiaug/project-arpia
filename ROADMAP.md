# 15 — ROADMAP (Planejamento por Fases)

**Projeto:** Arpia  
**Versão:** 1.0  
**Data:** 2026-06-21

---

## 1. Visão Geral

Roadmap de desenvolvimento em 4 fases: MVP, V1, V2, V3. Cada fase adiciona funcionalidades de forma incremental e testável.

---

## 2. MVP (Mínimo Viável) — Semanas 1-8

### 2.1 Objetivo
Plataforma funcional com autenticação, biblioteca básica e administração.

### 2.2 Funcionalidades

| Semana | Entregável | Descrição |
|--------|------------|-----------|
| 1-2 | Setup do projeto | Next.js, Supabase, Tailwind, shadcn/ui |
| 1-2 | Autenticação | Cadastro, login, logout, middleware |
| 1-2 | Database | Todas as tabelas, RLS, triggers |
| 3 | Layout base | Header, sidebar, responsividade |
| 3 | Dashboard | Página inicial com conteúdo recente |
| 4 | Biblioteca | CRUD admin, listagem, detalhe |
| 4 | Storage | Upload de PDFs e imagens |
| 5 | Livro | Visualização de PDF, link externo |
| 5 | Avaliação | Sistema de estrelas (1-5) |
| 6 | Admin | Dashboard, gestão de usuários |
| 6 | Admin | Gestão de livros |
| 7 | Testes | Testes unitários e de integração |
| 7 | Deploy | Configuração Vercel + Supabase |
| 8 | QA | Testes manuais, correção de bugs |

### 2.3 Checklist de Entrega MVP

- [ ] Projeto configurado (Next.js + Supabase + Tailwind)
- [ ] Autenticação completa (cadastro, login, logout, reset senha)
- [ ] Middleware de rotas funcionando
- [ ] Database criado com todas as tabelas
- [ ] RLS policies testadas para cada role
- [ ] Dashboard com conteúdo recente
- [ ] Biblioteca com listagem e busca
- [ ] Página de detalhe do livro
- [ ] Visualização de PDF embutido
- [ ] Sistema de avaliação (1-5 estrelas)
- [ ] Admin: gestão de usuários
- [ ] Admin: CRUD de livros
- [ ] Admin: upload de PDFs e imagens
- [ ] Layout responsivo
- [ ] Deploy em produção
- [ ] Testes unitários (80% cobertura)

### 2.4 Critérios de Sucesso MVP
- 10 usuários aprovados
- 20 livros catalogados
- Funcionalidade core testada
- Deploy estável

---

## 3. V1 — Semanas 9-14

### 3.1 Objetivo
Expandir conteúdo com audiolivros e fórum completo.

### 3.2 Funcionalidades

| Semana | Entregável | Descrição |
|--------|------------|-----------|
| 9 | Audiolivros | CRUD admin, listagem |
| 9 | Player de áudio | React Player integrado |
| 10 | Capítulos | Upload e gerenciamento |
| 10 | Categorias | CRUD de categorias |
| 11 | Fórum | CRUD de tópicos |
| 11 | Fórum | Comentários e respostas |
| 12 | Fórum | Votação |
| 12 | Fórum | Moderação admin |
| 13 | Busca | Busca avançada (livros + fórum) |
| 13 | Tags | CRUD de tags |
| 14 | Testes | Testes E2E com Playwright |
| 14 | QA | Testes de performance |

### 3.3 Checklist de Entrega V1

- [ ] Audiolivros: CRUD completo
- [ ] Player de áudio funcional
- [ ] Sistema de capítulos
- [ ] Categorias funcionando
- [ ] Fórum: criação de tópicos
- [ ] Fórum: comentários e respostas
- [ ] Fórum: sistema de votação
- [ ] Fórum: moderação admin
- [ ] Busca em livros e fórum
- [ ] Tags funcionando
- [ ] Testes E2E (fluxos críticos)
- [ ] Performance otimizada

### 3.4 Critérios de Sucesso V1
- 100 usuários aprovados
- 50 livros catalogados
- 10 audiolivros disponíveis
- 50 tópicos no fórum
- 200 comentários

---

## 4. V2 — Semanas 15-20

### 4.1 Objetivo
Adicionar comunicação em tempo real e recursos interativos.

### 4.2 Funcionalidades

| Semana | Entregável | Descrição |
|--------|------------|-----------|
| 15 | Chat | Salas de texto |
| 15 | Chat | Mensagens em tempo real |
| 16 | Chat | Histórico de mensagens |
| 16 | Chat | Indicador de digitando |
| 17 | Tarô | Baralho completo |
| 17 | Tarô | Sistema de tiragem |
| 18 | Tarô | Histórico de tiragens |
| 18 | Tarô | Significado das cartas |
| 19 | Notificações | Notificações in-app |
| 19 | Perfil | Edição de perfil |
| 20 | Performance | Otimizações finais |
| 20 | QA | Testes de carga |

### 4.3 Checklist de Entrega V2

- [ ] Chat: salas de texto
- [ ] Chat: mensagens em tempo real (Supabase Realtime)
- [ ] Chat: histórico de mensagens
- [ ] Chat: moderação admin
- [ ] Tarô: baralho com 78 cartas
- [ ] Tarô: tiragem de 1, 3 e 5 cartas
- [ ] Tarô: aleatoriedade criptográfica
- [ ] Tarô: histórico de tiragens
- [ ] Notificações in-app (básico)
- [ ] Edição de perfil
- [ ] Performance otimizada
- [ ] Testes de carga

### 4.4 Critérios de Sucesso V2
- 500 usuários aprovados
- 3 chat rooms ativos
- 100 mensagens/dia no chat
- 50 tiragens de tarô/dia
- < 3s tempo de carregamento

---

## 5. V3 — Contínuo (a partir da semana 21)

### 5.1 Objetivo
Expansão, escala e recursos avançados.

### 5.2 Funcionalidades Planejadas

| Recurso | Prioridade | Descrição |
|---------|------------|-----------|
| App Mobile | Alta | React Native ou PWA |
| Gamificação | Média | Conquistas, níveis, ranking |
| Cursos | Média | Sistema de cursos estruturados |
| Marketplace | Baixa | Venda de conteúdo |
| Multi-idioma | Baixa | i18n completo |
| MFA | Média | Auticação em dois fatores |
| Search Engine | Alta | Meilisearch ou similar |
| Analytics | Média | Dashboard de analytics |
| API Pública | Baixa | API para integrações |
| White Label | Baixa | Personalização por marca |

### 5.3 Prioridades V3

**Alta Prioridade:**
1. App Mobile (PWA ou React Native)
2. Search Engine dedicado
3. Performance e escala

**Média Prioridade:**
4. Gamificação
5. Cursos
6. MFA
7. Analytics

**Baixa Prioridade:**
8. Multi-idioma
9. API Pública
10. White Label
11. Marketplace

---

## 6. Timeline Visual

```
Semana:  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21+
         ├──┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──┼──→
Fase:    │  MVP                    │  V1                    │  V2         │  V3
         │                        │                        │             │  Contínuo
         ├────────────────────────┼────────────────────────┼─────────────┤
         │ • Setup                │ • Audiolivros          │ • Chat      │ • Mobile
         │ • Auth                 │ • Player de áudio      │ • Tarô      │ • Gamificação
         │ • Database             │ • Fórum                │ • Notificações│ • Cursos
         │ • Layout               │ • Categorias           │ • Perfil    │ • Search
         │ • Dashboard            │ • Busca                │ • Performance│ • MFA
         │ • Biblioteca           │ • Tags                 │ • QA        │ • Analytics
         │ • Avaliação            │ • Testes E2E           │             │
         │ • Admin                │                        │             │
         │ • Deploy               │                        │             │
         └────────────────────────┴────────────────────────┴─────────────┘
```

---

## 7. Marcos Importantes

### 7.1 Marcos do MVP
- **Semana 2:** Autenticação funcional
- **Semana 4:** Biblioteca funcional
- **Semana 6:** Admin funcional
- **Semana 8:** Deploy em produção

### 7.2 Marcos da V1
- **Semana 10:** Audiolivros disponíveis
- **Semana 12:** Fórum completo
- **Semana 14:** Busca avançada

### 7.3 Marcos da V2
- **Semana 16:** Chat em tempo real
- **Semana 18:** Tarô completo
- **Semana 20:** Otimizações finais

---

## 8. Recursos Necessários

### 8.1 Desenvolvimento
- 1 desenvolvedor full-stack (tempo integral)
- Ou 2 desenvolvedores (meio período)

### 8.2 Infraestrutura
- Supabase: gratuito → $25/mês (quando necessário)
- Vercel: gratuito → $20/mês (quando necessário)
- Domínio: ~$10/ano

### 8.3 Conteúdo
- Livros para catalogar (fornecidos pelo admin)
- Audiolivros para catalogar
- Cartas de tarô (78 cartas)
- Categorias predefinidas

---

## 9. Dependências Externas

### 9.1 Supabase
- Auth
- Database
- Storage
- Realtime

### 9.2 Vercel
- Hosting
- Serverless Functions
- CDN

### 9.3 GitHub
- Versionamento
- CI/CD

### 9.4 Bibliotecas
- Next.js
- React
- Tailwind CSS
- shadcn/ui
- React Player
- React Markdown

---

## 10. Riscos por Fase

### 10.1 MVP
- Configuração inicial pode demorar
- RLS policies podem ser complexas
- Upload de PDFs pode ter problemas

### 10.2 V1
- Fórum pode ter problemas de performance
- Busca pode ser lenta sem indexação adequada

### 10.3 V2
- Chat em tempo real pode ser instável
- Tarô pode ter problemas de aleatoriedade

### 10.4 V3
- Escalabilidade pode ser um desafio
- Custos podem crescer rapidamente

---

## 11. Critérios de Saída por Fase

### 11.1 Saída do MVP
- [ ] Todos os entregáveis do MVP concluídos
- [ ] Testes unitários com 80% de cobertura
- [ ] Deploy estável em produção
- [ ] 10 usuários aprovados e ativos
- [ ] Feedback positivo dos primeiros usuários

### 11.2 Saída da V1
- [ ] Todos os entregáveis da V1 concluídos
- [ ] Testes E2E passando
- [ ] 100 usuários ativos
- [ ] 50 livros e 10 audiolivros catalogados
- [ ] Fórum com atividade mínima

### 11.3 Saída da V2
- [ ] Todos os entregáveis da V2 concluídos
- [ ] Chat funcionando em tempo real
- [ ] Tarô com 78 cartas
- [ ] 500 usuários ativos
- [ ] Performance aceitável (< 3s)

---

## 12. Próximos Passos Imediatos

### 12.1 Antes de Começar
1. Criar repositório no GitHub
2. Configurar Supabase
3. Configurar Vercel
4. Definir branches (main, develop)
5. Configurar ESLint + Prettier

### 12.2 Primeira Semana
1. Setup do Next.js com App Router
2. Instalação de dependências
3. Configuração de Tailwind
4. Configuração do Supabase
5. Criação do banco de dados
6. Primeira migration

### 12.3 Segunda Semana
1. Autenticação completa
2. Middleware de rotas
3. Layout base
4. Primeiros componentes

---

## 13. Métricas de Sucesso

### 13.1 MVP
- 10 usuários aprovados
- 20 livros catalogados
- 0 bugs críticos
- Deploy estável

### 13.2 V1
- 100 usuários ativos
- 50 livros, 10 audiolivros
- 50 tópicos no fórum
- < 5s tempo de carregamento

### 13.3 V2
- 500 usuários ativos
- 3 salas de chat ativas
- 50 tiragens de tarô/dia
- < 3s tempo de carregamento

### 13.4 V3
- 2000 usuários ativos
- 300 livros
- App mobile disponível
- Receita (se marketplace)
