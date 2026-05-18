import 'package:app_gestao/modelos/contagemData.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CidadeInfo.fromJson converte resposta da API de cidade', () {
    final cidade = CidadeInfo.fromJson({
      'dados': {
        'id': 3118601,
        'nome': 'Contagem',
        'estado': 'Minas Gerais',
        'uf': 'MG',
        'regiao': 'Sudeste',
        'gentilico': 'contagense',
        'coordenadas': {'latitude': -19.9162, 'longitude': -44.0809},
        'area_km2': 195.268,
        'ddd': 31,
      }
    });

    expect(cidade.nome, 'Contagem');
    expect(cidade.uf, 'MG');
    expect(cidade.latitude, -19.9162);
    expect(cidade.ddd, 31);
  });

  test('PontoReferencia.fromJson converte ponto com campos opcionais', () {
    final ponto = PontoReferencia.fromJson({
      'id': 1,
      'nome': 'Parque Municipal',
      'categoria': 'lazer',
      'endereco': 'Contagem - MG',
      'telefone': null,
      'horario': '08:00 as 17:00',
      'latitude': -19.9162,
      'longitude': -44.0809,
      'avaliacao': 4.5,
    });

    expect(ponto.nome, 'Parque Municipal');
    expect(ponto.categoria, 'lazer');
    expect(ponto.telefone, isNull);
    expect(ponto.avaliacao, 4.5);
  });
}
