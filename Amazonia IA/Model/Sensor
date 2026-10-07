package com.amazoniainteligente.model;

import java.time.LocalDateTime;

/**
 * Representa um dado de uma área monitorada — automático (sensor físico,
 * simulado nesta fase) ou manual (reportado por um Usuário pelo app).
 */
public class Sensor {

    private static int proximoId = 1;

    private final int id;
    private String tipo;          // ex: "Qualidade da água", "Falta de energia"
    private String localizacao;   // ex: "Santa Rosa do Purus"
    private Double valorMedido;   // pode ser nulo em relatos manuais
    private String unidade;       // ex: "%"
    private final LocalDateTime dataHora;
    private String status;        // ativo / inativo
    private String origem;        // "automático" ou "manual"
    private String usuarioRegistro; // nome de quem reportou, se manual

    public Sensor(String tipo, String localizacao, Double valorMedido,
                   String unidade, String origem, String usuarioRegistro) {
        this.id = proximoId++;
        this.tipo = tipo;
        this.localizacao = localizacao;
        this.valorMedido = valorMedido;
        this.unidade = unidade;
        this.dataHora = LocalDateTime.now();
        this.status = "ativo";
        this.origem = origem;
        this.usuarioRegistro = usuarioRegistro;
    }

    public int getId() { return id; }
    public String getTipo() { return tipo; }
    public String getLocalizacao() { return localizacao; }
    public Double getValorMedido() { return valorMedido; }
    public String getUnidade() { return unidade; }
    public LocalDateTime getDataHora() { return dataHora; }
    public String getStatus() { return status; }
    public String getOrigem() { return origem; }
    public String getUsuarioRegistro() { return usuarioRegistro; }

    @Override
    public String toString() {
        String valor = (valorMedido != null) ? (valorMedido + (unidade != null ? unidade : "")) : "—";
        return "Sensor #" + id + " | " + tipo + " | " + localizacao
                + " | valor: " + valor + " | origem: " + origem
                + (usuarioRegistro != null ? " (" + usuarioRegistro + ")" : "");
    }
}



