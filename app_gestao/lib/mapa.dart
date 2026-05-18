import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../modelos/contagemData.dart';
import '../servicos/contagemServices.dart';

class MapaPage extends StatefulWidget {
  const MapaPage({super.key});

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final ContagemService _service = ContagemService();
  final MapController _mapController = MapController();
  final Distance _distance = const Distance();

  final LatLng _contagem = const LatLng(-19.9162, -44.0809);
  List<PontoReferencia> _farmacias = [];
  bool _carregando = true;
  LatLng? _cliente;
  String? _erroLocalizacao;

  @override
  void initState() {
    super.initState();
    _carregarFarmacias();
  }

  Future<void> _carregarFarmacias() async {
    setState(() => _carregando = true);
    final pontos = await _service.fetchEsalvarPontos();
    final farmaciasPorNome = pontos.where(_ehFarmacia).toList();
    final pontosDeSaude = pontos.where(_ehPontoDeSaude).toList();

    setState(() {
      _farmacias =
          farmaciasPorNome.isNotEmpty ? farmaciasPorNome : pontosDeSaude;
      _carregando = false;
    });
  }

  bool _ehFarmacia(PontoReferencia ponto) {
    final texto = _normalizarTexto(
      '${ponto.nome} ${ponto.categoria} ${ponto.endereco}',
    );
    return texto.contains('farmacia');
  }

  bool _ehPontoDeSaude(PontoReferencia ponto) {
    return _normalizarTexto(ponto.categoria).contains('saude');
  }

  String _normalizarTexto(String valor) {
    return valor
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('â', 'a')
        .replaceAll('ã', 'a')
        .replaceAll('é', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ç', 'c')
        .replaceAll('Ã¡', 'a')
        .replaceAll('Ã£', 'a')
        .replaceAll('Ã§', 'c');
  }

  Future<void> _localizarCliente() async {
    setState(() => _erroLocalizacao = null);

    final servicoAtivo = await Geolocator.isLocationServiceEnabled();
    if (!servicoAtivo) {
      setState(() {
        _erroLocalizacao = 'Ative a localizacao para calcular a distancia.';
      });
      return;
    }

    var permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
    }

    if (permissao == LocationPermission.denied ||
        permissao == LocationPermission.deniedForever) {
      setState(() {
        _erroLocalizacao = 'Permita a localizacao para calcular a distancia.';
      });
      return;
    }

    final posicao = await Geolocator.getCurrentPosition();
    final cliente = LatLng(posicao.latitude, posicao.longitude);
    setState(() => _cliente = cliente);
    _mapController.move(cliente, 14);
  }

  double? _distanciaKm(PontoReferencia farmacia) {
    final cliente = _cliente;
    if (cliente == null) return null;

    return _distance.as(
      LengthUnit.Kilometer,
      cliente,
      LatLng(farmacia.latitude, farmacia.longitude),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2A44),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2A44),
        title: const Text(
          'Farmacias - Contagem MG',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          if (_erroLocalizacao != null)
            Container(
              width: double.infinity,
              color: Colors.amber.shade700,
              padding: const EdgeInsets.all(10),
              child: Text(
                _erroLocalizacao!,
                style: const TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator())
                : _farmacias.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma farmacia encontrada no mapa.',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _contagem,
                          initialZoom: 13,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.app_gestao',
                          ),
                          if (_cliente != null)
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: _cliente!,
                                  width: 46,
                                  height: 46,
                                  child: const Icon(
                                    Icons.person_pin_circle,
                                    color: Colors.blue,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          MarkerLayer(
                            markers: _farmacias.map((farmacia) {
                              return Marker(
                                point: LatLng(
                                  farmacia.latitude,
                                  farmacia.longitude,
                                ),
                                width: 64,
                                height: 64,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => _mostrarDetalhes(farmacia),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.local_pharmacy,
                                      color: Colors.red,
                                      size: 42,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: _localizarCliente,
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }

  void _mostrarDetalhes(PontoReferencia farmacia) {
    final distanciaKm = _distanciaKm(farmacia);

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F2A44),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.local_pharmacy, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    farmacia.nome,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (distanciaKm != null)
              _linha(
                Icons.route,
                '${distanciaKm.toStringAsFixed(2)} km de distancia',
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.pop(context);
                    await _localizarCliente();
                    if (!mounted) return;
                    _mostrarDetalhes(farmacia);
                  },
                  icon: const Icon(Icons.my_location),
                  label: const Text('Calcular distancia ate aqui'),
                ),
              ),
            _linha(Icons.location_on, farmacia.endereco),
            if (farmacia.horario != null)
              _linha(Icons.access_time, farmacia.horario!),
            if (farmacia.telefone != null)
              _linha(Icons.phone, farmacia.telefone!),
            if (farmacia.avaliacao != null)
              _linha(Icons.star, '${farmacia.avaliacao} estrelas'),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _linha(IconData icone, String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icone, color: Colors.white54, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
