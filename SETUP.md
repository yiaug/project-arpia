# Guia de Configuração - Project Arpia

## 1. Configurar Supabase

### Passo 1: Criar projeto no Supabase
1. Acesse [supabase.com](https://supabase.com)
2. Clique em "Start your project"
3. Faça login com GitHub
4. Clique em "New project"
5. Preencha:
   - **Organization**: Selecione ou crie uma
   - **Project name**: `arpia`
   - **Database Password**: Gere uma senha segura
   - **Region**: Escolha a mais próxima (ex: South America)
6. Clique em "Create new project"
7. Aguarde a criação (pode levar alguns minutos)

### Passo 2: Obter credenciais
1. No painel do projeto, vá em **Settings** → **API**
2. Copie os valores:
   - **Project URL**: `https://xxxxx.supabase.co`
   - **anon public key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`

### Passo 3: Configurar variáveis de ambiente
1. Crie o arquivo `.env.local` na raiz do projeto:
```env
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

### Passo 4: Executar migrations
1. No painel do Supabase, vá em **SQL Editor**
2. Copie e execute cada migration na ordem:
   - `001_create_tables.sql`
   - `002_create_rls_policies.sql`
   - `003_create_triggers.sql`

### Passo 5: Criar primeiro admin
Após executar as migrations, crie o primeiro admin:
1. Faça cadastro normalmente na plataforma
2. No SQL Editor, execute:
```sql
UPDATE profiles 
SET role = 'admin', status = 'approved' 
WHERE email = 'seu@email.com';
```

---

## 2. Criar Repositório GitHub

### Passo 1: Inicializar Git
```bash
cd "C:\Users\Administrador\opencode projects\project arpia"
git init
git add .
git commit -m "feat: initial project setup"
```

### Passo 2: Criar repositório no GitHub
1. Acesse [github.com](https://github.com)
2. Clique em "+" → "New repository"
3. Preencha:
   - **Repository name**: `project-arpia`
   - **Description**: Plataforma de estudos esotéricos
   - **Visibility**: Private (recomendado)
4. NÃO marque "Add a README file" (já temos)
5. Clique em "Create repository"

### Passo 3: Conectar repositório local
```bash
git remote add origin https://github.com/SEU-USER/project-arpia.git
git branch -M main
git push -u origin main
```

---

## 3. Configurar Vercel

### Passo 1: Criar conta no Vercel
1. Acesse [vercel.com](https://vercel.com)
2. Clique em "Sign Up"
3. Faça login com GitHub

### Passo 2: Importar projeto
1. No dashboard, clique em "Add New..." → "Project"
2. Selecione o repositório `project-arpia`
3. Configure:
   - **Framework Preset**: Next.js
   - **Root Directory**: ./
   - **Build Command**: `npm run build`
   - **Output Directory**: `.next`

### Passo 3: Configurar variáveis de ambiente
Na tela de configuração, adicione:
- `NEXT_PUBLIC_SUPABASE_URL`: URL do Supabase
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`: Chave anônima do Supabase

### Passo 4: Deploy
1. Clique em "Deploy"
2. Aguarde o build (geralmente 1-2 minutos)
3. Ao final, clique no link gerado para acessar

### Passo 5: Configurar domínio (opcional)
1. No projeto na Vercel, vá em **Settings** → **Domains**
2. Adicione seu domínio personalizado
3. Configure os records DNS conforme instruções

---

## 4. Verificar Configuração

### Checklist
- [ ] Supabase project criado
- [ ] Variáveis de ambiente configuradas
- [ ] Migrations executadas
- [ ] Primeiro admin criado
- [ ] Repositório GitHub criado e push feito
- [ ] Vercel configurado e deploy feito
- [ ] Site acessível via URL da Vercel
- [ ] Login funcionando
- [ ] Cadastro funcionando
- [ ] Aprovação de usuários funcionando

---

## 5. Comandos Úteis

### Desenvolvimento local
```bash
npm run dev
```

### Build
```bash
npm run build
```

### Lint
```bash
npm run lint
```

### Deploy (manual)
```bash
git push origin main
```

---

## 6. Solução de Problemas

### Erro: "Supabase URL and API key are required"
- Verifique se o arquivo `.env.local` existe e está preenchido

### Erro: "Invalid login credentials"
- Verifique se o email e senha estão corretos
- Verifique se o usuário foi aprovado no painel admin

### Erro: Build falha no Vercel
- Verifique as variáveis de ambiente no painel da Vercel
- Verifique os logs do build para identificar o erro

### Erro: RLS blocking queries
- Verifique se as policies foram criadas corretamente
- Verifique se o usuário tem o role correto
