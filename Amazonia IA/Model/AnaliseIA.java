package com.amazoniainteligente.model;

import java.time.LocalDateTime;

/**
 * Registro de cada chamada feita à API de Inteligência Artificial
 * (implementação atual do MVP, via Groq/OpenRouter).
 */
public class AnaliseIA {

    private static int proximoId = 1;

    private final int id;
    private final String prompt;
    private final String resposta;
    private final LocalDateTime dataHora;
    private Integer alertaGeradoId; // pode ficar nulo se a IA não gerar alerta

    public AnaliseIA(String prompt, String resposta) {
        this.id = proximoId++;
        this.prompt = prompt;
        this.resposta = resposta;
        this.dataHora = LocalDateTime.now();
    }

    public int getId() { return id; }
    public String getPrompt() { return prompt; }
    public String getResposta() { return resposta; }
    public LocalDateTime getDataHora() { return dataHora; }
    public Integer getAlertaGeradoId() { return alertaGeradoId; }
    public void setAlertaGeradoId(Integer alertaGeradoId) { this.alertaGeradoId = alertaGeradoId; }

    @Override
    public String toString() {
        return "AnaliseIA #" + id + " | resposta: " + resposta;
    }
}

