-- Script para criar o primeiro admin
-- Execute este script após criar uma conta na plataforma

-- 1. Primeiro, faça cadastro na plataforma via /register
-- 2. Depois, execute este script no SQL Editor do Supabase

-- Substitua 'seu@email.com' pelo email que você usou no cadastro
UPDATE profiles 
SET role = 'admin', status = 'approved' 
WHERE email = 'seu@email.com';

-- Verificar se a atualização funcionou
SELECT id, full_name, email, role, status 
FROM profiles 
WHERE email = 'seu@email.com';
