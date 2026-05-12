import 'package:agen_nusantara/features/login/model/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  static const String usersTable = 'users';
  static const String tasksTable = 'tasks';

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'agen_nusantara.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $usersTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE $tasksTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        dueDate TEXT NOT NULL,
        taskType TEXT DEFAULT 'BIASA',
        status TEXT DEFAULT 'pending',
        createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (username) REFERENCES $usersTable(username)
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tasksTable (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT NOT NULL,
          title TEXT NOT NULL,
          description TEXT,
          dueDate TEXT NOT NULL,
          taskType TEXT DEFAULT 'BIASA',
          status TEXT DEFAULT 'pending',
          createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          FOREIGN KEY (username) REFERENCES $usersTable(username)
        )
      ''');
    }
  }

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert(usersTable, {
      'username': user.username,
      'password': user.password,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User?> getUserByCredentials(String username, String password) async {
    final db = await database;
    final maps = await db.query(
      usersTable,
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return User(
        username: maps.first['username'] as String,
        password: maps.first['password'] as String,
      );
    }
    return null;
  }

  Future<User?> getUserByUsername(String username) async {
    final db = await database;
    final maps = await db.query(
      usersTable,
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return User(
        username: maps.first['username'] as String,
        password: maps.first['password'] as String,
      );
    }
    return null;
  }

  Future<User?> getFirstUser() async {
    final db = await database;
    final maps = await db.query(usersTable, limit: 1);

    if (maps.isNotEmpty) {
      return User(
        username: maps.first['username'] as String,
        password: maps.first['password'] as String,
      );
    }
    return null;
  }

  Future<int> updateUserPassword(String username, String newPassword) async {
    final db = await database;
    return await db.update(
      usersTable,
      {'password': newPassword},
      where: 'username = ?',
      whereArgs: [username],
    );
  }

  Future<int> insertTask(
    String username,
    String title,
    String description,
    String dueDate, {
    String taskType = 'BIASA',
  }) async {
    final db = await database;
    return await db.insert(tasksTable, {
      'username': username,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'taskType': taskType,
      'status': 'pending',
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getTasksByUsername(String username) async {
    final db = await database;
    return await db.query(
      tasksTable,
      where: 'username = ?',
      whereArgs: [username],
      orderBy: 'createdAt DESC',
    );
  }

  Future<int> updateTask(
    int id,
    String title,
    String description,
    String dueDate,
    String status,
  ) async {
    final db = await database;
    return await db.update(
      tasksTable,
      {
        'title': title,
        'description': description,
        'dueDate': dueDate,
        'status': status,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(tasksTable, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateTaskStatus(int id, String status) async {
    final db = await database;
    return await db.update(
      tasksTable,
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
