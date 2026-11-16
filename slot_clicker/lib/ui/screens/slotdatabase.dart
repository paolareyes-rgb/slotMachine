import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

typedef LeaderboardDatabase = SlotDatabase;

class SlotDatabase {
  static final SlotDatabase instance = SlotDatabase._init();
  static Database? _database;

  SlotDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('slot_game.db');
    return _database!;
  }

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
      CREATE TABLE players (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE spins (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        item1 TEXT NOT NULL,
        item2 TEXT NOT NULL,
        item3 TEXT NOT NULL,
        points_earned REAL NOT NULL,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (player_id) REFERENCES players (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE leaderboard (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_name TEXT NOT NULL,
        score INTEGER NOT NULL
      )
    ''');

    // Sample initial leaderboard entries
    await db.insert('leaderboard', {'player_name': 'Rachel', 'score': 500});
    await db.insert('leaderboard', {'player_name': 'Austin', 'score': 250});
    await db.insert('leaderboard', {'player_name': 'Michelle', 'score': 100});
  }

  /// Adds a new player. Returns -1 if player name already exists.
  Future<int> addPlayer(String name) async {
    final db = await instance.database;
    try {
      return await db.insert('players', {'name': name});
    } catch (e) {
      return -1;
    }
  }

  /// Records a spin result in the database.
  Future<int> recordSpin({
    required int playerId,
    required String item1,
    required String item2,
    required String item3,
    required double pointsEarned,
  }) async {
    final db = await instance.database;
    return await db.insert('spins', {
      'player_id': playerId,
      'item1': item1,
      'item2': item2,
      'item3': item3,
      'points_earned': pointsEarned,
    });
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
