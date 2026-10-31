package Service;

import Model.Alerta;
import Model.AnaliseIA;
import Model.Sensor;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.Scanner;

public class Main {

    private static final List<Sensor> sensores = new ArrayList<>();
    private static final List<Alerta> alertas = new ArrayList<>();
    private static final List<AnaliseIA> analises = new ArrayList<>();

    public static void main(String[] args) {
        String apiKey = carregarApiKey();
        if (apiKey == null || apiKey.isBlank()) {
            System.out.println("ERRO: não encontrei a chave da API do Groq.");
            System.out.println("Crie um arquivo config.properties");
            System.out.println("ou defina a variável de ambiente GROQ_API_KEY antes de rodar.");
            return;
        }

        GroqService groq = new GroqService(apiKey);
        Scanner scanner = new Scanner(System.in);

        while (true) {
            System.out.println("\n===== Amazônia Inteligente MVP =====");
            System.out.println("1 - Cadastrar sensor/ocorrência (manual)");
            System.out.println("2 - Enviar um sensor para a IA analisar");
            System.out.println("3 - Listar sensores");
            System.out.println("4 - Listar alertas gerados");
            System.out.println("5 - Listar histórico de análises da IA");
            System.out.println("6 - Iniciar Servidor HTTP da API (Porta 8080 para App Flutter)");
            System.out.println("0 - Sair");
            System.out.print("Escolha uma opção: ");

            String opcao = scanner.nextLine().trim();

            switch (opcao) {
                case "1" -> cadastrarSensor(scanner);
                case "2" -> enviarParaIA(scanner, groq);
                case "3" -> listarSensores();
                case "4" -> listarAlertas();
                case "5" -> listarAnalises();
                case "6" -> iniciarServidorApi();
                case "0" -> {
                    System.out.println("Até mais!");
                    return;
                }
                default -> System.out.println("Opção inválida.");
            }
        }
    }

    private static void iniciarServidorApi() {
        try {
            ApiServer.iniciarServidor(8080);
            System.out.println("Servidor ativo e pronto para receber requisições do App Flutter.");
        } catch (IOException e) {
            System.err.println("Erro ao iniciar servidor HTTP: " + e.getMessage());
        }
    }

    private static void cadastrarSensor(Scanner scanner) {
        System.out.print("Tipo de ocorrência (ex: Falta de agua): ");
        String tipo = scanner.nextLine().trim();
        if (tipo.isBlank()) {
            System.out.println("Tipo não pode ficar em branco. Cadastro cancelado.");
            return;
        }

        System.out.print("Localização (ex: Santa Rosa do Purus): ");
        String localizacao = scanner.nextLine().trim();
        if (localizacao.isBlank()) {
            System.out.println("Localização não pode ficar em branco. Cadastro cancelado.");
            return;
        }

        System.out.print("Valor medido (número, ou deixe em branco se não houver): ");
        String valorTexto = scanner.nextLine().trim();
        Double valor = null;
        if (!valorTexto.isBlank()) {
            try {
                valor = Double.valueOf(valorTexto.replace(",", "."));
            } catch (NumberFormatException e) {
                System.out.println("Valor inválido — cadastrando sem valor numérico.");
            }
        }

        System.out.print("Unidade (ex: %, ou deixe em branco): ");
        String unidade = scanner.nextLine().trim();
        if (unidade.isBlank()) unidade = null;

        System.out.print("Quem está reportando (nome do morador/agente): ");
        String usuario = scanner.nextLine().trim();

        Sensor sensor = new Sensor(tipo, localizacao, valor, unidade, "manual", usuario);
        sensores.add(sensor);

        System.out.println("Cadastrado com sucesso: " + sensor);
    }

    private static void enviarParaIA(Scanner scanner, GroqService groq) {
        if (sensores.isEmpty()) {
            System.out.println("Cadastre um sensor primeiro (opção 1).");
            return;
        }

        listarSensores();
        System.out.print("Digite o número (#id) do sensor a analisar: ");
        int id;
        try {
            id = Integer.parseInt(scanner.nextLine().trim());
        } catch (NumberFormatException e) {
            System.out.println("Número inválido.");
            return;
        }

        Sensor sensor = sensores.stream()
                .filter(s -> s.getId() == id)
                .findFirst()
                .orElse(null);

        if (sensor == null) {
            System.out.println("Sensor não encontrado.");
            return;
        }

        String prompt = montarPrompt(sensor);
        System.out.println("\nEnviando para a IA...\nPrompt: " + prompt);

        try {
            String resposta = groq.enviarPrompt(prompt);
            System.out.println("\nResposta da IA:\n" + resposta);

            AnaliseIA analise = new AnaliseIA(prompt, resposta);
            analises.add(analise);

            String gravidade = classificarGravidade(resposta);
            if (!gravidade.equals("NORMAL")) {
                Alerta alerta = new Alerta(sensor.getTipo(), gravidade, sensor.getId());
                alertas.add(alerta);
                analise.setAlertaGeradoId(alerta.getId());
                System.out.println("\n Alerta gerado automaticamente: " + alerta);
            } else {
                System.out.println("\nA IA não identificou situação crítica...nenhum alerta gerado.");
            }

       } catch (Exception e) {
    System.err.println("Erro ao processar: " + e.getMessage());
    e.printStackTrace();
       }
    }

    private static String montarPrompt(Sensor sensor) {
        String valorTexto = (sensor.getValorMedido() != null)
                ? sensor.getValorMedido() + (sensor.getUnidade() != null ? sensor.getUnidade() : "")
                : "não informado";

        return "Você é um assistente que monitora infraestrutura em comunidades isoladas "
                + "da Amazônia (como Santa Rosa do Purus, AC). "
                + "Analise esta ocorrência e responda em uma única linha, começando "
                + "exatamente com uma destas palavras: NORMAL, ATENCAO ou CRITICO, "
                + "seguida de dois pontos e uma explicação curta (até 2 frases).\n\n"
                + "Tipo: " + sensor.getTipo() + "\n"
                + "Local: " + sensor.getLocalizacao() + "\n"
                + "Valor medido: " + valorTexto;
    }

    private static String classificarGravidade(String respostaIA) {
        String primeiraPalavra = respostaIA.trim().split("[:\\s]+", 2)[0].toUpperCase(Locale.ROOT);
        return switch (primeiraPalavra) {
            case "CRITICO" -> "Alta";
            case "ATENCAO" -> "Média";
            default -> "NORMAL";
        };
    }

    private static void listarSensores() {
        System.out.println("\n-- Sensores cadastrados --");
        if (sensores.isEmpty()) System.out.println("(nenhum ainda)");
        sensores.forEach(s -> System.out.println(s));
    }

    private static void listarAlertas() {
        System.out.println("\n-- Alertas gerados --");
        if (alertas.isEmpty()) System.out.println("(nenhum ainda)");
        alertas.forEach(a -> System.out.println(a));
    }

    private static void listarAnalises() {
        System.out.println("\n-- Histórico de análises da IA --");
        if (analises.isEmpty()) System.out.println("(nenhuma ainda)");
        analises.forEach(an -> System.out.println(an));
    }

    private static String carregarApiKey() {
        String doAmbiente = System.getenv("GROQ_API_KEY");
        if (doAmbiente != null && !doAmbiente.isBlank()) {
            return doAmbiente;
        }
        try (FileInputStream in = new FileInputStream("config.properties")) {
            Properties props = new Properties();
            props.load(in);
            return props.getProperty("groq.api.key");
        } catch (IOException e) {
            return null;
        }
    }
}
