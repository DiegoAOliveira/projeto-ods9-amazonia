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
        +atualizarStatus()
        +gerarHistorico()
    }
    note for AreaMonitorada "6 Frentes:
    Conectividade, Energia,Saneamento, Saúde,Educação, Meio Ambiente
    Exemplo Real:
    Tipo: Saneamento
    Status: Crítico
    Comunidade: Santa Rosa do Purus"

    class Sensor {
        +int id
        +String tipo
        +String localizacao
        +float valorMedido
        +String unidade
        +DateTime dataHora
        +String status
        +String origem
        +Usuario usuarioRegistro
        +coletarDados()
        +medirValor()
        +enviarDados()
        +verificarStatus()
    }
    note for Sensor "Exemplo Real:
    Tipo: Qualidade da água
    Local: Santa Rosa do Purus
    Valor: 38.9% (Crítico)\nStatus: ativo"

    class Alerta {
        +int id
        +String tipo
        +String gravidade
        +DateTime dataHora
        +String status
        +gerarAlerta()
        +notificarResponsavel()
        +resolverAlerta()
    }
    note for Alerta "Exemplo Real:
    Tipo: Baixa cobertura água
    Gravidade: Alta\nData: 01/09/2026
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
    Período: 2026\nIndicador: 38.9% água tratada
    Data: 01/09/2026"

    class ModeloPreditivo {
        +int id
        +String versao
        +float acuracia
        +DateTime dataTreinamento
        +treinar()
        +preverStatus()
    }

    Comunidade "1" --> "*" AreaMonitorada : possui
    AreaMonitorada "1" --> "*" Sensor : monitorada por
    Sensor "1" --> "*" Alerta : gera
    Usuario "1" --> "*" Alerta : recebe
    Usuario "1" --> "*" Relatorio : visualiza
    Usuario "1" --> "*" Sensor : pode registrar
    ModeloPreditivo "1" --> "*" AreaMonitorada : analisa
    ModeloPreditivo "1" --> "*" Alerta : pode gerar ```
