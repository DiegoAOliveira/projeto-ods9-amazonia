# 📱 Amazônia Inteligente — Aplicativo Flutter

Aplicativo móvel e web desenvolvido em **Flutter** para o projeto **Amazônia Inteligente (ODS 9 — Indústria, Inovação e Infraestrutura)**. O aplicativo permite o monitoramento de serviços essenciais e reporte de ocorrências em comunidades isoladas da Amazônia Legal (ex: Santa Rosa do Purus - AC), com análise inteligente da severidade das ocorrências (Normal, Atenção ou Crítico/Emergência).

---

## 🚀 Como Executar em Qualquer Máquina

### 1. Pré-requisitos
- **Flutter SDK** (versão 3.x ou superior): [Instalação do Flutter](https://docs.flutter.dev/get-started/install)
- **Dart SDK** (já incluso com o Flutter)
- Navegador Google Chrome (para Web) ou Emulador Android / dispositivo físico.

---

### 2. Passo a Passo de Execução

1. **Clone o repositório:**
   ```bash
   git clone <URL_DO_REPOSITORIO>
   cd "Projeto-ODS9-Amazonia" # ou nome da pasta clonada
   ```

2. **Acesse a pasta do aplicativo Flutter:**
   ```bash
   cd "Flutter.app"
   ```

3. **Baixe as dependências:**
   ```bash
   flutter pub get
   ```

4. **Execute o aplicativo:**
   - **No Navegador (Web - Chrome):**
     ```bash
     flutter run -d chrome
     ```
   - **No Navegador (Web Server genérico):**
     ```bash
     flutter run -d web-server --web-port 8080
     ```
   - **No Android (Emulador ou celular via USB com depuração ativada):**
     ```bash
     flutter run
     ```

---

## 🏗️ Estrutura de Pastas do App

```
Flutter.app/
├── lib/
│   ├── main.dart             # Inicialização do app e tema visual verde amazônico
│   ├── home_page.dart        # Dashboard com as 6 frentes do ODS 9 e contexto regional
│   ├── sensor_form_page.dart # Formulário com cidades da Amazônia Legal e reporte
│   ├── resultado_page.dart   # Exibição do parecer da IA e nível de severidade
│   ├── sensor.dart           # Modelo de dados da ocorrência/sensor
│   └── api_service.dart      # Conexão com back-end Java e fallback inteligente
├── test/
│   └── widget_test.dart      # Testes automatizados de widget e serviço
├── web/                      # Suporte para execução em navegadores
├── android/                  # Suporte para empacotamento Android (APK)
└── pubspec.yaml              # Dependências e metadados do projeto Flutter
```

---

## 💡 Como Funciona a Integração com a API / Back-end

- O aplicativo envia requisições HTTP para a API back-end em Java (`http://127.0.0.1:8080/sensores`).
- **Modo Resiliente / Demonstração:** Se o servidor Java não estiver em execução no momento (por exemplo, durante uma demonstração rápida, testes sem back-end ou sem conexão local), a classe `ApiService` gera automaticamente um parecer analítico contextualizado para Santa Rosa do Purus e o ODS 9, permitindo que a navegação e a experiência de uso funcionem perfeitamente.
