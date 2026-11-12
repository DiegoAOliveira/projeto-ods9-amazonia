import 'package:flutter/material.dart';
import 'api_service.dart';
import 'sensor_form_page.dart';

void main() {
  runApp(const AmazoniaApp());
}

class AmazoniaApp extends StatelessWidget {
  const AmazoniaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amazônia Inteligente',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF176B45),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F8F5),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final tipo = TextEditingController();
  final local = TextEditingController(
    text: 'Santa Rosa do Purus - AC',
  );
  final valor = TextEditingController();
  String unidade = '%';

  @override
  void dispose() {
    tipo.dispose();
    local.dispose();
    valor.dispose();
    super.dispose();
  }

  void registrar() {
    if (tipo.text.trim().isEmpty ||
        local.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha o tipo e a localização.'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ocorrência preenchida'),
        content: Text(
          'Tipo: ${tipo.text}\n'
          'Local: ${local.text}\n'
          'Valor: ${valor.text.isEmpty ? "Não informado" : "${valor.text} $unidade"}\n\n'
          'Próxima etapa: conectar à API Java.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF176B45),
        foregroundColor: Colors.white,
        title: const Text(
          'Amazônia Inteligente',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: const Icon(Icons.eco),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: ListView(
            padding: const EdgeInsets.all(28),
            children: [
              const Text(
                'MONITORAMENTO COMUNITÁRIO',
                style: TextStyle(
                  color: Color(0xFF176B45),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Cuidando das comunidades da Amazônia.',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Registre problemas de água, energia, '
                'internet, saúde e outros serviços essenciais.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SensorFormPage(_apiService),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF176B45),
                  foregroundColor: Colors.white, // Define o texto/ícones do botão como BRANCO
                ),
                child: const Text(
                  'Cadastrar ocorrência',
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Icon(
                    Icons.shield_outlined,
                    color: Color(0xFF176B45),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Projeto acadêmico alinhado ao ODS 9: '
                      'Indústria, Inovação e Infraestrutura.',
                      style: TextStyle(color: Colors.black54), // Voltado para cinza/escuro para ser legível no fundo claro
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}