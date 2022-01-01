import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../entity/retro.dart';

class AppDatabase {
  final String _tableName = 'Retro';
  final String _columnId = 'id';
  final String _columnPlus = 'plus';
  final String _columnDelta = 'delta';
  final String _columnNextAction = 'next_action';
  final String _columnCreatedAt = 'created_at';

  late Database _database;

  Future<Database> get database async {
    // if (_database != null) return _database;
    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'retro.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTable,
    );
  }

  Future<void> _createTable(Database db, int version) async {
    String sql = '''
      CREATE TABLE $_tableName(
        $_columnId TEXT PRIMARY KEY,
        $_columnPlus TEXT,
        $_columnDelta TEXT,
        $_columnNextAction TEXT,
        $_columnCreatedAt TEXT
      )
    ''';

    return await db.execute(sql);
  }

  Future<List<Retro>> loadAllRetro() async {
    final db = await database;
    var maps = await db.query(
      _tableName,
      orderBy: '$_columnCreatedAt DESC',
    );

    if (maps.isEmpty) return [];

    return maps.map((map) => fromMap(map)).toList();
  }

  Future insert(Retro retro) async {
    final db = await database;
    return await db.insert(_tableName, toMap(retro));
  }

  Future update(Retro retro) async {
    final db = await database;
    return await db.update(
      _tableName,
      toMap(retro),
      where: '$_columnId = ?',
      whereArgs: [retro.id],
    );
  }

  Future delete(Retro retro) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [retro.id],
    );
  }

  Map<String, dynamic> toMap(Retro retro) {
    return {
      _columnId: retro.id,
      _columnPlus: retro.plus,
      _columnDelta: retro.delta,
      _columnNextAction: retro.nextAction,
      _columnCreatedAt: retro.createdAt.toUtc().toIso8601String()
    };
  }

  Retro fromMap(Map<String, dynamic> json) {
    return Retro(
      id: json[_columnId],
      plus: json[_columnPlus],
      delta: json[_columnDelta],
      nextAction: json[_columnNextAction],
      createdAt: DateTime.parse(json[_columnCreatedAt]).toLocal(),
    );
  }
}