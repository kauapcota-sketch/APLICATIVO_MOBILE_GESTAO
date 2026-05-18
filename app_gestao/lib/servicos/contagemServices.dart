import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../database/database.dart';
import '../modelos/contagemData.dart';

class ContagemService {
  static const String _configuredBaseUrl =
      String.fromEnvironment('CONTAGEM_API_URL');

  static String get _baseUrl {
    if (_configuredBaseUrl.isNotEmpty) return _configuredBaseUrl;
    if (kIsWeb) return 'http://localhost:3000';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://localhost:3000';
  }

  final DatabaseHelper _db = DatabaseHelper.instance;

  Future<http.Response> _get(String path, [Map<String, String>? query]) {
    final uri = Uri.parse(_baseUrl).replace(
      path: path,
      queryParameters: query,
    );
    return http.get(uri).timeout(const Duration(seconds: 10));
  }

  Future<CidadeInfo?> fetchEsalvarCidade() async {
    try {
      final response = await _get('/cidade');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final cidade = CidadeInfo.fromJson(json);
        await _db.inserirOuAtualizarCidade(cidade.toMap());
        return cidade;
      }

      debugPrint('Erro ao buscar cidade: HTTP ${response.statusCode}');
    } catch (e) {
      debugPrint('Erro ao buscar cidade em $_baseUrl: $e');
    }

    return await _db.getCidadeLocal();
  }

  Future<Demograficos?> fetchEsalvarDemograficos() async {
    try {
      final response = await _get('/cidade/demograficos');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final dem = Demograficos.fromJson(json);
        await _db.inserirOuAtualizarDemograficos(dem.toMap());
        return dem;
      }

      debugPrint('Erro ao buscar demograficos: HTTP ${response.statusCode}');
    } catch (e) {
      debugPrint('Erro ao buscar demograficos em $_baseUrl: $e');
    }

    return await _db.getDemograficosLocal();
  }

  Future<List<PontoReferencia>> fetchEsalvarPontos({
    String? categoria,
  }) async {
    try {
      final response = await _get(
        '/pontos',
        categoria != null ? {'categoria': categoria} : null,
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final lista = (json['dados'] as List)
            .map((e) => PontoReferencia.fromJson(e))
            .toList();

        for (final ponto in lista) {
          await _db.inserirOuAtualizarPonto(ponto.toMap());
        }
        return lista;
      }

      debugPrint('Erro ao buscar pontos: HTTP ${response.statusCode}');
    } catch (e) {
      debugPrint('Erro ao buscar pontos em $_baseUrl: $e');
    }

    return await _db.getPontosLocal(categoria: categoria);
  }

  Future<List<PontoReferencia>> buscarPontosProximos({
    required double lat,
    required double lng,
    double raioKm = 3,
  }) async {
    try {
      final response = await _get('/pontos/proximos', {
        'lat': lat.toString(),
        'lng': lng.toString(),
        'raio': raioKm.toString(),
      });

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return (json['dados'] as List)
            .map((e) => PontoReferencia.fromJson(e))
            .toList();
      }

      debugPrint('Erro ao buscar pontos proximos: HTTP ${response.statusCode}');
    } catch (e) {
      debugPrint('Erro ao buscar pontos proximos em $_baseUrl: $e');
    }

    return [];
  }
}