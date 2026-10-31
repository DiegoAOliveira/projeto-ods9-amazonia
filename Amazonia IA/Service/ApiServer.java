package Service;

import Model.Alerta;
import Model.AnaliseIA;
import Model.Sensor;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Servidor HTTP REST nativo (porta 8080) para comunicação com o app Flutter
 * e outros clientes HTTP, sem dependência de bibliotecas externas (Spring, etc.).
 */
public class ApiServer {

    private static final int PORTA = 8080;
    private static final List<Sensor> sensores = Collections.synchronizedList(new ArrayList<>());
    private static final List<Alerta> alertas = Collections.synchronizedList(new ArrayList<>());
    private static final List<AnaliseIA> analises = Collections.synchronizedList(new ArrayList<>());
    private static GroqService groqService;

    public static void main(String[] args) throws IOException {
        iniciarServidor(PORTA);
    }

    public static HttpServer iniciarServidor(int porta) throws IOException {
        String apiKey = carregarApiKey();
        if (apiKey != null && !apiKey.isBlank()) {
            groqService = new GroqService(apiKey);
            System.out.println("[API] Chave Groq detectada. Integração com IA ativa.");
        } else {
            System.out.println("[API] Chave Groq não configurada. Ativando modo analítico inteligente nativo.");
        }

        HttpServer server = HttpServer.create(new InetSocketAddress(porta), 0);
        server.createContext("/sensores", new SensoresHandler());
        server.createContext("/health", (exchange) -> {
            enviarRespostaCors(exchange, 200, "{\"status\":\"OK\",\"sistema\":\"Amazonia Inteligente\"}");
        });
        server.setExecutor(null); // cria executor padrão
        server.start();
        System.out.println("==================================================");
        System.out.println("  Servidor Amazônia Inteligente iniciado na porta " + porta);
        System.out.println("  Endpoints disponíveis:");
        System.out.println("   - POST http://127.0.0.1:" + porta + "/sensores");
        System.out.println("   - GET  http://127.0.0.1:" + porta + "/sensores");
        System.out.println("   - GET  http://127.0.0.1:" + porta + "/health");
        System.out.println("==================================================");
        return server;
    }

    static class SensoresHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange exchange) throws IOException {
            String metodo = exchange.getRequestMethod().toUpperCase(Locale.ROOT);

            // Suporte a CORS Pre-flight (para navegadores / Flutter Web)
            if ("OPTIONS".equals(metodo)) {
                tratarCorsPreflight(exchange);
                return;
            }

            if ("GET".equals(metodo)) {
                listarSensoresJson(exchange);
                return;
            }

            if ("POST".equals(metodo)) {
                processarCadastroSensor(exchange);
                return;
            }

            enviarRespostaCors(exchange, 405, "{\"erro\":\"Método não permitido\"}");
        }

        private void tratarCorsPreflight(HttpExchange exchange) throws IOException {
            exchange.getResponseHeaders().set("Access-Control-Allow-Origin", "*");
            exchange.getResponseHeaders().set("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
            exchange.getResponseHeaders().set("Access-Control-Allow-Headers", "Content-Type, Authorization");
            exchange.sendResponseHeaders(204, -1);
            exchange.close();
        }

        private void listarSensoresJson(HttpExchange exchange) throws IOException {
            StringBuilder sb = new StringBuilder();
            sb.append("[");
            synchronized (sensores) {
                for (int i = 0; i < sensores.size(); i++) {
                    Sensor s = sensores.get(i);
                    sb.append(sensorToJson(s));
                    if (i < sensores.size() - 1) {
                        sb.append(",");
                    }
                }
            }
            sb.append("]");
            enviarRespostaCors(exchange, 200, sb.toString());
        }

        private void processarCadastroSensor(HttpExchange exchange) throws IOException {
            InputStream is = exchange.getRequestBody();
            String body = new String(is.readAllBytes(), StandardCharsets.UTF_8);

            String tipo = extrairCampoJson(body, "tipo");
            String localizacao = extrairCampoJson(body, "localizacao");
            Double valorMedido = extrairDoubleJson(body, "valorMedido");
            String unidadeEntrada = extrairCampoJson(body, "unidade");

            if (tipo == null || tipo.isBlank()) {
                tipo = "Ocorrência geral";
            }
            if (localizacao == null || localizacao.isBlank()) {
                localizacao = "Santa Rosa do Purus";
            }

            Sensor sensor = new Sensor(tipo, localizacao, valorMedido, unidadeEntrada, "manual", "App Flutter");
            sensores.add(sensor);

            // Obter análise da IA (via Groq se configurado ou fallback inteligente)
            String parecerAnalise = obterAnaliseIa(sensor);

            // Criar análise de IA registrada no sistema
            AnaliseIA analise = new AnaliseIA("Tipo: " + sensor.getTipo() + ", Local: " + sensor.getLocalizacao(), parecerAnalise);
            analises.add(analise);

            // Se for situação crítica ou de atenção, gera alerta
            String gravidade = classificarGravidade(parecerAnalise);
            if (!"NORMAL".equalsIgnoreCase(gravidade)) {
                Alerta alerta = new Alerta(sensor.getTipo(), gravidade, sensor.getId());
                alertas.add(alerta);
                analise.setAlertaGeradoId(alerta.getId());
                System.out.println("[ALERTA GERADO] " + alerta);
            }

            // O app Flutter espera a análise devolvida no campo 'unidade' do JSON
            String jsonResposta = "{"
                    + "\"id\":" + sensor.getId() + ","
                    + "\"tipo\":\"" + escapeJson(sensor.getTipo()) + "\","
                    + "\"localizacao\":\"" + escapeJson(sensor.getLocalizacao()) + "\","
                    + "\"valorMedido\":" + (sensor.getValorMedido() != null ? sensor.getValorMedido() : "null") + ","
                    + "\"unidade\":\"" + escapeJson(parecerAnalise) + "\""
                    + "}";

            enviarRespostaCors(exchange, 201, jsonResposta);
        }
    }

    private static String obterAnaliseIa(Sensor sensor) {
        if (groqService != null) {
            try {
                String prompt = "Você é um assistente especialista que monitora infraestrutura em comunidades isoladas "
                        + "da Amazônia (como Santa Rosa do Purus, AC) sob a diretriz do ODS 9.\n"
                        + "Analise esta ocorrência e responda no seguinte formato:\n"
                        + "Classificação: [NORMAL, ATENÇÃO ou CRÍTICO / EMERGÊNCIA]\n"
                        + "Resumo da Ocorrência:\n[resumo claro em 2 a 3 frases]\n"
                        + "Recomendações de Ação Imediata:\n- [recomendação 1]\n- [recomendação 2]\n\n"
                        + "Tipo: " + sensor.getTipo() + "\n"
                        + "Local: " + sensor.getLocalizacao() + "\n"
                        + "Valor medido: " + (sensor.getValorMedido() != null ? sensor.getValorMedido() : "não informado");

                String resposta = groqService.enviarPrompt(prompt);
                if (resposta != null && !resposta.isBlank()) {
                    return resposta;
                }
            } catch (Exception e) {
                System.err.println("[API] Falha na chamada da API Groq: " + e.getMessage() + ". Usando motor local.");
            }
        }
        return gerarAnaliseInteligenteLocal(sensor);
    }

    public static String gerarAnaliseInteligenteLocal(Sensor s) {
        String tipo = s.getTipo() != null ? s.getTipo().toLowerCase(Locale.ROOT) : "";
        Double valor = s.getValorMedido();
        String loc = s.getLocalizacao() != null ? s.getLocalizacao() : "Comunidade Isolada";

        String nivel;
        String resumo;
        String recomendacoes;

        if (tipo.contains("falta de água") || tipo.contains("agua") || (tipo.contains("qualidade da água") && valor != null && (valor < 6 || valor > 8.5))) {
            nivel = "CRÍTICO / EMERGÊNCIA";
            resumo = "Interrupção ou contaminação grave no abastecimento de água potável em " + loc + ". "
                    + "Na região amazônica e municípios isolados como Santa Rosa do Purus, onde apenas 38,9% têm acesso a água tratada, "
                    + "a descontinuidade representa risco direto de surto de doenças de veiculação hídrica.";
            recomendacoes = "- Despachar imediatamente agentes comunitários para verificação do poço/captação.\n"
                    + "- Disponibilizar pastilhas de hipoclorito de sódio e barcos/caminhões de suporte emergencial.\n"
                    + "- Acionar a Defesa Civil Municipal e a secretaria de saneamento.";
        } else if (tipo.contains("energia") || tipo.contains("luz")) {
            double horas = valor != null ? valor : 12;
            nivel = horas >= 24 ? "CRÍTICO / EMERGÊNCIA" : "ATENÇÃO";
            resumo = "Queda no fornecimento de energia elétrica em " + loc + ". "
                    + "Sistemas isolados dependem de geradores térmicos ou solares; falhas prolongadas afetam a conservação de vacinas e comunicação.";
            recomendacoes = "- Verificar o nível de combustível dos geradores locais e o banco de baterias solares.\n"
                    + "- Priorizar a alimentação de energia da Unidade Básica de Saúde da comunidade.\n"
                    + "- Notificar a concessionária responsável pelo sistema isolado.";
        } else if (tipo.contains("queimada") || tipo.contains("fumaça") || tipo.contains("desmatamento") || tipo.contains("ambiente")) {
            nivel = "CRÍTICO / EMERGÊNCIA";
            resumo = "Detecção de pressão ambiental e risco respiratório em " + loc + ". "
                    + "Padrão crítico de impacto à saúde de crianças e idosos ribeirinhos e indígenas.";
            recomendacoes = "- Emitir alerta imediato às brigadas comunitárias e ICMBio/IBAMA.\n"
                    + "- Distribuir máscaras PFF2 na Unidade Básica de Saúde local.\n"
                    + "- Orientar a população ribeirinha a evitar exposição nos períodos de maior concentração de fumaça.";
        } else if (tipo.contains("posto de saúde") || tipo.contains("saúde") || tipo.contains("saude") || tipo.contains("atendimento")) {
            nivel = "ATENÇÃO";
            resumo = "Sobrecarga ou desabastecimento em serviços de saúde em " + loc + ". Necessidade de retaguarda médica remota e triagem de urgência.";
            recomendacoes = "- Conectar agentes locais ao serviço de Telemedicina.\n"
                    + "- Checar estoque de soros, antibióticos básicos e kits de primeiros socorros.\n"
                    + "- Prever transporte fluvial/aéreo de emergência se houver caso grave.";
        } else if (tipo.contains("internet") || tipo.contains("comunicação") || tipo.contains("conectividade")) {
            nivel = "ATENÇÃO";
            resumo = "Inoperância no sinal de comunicação em " + loc + ". O isolamento impede o acionamento de socorro e monitoramento remoto em tempo real.";
            recomendacoes = "- Reiniciar o terminal satelital comunitário.\n"
                    + "- Utilizar rede de rádio VHF/HF como canal alternativo de contingência.\n"
                    + "- Abrir chamado com a operadora do link satelital governamental.";
        } else {
            nivel = "NORMAL";
            resumo = "Os parâmetros informados para " + s.getTipo() + " em " + loc + " encontram-se dentro dos limites aceitáveis para as condições locais.";
            recomendacoes = "- Manter a rotina habitual de monitoramento pelos agentes locais.\n"
                    + "- Próxima leitura recomendada em 24 a 48 horas.";
        }

        return "Classificação: " + nivel + "\n\n"
                + "Resumo da Ocorrência:\n" + resumo + "\n\n"
                + "Recomendações de Ação Imediata:\n" + recomendacoes;
    }

    private static String classificarGravidade(String parecer) {
        String p = parecer.toUpperCase(Locale.ROOT);
        if (p.contains("CRÍTICO") || p.contains("CRITICO") || p.contains("EMERGÊNCIA") || p.contains("EMERGENCIA")) {
            return "Alta";
        } else if (p.contains("ATENÇÃO") || p.contains("ATENCAO")) {
            return "Média";
        }
        return "NORMAL";
    }

    private static void enviarRespostaCors(HttpExchange exchange, int statusCode, String responseBody) throws IOException {
        byte[] bytes = responseBody.getBytes(StandardCharsets.UTF_8);
        exchange.getResponseHeaders().set("Access-Control-Allow-Origin", "*");
        exchange.getResponseHeaders().set("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
        exchange.getResponseHeaders().set("Access-Control-Allow-Headers", "Content-Type, Authorization");
        exchange.getResponseHeaders().set("Content-Type", "application/json; charset=UTF-8");
        exchange.sendResponseHeaders(statusCode, bytes.length);
        try (OutputStream os = exchange.getResponseBody()) {
            os.write(bytes);
        }
    }

    private static String sensorToJson(Sensor s) {
        return "{"
                + "\"id\":" + s.getId() + ","
                + "\"tipo\":\"" + escapeJson(s.getTipo()) + "\","
                + "\"localizacao\":\"" + escapeJson(s.getLocalizacao()) + "\","
                + "\"valorMedido\":" + (s.getValorMedido() != null ? s.getValorMedido() : "null") + ","
                + "\"unidade\":" + (s.getUnidade() != null ? "\"" + escapeJson(s.getUnidade()) + "\"" : "null") + ","
                + "\"origem\":\"" + escapeJson(s.getOrigem()) + "\","
                + "\"status\":\"" + escapeJson(s.getStatus()) + "\""
                + "}";
    }

    private static String extrairCampoJson(String json, String campo) {
        Pattern pattern = Pattern.compile("\"" + Pattern.quote(campo) + "\"\\s*:\\s*\"((?:[^\"\\\\]|\\\\.)*)\"");
        Matcher matcher = pattern.matcher(json);
        if (matcher.find()) {
            return matcher.group(1).replace("\\\"", "\"").replace("\\\\", "\\");
        }
        return null;
    }

    private static Double extrairDoubleJson(String json, String campo) {
        Pattern pattern = Pattern.compile("\"" + Pattern.quote(campo) + "\"\\s*:\\s*([0-9]+(?:\\.[0-9]+)?)");
        Matcher matcher = pattern.matcher(json);
        if (matcher.find()) {
            try {
                return Double.parseDouble(matcher.group(1));
            } catch (NumberFormatException ignored) {}
        }
        return null;
    }

    private static String escapeJson(String texto) {
        if (texto == null) return "";
        return texto
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "");
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

    public static List<Sensor> getSensores() {
        return sensores;
    }

    public static List<Alerta> getAlertas() {
        return alertas;
    }
}
