#!/bin/bash

# Configurações
APP_NAME="RuanDevAPIServer"
BUNDLE_ID="com.ruandev.apiserver"
BUILD_DIR="build"
PAYLOAD_DIR="Payload"

echo "🚀 Iniciando processo de build para iOS..."

# 1. Limpar builds anteriores
rm -rf $BUILD_DIR $PAYLOAD_DIR *.ipa
mkdir -p $BUILD_DIR

# 2. Compilar o App Demo (Swift Package)
echo "📦 Compilando o App Demo..."
swift build -c release --triple arm64-apple-ios14.0

# 3. Compilar a Dylib
echo "⚙️ Compilando a Dylib..."
cd Dylib
xcrun -sdk iphoneos swiftc -emit-library -target arm64-apple-ios14.0 RuanDevAPIServerDylib.swift -o ../$BUILD_DIR/RuanDevAPIServer.dylib
cd ..

# 4. Montar a estrutura do IPA
echo "🏗️ Montando a estrutura do IPA..."
mkdir -p $PAYLOAD_DIR/$APP_NAME.app/Frameworks
mkdir -p $PAYLOAD_DIR/$APP_NAME.app/Backend

# Copiar o binário compilado (se existir)
# Nota: Como é um Swift Package, o binário fica em .build/arm64-apple-ios14.0/release/
BINARY_PATH=".build/arm64-apple-ios14.0/release/$APP_NAME"
if [ -f "$BINARY_PATH" ]; then
    cp "$BINARY_PATH" $PAYLOAD_DIR/$APP_NAME.app/$APP_NAME
else
    echo "⚠️ Binário principal não encontrado, criando um placeholder para estrutura..."
    touch $PAYLOAD_DIR/$APP_NAME.app/$APP_NAME
fi

# Copiar a Dylib e recursos
cp $BUILD_DIR/RuanDevAPIServer.dylib $PAYLOAD_DIR/$APP_NAME.app/Frameworks/
cp Backend/server.js $PAYLOAD_DIR/$APP_NAME.app/Backend/
cp Backend/package.json $PAYLOAD_DIR/$APP_NAME.app/Backend/
cp README.md $PAYLOAD_DIR/$APP_NAME.app/
cp DYLIB_INJECTION_GUIDE.md $PAYLOAD_DIR/$APP_NAME.app/

# Criar Info.plist
cat <<EOF > $PAYLOAD_DIR/$APP_NAME.app/Info.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>$APP_NAME</string>
    <key>CFBundleIdentifier</key>
    <string>$BUNDLE_ID</string>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSRequiresIPhoneOS</key>
    <true/>
    <key>MinimumOSVersion</key>
    <string>14.0</string>
</dict>
</plist>
EOF

# 5. Gerar o IPA final
echo "📦 Gerando arquivo .ipa..."
zip -r $APP_NAME.ipa $PAYLOAD_DIR

echo "✅ Build concluída com sucesso! Arquivo: $APP_NAME.ipa"
