import Link from 'next/link'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { LoginForm } from '@/components/auth/login-form'

export default function LoginPage() {
  return (
    <Card>
      <CardHeader className="text-center">
        <CardTitle>Bem-vindo de volta</CardTitle>
        <CardDescription>
          Entre na sua conta para acessar a plataforma
        </CardDescription>
      </CardHeader>
      <CardContent>
        <LoginForm />
        <p className="mt-4 text-center text-sm text-muted-foreground">
          Não tem uma conta?{' '}
          <Link href="/register" className="text-primary hover:underline">
            Criar conta
          </Link>
        </p>
      </CardContent>
    </Card>
  )
}
