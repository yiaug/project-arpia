# 13 — SECURITY (Análise de Segurança)

**Projeto:** Arpia  
**Versão:** 1.0  
**Data:** 2026-06-21

---

## 1. Visão Geral

Análise de segurança baseada no framework STRIDE (Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege).

---

## 2. Ameaças e Mitigações

### 2.1 Spoofing (Falsificação de Identidade)

| Ameaça | Probabilidade | Impacto | Mitigação |
|--------|---------------|---------|-----------|
| Usuário finge ser outro | Média | Alto | JWT tokens, RLS policies |
| Admin fake | Baixa | Crítico | Verificação de role no backend |
| Token roubado | Média | Alto | Tokens de curta duração, refresh tokens |

**Mitigações Implementadas:**
- Supabase Auth com JWT
- RLS policies verificando `auth.uid()`
- Access tokens expiram em 1 hora
- Refresh tokens expiram em 7 dias
- Cookies httpOnly (não acessíveis via JS)

### 2.2 Tampering (Alteração Não Autorizada)

| Ameaça | Probabilidade | Impacto | Mitigação |
|--------|---------------|---------|-----------|
| Alterar dados de outros usuários | Média | Alto | RLS policies |
| Alterar conteúdo de outros | Média | Médio | Permissões de edição |
| Manipular avaliações | Baixa | Médio | Uma avaliação por usuário |
| Alterar resultados de tarô | Baixa | Baixo | Servidor-side random |

**Mitigações Implementadas:**
- RLS em todas as tabelas
- Validação de propriedade (author_id = auth.uid())
- CHECK constraints no banco
- Validação de input via Zod

### 2.3 Repudiation (Negação de Ações)

| Ameaça | Probabilidade | Impacto | Mitigação |
|--------|---------------|---------|-----------|
| Usuário nega ter postado conteúdo | Média | Médio | Logs de auditoria |
| Admin nega ter aprovado usuário | Baixa | Médio | Logs de auditoria |

**Mitigações Implementadas:**
- Timestamps em todas as tabelas (`created_at`, `updated_at`)
- Campo `author_id` em conteúdo
- Trigger de atualização de `updated_at`
- Futuro: tabela de audit_logs

### 2.4 Information Disclosure (Vazamento de Informações)

| Ameaça | Probabilidade | Impacto | Mitigação |
|--------|---------------|---------|-----------|
| Dados de outros usuários expostos | Média | Alto | RLS policies |
| PDFs acessíveis sem autenticação | Baixa | Alto | Storage policies |
| Senhas expostas | Baixa | Crítico | bcrypt, httpOnly cookies |
| Tokens expostos | Média | Alto | httpOnly, short-lived |

**Mitigações Implementadas:**
- RLS em todas as tabelas
- Storage policies por bucket
- Senhas armazenadas com bcrypt
- Tokens em cookies httpOnly
- Nunca logs de senhas ou tokens

### 2.5 Denial of Service (Negação de Serviço)

| Ameaça | Probabilidade | Impacto | Mitigação |
|--------|---------------|---------|-----------|
| Ataque DDoS | Média | Alto | Vercel CDN, rate limiting |
| Muitos uploads simultâneos | Baixa | Médio | Limites de tamanho |
| Muitas requisições ao DB | Baixa | Médio | Connection pooling |

**Mitigações Implementadas:**
- Vercel Edge Network (DDoS protection)
- Rate limiting via Supabase
- Limites de upload por arquivo
- Paginação em todas as listagens
- Lazy loading

### 2.6 Elevation of Privilege (Elevação de Privilégios)

| Ameaça | Probabilidade | Impacto | Mitigação |
|--------|---------------|---------|-----------|
| Usuário comum virar admin | Baixa | Crítico | Verificação de role server-side |
| Acessar rotas admin sem permissão | Média | Alto | Middleware + RLS |
| Bypass de RLS | Baixa | Crítico | Supabase RLS nativo |

**Mitigações Implementadas:**
- RLS policies verificando role
- Middleware Next.js verificando role
- Não há auto-promoção de roles
- Admin só promovido manualmente via SQL

---

## 3. Controles de Acesso

### 3.1 Autenticação
- Email/senha via Supabase Auth
- JWT tokens com expiração
- Refresh tokens para manter sessão
- Logout com invalidação de tokens

### 3.2 Autorização
- RBAC (Role-Based Access Control)
- 3 roles: pending, approved, admin
- RLS policies em todas as tabelas
- Middleware verificando role

### 3.3 Princípio do Menor Privilégio
- Usuários comuns: apenas leitura e participação
- Admin: controle total
- Pendentes: sem acesso ao conteúdo

---

## 4. Proteção de Dados

### 4.1 Dados Pessoais
- Nome completo
- Email
- Bio (opcional)
- Dados de perfil

### 4.2 Proteção
- Armazenamento seguro (Supabase)
- Acesso restrito via RLS
- Não compartilhamento com terceiros
- LGPD compliance (futuro)

### 4.3 Direitos do Usuário
- Acesso aos dados pessoais
- Correção de dados
- Exclusão de conta
- Portabilidade de dados

---

## 5. Segurança de Transporte

### 5.1 HTTPS
- Todas as comunicações via HTTPS
- TLS 1.2+ obrigatório
- Certificados gerenciados por Vercel/Supabase

### 5.2 Headers de Segurança
```typescript
// next.config.js
const securityHeaders = [
  { key: 'X-Frame-Options', value: 'DENY' },
  { key: 'X-Content-Type-Options', value: 'nosniff' },
  { key: 'X-XSS-Protection', value: '1; mode=block' },
  { key: 'Referrer-Policy', value: 'strict-origin-when-cross-origin' },
]
```

---

## 6. Segurança de Storage

### 6.1 Políticas de Acesso
- Leitura: apenas autenticados com role adequada
- Upload: apenas admin
- Exclusão: apenas admin

### 6.2 Validação de Arquivos
- Tipos permitidos por bucket
- Tamanhos máximos configuráveis
- Scan de malware (futuro)

### 6.3 Nomes de Arquivos
- UUIDs para evitar conflitos
- Sem caracteres especiais
- Estrutura de pastas organizada

---

## 7. Segurança de Chat

### 7.1 Mensagens
- Armazenamento persistente
- Autor verificável (author_id)
- Edição controlada (apenas autor)
- Exclusão apenas por admin

### 7.2 Tempo Real
- Conexões autenticadas
- Broadcast apenas para sala correta
- Sem expor dados de outros usuários

---

## 8. Segurança de Tarô

### 8.1 Aleatoriedade
- Cripto random para sorteios
- Sem manipulação de resultados
- Histórico de tiragens registrado

### 8.2 Limites
- Máximo 10 tiragens por usuário por dia
- Previne abuso do sistema

---

## 9. Monitoramento e Resposta a Incidentes

### 9.1 Logs
- Logs de autenticação (login, logout, falhas)
- Logs de operações CRUD
- Logs de erros

### 9.2 Alertas
- Múltiplas falhas de login
- Uploads anômalos
- Acesso não autorizado

### 9.3 Plano de Resposta
1. Identificar o incidente
2. Conter o dano
3. Eradicar a causa raiz
4. Recuperar sistemas
5. Documentar lições aprendidas

---

## 10. Compliance

### 10.1 LGPD (Brasil)
- Consentimento de dados
- Direito de exclusão
- Portabilidade
- Responsável pelos dados

### 10.2 GDPR (futuro)
- Se expansão para Europa
- DPO necessário
- Privacy by design

---

## 11. Checklist de Segurança

### 11.1 Pré-deploy
- [ ] RLS habilitado em todas as tabelas
- [ ] Policies testadas para cada role
- [ ] Storage policies configuradas
- [ ] Headers de segurança configurados
- [ ] Rate limiting habilitado
- [ ] Validação de input implementada
- [ ] Senhas com bcrypt
- [ ] Tokens em httpOnly cookies

### 11.2 Em Produção
- [ ] Monitoramento ativo
- [ ] Logs revisados periodicamente
- [ ] Backups verificados
- [ ] Atualizações de segurança aplicadas
- [ ] Pen testing periódico (futuro)

---

## 12. Vulnerabilidades Conhecidas

### 12.1 Supabase
- Dependência de terceiros
- Controle limitado sobre infraestrutura
- Mitigação: monitoramento, backups, plano de migração

### 12.2 Next.js
- Vulnerabilidades em dependências
- Mitigação: atualizações regulares, audit de dependências

### 12.3 Dependências
- Pacotes npm com vulnerabilidades
- Mitigação: npm audit, dependabot, renovação regular

---

## 13. Recomendações Futuras

1. **Penetration Testing:** Contratar teste de segurança periodicamente
2. **WAF:** Web Application Firewall via Cloudflare
3. **SIEM:** Security Information and Event Management
4. **MFA:** Multi-Factor Authentication (futuro)
5. **Audit Logging:** Tabela dedicada para auditoria
6. **Rate Limiting Avançado:** Por endpoint, não apenas global
