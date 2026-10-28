package servise;

import Model.AnaliseIA;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.util.Properties;

public class GroqService {

    private String apiKeyInstance;

    // Construtor para ser usado pelo Main.java
    public GroqService(String apiKey) {
        this.apiKeyInstance = apiKey;
    }

    // Construtor padrão
    public GroqService() {}

    public static String carregarApiKey() {
        Properties prop = new Properties();

        // 1. Raiz do projeto
        try (FileInputStream fis = new FileInputStream("config.properties")) {
            prop.load(fis);
            return prop.getProperty("groq.api.key");
        } catch (IOException e1) {
            // 2. Pasta src
            try (FileInputStream fisSrc = new FileInputStream("src/config.properties")) {
                prop.load(fisSrc);
                return prop.getProperty("groq.api.key");
            } catch (IOException e2) {
                // 3. Classpath
                try (var is = GroqService.class.getClassLoader().getResourceAsStream("config.properties")) {
                    if (is != null) {
                        prop.load(is);
                        return prop.getProperty("groq.api.key");
                    }
                } catch (IOException ignored) {}
            }
        }

        
        String envKey = System.getenv("GROQ_API_KEY");
        if (envKey != null && !envKey.isBlank()) {
            return envKey;
        }

        return null;
    }

   
    public String enviarPrompt(String prompt) throws IOException {
        String key = (this.apiKeyInstance != null && !this.apiKeyInstance.isBlank()) ? this.apiKeyInstance : carregarApiKey();
        AnaliseIA res = executarRequisicaoGroq(prompt, key);
        return res != null ? res.getConteudo() : "";
    }

    // Método estático chamado pelo ApiServer.java
    public static AnaliseIA analisar(String dados) throws IOException {
        String apiKey = carregarApiKey();
        if (apiKey == null || apiKey.isBlank()) {
            throw new IOException("Chave da API Groq não encontrada. Verifique o config.properties.");
        }
        return executarRequisicaoGroq(dados, apiKey);
    }

    private static AnaliseIA executarRequisicaoGroq(String dados, String apiKey) throws IOException {
        HttpURLConnection conn = (HttpURLConnection) URI.create("https://api.groq.com/openai/v1/chat/completions").toURL().openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Authorization", "Bearer " + apiKey.trim());
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        
        String promptEscapado = dados.replace("\\", "\\\\")
                                     .replace("\"", "\\\"")
                                     .replace("\n", " ")
                                     .replace("\r", " ");

        
        String systemPrompt = "Você é um especialista em monitoramento socioambiental na Amazônia. "
        + "Analise os dados fornecidos e classifique a ocorrência rigorosamente com base nas métricas:\\n\\n"
        + "- **Nível da Água (% ou m)**: Normal (<60%), Atenção (60-79%), Crítico (80-95%), Emergência (>95%/Transbordamento).\\n"
        + "- **Qualidade da Água (pH/NTU)**: Normal (pH 6.5-8.5), Atenção (pH 5.5-6.4/8.6-9.0), Crítico (pH 4.5-5.4/9.1-10.0), Emergência (pH <4.5 ou >10.0).\\n"
        + "- **Falta de Água/Energia/Internet (Horas/Dias)**: Normal (0h), Atenção (2h a 6h), Crítico (6h a 24h), Emergência (>24h / >3 dias).\\n"
        + "- **Queimada (Distância km)**: Normal (>10km), Atenção (5-10km/fumaça), Crítico (1-5km), Emergência (<1km de casas).\\n"
        + "- **Desmatamento (Hectares ha)**: Normal (0 ha), Atenção (<2 ha), Crítico (2-10 ha), Emergência (>10 ha ou área protegida).\\n\\n"
        + "Responda sempre começando com:\\n"
        + "**Classificação:** [Nível, Cor e Nome]\\n\\n"
        + "**Resumo da Ocorrência:**\\n[Texto conciso]\\n\\n"
        + "**Recomendações de Ação Imediata:**\\n1. [Passo 1]\\n2. [Passo 2]";

     
        String jsonInput = String.format(
            "{\"model\":\"openai/gpt-oss-20b\",\"messages\":["
            + "{\"role\":\"system\",\"content\":\"%s\"},"
            + "{\"role\":\"user\",\"content\":\"Dados da ocorrência: %s\"}"
            + "],\"temperature\":0.1}",
            systemPrompt,
            promptEscapado
        );

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = jsonInput.getBytes(StandardCharsets.UTF_8);
            os.write(input, 0, input.length);
        }

        int responseCode = conn.getResponseCode();
        if (responseCode == 200) {
            String respostaBruta = new String(conn.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
            
            // Extrai o conteúdo da propriedade "content" do JSON
            String textoLimpo = respostaBruta;
            if (respostaBruta.contains("\"content\":\"")) {
                try {
                    int inicio = respostaBruta.indexOf("\"content\":\"") + 11;
                    int fim = respostaBruta.indexOf("\"", inicio);
                    if (fim > inicio) {
                        textoLimpo = respostaBruta.substring(inicio, fim);
                    }
                } catch (Exception ignored) {}
            }

            AnaliseIA analise = new AnaliseIA();
            analise.setConteudo(textoLimpo);
            return analise;
        } else {
            String erroBruto = new String(conn.getErrorStream().readAllBytes(), StandardCharsets.UTF_8);
            System.err.println("Erro detalhado da API Groq (HTTP " + responseCode + "): " + erroBruto);
            throw new IOException("Erro da API Groq (HTTP " + responseCode + "): " + erroBruto);
        }
    }
}
