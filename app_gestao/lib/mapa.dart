import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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

  List<PontoReferencia> _pontos = [];
  bool _carregando = true;
  String _categoriaFiltro = 'todos';

  final LatLng _contagem = const LatLng(-19.9162, -44.0809);

  final List<String> _categorias = [
    'todos', 'saude', 'lazer', 'governo', 'comercio', 'abastecimento'
  ];

  final Map<String, Color> _cores = {
    'saude':         Colors.red,
    'lazer':         Colors.green,
    'governo':       Colors.blue,
    'comercio':      Colors.orange,
    'abastecimento': Colors.purple,
  };

  final Map<String, IconData> _icones = {
    'saude':         Icons.local_hospital,
    'lazer':         Icons.park,
    'governo':       Icons.account_balance,
    'comercio':      Icons.shopping_bag,
    'abastecimento': Icons.storefront,
  };

  @override
  void initState() {
    super.initState();
    _carregarPontos();
  }

  Future<void> _carregarPontos() async {
    setState(() => _carregando = true);
    final pontos = await _service.fetchEsalvarPontos(
      categoria: _categoriaFiltro == 'todos' ? null : _categoriaFiltro,
    );
    setState(() {
      _pontos = pontos;
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2A44),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2A44),
        title: const Text(
          'Mapa — Contagem MG',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Filtros de categoria
          Container(
            color: const Color(0xFF1F2A44),
            height: 46,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: _categorias.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = _categorias[i];
                final ativo = cat == _categoriaFiltro;
                return GestureDetector(
                  onTap: () {
                    setState(() => _categoriaFiltro = cat);
                    _carregarPontos();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: ativo ? Colors.blue : Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      cat,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 13),
                    ),
                  ),
                );
              },
            ),
          ),

          // Mapa
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator())
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
                      MarkerLayer(
                        markers: _pontos.map((ponto) {
                          final cor = _cores[ponto.categoria] ?? Colors.grey;
                          final icone =
                              _icones[ponto.categoria] ?? Icons.place;
                          return Marker(
                            point: LatLng(ponto.latitude, ponto.longitude),
                            width: 44,
                            height: 44,
                            child: GestureDetector(
                              onTap: () => _mostrarDetalhes(ponto),
                              child: Icon(icone, color: cor, size: 36),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
          ),
        ],
      ),

      // Botão centralizar
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          _mapController.move(_contagem, 13);
        },
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }

  void _mostrarDetalhes(PontoReferencia ponto) {
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
            Row(children: [
              Icon(
                _icones[ponto.categoria] ?? Icons.place,
                color: _cores[ponto.categoria] ?? Colors.grey,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  ponto.nome,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            const SizedBox(height: 10),
            _linha(Icons.location_on, ponto.endereco),
            if (ponto.horario != null)
              _linha(Icons.access_time, ponto.horario!),
            if (ponto.telefone != null)
              _linha(Icons.phone, ponto.telefone!),
            if (ponto.avaliacao != null)
              _linha(Icons.star, '${ponto.avaliacao} estrelas'),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _linha(IconData icone, String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        Icon(icone, color: Colors.white54, size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(texto,
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ),
      ]),
    );
  }
}