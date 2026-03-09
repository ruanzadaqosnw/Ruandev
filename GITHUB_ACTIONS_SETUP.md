# 🚀 GitHub Actions - Build Automático do IPA

Este repositório está configurado para **compilar automaticamente o IPA no macOS** usando GitHub Actions.

## ✅ Como Funciona

Toda vez que você faz **push** para a branch `main` ou `master`, o GitHub Actions:

1. ✅ Clona o repositório
2. ✅ Instala as dependências
3. ✅ Gera o projeto Xcode
4. ✅ Compila para iOS (arm64)
5. ✅ Cria o arquivo IPA
6. ✅ Faz upload como Artifact
7. ✅ Cria uma Release automática

## 📋 Pré-requisitos

- ✅ Repositório GitHub (já tem)
- ✅ GitHub Actions habilitado (padrão)
- ✅ Sem necessidade de certificados (usa defaults do macOS)

## 🎯 Como Usar

### Opção 1: Trigger Automático (Recomendado)

Simplesmente faça um **push** para a branch `main`:

```bash
git add .
git commit -m "Update app"
git push origin main
```

O build iniciará automaticamente!

### Opção 2: Trigger Manual

1. Vá em **GitHub** → **Actions**
2. Selecione o workflow **Auto Build IPA**
3. Clique em **Run workflow**
4. Aguarde a compilação

### Opção 3: Via Tags (Releases)

```bash
git tag v1.0.0
git push origin v1.0.0
```

Cria uma Release com o IPA automaticamente!

## 📥 Baixar o IPA

### Método 1: Via Artifacts (Mais Rápido)

1. Vá em **GitHub** → **Actions**
2. Clique no workflow mais recente
3. Role para baixo até **Artifacts**
4. Clique em **RuanDevAPIServer.ipa**
5. Download automático

### Método 2: Via Releases

1. Vá em **GitHub** → **Releases**
2. Selecione a release mais recente
3. Clique em **RuanDevAPIServer-arm64.ipa**
4. Download

## 🔍 Monitorar o Build

1. Vá em **GitHub** → **Actions**
2. Veja o status do workflow
3. Clique para ver logs detalhados
4. Verifique se há erros

## 📊 Status do Build

| Status | Significado |
|--------|-------------|
| ✅ Passed | IPA compilado com sucesso |
| ❌ Failed | Erro na compilação |
| ⏳ In Progress | Compilando... |
| ⏸️ Skipped | Não foi executado |

## 🛠️ Troubleshooting

### Problema: Build falhou

**Solução:**
1. Clique no workflow para ver logs
2. Procure por erros de compilação
3. Corrija o código
4. Faça push novamente

### Problema: IPA não aparece em Artifacts

**Solução:**
1. Verifique se o build passou (✅)
2. Role para baixo na página do workflow
3. Procure pela seção "Artifacts"
4. Se não houver, o build falhou

### Problema: Erro "Swift package not found"

**Solução:**
1. Verifique se `Package.swift` existe
2. Verifique se a estrutura está correta
3. Teste localmente com `swift package generate-xcodeproj`

## 📝 Customizar o Build

### Mudar a Branch Padrão

Edite `.github/workflows/auto-build.yml`:

```yaml
on:
  push:
    branches: [ main, develop ]  # Adicione suas branches
```

### Mudar o Scheme

```yaml
xcodebuild -scheme SEU_SCHEME \
```

### Adicionar Certificado

Para assinar com certificado real:

```yaml
- name: Install Certificate
  run: |
    echo "${{ secrets.CERTIFICATE }}" | base64 --decode > cert.p12
    security import cert.p12 -P "${{ secrets.CERT_PASSWORD }}"
```

## 🔐 Segurança

- ✅ O código é compilado em servidores seguros do GitHub
- ✅ Artifacts são armazenados por 90 dias
- ✅ Releases são públicas (você controla)
- ✅ Nenhuma informação sensível é exposta

## 📞 Dicas

1. **Teste localmente primeiro** - Antes de fazer push
2. **Verifique os logs** - Se algo der errado
3. **Use tags para releases** - Cria releases automáticas
4. **Monitore os artifacts** - Veja o tamanho do IPA
5. **Mantenha o código limpo** - Evita erros de compilação

## 🎯 Próximos Passos

1. ✅ Faça um push para ativar o build
2. ✅ Vá em Actions e monitore
3. ✅ Baixe o IPA quando pronto
4. ✅ Instale no iPhone
5. ✅ Teste a funcionalidade

## 📚 Documentação

- **README.md** - Visão geral
- **QUICK_START.md** - Início rápido
- **COMPILAR_IPA.md** - Compilação manual
- **BUILD_GUIDE.md** - Guia de build

---

**Versão**: 1.0.0  
**Última atualização**: 2026-03-09

© Ruan Dev
