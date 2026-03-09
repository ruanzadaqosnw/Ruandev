# Guia de Injeção de Dylib em Apps iOS

Este guia explica como injetar a dylib `RuanDevAPIServer` em um app iOS existente para adicionar o sistema de licenças.

## 📋 Pré-requisitos

- Xcode instalado
- Conhecimento básico de iOS development
- Certificados de desenvolvimento Apple
- Uma ferramenta de modificação de apps (Theos, Frida, ou similar)

## 🔧 Opção 1: Usando Theos (Recomendado)

### 1.1 Instalar Theos

```bash
git clone https://github.com/theos/theos.git ~/theos
cd ~/theos
./bin/install.sh
```

### 1.2 Criar um Tweak

```bash
$THEOS/bin/nic.pl
# Escolha: iphone/tweak
# Nome do projeto: RuanDevAPIServerTweak
# Pacote: com.ruandev.apiservertw
```

### 1.3 Editar o arquivo Tweak.xm

```logos
#import <UIKit/UIKit.h>

// Importar a dylib
#import "RuanDevAPIServerDylib.h"

%hook AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Inicializar o sistema de licenças
    [RuanDevAPIServer.shared initializeWithApiURL:@"https://seu-api-server.com" 
                                     packageToken:@"seu-package-token"];
    
    // Chamar o método original
    return %orig;
}
%end
```

### 1.4 Compilar e Instalar

```bash
cd RuanDevAPIServerTweak
make
make package
# Instalar no dispositivo via SSH
make install
```

## 🔧 Opção 2: Usando Frida

### 2.1 Instalar Frida

```bash
pip3 install frida-tools
```

### 2.2 Criar Script Frida

Crie um arquivo `inject.js`:

```javascript
// Injetar a dylib no app
var RuanDevAPIServer = ObjC.classes.RuanDevAPIServer;

if (RuanDevAPIServer) {
    var shared = RuanDevAPIServer.$ownMembers().shared;
    var dylib = shared.value();
    
    dylib.$ownMembers().initialize(
        "https://seu-api-server.com",
        "seu-package-token"
    );
    
    console.log("[+] RuanDevAPIServer inicializado!");
} else {
    console.log("[-] RuanDevAPIServer não carregado");
}
```

### 2.3 Executar Injeção

```bash
# Conectar ao dispositivo
frida -U -f com.seu.app -l inject.js
```

## 🔧 Opção 3: Injeção Manual com Xcode

### 3.1 Adicionar a Dylib ao Projeto

1. Abra seu projeto no Xcode
2. Vá para **Build Phases** → **Link Binary With Libraries**
3. Clique em **+** e adicione `RuanDevAPIServer.dylib`

### 3.2 Adicionar Header Search Path

1. Vá para **Build Settings**
2. Procure por **Header Search Paths**
3. Adicione o caminho para os headers da dylib

### 3.3 Modificar AppDelegate

```swift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Inicializar RuanDevAPIServer
        RuanDevAPIServer.shared.initialize(
            apiURL: "https://seu-api-server.com",
            packageToken: "seu-package-token"
        )
        
        // Seu código original aqui
        return true
    }
}
```

## 📱 Testando a Injeção

### 1. Verificar se a Dylib foi Carregada

```bash
# Via SSH no dispositivo
ps aux | grep seu-app-name
otool -L /var/mobile/Containers/Bundle/Application/.../seu-app
```

### 2. Testar Funcionalidades

Após injetar, o app deve:
1. ✅ Mostrar tela de obtenção de UDID
2. ✅ Carregar packages do servidor
3. ✅ Pedir a Key do usuário
4. ✅ Validar a Key
5. ✅ Liberar acesso ao app

### 3. Verificar Logs

```bash
# Ver logs da dylib
log stream --predicate 'eventMessage contains "RuanDev"'
```

## 🔐 Segurança

### Assinatura da Dylib

```bash
# Assinar a dylib com seu certificado
codesign -s "iPhone Developer" RuanDevAPIServer.dylib

# Verificar assinatura
codesign -v RuanDevAPIServer.dylib
```

### Proteção de Código

A dylib deve ser compilada com proteção de código:

```bash
clang -shared -fPIC \
    -fobjc-arc \
    -fvisibility=hidden \
    -fvisibility-inlines-hidden \
    RuanDevAPIServerDylib.swift \
    -o RuanDevAPIServer.dylib
```

## 🐛 Troubleshooting

### Problema: Dylib não carrega

**Solução:**
- Verificar se a dylib está assinada corretamente
- Confirmar que o caminho está correto
- Verificar se há conflitos de símbolos

### Problema: App crasha ao injetar

**Solução:**
- Verificar logs com `log stream`
- Confirmar que a dylib é compatível com a versão do iOS
- Testar com o app demo primeiro

### Problema: Tela de login não aparece

**Solução:**
- Verificar se `initialize()` foi chamado
- Confirmar que a API URL está correta
- Verificar conexão de internet

## 📚 Referências

- [Theos Documentation](https://theos.dev/)
- [Frida Documentation](https://frida.re/)
- [iOS Runtime Headers](https://github.com/nst/iOS-Runtime-Headers)
- [Logos Syntax](https://theos.dev/docs/logos)

## 💡 Dicas

1. **Sempre teste com o app demo primeiro** antes de injetar em apps de terceiros
2. **Use certificados de desenvolvimento válidos** para assinar a dylib
3. **Mantenha backups** dos apps originais antes de injetar
4. **Teste em múltiplos dispositivos** para garantir compatibilidade
5. **Monitore os logs** durante o desenvolvimento

## 📞 Suporte

Para dúvidas sobre injeção:
- Consulte a documentação oficial do Theos
- Verifique os logs do dispositivo
- Teste com apps de exemplo primeiro

---

**Versão**: 1.0.0  
**Última atualização**: 2026-03-09
