import Link from 'next/link'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { RegisterForm } from '@/components/auth/register-form'

export default function RegisterPage() {
  return (
    <Card>
      <CardHeader className="text-center">
        <CardTitle>Criar conta</CardTitle>
        <CardDescription>
          Junte-se à comunidade de estudos esotéricos
        </CardDescription>
      </CardHeader>
      <CardContent>
        <RegisterForm />
        <p className="mt-4 text-center text-sm text-muted-foreground">
          Já tem uma conta?{' '}
          <Link href="/login" className="text-primary hover:underline">
            Entrar
          </Link>
        </p>
      </CardContent>
    </Card>
  )
}
