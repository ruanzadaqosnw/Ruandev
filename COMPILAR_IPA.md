# 📱 Como Compilar e Gerar o IPA

Este guia explica como compilar o projeto Ruan Dev API Server e gerar um arquivo IPA pronto para instalar em iPhones.

## 🔧 Pré-requisitos

- **Mac com Xcode instalado** (versão 13+)
- **Certificados de desenvolvimento Apple**
- **Provisionamento Profile**
- **iPhone ou Simulador iOS**

## 🚀 Opção 1: Compilar Localmente (Recomendado)

### Passo 1: Preparar o Ambiente

```bash
# Clonar o repositório
git clone https://github.com/ruanzadaqosnw/Ruandev.git
cd Ruandev

# Instalar dependências
cd Backend
npm install
cd ..
```

### Passo 2: Executar o Script de Build

```bash
# Tornar o script executável (se necessário)
chmod +x build-ipa.sh

# Executar o build
./build-ipa.sh
```

O script irá:
1. ✅ Verificar se Xcode está instalado
2. ✅ Criar o projeto Xcode
3. ✅ Compilar para iOS (arm64)
4. ✅ Gerar o arquivo IPA
5. ✅ Criar arquivo de informações

### Passo 3: Encontrar o IPA

O arquivo IPA estará em:
```
build/RuanDevAPIServer.ipa
```

## 🖥️ Opção 2: Compilar via Xcode GUI

### Passo 1: Abrir o Projeto

```bash
# Gerar projeto Xcode
swift package generate-xcodeproj

# Abrir no Xcode
open RuanDevAPIServer.xcodeproj
```

### Passo 2: Configurar Assinatura

1. Selecione o projeto no Xcode
2. Vá em **Signing & Capabilities**
3. Selecione seu **Team** (sua conta Apple)
4. Certifique-se de que o **Bundle Identifier** é único

### Passo 3: Compilar

1. Selecione **Generic iOS Device** ou seu iPhone
2. Vá em **Product** → **Build** (⌘B)
3. Aguarde a compilação terminar

### Passo 4: Gerar o IPA

1. Vá em **Product** → **Archive**
2. Selecione o arquivo no **Organizer**
3. Clique em **Distribute App**
4. Escolha **Ad Hoc** ou **Development**
5. Selecione suas opções de assinatura
6. Clique em **Export** e salve o IPA

## 📦 Opção 3: Compilar via Terminal (Avançado)

```bash
# Gerar projeto Xcode
swift package generate-xcodeproj

# Compilar para iOS
xcodebuild -scheme RuanDevAPIServer \
    -configuration Release \
    -sdk iphoneos \
    -derivedDataPath build \
    -arch arm64 \
    build

# Criar o IPA manualmente
mkdir -p build/ipa/Payload
cp -r build/Build/Products/Release-iphoneos/RuanDevAPIServer.app \
    build/ipa/Payload/
cd build/ipa
zip -r ../RuanDevAPIServer.ipa Payload/
cd ../..
```

## 📱 Instalar o IPA

### Opção A: Via Xcode (Recomendado)

```bash
# Conectar iPhone ao Mac
# Abrir Xcode
# Window → Devices and Simulators
# Selecionar seu iPhone
# Clicar em + e selecionar o IPA
```

### Opção B: Via Apple Configurator

1. Abrir **Apple Configurator 2**
2. Conectar iPhone
3. Arrastar o IPA para o dispositivo

### Opção C: Via Finder (macOS 11+)

1. Abrir **Finder**
2. Conectar iPhone
3. Arrastar o IPA para a seção **Apps** do iPhone

### Opção D: Via iTunes (macOS 10.15 ou anterior)

1. Abrir **iTunes**
2. Conectar iPhone
3. Arrastar o IPA para a biblioteca
4. Sincronizar

## 🔐 Assinatura do IPA

### Assinar com Certificado de Desenvolvimento

```bash
# Listar certificados disponíveis
security find-identity -v -p codesigning

# Assinar o IPA
codesign -s "iPhone Developer" \
    build/ipa/Payload/RuanDevAPIServer.app

# Verificar assinatura
codesign -v build/ipa/Payload/RuanDevAPIServer.app
```

### Assinar com Certificado Enterprise

```bash
codesign -s "iPhone Distribution" \
    build/ipa/Payload/RuanDevAPIServer.app
```

## 🐛 Troubleshooting

### Erro: "Xcode não está instalado"

```bash
# Instalar Xcode Command Line Tools
xcode-select --install

# Ou usar Xcode completo
xcode-select --switch /Applications/Xcode.app/Contents/Developer
```

### Erro: "Certificado não encontrado"

1. Abrir **Xcode**
2. Ir em **Preferences** → **Accounts**
3. Selecionar sua conta Apple
4. Clicar em **Manage Certificates**
5. Criar novo certificado se necessário

### Erro: "Assinatura inválida"

```bash
# Remover assinatura anterior
codesign --remove-signature build/ipa/Payload/RuanDevAPIServer.app

# Assinar novamente
codesign -s "iPhone Developer" \
    build/ipa/Payload/RuanDevAPIServer.app
```

### Erro: "Provisionamento Profile não encontrado"

1. Ir em **developer.apple.com**
2. Criar novo **Provisioning Profile**
3. Fazer download e instalar
4. Tentar compilar novamente

## 📊 Verificar Informações do IPA

```bash
# Listar conteúdo do IPA
unzip -l build/RuanDevAPIServer.ipa

# Extrair e inspecionar
unzip -q build/RuanDevAPIServer.ipa
cat Payload/RuanDevAPIServer.app/Info.plist

# Verificar assinatura
codesign -v Payload/RuanDevAPIServer.app
```

## 🔄 GitHub Actions (Compilação Automática)

O repositório inclui um workflow GitHub Actions que compila automaticamente:

1. **Push para main/master/develop** - Compila automaticamente
2. **Pull Request** - Compila para validação
3. **Manual** - Clique em "Run workflow"

Para baixar o IPA compilado:
1. Ir em **Actions**
2. Selecionar o workflow mais recente
3. Clicar em **Artifacts**
4. Baixar `RuanDevAPIServer.ipa`

## 📝 Notas Importantes

- ✅ O IPA é um arquivo ZIP com estrutura específica
- ✅ Deve ser assinado com certificado válido
- ✅ Requer Provisioning Profile correto
- ✅ Compatível com iOS 14+
- ✅ Arquitetura: arm64 (iPhone 6s+)

## 🎯 Próximos Passos

1. **Compilar o IPA** - Use um dos métodos acima
2. **Testar no iPhone** - Instale e teste a funcionalidade
3. **Injetar Dylib** - Use Theos ou método manual
4. **Distribuir** - Envie para TestFlight ou App Store

## 📞 Suporte

Para problemas:
1. Verifique se Xcode está atualizado
2. Confirme que os certificados são válidos
3. Teste com o simulador primeiro
4. Verifique os logs de compilação

---

**Versão**: 1.0.0  
**Última atualização**: 2026-03-09
