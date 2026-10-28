package com.amazoniainteligente.service;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Integração com a API do Groq (compatível com o formato da OpenAI).
 * Documentação: https://console.groq.com/docs/quickstart
 *
 * Não usa nenhuma biblioteca externa de JSON — a requisição é montada como
 * texto e a resposta é lida com uma expressão regular simples. Isso evita
 * precisar configurar Maven/Gradle só para rodar este MVP.
 */
public class GroqService {

    private static final String ENDPOINT = "https://api.groq.com/openai/v1/chat/completions";

    // Veja em console.groq.com quais modelos gratuitos estão disponíveis
    // no momento — o nome do modelo pode mudar com o tempo.
    private static final String MODEL = "openai/gpt-oss-120b";

    private final String apiKey;
    private final HttpClient client;

    public GroqService(String apiKey) {
        this.apiKey = apiKey;
        this.client = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(15))
                .build();
    }

    /**
     * Envia um prompt para a IA e devolve só o texto de resposta.
     */
    public String enviarPrompt(String prompt) throws IOException, InterruptedException {
        String corpo = criarCorpo(prompt);
        HttpRequest request = criarRequisicao(corpo);
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() != 200) {
            throw new IOException("Groq respondeu com status " + response.statusCode()
                    + ": " + response.body());
        }

        return processarResposta(response.body());
    }

    private String criarCorpo(String prompt) {
        return "{"
                + "\"model\":\"" + MODEL + "\","
                + "\"messages\":[{\"role\":\"user\",\"content\":\"" + escapeJson(prompt) + "\"}],"
                + "\"temperature\":0.3"
                + "}";
    }

    private HttpRequest criarRequisicao(String corpo) {
        return HttpRequest.newBuilder()
                .uri(URI.create(ENDPOINT))
                .header("Authorization", "Bearer " + apiKey)
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(corpo))
                .build();
    }
    private String escapeJson(String texto) {
        return texto
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "");
    }

    private String processarResposta(String jsonBody) {
        Pattern pattern = Pattern.compile("\"content\"\\s*:\\s*\"((?:[^\"\\\\]|\\\\.)*)\"");
        Matcher matcher = pattern.matcher(jsonBody);
        if (matcher.find()) {
            String bruto = matcher.group(1);
            return bruto
                    .replace("\\n", "\n")
                    .replace("\\\"", "\"")
                    .replace("\\\\", "\\");
        }
        return "[Não foi possível interpretar a resposta da IA. Resposta bruta: " + jsonBody + "]";
    }
}


