import 'package:flutter/material.dart';
import '../modelos/contagemData.dart';
import '../servicos/contagemServices.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ContagemService _service = ContagemService();

  CidadeInfo? _cidade;
  Demograficos? _demograficos;
  List<PontoReferencia> _pontos = [];

  bool _carregando = true;
  String? _erro;
  String _categoriaFiltro = 'todos';

  final List<String> _categorias = [
    'todos', 'saude', 'lazer', 'governo', 'comercio', 'abastecimento'
  ];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  // ─────────────────────────────────────────────
  //  CARREGAMENTO
  // ─────────────────────────────────────────────

  Future<void> _carregarDados() async {
    setState(() { _carregando = true; _erro = null; });

    try {
      // Busca em paralelo para ser mais rápido
      final resultados = await Future.wait([
        _service.fetchEsalvarCidade(),
        _service.fetchEsalvarDemograficos(),
        _service.fetchEsalvarPontos(),
      ]);

      setState(() {
        _cidade       = resultados[0] as CidadeInfo?;
        _demograficos = resultados[1] as Demograficos?;
        _pontos       = resultados[2] as List<PontoReferencia>;
        _carregando   = false;
      });
    } catch (e) {
      setState(() {
        _erro       = 'Erro ao carregar dados: $e';
        _carregando = false;
      });
    }
  }

  Future<void> _filtrarPorCategoria(String categoria) async {
    setState(() { _categoriaFiltro = categoria; _carregando = true; });

    final pontos = await _service.fetchEsalvarPontos(
      categoria: categoria == 'todos' ? null : categoria,
    );

    setState(() { _pontos = pontos; _carregando = false; });
  }

  // ─────────────────────────────────────────────
  //  UI
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contagem - MG'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarDados,
          ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _erro != null
              ? _buildErro()
              : _buildConteudo(),
    );
  }

  Widget _buildErro() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text(_erro!, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _carregarDados,
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  Widget _buildConteudo() {
    return RefreshIndicator(
      onRefresh: _carregarDados,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_cidade != null) _cardCidade(),
          const SizedBox(height: 12),
          if (_demograficos != null) _cardDemograficos(),
          const SizedBox(height: 20),
          _filtrosCategorias(),
          const SizedBox(height: 12),
          ..._pontos.map(_cardPonto),
        ],
      ),
    );
  }

  // ─── Card Cidade ───

  Widget _cardCidade() {
    final c = _cidade!;
    return Card(
      child: ListTile(
        leading: const Icon(Icons.location_city, size: 36),
        title: Text(c.nome,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text('${c.estado} · ${c.regiao}\n'
            'Lat: ${c.latitude} | Lng: ${c.longitude}\n'
            'Área: ${c.areaKm2} km² · DDD: ${c.ddd}'),
        isThreeLine: true,
      ),
    );
  }

  // ─── Card Demográficos ───

  Widget _cardDemograficos() {
    final d = _demograficos!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dados Populacionais',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Divider(),
            _linhaInfo('População (censo 2022)',
                '${d.populacaoCenso2022.toString().replaceAllMapped(
                  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  (m) => '${m[1]}.',
                )} hab.'),
            _linhaInfo('Estimativa 2025', '${d.populacaoEstimada2025} hab.'),
            _linhaInfo('Densidade', '${d.densidadeDemografica} hab/km²'),
            _linhaInfo('IDHM', d.idhm.toString()),
            _linhaInfo('Escolarização 6–14 anos', '${d.escolarizacaoPct}%'),
          ],
        ),
      ),
    );
  }

  Widget _linhaInfo(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.grey)),
          Text(valor,
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ─── Filtros de Categoria ───

  Widget _filtrosCategorias() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categorias.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final cat = _categorias[i];
          final ativo = cat == _categoriaFiltro;
          return ChoiceChip(
            label: Text(cat),
            selected: ativo,
            onSelected: (_) => _filtrarPorCategoria(cat),
          );
        },
      ),
    );
  }

  // ─── Card Ponto ───

  Widget _cardPonto(PontoReferencia p) {
    final icones = {
      'saude': Icons.local_hospital,
      'lazer': Icons.park,
      'governo': Icons.account_balance,
      'comercio': Icons.shopping_bag,
      'abastecimento': Icons.storefront,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icones[p.categoria] ?? Icons.place, color: Colors.blue),
        title: Text(p.nome,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(p.endereco),
            if (p.horario != null)
              Text(p.horario!,
                  style: const TextStyle(color: Colors.green, fontSize: 12)),
            if (p.avaliacao != null)
              Row(children: [
                const Icon(Icons.star, size: 14, color: Colors.amber),
                Text(' ${p.avaliacao}',
                    style: const TextStyle(fontSize: 12)),
              ]),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
