import 'package:flutter/material.dart';
import 'api_service.dart';
import 'sensor.dart';
import 'resultado_page.dart';

class SensorFormPage extends StatefulWidget {
  final ApiService _apiService;

  const SensorFormPage(this._apiService, {super.key});

  @override
  State<SensorFormPage> createState() => _SensorFormPageState();
}

class _SensorFormPageState extends State<SensorFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _tipoController = TextEditingController();
  final _estadoController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _valorMedidoController = TextEditingController();
  final _unidadeController = TextEditingController();

  bool _carregando = false;

  final List<Map<String, dynamic>> _tiposComIcone = [
    {'label': 'Nível da água', 'icon': Icons.water},
    {'label': 'Qualidade da água', 'icon': Icons.science},
    {'label': 'Falta de água', 'icon': Icons.invert_colors_off},
    {'label': 'Falta de energia', 'icon': Icons.flash_off},
    {'label': 'Sinal de internet/comunicação', 'icon': Icons.wifi_off},
    {'label': 'Posto de saúde / Atendimento médico', 'icon': Icons.local_hospital},
    {'label': 'Queimada / Fumaça', 'icon': Icons.local_fire_department},
    {'label': 'Desmatamento', 'icon': Icons.forest},
  ];

  final Map<String, List<String>> _unidadesPorTipo = {
    'Nível da água': ['%', 'm (metros)'],
    'Qualidade da água': ['pH', 'NTU (turbidez)'],
    'Falta de água': ['horas', 'dias'],
    'Falta de energia': ['horas', 'dias'],
    'Sinal de internet/comunicação': ['horas', 'dias'],
    'Posto de saúde / Atendimento médico': ['%', 'casos'],
    'Queimada / Fumaça': ['km (distância)'],
    'Desmatamento': ['ha (hectares)', 'km²'],
  };

  final Map<String, List<String>> _cidadesPorEstado = {
    'Acre (AC)': [
      'Rio Branco',
      'Cruzeiro do Sul',
      'Sena Madureira',
      'Tarauacá',
      'Feijó',
      'Brasiléia',
      'Senador Guiomard',
      'Plácido de Castro',
      'Xapuri',
      'Mâncio Lima',
      'Porto Acre',
      'Marechal Thaumaturgo',
      'Santa Rosa do Purus',
      'Jordão',
      'Rodrigues Alves'
    ],
    'Amapá (AP)': [
      'Macapá',
      'Santana',
      'Laranjal do Jari',
      'Oiapoque',
      'Mazagão',
      'Porto Grande',
      'Tartarugalzinho',
      'Pedra Branca do Amapari'
    ],
    'Amazonas (AM)': [
      'Manaus',
      'Parintins',
      'Itacoatiara',
      'Manacapuru',
      'Coari',
      'Tabatinga',
      'Maués',
      'Tefé',
      'Humaitá',
      'São Gabriel da Cachoeira',
      'Eirunepé',
      'Lábrea',
      'Iranduba',
      'São Paulo de Olivença',
      'Atalaia do Norte'
    ],
    'Maranhão (MA)': [
      'São Luís',
      'Imperatriz',
      'Caxias',
      'Timon',
      'Codó',
      'Açailândia',
      'Bacabal',
      'Balsas',
      'Santa Inês',
      'Barra do Corda'
    ],
    'Mato Grosso (MT)': [
      'Cuiabá',
      'Várzea Grande',
      'Rondonópolis',
      'Sinop',
      'Tangará da Serra',
      'Sorriso',
      'Lucas do Rio Verde',
      'Primavera do Leste',
      'Barra do Garças',
      'Alta Floresta'
    ],
    'Pará (PA)': [
      'Belém',
      'Ananindeua',
      'Santarém',
      'Marabá',
      'Parauapebas',
      'Castanhal',
      'Abaetetuba',
      'Cametá',
      'Altamira',
      'Tucuruí',
      'Itaituba',
      'Redenção',
      'Barcarena'
    ],
    'Rondônia (RO)': [
      'Porto Velho',
      'Ji-Paraná',
      'Ariquemes',
      'Vilhena',
      'Cacoal',
      'Rolim de Moura',
      'Jaru',
      'Guajará-Mirim',
      'Ouro Preto do Oeste'
    ],
    'Roraima (RR)': [
      'Boa Vista',
      'Rorainópolis',
      'Caracaraí',
      'Pacaraima',
      'Canta',
      'Mucajaí',
      'Alto Alegre',
      'Bonfim'
    ],
    'Tocantins (TO)': [
      'Palmas',
      'Araguaína',
      'Gurupi',
      'Porto Nacional',
      'Paraíso do Tocantins',
      'Colinas do Tocantins',
      'Guaraí',
      'Tocantinópolis'
    ],
  };

  List<String> _unidadesDisponiveis = [];
  List<String> _cidadesDisponiveis = [];

  @override
  void dispose() {
    _tipoController.dispose();
    _estadoController.dispose();
    _cidadeController.dispose();
    _valorMedidoController.dispose();
    _unidadeController.dispose();
    super.dispose();
  }

  void _aoSelecionarTipo(String? tipoSelecionado) {
    if (tipoSelecionado == null) return;

    setState(() {
      _unidadesDisponiveis = _unidadesPorTipo[tipoSelecionado] ?? [];
      if (_unidadesDisponiveis.length == 1) {
        _unidadeController.text = _unidadesDisponiveis.first;
      } else {
        _unidadeController.clear();
      }
    });
  }

  void _aoSelecionarEstado(String? estadoSelecionado) {
    if (estadoSelecionado == null) return;

    setState(() {
      _cidadesDisponiveis = _cidadesPorEstado[estadoSelecionado] ?? [];
      _cidadeController.clear();
    });
  }

  Future<void> cadastrarSensor() async {
    if (_formKey.currentState!.validate()) {
      if (_tipoController.text.trim().isEmpty) {
        _exibirAviso('Por favor, selecione o tipo de ocorrência.');
        return;
      }

      if (_estadoController.text.trim().isEmpty || _cidadeController.text.trim().isEmpty) {
        _exibirAviso('Por favor, informe o Estado e o Município/Comunidade.');
        return;
      }

      final String localizacaoCompleta =
          '${_cidadeController.text.trim()} - ${_estadoController.text.trim()}';

      if (_tipoController.text.isNotEmpty &&
          _unidadesPorTipo.containsKey(_tipoController.text)) {
        final permitidas = _unidadesPorTipo[_tipoController.text]!;
        if (_unidadeController.text.isNotEmpty &&
            !permitidas.contains(_unidadeController.text)) {
          _exibirAviso('Unidade inválida para "${_tipoController.text}". Use: ${permitidas.join(", ")}');
          return;
        }
      }

      setState(() {
        _carregando = true;
      });

      final sensor = Sensor(
        id: 0,
        tipo: _tipoController.text,
        localizacao: localizacaoCompleta,
        valorMedido: _valorMedidoController.text.isNotEmpty
            ? double.tryParse(_valorMedidoController.text)
            : null,
        unidade: _unidadeController.text,
      );

      try {
        final Sensor resultado = await widget._apiService.cadastrarSensor(sensor);
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultadoPage(
              analiseIa: resultado.unidade ?? 'Análise concluída com sucesso.',
              tipoOcorrencia: _tipoController.text,
              localizacao: localizacaoCompleta,
            ),
          ),
        );
      } catch (e) {
        if (!mounted) return;
        _exibirAviso('Erro ao cadastrar ocorrência: $e');
      } finally {
        if (mounted) {
          setState(() {
            _carregando = false;
          });
        }
      }
    }
  }

  void _exibirAviso(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem, style: const TextStyle(fontSize: 15)),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final estadosSugeridos = _cidadesPorEstado.keys.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F5),
      appBar: AppBar(
        title: const Text(
          'Cadastrar Ocorrência',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF176B45),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CARD 1: TIPO DE OCORRÊNCIA
                _buildCardSecao(
                  titulo: '1. O que está acontecendo?',
                  iconeHeader: Icons.report_problem_outlined,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return DropdownMenu<String>(
                        width: constraints.maxWidth,
                        controller: _tipoController,
                        enableFilter: true,
                        requestFocusOnTap: true,
                        hintText: 'Toque para escolher o tipo...',
                        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                        dropdownMenuEntries: _tiposComIcone.map((item) {
                          return DropdownMenuEntry<String>(
                            value: item['label'] as String,
                            label: item['label'] as String,
                            leadingIcon: Icon(item['icon'] as IconData, color: const Color(0xFF176B45)),
                          );
                        }).toList(),
                        onSelected: _aoSelecionarTipo,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // CARD 2: LOCALIZAÇÃO
                _buildCardSecao(
                  titulo: '2. Onde ocorreu?',
                  iconeHeader: Icons.location_on_outlined,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Estado (UF) — Amazônia Legal',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
                      ),
                      const SizedBox(height: 6),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return DropdownMenu<String>(
                            width: constraints.maxWidth,
                            controller: _estadoController,
                            enableFilter: true,
                            requestFocusOnTap: true,
                            hintText: 'Selecione o Estado...',
                            textStyle: const TextStyle(fontSize: 15),
                            dropdownMenuEntries: estadosSugeridos.map((String estado) {
                              return DropdownMenuEntry<String>(
                                value: estado,
                                label: estado,
                                leadingIcon: const Icon(Icons.map_outlined, color: Color(0xFF176B45)),
                              );
                            }).toList(),
                            onSelected: _aoSelecionarEstado,
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Município / Comunidade Isolada',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
                      ),
                      const SizedBox(height: 6),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return DropdownMenu<String>(
                            key: ValueKey(_cidadesDisponiveis.join(',')),
                            width: constraints.maxWidth,
                            controller: _cidadeController,
                            enableFilter: true,
                            requestFocusOnTap: true,
                            hintText: _estadoController.text.isEmpty
                                ? 'Selecione o Estado primeiro'
                                : 'Escolha ou digite a cidade...',
                            textStyle: const TextStyle(fontSize: 15),
                            dropdownMenuEntries: _cidadesDisponiveis.map((String cidade) {
                              return DropdownMenuEntry<String>(
                                value: cidade,
                                label: cidade,
                                leadingIcon: const Icon(Icons.location_city_outlined, color: Color(0xFF176B45)),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // CARD 3: MEDIÇÃO (OPCIONAL)
                _buildCardSecao(
                  titulo: '3. Detalhes da Medição (Opcional)',
                  iconeHeader: Icons.straighten_outlined,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _valorMedidoController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: const TextStyle(fontSize: 15),
                        decoration: const InputDecoration(
                          labelText: 'Valor Medido',
                          hintText: 'Ex: 38.9 ou 24',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.numbers, color: Color(0xFF176B45)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Unidade de Medida',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
                      ),
                      const SizedBox(height: 6),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return DropdownMenu<String>(
                            key: ValueKey(_unidadesDisponiveis.join(',')),
                            width: constraints.maxWidth,
                            controller: _unidadeController,
                            enableFilter: true,
                            requestFocusOnTap: true,
                            hintText: _tipoController.text.isEmpty
                                ? 'Selecione o Tipo primeiro'
                                : 'Selecione a unidade...',
                            textStyle: const TextStyle(fontSize: 15),
                            dropdownMenuEntries: _unidadesDisponiveis.map((String value) {
                              return DropdownMenuEntry<String>(
                                value: value,
                                label: value,
                                leadingIcon: const Icon(Icons.square_foot_outlined, color: Color(0xFF176B45)),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // BOTÃO PRINCIPAL COM CARREGAMENTO
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _carregando ? null : cadastrarSensor,
                    icon: _carregando
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                        : const Icon(Icons.analytics_outlined, size: 24),
                    label: Text(
                      _carregando ? 'PROCESSANDO ANÁLISE IA...' : 'ENVIAR E ANALISAR COM IA',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF176B45),
                      foregroundColor: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardSecao({
    required String titulo,
    required IconData iconeHeader,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(iconeHeader, color: const Color(0xFF176B45), size: 22),
                const SizedBox(width: 8),
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF176B45),
                  ),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1),
            child,
          ],
        ),
      ),
    );
  }
}
