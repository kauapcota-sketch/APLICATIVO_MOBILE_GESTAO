

class CidadeInfo {
  final int id;
  final String nome;
  final String estado;
  final String uf;
  final String regiao;
  final String gentilico;
  final double latitude;
  final double longitude;
  final double areaKm2;
  final int ddd;

  CidadeInfo({
    required this.id,
    required this.nome,
    required this.estado,
    required this.uf,
    required this.regiao,
    required this.gentilico,
    required this.latitude,
    required this.longitude,
    required this.areaKm2,
    required this.ddd,
  });

  factory CidadeInfo.fromJson(Map<String, dynamic> json) {
    final dados = json['dados'];
    return CidadeInfo(
      id: dados['id'],
      nome: dados['nome'],
      estado: dados['estado'],
      uf: dados['uf'],
      regiao: dados['regiao'],
      gentilico: dados['gentilico'],
      latitude: dados['coordenadas']['latitude'].toDouble(),
      longitude: dados['coordenadas']['longitude'].toDouble(),
      areaKm2: dados['area_km2'].toDouble(),
      ddd: dados['ddd'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'estado': estado,
        'uf': uf,
        'regiao': regiao,
        'gentilico': gentilico,
        'latitude': latitude,
        'longitude': longitude,
        'area_km2': areaKm2,
        'ddd': ddd,
      };
}

class Demograficos {
  final int populacaoCenso2022;
  final int populacaoEstimada2025;
  final double densidadeDemografica;
  final double escolarizacaoPct;
  final double mortalidadeInfantil;
  final double idhm;

  Demograficos({
    required this.populacaoCenso2022,
    required this.populacaoEstimada2025,
    required this.densidadeDemografica,
    required this.escolarizacaoPct,
    required this.mortalidadeInfantil,
    required this.idhm,
  });

  factory Demograficos.fromJson(Map<String, dynamic> json) {
    final d = json['dados'];
    return Demograficos(
      populacaoCenso2022: d['populacao_censo_2022'],
      populacaoEstimada2025: d['populacao_estimada_2025'],
      densidadeDemografica: d['densidade_demografica'].toDouble(),
      escolarizacaoPct: d['escolarizacao_6_14_anos_pct'].toDouble(),
      mortalidadeInfantil: d['mortalidade_infantil_por_mil'].toDouble(),
      idhm: d['idhm'].toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
        'populacao_censo_2022': populacaoCenso2022,
        'populacao_estimada_2025': populacaoEstimada2025,
        'densidade_demografica': densidadeDemografica,
        'escolarizacao_pct': escolarizacaoPct,
        'mortalidade_infantil': mortalidadeInfantil,
        'idhm': idhm,
      };
}

class PontoReferencia {
  final int id;
  final String nome;
  final String categoria;
  final String endereco;
  final String? telefone;
  final String? horario;
  final double latitude;
  final double longitude;
  final double? avaliacao;

  PontoReferencia({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.endereco,
    this.telefone,
    this.horario,
    required this.latitude,
    required this.longitude,
    this.avaliacao,
  });

  factory PontoReferencia.fromJson(Map<String, dynamic> json) {
    return PontoReferencia(
      id: json['id'],
      nome: json['nome'],
      categoria: json['categoria'],
      endereco: json['endereco'],
      telefone: json['telefone'],
      horario: json['horario'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      avaliacao: json['avaliacao']?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'categoria': categoria,
        'endereco': endereco,
        'telefone': telefone,
        'horario': horario,
        'latitude': latitude,
        'longitude': longitude,
        'avaliacao': avaliacao,
      };
}
