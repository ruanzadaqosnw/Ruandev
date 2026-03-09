# 🚀 Guia de Início Rápido - Ruan Dev API Server

## O que você recebeu?

Um sistema completo de gerenciamento de licenças iOS com:

✅ **App iOS Demo** - Para testar toda a funcionalidade  
✅ **Dylib Injetável** - Para adicionar licenças em qualquer app iOS  
✅ **Backend API** - Servidor Node.js para gerenciar packages, keys e devices  
✅ **Documentação Completa** - Guias de uso e injeção  

---

## 📱 Passo 1: Compilar o App iOS Demo

### No Xcode:

```bash
# Abra o projeto
open -a Xcode RuanDevAPIServer/

# Ou compile via terminal
cd RuanDevAPIServer
swift build
```

### Resultado:
Um app iOS funcional com:
- Login com Key
- Obtenção de UDID
- Dashboard com estatísticas
- Gerenciamento de Keys e Devices
- Perfil do usuário

---

## 🖥️ Passo 2: Iniciar o Backend API

### Instalação:

```bash
cd RuanDevAPIServer/Backend
npm install
```

### Execução:

```bash
npm start
# Servidor rodando em http://localhost:3000
```

### Credenciais Padrão:
- **Usuário**: `admin`
- **Senha**: `admin123`

### Endpoints Disponíveis:

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| POST | `/auth/login` | Login com usuário/senha |
| POST | `/auth/login-with-key` | Login com Key |
| POST | `/auth/validate-key` | Validar Key |
| POST | `/packages` | Criar package |
| GET | `/packages` | Listar packages |
| POST | `/keys` | Gerar nova Key |
| GET | `/keys/my-keys` | Listar minhas Keys |
| POST | `/devices/register` | Registrar device |
| GET | `/devices/my-devices` | Listar meus devices |

---

## 🔑 Passo 3: Criar Packages e Keys

### Via API (curl):

```bash
# 1. Fazer login
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'

# Resposta: {"token":"seu-token-aqui", ...}

# 2. Criar package
curl -X POST http://localhost:3000/packages \
  -H "Authorization: Bearer seu-token-aqui" \
  -H "Content-Type: application/json" \
  -d '{"name":"Meu App"}'

# Resposta: {"id":"...", "name":"Meu App", "token":"..."}

# 3. Gerar Key
curl -X POST http://localhost:3000/keys \
  -H "Authorization: Bearer seu-token-aqui" \
  -H "Content-Type: application/json" \
  -d '{"packageId":"...","alias":"FFH4X","duration":"week"}'

# Resposta: {"id":"...", "keyValue":"FFH4X-week-a1b2c3d4", ...}
```

---

## 💉 Passo 4: Injetar Dylib em Outro App

### Opção A: Usando Theos (Recomendado)

```bash
# 1. Instalar Theos
git clone https://github.com/theos/theos.git ~/theos

# 2. Criar tweak
$THEOS/bin/nic.pl
# Escolha: iphone/tweak

# 3. Editar Tweak.xm (veja DYLIB_INJECTION_GUIDE.md)

# 4. Compilar
cd seu-tweak
make
make package
```

### Opção B: Injeção Manual com Xcode

1. Abra seu projeto no Xcode
2. **Build Phases** → **Link Binary With Libraries**
3. Adicione `RuanDevAPIServer.dylib`
4. Modifique `AppDelegate.swift`:

```swift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Inicializar o sistema de licenças
        RuanDevAPIServer.shared.initialize(
            apiURL: "https://seu-servidor.com",
            packageToken: "seu-package-token"
        )
        
        return true
    }
}
```

---

## 🧪 Passo 5: Testar Tudo

### No App Demo:

1. **Tela de Login**
   - Clique em "Obter UDID" para copiar o UDID
   - Cole uma Key válida
   - Cole o Package Token
   - Clique em "Entrar"

2. **Dashboard**
   - Veja estatísticas de Keys, Devices, Packages
   - Clique em "Sair" para fazer logout

3. **Minhas Keys**
   - Veja todas as suas Keys
   - Clique em uma Key para ver detalhes
   - Copie a Key com o botão 📋

4. **Meus Devices**
   - Veja todos os devices registrados
   - Veja status online/offline
   - Clique para ver detalhes

5. **Perfil**
   - Altere idioma (PT/BR ou EN)
   - Mude sua senha
   - Veja dispositivos logados
   - Limpe sessões

---

## 📊 Estrutura de Dados

### Key
```
FFH4X-week-a1b2c3d4
├── FFH4X = Alias (customizável)
├── week = Duração (day, week, month, year)
└── a1b2c3d4 = Identificador único
```

### Package
- Um usuário pode criar até 3 packages
- Cada package tem um token único
- Cada package pode ter múltiplas keys

### Device
- Um device é registrado quando uma Key é ativada
- Rastreia UDID, nome, versão do iOS
- Status online/offline

### Planos VIP
| Plano | Limite de Keys | Limite Diário |
|-------|---|---|
| VIP 1 | 200 | Ilimitado |
| VIP 2 | 500 | Ilimitado |
| VIP 3 | 1000 | Ilimitado |
| VIP 4 | Ilimitado | 10.000 |

---

## 🔧 Configuração da API

### Variáveis de Ambiente

```bash
# Backend
PORT=3000
JWT_SECRET=sua-chave-secreta-aqui

# App iOS (em APIService.swift)
let baseURL = "https://seu-servidor.com"
```

### Endpoints Esperados

A dylib espera estes endpoints:

```
POST /auth/validate-key
POST /packages/{packageToken}
POST /keys/info
```

Veja `Backend/server.js` para implementação completa.

---

## 🐛 Troubleshooting

### Problema: "Key inválida"
- Confirme que a Key foi gerada corretamente
- Verifique se a Key não expirou
- Teste com o app demo primeiro

### Problema: "Package não encontrado"
- Confirme que o Package Token está correto
- Verifique se o package está ativo

### Problema: "Conexão recusada"
- Verifique se o backend está rodando
- Confirme a URL da API
- Teste com `curl http://localhost:3000/health`

### Problema: Dylib não carrega
- Verifique se a dylib está assinada
- Confirme que o caminho está correto
- Veja `DYLIB_INJECTION_GUIDE.md`

---

## 📚 Próximos Passos

1. **Customize o Design**
   - Altere cores, logos, fontes
   - Adicione sua marca

2. **Implemente o Backend**
   - Use o exemplo em `Backend/server.js`
   - Conecte a um banco de dados real
   - Deploy em um servidor

3. **Compile a Dylib**
   - Use Xcode ou clang
   - Assine com seu certificado
   - Teste em dispositivos reais

4. **Injete em Seus Apps**
   - Use Theos ou método manual
   - Teste a funcionalidade
   - Distribua com confiança

---

## 📖 Documentação Completa

- **README.md** - Visão geral e arquitetura
- **DYLIB_INJECTION_GUIDE.md** - Como injetar em apps
- **Backend/server.js** - Implementação da API
- **Sources/** - Código-fonte do app

---

## 💡 Dicas Importantes

✅ **Sempre teste com o app demo primeiro**  
✅ **Mantenha backups dos apps originais**  
✅ **Use certificados válidos para assinar**  
✅ **Monitore os logs durante desenvolvimento**  
✅ **Teste em múltiplos dispositivos**  

---

## 📞 Suporte

Para dúvidas:
1. Consulte a documentação incluída
2. Verifique os logs do app
3. Teste com o app demo
4. Revise a implementação da API

---

**Versão**: 1.0.0  
**Criado**: 2026-03-09  
**Autor**: Ruan Dev  

© Todos os direitos reservados Ruan Dev
