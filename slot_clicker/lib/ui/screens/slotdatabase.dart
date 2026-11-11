import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LeaderboardDatabase {
  static final LeaderboardDatabase instance = LeaderboardDatabase._init();
  static Database? _database;

  LeaderboardDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('leaderboard.db');
    return _database!;
  }
//test
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE leaderboard (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_name TEXT NOT NULL,
        score INTEGER NOT NULL
      )
    ''');

    // Sample initial leaderboard entries
    await db.insert('leaderboard', {'player_name': 'High Roller', 'score': 500});
    await db.insert('leaderboard', {'player_name': 'Lucky Spinner', 'score': 250});
    await db.insert('leaderboard', {'player_name': 'Ocean Gambler', 'score': 100});
  }

  Future<List<Map<String, Object?>>> getLeaderboard() async {
    final db = await instance.database;
    return await db.query(
      'leaderboard',
      orderBy: 'score DESC',
    );
  }

  Future<int> insertScore(String name, int score) async {
    final db = await instance.database;
    return await db.insert('leaderboard', {
      'player_name': name,
      'score': score,
    });
  }
}
