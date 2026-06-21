import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Clock } from 'lucide-react'

export default function PendingPage() {
  return (
    <Card>
      <CardHeader className="text-center">
        <Clock className="mx-auto h-12 w-12 text-muted-foreground" />
        <CardTitle>Aguardando aprovação</CardTitle>
        <CardDescription>
          Seu cadastro está pendente de aprovação por um administrador.
          Você receberá um email quando for aprovado.
        </CardDescription>
      </CardHeader>
      <CardContent className="text-center">
        <p className="text-sm text-muted-foreground">
          Enquanto isso, você pode acessar sua caixa de entrada.
        </p>
      </CardContent>
    </Card>
  )
}
