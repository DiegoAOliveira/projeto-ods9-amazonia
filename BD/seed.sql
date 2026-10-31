-- =============================================================================
-- PROJETO AMAZÔNIA INTELIGENTE (ODS 9 - INDÚSTRIA, INOVAÇÃO E INFRAESTRUTURA)
-- SCRIPT DML: DADOS INICIAIS (SEED)
-- =============================================================================

USE amazonia_db;

-- 1. Inserir Comunidade de Referência
INSERT INTO comunidade (id_comunidade, nome, localizacao, populacao_estimada)
VALUES (1, 'Santa Rosa do Purus', 'Acre, fronteira com o Peru (Amazônia Ocidental)', 7143)
ON DUPLICATE KEY UPDATE nome = VALUES(nome);

-- 2. Inserir Usuários Iniciais (Representando os papéis do sistema)
INSERT INTO usuario (id_usuario, nome, email, senha, papel) VALUES
(1, 'João Silva', 'joao.silva@comunidade.org', 'senha123', 'agente'),
(2, 'Maria Santos', 'maria.moradora@email.com', 'senha123', 'morador'),
(3, 'Carlos Oliveira', 'carlos.gestor@prefeitura.gov.br', 'senha123', 'gestor'),
(4, 'Equipe Manutenção Elétrica', 'manutencao.energia@rede.com.br', 'senha123', 'manutencao')
ON DUPLICATE KEY UPDATE nome = VALUES(nome);

-- 3. Inserir as 6 Áreas Monitoradas do ODS 9 para Santa Rosa do Purus
INSERT INTO area_monitorada (id_area, id_comunidade, tipo, status_atual, descricao) VALUES
(1, 1, 'Saneamento', 'CRÍTICO', 'Apenas 38,9% da população possui acesso à água tratada regular.'),
(2, 1, 'Energia', 'ATENÇÃO', 'Sistema isolado térmico/solar sujeito a interrupções no fornecimento.'),
(3, 1, 'Conectividade', 'ATENÇÃO', 'Sinal satelital instável e baixa velocidade de transmissão.'),
(4, 1, 'Saúde', 'NORMAL', 'Monitoramento da Unidade Básica de Saúde fluvial e terrestre.'),
(5, 1, 'Educação', 'NORMAL', 'Estrutura física e fornecimento de energia para escolas ribeirinhas.'),
(6, 1, 'Meio Ambiente', 'NORMAL', 'Monitoramento de focos de queimada, estiagem e turbidez das águas.')
ON DUPLICATE KEY UPDATE tipo = VALUES(tipo);

-- 4. Inserir Sensores e Ocorrências Demonstrativas
INSERT INTO sensor (id_sensor, id_area, id_usuario, tipo, localizacao, valor_medido, unidade, origem, status) VALUES
(1, 1, 1, 'Qualidade da água', 'Santa Rosa do Purus', 38.90, '%', 'automático', 'ativo'),
(2, 2, 2, 'Falta de energia', 'Santa Rosa do Purus', 18.00, 'horas', 'manual', 'ativo'),
(3, 3, 1, 'Perda de sinal de internet', 'Santa Rosa do Purus', NULL, NULL, 'manual', 'ativo')
ON DUPLICATE KEY UPDATE tipo = VALUES(tipo);

-- 5. Inserir Alerta Inicial
INSERT INTO alerta (id_alerta, id_sensor, id_usuario_destinatario, tipo, gravidade, status) VALUES
(1, 1, 3, 'Baixa cobertura de água tratada', 'Alta', 'aberto'),
(2, 2, 4, 'Falta de energia prolongada', 'Média', 'aberto')
ON DUPLICATE KEY UPDATE tipo = VALUES(tipo);

-- 6. Inserir Registro de Análise de IA
INSERT INTO analise_ia (id_analise, id_sensor, id_alerta_gerado, prompt, resposta, modelo) VALUES
(1, 1, 1,
 'Analise a ocorrência: Tipo: Qualidade da água, Local: Santa Rosa do Purus, Valor: 38.9%',
 'CRÍTICO: Apenas 38,9% da população com acesso regular a água tratada representa risco iminente de contaminação e doenças hídricas. Ação imediata requer envio de pastilhas de cloração e apoio da Defesa Civil.',
 'openai/gpt-oss-120b')
ON DUPLICATE KEY UPDATE prompt = VALUES(prompt);
