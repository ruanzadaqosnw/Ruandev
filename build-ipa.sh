#!/bin/bash

# Ruan Dev API Server - Build IPA Script
# Este script compila o projeto iOS e gera um arquivo IPA

set -e

echo "🚀 Iniciando build do IPA..."

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar se Xcode está instalado
if ! command -v xcodebuild &> /dev/null; then
    echo -e "${RED}❌ Xcode não está instalado${NC}"
    exit 1
fi

echo -e "${YELLOW}📦 Xcode encontrado:${NC}"
xcodebuild -version

# Diretórios
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$PROJECT_DIR/build"
IPA_DIR="$BUILD_DIR/ipa"
PAYLOAD_DIR="$IPA_DIR/Payload"

# Limpar builds anteriores
echo -e "${YELLOW}🧹 Limpando builds anteriores...${NC}"
rm -rf "$BUILD_DIR"
mkdir -p "$PAYLOAD_DIR"

# Criar projeto Xcode se não existir
if [ ! -f "$PROJECT_DIR/RuanDevAPIServer.xcodeproj/project.pbxproj" ]; then
    echo -e "${YELLOW}📝 Criando projeto Xcode...${NC}"
    
    # Criar estrutura do projeto
    mkdir -p "$PROJECT_DIR/RuanDevAPIServer"
    
    # Usar swift package para criar o projeto
    cd "$PROJECT_DIR"
    swift package generate-xcodeproj
    
    if [ -f "RuanDevAPIServer.xcodeproj/project.pbxproj" ]; then
        echo -e "${GREEN}✅ Projeto Xcode criado${NC}"
    else
        echo -e "${RED}❌ Erro ao criar projeto Xcode${NC}"
        exit 1
    fi
fi

# Build para iOS
echo -e "${YELLOW}🔨 Compilando para iOS...${NC}"

xcodebuild -scheme RuanDevAPIServer \
    -configuration Release \
    -sdk iphoneos \
    -derivedDataPath "$BUILD_DIR/derived" \
    -arch arm64 \
    build 2>&1 | tail -20

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Erro na compilação${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Compilação concluída${NC}"

# Copiar app para Payload
echo -e "${YELLOW}📦 Criando estrutura do IPA...${NC}"

APP_PATH="$BUILD_DIR/derived/Build/Products/Release-iphoneos/RuanDevAPIServer.app"

if [ ! -d "$APP_PATH" ]; then
    echo -e "${RED}❌ App não encontrado em $APP_PATH${NC}"
    echo "Tentando encontrar o app..."
    find "$BUILD_DIR" -name "*.app" -type d
    exit 1
fi

cp -r "$APP_PATH" "$PAYLOAD_DIR/"
echo -e "${GREEN}✅ App copiado${NC}"

# Criar arquivo Info.plist se necessário
if [ ! -f "$PAYLOAD_DIR/RuanDevAPIServer.app/Info.plist" ]; then
    echo -e "${YELLOW}📝 Criando Info.plist...${NC}"
    cat > "$PAYLOAD_DIR/RuanDevAPIServer.app/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>RuanDevAPIServer</string>
    <key>CFBundleIdentifier</key>
    <string>com.ruandev.apiserverapp</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>Ruan Dev API Server</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSRequiresIPhoneOS</key>
    <true/>
    <key>UIMainStoryboardFile</key>
    <string>Main</string>
    <key>UIRequiredDeviceCapabilities</key>
    <array>
        <string>armv7</string>
    </array>
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
    <key>UISupportedInterfaceOrientations~ipad</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationPortraitUpsideDown</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
</dict>
</plist>
EOF
fi

# Criar o IPA (que é um ZIP com estrutura específica)
echo -e "${YELLOW}📦 Criando arquivo IPA...${NC}"

cd "$IPA_DIR"
zip -r -q "../RuanDevAPIServer.ipa" Payload/
cd "$PROJECT_DIR"

if [ -f "$BUILD_DIR/RuanDevAPIServer.ipa" ]; then
    echo -e "${GREEN}✅ IPA criado com sucesso!${NC}"
    echo -e "${GREEN}📁 Localização: $BUILD_DIR/RuanDevAPIServer.ipa${NC}"
    ls -lh "$BUILD_DIR/RuanDevAPIServer.ipa"
else
    echo -e "${RED}❌ Erro ao criar IPA${NC}"
    exit 1
fi

# Criar arquivo de informações
echo -e "${YELLOW}📝 Criando arquivo de informações...${NC}"

cat > "$BUILD_DIR/BUILD_INFO.txt" << EOF
Ruan Dev API Server - Build Info
==================================

Data: $(date)
Versão: 1.0.0
Plataforma: iOS
Arquitetura: arm64

Arquivo: RuanDevAPIServer.ipa
Tamanho: $(du -h "$BUILD_DIR/RuanDevAPIServer.ipa" | cut -f1)

Instruções de instalação:
1. Conecte seu iPhone ao Mac
2. Abra o Xcode
3. Vá em Window > Devices and Simulators
4. Selecione seu dispositivo
5. Clique em + e selecione o arquivo IPA

Ou use o Finder:
1. Abra o Finder
2. Vá em Applications > Xcode
3. Clique com botão direito > Show Package Contents
4. Navegue até Contents/Developer/Applications/Simulator.app
5. Arraste o IPA para o simulador

EOF

echo -e "${GREEN}✅ Build concluído com sucesso!${NC}"
echo ""
echo -e "${YELLOW}📊 Resumo:${NC}"
echo "  IPA: $BUILD_DIR/RuanDevAPIServer.ipa"
echo "  Tamanho: $(du -h "$BUILD_DIR/RuanDevAPIServer.ipa" | cut -f1)"
echo "  Timestamp: $(date)"
echo ""
echo -e "${GREEN}🎉 Pronto para instalar no iPhone!${NC}"
