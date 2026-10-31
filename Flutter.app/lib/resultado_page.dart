import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ResultadoPage extends StatelessWidget {
  final String analiseIa;
  final String tipoOcorrencia;
  final String localizacao;

  const ResultadoPage({
    super.key,
    required this.analiseIa,
    required this.tipoOcorrencia,
    required this.localizacao,
  });

  // Identifica o nível de severidade para aplicar cores e ícones dinâmicos
  Map<String, dynamic> _obterEstiloSeveridade(String texto) {
    final t = texto.toLowerCase();
    if (t.contains('emergência') ||
        t.contains('crítico') ||
        t.contains('critico') ||
        t.contains('vermelho')) {
      return {
        'cor': const Color(0xFFD32F2F),
        'fundo': const Color(0xFFFFEBEE),
        'icone': Icons.warning_amber_rounded,
        'label': 'ALERTA MÁXIMO / EMERGÊNCIA',
      };
    } else if (t.contains('atenção') || t.contains('atencao') || t.contains('amarelo')) {
      return {
        'cor': const Color(0xFFF57C00),
        'fundo': const Color(0xFFFFF3E0),
        'icone': Icons.error_outline_rounded,
        'label': 'SITUAÇÃO DE ATENÇÃO',
      };
    } else {
      return {
        'cor': const Color(0xFF2E7D32),
        'fundo': const Color(0xFFE8F5E9),
        'icone': Icons.check_circle_outline_rounded,
        'label': 'SITUAÇÃO NORMAL',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Correção dos caracteres Unicode (\u003e, \u003c, etc.) e formatação
    final String textoTratado = analiseIa
        .replaceAll(r'\u003e', '>')
        .replaceAll(r'\u003c', '<')
        .replaceAll(r'\n', '\n')
        .replaceAll(r'\"', '"')
        .replaceAll('Classificação:', '🚨 **Classificação:**')
        .replaceAll('Resumo da Ocorrência:', '📋 **Resumo da Ocorrência:**')
        .replaceAll(
          'Recomendações de Ação Imediata:',
          '🛠️ **Recomendações de Ação Imediata:**',
        );

    final estiloSeveridade = _obterEstiloSeveridade(textoTratado);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F5),
      appBar: AppBar(
        title: const Text(
          'Análise Inteligente',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF176B45),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CARD 1: BANNER DE CLASSIFICAÇÃO / ALERTAS (DESTAQUE VISUAL)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18.0),
              decoration: BoxDecoration(
                color: estiloSeveridade['fundo'] as Color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: estiloSeveridade['cor'] as Color,
                  width: 2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (estiloSeveridade['cor'] as Color).withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      estiloSeveridade['icone'] as IconData,
                      color: estiloSeveridade['cor'] as Color,
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          estiloSeveridade['label'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: estiloSeveridade['cor'] as Color,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tipoOcorrencia,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '📍 $localizacao',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // CARD 2: CONTEÚDO FORMATADO COM MARKDOWN E ÍCONES
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.psychology_outlined,
                          color: Color(0xFF176B45),
                          size: 26,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Parecer do Agente Virtual IA',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF176B45),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24, thickness: 1),

                    // Renderização do Markdown
                    MarkdownBody(
                      data: textoTratado,
                      selectable: true,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(
                          fontSize: 15,
                          height: 1.6,
                          color: Colors.black87,
                        ),
                        strong: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF176B45),
                        ),
                        listBullet: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF176B45),
                        ),
                        h2: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF176B45),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // BOTÃO DE RETORNO
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                icon: const Icon(Icons.home_outlined),
                label: const Text(
                  'VOLTAR AO INÍCIO',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF176B45),
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
