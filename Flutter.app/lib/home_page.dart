import 'package:flutter/material.dart';
import 'api_service.dart';
import 'sensor_form_page.dart';

class HomePage extends StatefulWidget {
  final ApiService apiService;

  const HomePage({super.key, required this.apiService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Lista das 6 frentes do ODS 9 monitoradas
  final List<Map<String, dynamic>> _areasODS = [
    {
      'titulo': 'Saneamento & Água',
      'icone': Icons.water_drop,
      'status': 'Crítico',
      'corStatus': Color(0xFFD32F2F),
      'indicador': '38.9% com água tratada',
      'local': 'Santa Rosa do Purus (AC)',
      'descricao': 'Comunidades ribeirinhas com alta dependência de poços e rios.',
    },
    {
      'titulo': 'Energia Elétrica',
      'icone': Icons.bolt,
      'status': 'Atenção',
      'corStatus': Color(0xFFF57C00),
      'indicador': 'Sistemas Isolados',
      'local': '160 localidades da Amazônia',
      'descricao': 'Geração térmica a diesel e microrredes solares intermitentes.',
    },
    {
      'titulo': 'Conectividade',
      'icone': Icons.wifi,
      'status': 'Atenção',
      'corStatus': Color(0xFFF57C00),
      'indicador': 'Satélite Comunitário',
      'local': 'Áreas remotas',
      'descricao': 'Sinal sujeito a intempéries climáticas e quedas frequentes.',
    },
    {
      'titulo': 'Saúde & UBS',
      'icone': Icons.local_hospital,
      'status': 'Normal',
      'corStatus': Color(0xFF2E7D32),
      'indicador': 'Telemedicina Ativa',
      'local': 'Postos Locais',
      'descricao': 'Monitoramento preventivo e suporte a agentes comunitários.',
    },
    {
      'titulo': 'Educação',
      'icone': Icons.school,
      'status': 'Normal',
      'corStatus': Color(0xFF2E7D32),
      'indicador': 'Aulas Regulares',
      'local': 'Escolas Ribeirinhas',
      'descricao': 'Acompanhamento de infraestrutura escolar e merenda.',
    },
    {
      'titulo': 'Meio Ambiente',
      'icone': Icons.forest,
      'status': 'Atenção',
      'corStatus': Color(0xFFF57C00),
      'indicador': 'Monitoramento de Fumaça',
      'local': 'Calha dos Rios',
      'descricao': 'Vigilância contra focos de queimada e estiagem severa.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF176B45),
        elevation: 0,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(40),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.eco, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Amazônia Inteligente',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'ODS 9 • Infraestrutura & Inovação',
                  style: TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Sobre o Projeto',
            onPressed: () => _mostrarSobre(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CABEÇALHO HERO COM IDENTIDADE AMAZÔNICA
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: const BoxDecoration(
                color: Color(0xFF176B45),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(35),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '📍 Comunidades Isoladas da Amazônia Legal',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Monitoramento Inteligente de Serviços Essenciais',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Detecção rápida com Inteligência Artificial para apoiar moradores, agentes de saúde e gestores públicos.',
                    style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 18),

                  // BOTÃO DE AÇÃO PRINCIPAL
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SensorFormPage(widget.apiService),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_alert_rounded, color: Color(0xFF176B45), size: 24),
                      label: const Text(
                        'REPORTAR NOVA OCORRÊNCIA',
                        style: TextStyle(
                          color: Color(0xFF176B45),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ESTATÍSTICA REAL DE SANTA ROSA DO PURUS (AC)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.water_damage_outlined,
                          color: Color(0xFF176B45),
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DADO DE REFERÊNCIA REAL',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF176B45),
                                letterSpacing: 0.8,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Santa Rosa do Purus (AC)',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Apenas 38,9% da população tem água tratada. 96,9% de quilombolas com precariedade de saneamento.',
                              style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // SEÇÃO DAS 6 FRENTES MONITORADAS
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Áreas Monitoradas (6 Frentes)',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF176B45),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF176B45).withAlpha(20),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'ODS 9',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF176B45),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // GRID DAS 6 FRENTES
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _areasODS.length,
              itemBuilder: (context, index) {
                final area = _areasODS[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  color: Colors.white,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF176B45).withAlpha(18),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(area['icone'] as IconData, color: const Color(0xFF176B45)),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          area['titulo'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: (area['corStatus'] as Color).withAlpha(25),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: area['corStatus'] as Color, width: 1),
                          ),
                          child: Text(
                            area['status'] as String,
                            style: TextStyle(
                              color: area['corStatus'] as Color,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          '${area['indicador']} • ${area['local']}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          area['descricao'] as String,
                          style: const TextStyle(fontSize: 11, color: Colors.black54),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SensorFormPage(widget.apiService),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _mostrarSobre(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.eco, color: Color(0xFF176B45)),
            SizedBox(width: 8),
            Text('Amazônia Inteligente'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Plataforma Inteligente de Monitoramento de Infraestrutura e Serviços Essenciais em Comunidades Isoladas da Amazônia.',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 12),
              Text(
                '• ODS 9: Indústria, Inovação e Infraestrutura\n'
                '• 6 Frentes: Conectividade, Energia, Saneamento, Saúde, Educação e Meio Ambiente\n'
                '• Classificação Automática por IA: Normal, Atenção e Crítico\n'
                '• Arquitetura Offline-First pensada para a realidade da floresta.',
                style: TextStyle(fontSize: 13, height: 1.5),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('FECHAR', style: TextStyle(color: Color(0xFF176B45), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
