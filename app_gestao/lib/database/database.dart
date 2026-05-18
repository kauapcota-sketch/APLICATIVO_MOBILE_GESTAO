import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../modelos/contagemData.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await _createUsersTable(db);

    await db.execute('''
      CREATE TABLE cidade (
        id INTEGER PRIMARY KEY,
        nome TEXT,
        estado TEXT,
        uf TEXT,
        regiao TEXT,
        gentilico TEXT,
        latitude REAL,
        longitude REAL,
        area_km2 REAL,
        ddd INTEGER,
        atualizado_em TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE demograficos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        populacao_censo_2022 INTEGER,
        populacao_estimada_2025 INTEGER,
        densidade_demografica REAL,
        escolarizacao_pct REAL,
        mortalidade_infantil REAL,
        idhm REAL,
        atualizado_em TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE pontos (
        id INTEGER PRIMARY KEY,
        nome TEXT,
        categoria TEXT,
        endereco TEXT,
        telefone TEXT,
        horario TEXT,
        latitude REAL,
        longitude REAL,
        avaliacao REAL,
        atualizado_em TEXT
      )
    ''');
  }

  Future<void> _createUsersTable(Database db) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        senha TEXT,
        endereco TEXT,
        criado_em TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE users ADD COLUMN age INTEGER');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS cidade (
          id INTEGER PRIMARY KEY,
          nome TEXT,
          estado TEXT,
          uf TEXT,
          regiao TEXT,
          gentilico TEXT,
          latitude REAL,
          longitude REAL,
          area_km2 REAL,
          ddd INTEGER,
          atualizado_em TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS demograficos (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          populacao_censo_2022 INTEGER,
          populacao_estimada_2025 INTEGER,
          densidade_demografica REAL,
          escolarizacao_pct REAL,
          mortalidade_infantil REAL,
          idhm REAL,
          atualizado_em TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS pontos (
          id INTEGER PRIMARY KEY,
          nome TEXT,
          categoria TEXT,
          endereco TEXT,
          telefone TEXT,
          horario TEXT,
          latitude REAL,
          longitude REAL,
          avaliacao REAL,
          atualizado_em TEXT
        )
      ''');
    }

    if (oldVersion < 3) {
      await db.execute('ALTER TABLE users ADD COLUMN senha TEXT');
      await db.execute('ALTER TABLE users ADD COLUMN endereco TEXT');
      await db.execute('ALTER TABLE users ADD COLUMN criado_em TEXT');
    }
  }

  Future<void> inserirOuAtualizarCidade(Map<String, dynamic> data) async {
    final db = await instance.database;
    await db.insert(
      'cidade',
      {...data, 'atualizado_em': DateTime.now().toIso8601String()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<CidadeInfo?> getCidadeLocal() async {
    final db = await instance.database;
    final result = await db.query('cidade', limit: 1);
    if (result.isEmpty) return null;
    final r = result.first;
    return CidadeInfo(
      id: r['id'] as int,
      nome: r['nome'] as String,
      estado: r['estado'] as String,
      uf: r['uf'] as String,
      regiao: r['regiao'] as String,
      gentilico: r['gentilico'] as String,
      latitude: r['latitude'] as double,
      longitude: r['longitude'] as double,
      areaKm2: r['area_km2'] as double,
      ddd: r['ddd'] as int,
    );
  }

  Future<void> inserirOuAtualizarDemograficos(
    Map<String, dynamic> data,
  ) async {
    final db = await instance.database;
    await db.delete('demograficos');
    await db.insert(
      'demograficos',
      {...data, 'atualizado_em': DateTime.now().toIso8601String()},
    );
  }

  Future<Demograficos?> getDemograficosLocal() async {
    final db = await instance.database;
    final result = await db.query('demograficos', limit: 1);
    if (result.isEmpty) return null;
    final r = result.first;
    return Demograficos(
      populacaoCenso2022: r['populacao_censo_2022'] as int,
      populacaoEstimada2025: r['populacao_estimada_2025'] as int,
      densidadeDemografica: r['densidade_demografica'] as double,
      escolarizacaoPct: r['escolarizacao_pct'] as double,
      mortalidadeInfantil: r['mortalidade_infantil'] as double,
      idhm: r['idhm'] as double,
    );
  }

  Future<void> inserirOuAtualizarPonto(Map<String, dynamic> data) async {
    final db = await instance.database;
    await db.insert(
      'pontos',
      {...data, 'atualizado_em': DateTime.now().toIso8601String()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<PontoReferencia>> getPontosLocal({String? categoria}) async {
    final db = await instance.database;
    final result = categoria != null
        ? await db.query(
            'pontos',
            where: 'categoria = ?',
            whereArgs: [categoria],
          )
        : await db.query('pontos');

    return result
        .map(
          (r) => PontoReferencia(
            id: r['id'] as int,
            nome: r['nome'] as String,
            categoria: r['categoria'] as String,
            endereco: r['endereco'] as String,
            telefone: r['telefone'] as String?,
            horario: r['horario'] as String?,
            latitude: r['latitude'] as double,
            longitude: r['longitude'] as double,
            avaliacao: r['avaliacao'] as double?,
          ),
        )
        .toList();
  }

  Future<int> deletePonto(int id) async {
    final db = await instance.database;
    return await db.delete('pontos', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> createUser(Map<String, dynamic> user) async {
    final db = await instance.database;
    return await db.insert(
      'users',
      {...user, 'criado_em': DateTime.now().toIso8601String()},
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await instance.database;
    return await db.query('users');
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return result.first;
  }

  Future<Map<String, dynamic>?> getUserByEmailAndSenha({
    required String email,
    required String senha,
  }) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senha],
      limit: 1,
    );
    if (result.isEmpty) return null;
    return result.first;
  }

  Future<int> deleteUser(int id) async {
    final db = await instance.database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}