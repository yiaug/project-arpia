#!/bin/bash

# Script para executar migrations do Supabase
# Execute este script após configurar o Supabase CLI

echo "🚀 Iniciando configuração do Supabase..."

# Verificar se o Supabase CLI está instalado
if ! command -v supabase &> /dev/null; then
    echo "❌ Supabase CLI não encontrado. Instale com: npm install -g supabase"
    exit 1
fi

# Fazer login
echo "📧 Fazendo login no Supabase..."
supabase login

# Linkar projeto
echo "🔗 Linkando projeto..."
supabase link --project-ref nalzglrrjqcglxfwrpyp

# Executar migrations
echo "📦 Executando migrations..."
supabase db push

echo "✅ Configuração concluída!"
echo ""
echo "Próximos passos:"
echo "1. Acesse o painel do Supabase"
echo "2. Vá em SQL Editor"
echo "3. Execute o primeiro login e crie um admin"
