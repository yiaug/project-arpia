@echo off
REM Script para executar migrations do Supabase (Windows)
REM Execute este script após configurar o Supabase CLI

echo 🚀 Iniciando configuração do Supabase...

REM Verificar se o Supabase CLI está instalado
where supabase >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Supabase CLI não encontrado. Instale com: npm install -g supabase
    pause
    exit /b 1
)

REM Fazer login
echo 📧 Fazendo login no Supabase...
supabase login

REM Linkar projeto
echo 🔗 Linkando projeto...
supabase link --project-ref nalzglrrjqcglxfwrpyp

REM Executar migrations
echo 📦 Executando migrations...
supabase db push

echo ✅ Configuração concluída!
echo.
echo Próximos passos:
echo 1. Acesse o painel do Supabase
echo 2. Vá em SQL Editor
echo 3. Execute o primeiro login e crie um admin

pause
