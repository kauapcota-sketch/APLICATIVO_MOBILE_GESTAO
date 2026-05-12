// services/contagem_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modelos/contagemData.dart';
import '../database/database.dart';

class ContagemService {
  // Flutter Web (Chrome): usa localhost
  // Emulador Android: 10.0.2.2
  // Emulador iOS: 127.0.0.1
  // Celular físico: IP local da máquina (ex: 192.168.1.X)
  static const String _baseUrl = 'http://localhost:3000';

  final DatabaseHelper _db = DatabaseHelper.instance;

  // ─────────────────────────────────────────────
  //  BUSCAR DA API + SALVAR NO BANCO LOCAL
  // ─────────────────────────────────────────────

  Future<CidadeInfo?> fetchEsalvarCidade() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/cidade'));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final cidade = CidadeInfo.fromJson(json);
        await _db.inserirOuAtualizarCidade(cidade.toMap());
        return cidade;
      }
    } catch (e) {
      print('Erro ao buscar cidade: $e');
    }
    // fallback: busca do banco local
    return await _db.getCidadeLocal();
  }

  Future<Demograficos?> fetchEsalvarDemograficos() async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/cidade/demograficos'));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final dem = Demograficos.fromJson(json);
        await _db.inserirOuAtualizarDemograficos(dem.toMap());
        return dem;
      }
    } catch (e) {
      print('Erro ao buscar demograficos: $e');
    }
    return await _db.getDemograficosLocal();
  }

  Future<List<PontoReferencia>> fetchEsalvarPontos({
    String? categoria,
  }) async {
    try {
      final url = categoria != null
          ? '$_baseUrl/pontos?categoria=$categoria'
          : '$_baseUrl/pontos';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final lista = (json['dados'] as List)
            .map((e) => PontoReferencia.fromJson(e))
            .toList();

        // Salva cada ponto no banco local
        for (final ponto in lista) {
          await _db.inserirOuAtualizarPonto(ponto.toMap());
        }
        return lista;
      }
    } catch (e) {
      print('Erro ao buscar pontos: $e');
    }
    // fallback: busca do banco local
    return await _db.getPontosLocal(categoria: categoria);
  }

  Future<List<PontoReferencia>> buscarPontosProximos({
    required double lat,
    required double lng,
    double raioKm = 3,
  }) async {
    try {
      final url =
          '$_baseUrl/pontos/proximos?lat=$lat&lng=$lng&raio=$raioKm';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return (json['dados'] as List)
            .map((e) => PontoReferencia.fromJson(e))
            .toList();
      }
    } catch (e) {
      print('Erro ao buscar pontos próximos: $e');
    }
    return [];
  }
}