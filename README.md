# Ruan Dev API Server - Sistema de Gerenciamento de Licenças iOS

Sistema completo de gerenciamento de licenças para apps iOS com suporte a packages, keys, devices/UDIDs, e integração via dylib injetável.

## 📋 Estrutura do Projeto

```
RuanDevAPIServer/
├── Sources/
│   ├── App/
│   │   └── AppDelegate.swift          # Ponto de entrada do app
│   ├── Models/
│   │   └── KeyModel.swift             # Modelos de dados (Key, Package, Device, UDID)
│   ├── Services/
│   │   └── APIService.swift           # Serviço de comunicação com API
│   └── ViewControllers/
│       ├── LoginViewController.swift   # Tela de login com Key
│       ├── UDIDViewController.swift    # Tela de obtenção de UDID
│       ├── DashboardViewController.swift # Dashboard com estatísticas
│       ├── KeysViewController.swift    # Gerenciamento de Keys
│       ├── DevicesViewController.swift # Gerenciamento de Devices
│       └── ProfileViewController.swift # Perfil do usuário
├── Dylib/
│   └── RuanDevAPIServerDylib.swift    # Dylib para injetar em outros apps
├── Package.swift                      # Configuração do Swift Package
└── README.md                          # Este arquivo
```

## 🚀 Funcionalidades

### App iOS Demo
- ✅ **Login com Key** - Autenticação via chave de licença
- ✅ **Obtenção de UDID** - Captura e cópia do UDID do dispositivo
- ✅ **Dashboard** - Visualização de estatísticas (keys, devices, packages)
- ✅ **Gerenciamento de Keys** - Lista e detalhes de keys ativas
- ✅ **Gerenciamento de Devices** - Visualização de dispositivos registrados
- ✅ **Perfil** - Configurações de usuário, idioma, senha

### Dylib Injetável
A dylib pode ser injetada em qualquer app iOS para:
- 🔐 Controlar acesso via sistema de licenças
- 📱 Obter e validar UDID do dispositivo
- 🔑 Pedir Key do usuário antes de liberar o app
- 📦 Carregar packages disponíveis
- ✅ Validar licenças em tempo real

## 📱 Como Usar

### 1. Compilar o App iOS Demo

```bash
cd RuanDevAPIServer
swift build
```

### 2. Compilar a Dylib

```bash
cd Dylib
# Compile como dylib usando Xcode ou clang
clang -shared -fPIC RuanDevAPIServerDylib.swift -o RuanDevAPIServer.dylib
```

### 3. Injetar Dylib em Outro App

Você pode usar ferramentas como:
- **Theos** - Framework para modificar apps iOS
- **Frida** - Dynamic instrumentation toolkit
- **Logos** - Linguagem para escrever tweaks

Exemplo com Logos:
```logos
%hook AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [RuanDevAPIServer.shared initializeWithApiURL:@"https://seu-api.com" packageToken:@"seu-token"];
    return %orig;
}
%end
```

## 🔧 Configuração da API

### Endpoints Necessários

A dylib espera os seguintes endpoints na sua API:

#### 1. Validar Key
```
POST /auth/validate-key
Body: {
  "key": "string",
  "packageToken": "string",
  "udid": "string",
  "deviceName": "string",
  "osVersion": "string"
}
Response: {
  "isValid": boolean,
  "message": "string"
}
```

#### 2. Carregar Packages
```
GET /packages/{packageToken}
Response: [
  {
    "id": "string",
    "name": "string",
    "token": "string",
    "isActive": boolean
  }
]
```

#### 3. Obter Informações da Key
```
POST /keys/info
Headers: Authorization: Bearer {key}
Response: {
  "keyValue": "string",
  "packageName": "string",
  "expiresAt": "ISO8601",
  "activatedAt": "ISO8601",
  "isActive": boolean
}
```

## 🔑 Formato das Keys

As keys seguem o padrão:
```
{ALIAS}-{DURATION}-{RANDOM}

Exemplo: FFH4X-week-a1b2c3d4e5f6g7h8
```

Onde:
- **ALIAS**: Prefixo customizável (máx. 3 aliases por usuário)
- **DURATION**: `day`, `week`, `month`, `year`
- **RANDOM**: Identificador único aleatório

## 📊 Modelos de Dados

### APIKey
```swift
struct APIKey {
    let id: String
    let keyValue: String
    let alias: String
    let packageId: String
    let packageName: String
    let userId: String
    let duration: String
    let createdAt: Date
    let expiresAt: Date
    let isActive: Bool
    let deviceUDID: String?
    let activatedAt: Date?
}
```

### Package
```swift
struct Package {
    let id: String
    let name: String
    let userId: String
    let token: String
    let createdAt: Date
    let isActive: Bool
    let status: String // "active", "maintenance", "paused", "banned"
    let totalKeys: Int
    let activeKeys: Int
    let totalDevices: Int
    let onlineDevices: Int
}
```

### Device
```swift
struct Device {
    let id: String
    let udid: String
    let packageId: String
    let userId: String
    let keyId: String
    let isOnline: Bool
    let lastSeen: Date
    let registeredAt: Date
    let deviceName: String?
    let osVersion: String?
}
```

## 🎯 Planos VIP

| Plano | Limite de Keys | Limite Diário | Duração |
|-------|---|---|---|
| VIP 1 | 200 | Ilimitado | 1 mês |
| VIP 2 | 500 | Ilimitado | 1 mês |
| VIP 3 | 1000 | Ilimitado | 1 mês |
| VIP 4 | Ilimitado | 10.000 | 1 mês |

## 🔐 Segurança

- ✅ Validação de UDID por dispositivo
- ✅ Expiração automática de keys
- ✅ Suporte a múltiplos packages por usuário
- ✅ Rastreamento de dispositivos online/offline
- ✅ Histórico de ativações

## 📝 Notas Importantes

1. **Dylib em Produção**: A dylib é compilada como arquivo binário. Você precisará de ferramentas de modificação de apps para injetá-la em outros IPAs.

2. **API Server**: Este projeto inclui apenas o cliente iOS. Você precisará implementar o backend (Node.js, Python, etc.) com os endpoints descritos.

3. **Segurança da Dylib**: A dylib deve ser assinada com seu certificado de desenvolvimento para funcionar em dispositivos reais.

4. **Testando Localmente**: Use o app demo para testar toda a funcionalidade antes de injetar a dylib em outros apps.

## 📞 Suporte

Para dúvidas ou problemas:
- Verifique se a API está respondendo corretamente
- Confirme que o packageToken está correto
- Valide o formato das keys
- Teste com o app demo primeiro

## 📄 Copyright

© Todos os direitos reservados Ruan Dev

---

**Versão**: 1.0.0  
**Última atualização**: 2026-03-09
