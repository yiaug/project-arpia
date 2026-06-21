# 14 — RISKS (Lista de Riscos Técnicos)

**Projeto:** Arpia  
**Versão:** 1.0  
**Data:** 2026-06-21

---

## 1. Matriz de Riscos

### 1.1 Legenda

| Probabilidade | Impacto |
|---------------|---------|
| Baixa | Baixo |
| Média | Médio |
| Alta | Alto |
| | Crítico |

### 1.2 Riscos Identificados

| ID | Risco | Probabilidade | Impacto | Prioridade |
|----|-------|---------------|---------|------------|
| R1 | Custo do Supabase Storage | Média | Alto | Alta |
| R2 | Performance do chat | Média | Médio | Média |
| R3 | Moderacão de conteúdo | Alta | Alto | Crítica |
| R4 | Backup inadequado | Baixa | Crítico | Alta |
| R5 | Vendor lock-in (Supabase) | Baixa | Médio | Média |
| R6 | Performance com muitos livros | Média | Médio | Média |
| R7 | Segurança de autenticação | Baixa | Crítico | Alta |
| R8 | Escalabilidade do banco | Média | Alto | Alta |
| R9 | Custo da Vercel | Baixa | Médio | Baixa |
| R10 | Dependência de terceiros | Média | Médio | Média |
| R11 | Manutenção futura | Média | Médio | Média |
| R12 | Experiência do usuário | Média | Médio | Média |

---

## 2. Análise Detalhada

### R1: Custo do Supabase Storage

**Descrição:** PDFs e MP3s podem consumir rapidamente o limite de 1GB do plano gratuito.

**Probabilidade:** Média  
**Impacto:** Alto

**Causas:**
- PDFs de livros podem ter 10-50MB cada
- MP3s de audiolivros podem ter 50-100MB cada
- 50 livros × 30MB = 1.5GB (já ultrapassa limite)

**Mitigação:**
- Compressão de PDFs antes de upload
- Limite rigoroso de tamanho (50MB PDF, 100MB MP3)
- Upgrade para plano pago ($25/mês) se necessário
- Considerar alternativas (Google Drive para PDFs)

**Plano de Contingência:**
- Migrar PDFs para Google Drive (links externos)
- Comprimir MP3s para bitrate menor
- Upgrade de plano

**Custo Estimado:**
- Plano gratuito: $0/mês (1GB storage)
- Plano pago: $25/mês (100GB storage)

---

### R2: Performance do Chat

**Descrição:** Muitos usuários simultâneos no chat podem causar lentidão.

**Probabilidade:** Média  
**Impacto:** Médio

**Causas:**
- Supabase Realtime tem limite de conexões
- Mensagens em tempo real consomem recursos
- Muitas salas ativas

**Mitigação:**
- Limitar a 10 salas ativas
- Paginação de mensagens (últimas 500)
- Lazy loading de histórico
- Monitoramento de conexões

**Plano de Contingência:**
- Migrar para WebSocket customizado
- Implementar caching de mensagens
- Limitar usuários por sala

---

### R3: Moderacão de Conteúdo

**Descrição:** Conteúdo inadequado no fórum ou chat sem moderação eficiente.

**Probabilidade:** Alta  
**Impacto:** Alto

**Causas:**
- Fórum aberto para todos os aprovados
- Chat em tempo real dificulta moderação
- Poucos administradores

**Mitigação:**
- Filtro de palavras (básico)
- Sistema de denúncia (futuro)
- Moderação ativa por admins
- Termos de uso claros

**Plano de Contingência:**
- Desativar fórum temporariamente
- Limitar permissões de usuários
- Contratar moderadores

---

### R4: Backup Inadequado

**Descrição:** Perda de dados por falta de backup adequado.

**Probabilidade:** Baixa  
**Impacto:** Crítico

**Causas:**
- Supabase gratuito tem backup diário mas sem garantia
- Storage não tem backup automático
- Código no GitHub (seguro)

**Mitigação:**
- Backup manual semanal do banco
- Exportação de dados periodicamente
- Versionamento de código no GitHub
- Documentação de configurações

**Plano de Contingência:**
- Restaurar de backup do Supabase
- Re-upload de arquivos perdidos
- Reconstruir dados a partir de logs

---

### R5: Vendor Lock-in (Supabase)

**Descrição:** Dependência excessiva do Supabase dificulta migração futura.

**Probabilidade:** Baixa  
**Impacto:** Médio

**Causas:**
- Supabase Auth é proprietário
- RLS policies específicas do Supabase
- Storage API específica

**Mitigação:**
- Abstração via interfaces
- Documentação de todas as operações
- Testes de integração
- Plano de migração documentado

**Plano de Contingência:**
- Migrar para Firebase/Custom Backend
- Reescrever auth e RLS
- Estimativa: 2-4 semanas de trabalho

---

### R6: Performance com Muitos Livros

**Descrição:** Lentidão na listagem de livros com muitos registros.

**Probabilidade:** Média  
**Impacto:** Médio

**Causas:**
- Muitos livros sem paginação adequada
- Queries lentas sem índices
- Imagens sem otimização

**Mitigação:**
- Paginação em todas as listagens
- Índices em colunas frequentes
- Otimização de imagens (Next/Image)
- Lazy loading

**Plano de Contingência:**
- Adicionar cache de queries
- Implementar search engine (Meilisearch)
- Otimizar queries lentas

---

### R7: Segurança de Autenticação

**Descrição:** Vulnerabilidades no sistema de autenticação.

**Probabilidade:** Baixa  
**Impacto:** Crítico

**Causas:**
- Tokens mal configurados
- Senhas fracas
- CSRF/SSRF

**Mitigação:**
- Supabase Auth (testado e seguro)
- Tokens em httpOnly cookies
- Validação de input via Zod
- Rate limiting

**Plano de Contingência:**
- Forçar reset de senhas
- Invalidar todas as sessões
- Investigar e corrigir vulnerabilidade

---

### R8: Escalabilidade do Banco

**Descrição:** Banco de dados não escala para muitos usuários.

**Probabilidade:** Média  
**Impacto:** Alto

**Causas:**
- Muitas queries simultâneas
- Tabelas crescendo rápido
- Índices faltando

**Mitigação:**
- Connection pooling (PgBouncer)
- Índices adequados
- Paginação
- Cache de queries

**Plano de Contingência:**
- Upgrade de plano Supabase
- Migrar para banco dedicado
- Implementar read replicas

---

### R9: Custo da Vercel

**Descrição:** Custos da Vercel crescem com tráfego.

**Probabilidade:** Baixa  
**Impacto:** Médio

**Causas:**
- Bandwidth do plano gratuito (100GB)
- Builds excedem limite
- Serverless functions excedem limite

**Mitigação:**
- Otimizar bundle size
- Cache agressivo
- ISR para páginas estáticas

**Plano de Contingência:**
- Upgrade de plano Vercel
- Migrar para outro hosting
- Otimizar uso de recursos

---

### R10: Dependência de Terceiros

**Descrição:** Falha em serviços de terceiros afeta o sistema.

**Probabilidade:** Média  
**Impacto:** Médio

**Serviços críticos:**
- Supabase (Auth, DB, Storage)
- Vercel (Hosting)
- GitHub (Versionamento)

**Mitigação:**
- Monitore status pages
- Fallbacks onde possível
- Documentação de dependências

**Plano de Contingência:**
- Supabase down: usar cache local
- Vercel down: aguardar恢复
- GitHub down: trabalhar localmente

---

### R11: Manutenção Futura

**Descrição:** Dificuldade para manter e atualizar o sistema.

**Probabilidade:** Média  
**Impacto:** Médio

**Causas:**
- Código sem testes
- Documentação desatualizada
- Dependências desatualizadas

**Mitigação:**
- Testes automatizados
- Documentação completa
- Atualizações regulares
- Code review

**Plano de Contingência:**
- Refatoração gradual
- Contratação de desenvolvedores
- Migração para framework mais simples

---

### R12: Experiência do Usuário

**Descrição:** UX ruim afeta retenção de usuários.

**Probabilidade:** Média  
**Impacto:** Médio

**Causas:**
- Interface confusa
- Lentidão
- Bugs frequentes

**Mitigação:**
- Design system definido
- Testes de usabilidade
- Feedback de usuários
- Iteração contínua

**Plano de Contingência:**
- Redesign de componentes críticos
- Pesquisa de satisfação
- Priorização de melhorias

---

## 3. Riscos por Fase

### 3.1 MVP (Semanas 1-8)
| Risco | Prioridade |
|-------|------------|
| R1 (Storage) | Alta |
| R4 (Backup) | Alta |
| R7 (Auth) | Alta |

### 3.2 V1 (Semanas 9-14)
| Risco | Prioridade |
|-------|------------|
| R3 (Moderação) | Crítica |
| R6 (Performance) | Média |
| R8 (Escalabilidade) | Alta |

### 3.3 V2 (Semanas 15-20)
| Risco | Prioridade |
|-------|------------|
| R2 (Chat) | Média |
| R10 (Terceiros) | Média |

### 3.4 V3 (Contínuo)
| Risco | Prioridade |
|-------|------------|
| R5 (Vendor Lock-in) | Média |
| R9 (Custo Vercel) | Baixa |
| R11 (Manutenção) | Média |
| R12 (UX) | Média |

---

## 4. Matriz de Mitigação

| Risco | Mitigação Principal | Custo | Prazo |
|-------|---------------------|-------|-------|
| R1 | Upgrade Supabase | $25/mês | Imediato |
| R2 | Limitar salas | $0 | 1 dia |
| R3 | Filtro + moderação | $0 | 1 semana |
| R4 | Backup manual | $0 | 1 hora/semana |
| R5 | Abstração de código | $0 | Contínuo |
| R6 | Índices + paginação | $0 | 2 dias |
| R7 | Supabase Auth nativo | $0 | Imediato |
| R8 | Connection pooling | $0 | 1 dia |
| R9 | Otimização | $0 | Contínuo |
| R10 | Monitoramento | $0 | 1 dia |
| R11 | Testes + docs | $0 | Contínuo |
| R12 | Design system | $0 | 1 semana |

---

## 5. Recomendações

### 5.1 Prioridades Imediatas
1. Configurar backup manual do banco
2. Implementar paginação em todas as listagens
3. Testar RLS policies exaustivamente
4. Definir limites de upload rigorosos

### 5.2 Curto Prazo (1-3 meses)
1. Monitorar custos do Supabase
2. Implementar filtro de palavras básico
3. Otimizar queries lentas
4. Documentar processos de deploy

### 5.3 Médio Prazo (3-6 meses)
1. Avaliar necessidade de upgrade de plano
2. Implementar sistema de denúncia
3. Adicionar cache de queries
4. Realizar testes de segurança

### 5.4 Longo Prazo (6+ meses)
1. Avaliar migração de backend se necessário
2. Implementar search engine dedicado
3. Adicionar MFA
4. Contratar pent testing
