-- =============================================================================
-- PROJETO AMAZÔNIA INTELIGENTE (ODS 9 - INDÚSTRIA, INOVAÇÃO E INFRAESTRUTURA)
-- SCRIPT DDL: CRIAÇÃO DO BANCO DE DADOS E TABELAS (MYSQL)
-- =============================================================================

CREATE DATABASE IF NOT EXISTS amazonia_db
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE amazonia_db;

-- 1. TABELA: COMUNIDADE
CREATE TABLE IF NOT EXISTS comunidade (
    id_comunidade INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    localizacao VARCHAR(255) NOT NULL,
    populacao_estimada INT DEFAULT 0,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. TABELA: USUARIO
CREATE TABLE IF NOT EXISTS usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    papel ENUM('morador', 'agente', 'gestor', 'manutencao') NOT NULL DEFAULT 'morador',
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 3. TABELA: AREA MONITORADA
CREATE TABLE IF NOT EXISTS area_monitorada (
    id_area INT AUTO_INCREMENT PRIMARY KEY,
    id_comunidade INT NOT NULL,
    tipo ENUM('Conectividade', 'Energia', 'Saneamento', 'Saúde', 'Educação', 'Meio Ambiente') NOT NULL,
    status_atual ENUM('NORMAL', 'ATENÇÃO', 'CRÍTICO') NOT NULL DEFAULT 'NORMAL',
    descricao TEXT,
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_area_comunidade FOREIGN KEY (id_comunidade)
        REFERENCES comunidade (id_comunidade)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 4. TABELA: SENSOR / OCORRÊNCIA
CREATE TABLE IF NOT EXISTS sensor (
    id_sensor INT AUTO_INCREMENT PRIMARY KEY,
    id_area INT NOT NULL,
    id_usuario INT NULL,
    tipo VARCHAR(100) NOT NULL,
    localizacao VARCHAR(255) NOT NULL,
    valor_medido DECIMAL(10, 2) NULL,
    unidade VARCHAR(50) NULL,
    origem ENUM('automático', 'manual') NOT NULL DEFAULT 'manual',
    status ENUM('ativo', 'inativo') NOT NULL DEFAULT 'ativo',
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sensor_area FOREIGN KEY (id_area)
        REFERENCES area_monitorada (id_area)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_sensor_usuario FOREIGN KEY (id_usuario)
        REFERENCES usuario (id_usuario)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 5. TABELA: ALERTA
CREATE TABLE IF NOT EXISTS alerta (
    id_alerta INT AUTO_INCREMENT PRIMARY KEY,
    id_sensor INT NOT NULL,
    id_usuario_destinatario INT NULL,
    tipo VARCHAR(100) NOT NULL,
    gravidade ENUM('Baixa', 'Média', 'Alta', 'Crítica') NOT NULL,
    status ENUM('aberto', 'resolvido') NOT NULL DEFAULT 'aberto',
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolvido_em TIMESTAMP NULL,
    CONSTRAINT fk_alerta_sensor FOREIGN KEY (id_sensor)
        REFERENCES sensor (id_sensor)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_alerta_usuario FOREIGN KEY (id_usuario_destinatario)
        REFERENCES usuario (id_usuario)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 6. TABELA: ANÁLISE IA
CREATE TABLE IF NOT EXISTS analise_ia (
    id_analise INT AUTO_INCREMENT PRIMARY KEY,
    id_sensor INT NOT NULL,
    id_alerta_gerado INT NULL,
    prompt TEXT NOT NULL,
    resposta MEDIUMTEXT NOT NULL,
    modelo VARCHAR(100) DEFAULT 'openai/gpt-oss-120b',
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_analise_sensor FOREIGN KEY (id_sensor)
        REFERENCES sensor (id_sensor)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_analise_alerta FOREIGN KEY (id_alerta_gerado)
        REFERENCES alerta (id_alerta)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 7. TABELA: RELATÓRIO
CREATE TABLE IF NOT EXISTS relatorio (
    id_relatorio INT AUTO_INCREMENT PRIMARY KEY,
    id_area INT NOT NULL,
    id_usuario_gerador INT NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    periodo VARCHAR(50) NOT NULL,
    dados JSON NULL,
    indicadores TEXT,
    data_geracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_relatorio_area FOREIGN KEY (id_area)
        REFERENCES area_monitorada (id_area)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_relatorio_usuario FOREIGN KEY (id_usuario_gerador)
        REFERENCES usuario (id_usuario)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 8. TABELA: MODELO PREDITIVO (FASE FUTURA)
CREATE TABLE IF NOT EXISTS modelo_preditivo (
    id_modelo INT AUTO_INCREMENT PRIMARY KEY,
    id_area INT NOT NULL,
    versao VARCHAR(50) NOT NULL,
    acuracia DECIMAL(5, 2) NOT NULL,
    data_treinamento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resultado_previsao VARCHAR(255) NULL,
    CONSTRAINT fk_modelo_area FOREIGN KEY (id_area)
        REFERENCES area_monitorada (id_area)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
