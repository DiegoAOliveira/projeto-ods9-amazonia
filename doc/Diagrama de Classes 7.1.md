```mermaid
classDiagram
    class Usuario {
        +int id
        +String nome
        +String email
        +String papel
        +login()
        +logout()
        +atualizarPerfil()
        +registrarOcorrencia()
    }
    note for Usuario "Exemplo Real:
    Nome: João Silva
    Email: joao@email.com
    Papel: Agente de Saúde"

    class Comunidade {
        +int id
        +String nome
        +String localizacao
        +int populacaoEstimada
        +cadastrarComunidade()
        +listarAreasMonitoradas()
    }
    note for Comunidade "Exemplo Real:
    Nome: Santa Rosa do Purus
    Local: Acre, fronteira Peru
    Pop: 7143"

    class AreaMonitorada {
        +int id
        +String tipo
        +String statusAtual
        +int comunidadeId
        +atualizarStatus()
        +gerarHistorico()
    }
    note for AreaMonitorada "6 Frentes: Conectividade, Energia,
    Saneamento, Saúde, Educação, Meio Ambiente
    Exemplo Real:
    Tipo: Saneamento
    Status: Crítico"

    class Sensor {
        +int id
        +String tipo
        +String localizacao
        +float valorMedido
        +String unidade
        +DateTime dataHora
        +String status
        +String origem
        +int usuarioRegistroId
        +int areaMonitoradaId
        +coletarDados()
        +medirValor()
        +enviarDados()
        +verificarStatus()
    }
    note for Sensor "Exemplo Real:
    Tipo: Qualidade da água
    Valor: 38.9% (Crítico)
    Status: ativo"

    class Alerta {
        +int id
        +String tipo
        +String gravidade
        +DateTime dataHora
        +String status
        +int sensorId
        +gerarAlerta()
        +notificarResponsavel()
        +resolverAlerta()
    }
    note for Alerta "Exemplo Real:
    Tipo: Baixa cobertura água
    Gravidade: Alta
    Status: aberto"

    class Relatorio {
        +int id
        +String titulo
        +String periodo
        +String dados
        +String indicadores
        +DateTime dataGeracao
        +gerarRelatorio()
        +analisarDados()
        +calcularIndicadores()
        +exportarRelatorio()
    }
    note for Relatorio "Exemplo Real:
    Título: Monitoramento Saneamento
    Indicador: 38.9% água tratada"

    class AnaliseIA {
        +int id
        +String prompt
        +String resposta
        +DateTime dataHora
        +int alertaGeradoId
        +enviarParaIA()
        +salvarResposta()
    }
    note for AnaliseIA "Implementação atual do MVP
    via API Groq/OpenRouter"

    class ModeloPreditivo {
        +int id
        +String versao
        +float acuracia
        +DateTime dataTreinamento
        +treinar()
        +preverStatus()
    }
    note for ModeloPreditivo "Planejado — fase futura"

    Comunidade "1" --> "*" AreaMonitorada : possui
    AreaMonitorada "1" --> "*" Sensor : monitorada por
    Sensor "1" --> "*" Alerta : gera
    Usuario "1" --> "*" Alerta : recebe
    Usuario "1" --> "*" Relatorio : visualiza
    Usuario "1" --> "*" Sensor : pode registrar
    Sensor "1" --> "*" AnaliseIA : é analisado por
    AnaliseIA "1" --> "*" Alerta : pode gerar
    ModeloPreditivo "1" --> "*" AreaMonitorada : analisa (futuro)
    ModeloPreditivo "1" --> "*" Alerta : pode gerar (futuro)
