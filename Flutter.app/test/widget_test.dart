import 'package:flutter_test/flutter_test.dart';
import 'package:amazonia_inteligente/main.dart';
import 'package:amazonia_inteligente/home_page.dart';
import 'package:amazonia_inteligente/sensor.dart';
import 'package:amazonia_inteligente/api_service.dart';

void main() {
  testWidgets('Renderiza a HomePage do Amazônia Inteligente', (WidgetTester tester) async {
    await tester.pumpWidget(const AmazoniaInteligenteApp());
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Amazônia Inteligente'), findsWidgets);
    expect(find.text('REPORTAR NOVA OCORRÊNCIA'), findsOneWidget);
    expect(find.text('Santa Rosa do Purus (AC)'), findsOneWidget);
  });

  test('Teste de serialização do modelo Sensor', () {
    final sensor = Sensor(
      id: 1,
      tipo: 'Falta de água',
      localizacao: 'Santa Rosa do Purus - Acre (AC)',
      valorMedido: 38.9,
      unidade: '%',
    );

    final json = sensor.toJson();
    expect(json['tipo'], 'Falta de água');
    expect(json['valorMedido'], 38.9);

    final reconstituido = Sensor.fromJson(json);
    expect(reconstituido.tipo, 'Falta de água');
    expect(reconstituido.localizacao, 'Santa Rosa do Purus - Acre (AC)');
  });

  test('Teste do fallback inteligente de IA na ApiService', () async {
    final apiService = ApiService(baseUrl: 'http://127.0.0.1:9999/invalido');
    final sensor = Sensor(
      id: 10,
      tipo: 'Falta de água',
      localizacao: 'Santa Rosa do Purus - Acre (AC)',
      valorMedido: 0,
      unidade: 'horas',
    );

    final resultado = await apiService.cadastrarSensor(sensor);
    expect(resultado.unidade, isNotNull);
    expect(resultado.unidade!.contains('CRÍTICO'), isTrue);
  });
}
