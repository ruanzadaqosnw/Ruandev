# 🚀 Guia Rápido de Compilação - Ruan Dev API Server

## ⚡ Compilação Rápida (3 Passos)

### 1️⃣ Clone o Repositório
```bash
git clone https://github.com/ruanzadaqosnw/Ruandev.git
cd Ruandev
```

### 2️⃣ Execute o Script de Build
```bash
chmod +x build-ipa.sh
./build-ipa.sh
```

### 3️⃣ Encontre o IPA
```
build/RuanDevAPIServer.ipa ✅
```

## 📱 Instalar no iPhone

### Via Xcode:
```bash
# Conectar iPhone → Xcode → Window → Devices → + → Selecionar IPA
```

### Via Terminal:
```bash
# Instalar no iPhone conectado
xcrun devicectl device install app build/RuanDevAPIServer.ipa
```

## 🔄 GitHub Actions (Automático)

O repositório compila automaticamente quando você faz push:

1. Vá em **Actions** no GitHub
2. Veja o workflow **Build IPA**
3. Baixe o IPA em **Artifacts**

## 🛠️ Troubleshooting

| Problema | Solução |
|----------|---------|
| "Xcode não encontrado" | `xcode-select --install` |
| "Certificado inválido" | Abrir Xcode → Preferences → Accounts |
| "Assinatura falhou" | Verificar Signing & Capabilities no Xcode |
| "Compilação falhou" | Ver logs: `xcodebuild -showsdks` |

## 📚 Documentação Completa

- **COMPILAR_IPA.md** - Guia detalhado de compilação
- **README.md** - Visão geral do projeto
- **QUICK_START.md** - Início rápido
- **DYLIB_INJECTION_GUIDE.md** - Como injetar em apps

## 🎯 Próximos Passos

1. ✅ Compilar IPA
2. ✅ Instalar no iPhone
3. ✅ Testar funcionalidade
4. ✅ Injetar dylib em outro app (opcional)

---

**Versão**: 1.0.0  
© Ruan Dev
