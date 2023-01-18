import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlLiteDb {
  static Database? _database;

  initDatabase() async {
    _database = await openDatabase(
        join(await getDatabasesPath(), 'europe_express.db'),
        onCreate: _createTables,
        version: 1);
    return _database;
  }

  void _createTables(Database db, int version) async {
    await db.execute("CREATE TABLE active_orders ("
        "id INTEGER PRIMARY KEY,"
        "loadingStartTime TEXT,"
        "loadingEndTime TEXT,"
        "unloadingStartTime TEXT,"
        "unloadingEndTime TEXT,"
        "loadingStartImage TEXT,"
        "loadingEndImage TEXT,"
        "unloadingStartImage TEXT,"
        "unloadingEndImage TEXT,"
        "loadingStartStatus INTEGER DEFAULT 0,"
        "loadingEndStatus INTEGER DEFAULT 0,"
        "unloadingStartStatus INTEGER DEFAULT 0,"
        "unloadingEndStatus INTEGER DEFAULT 0,"
        "currentStatus TEXT"
        ")");
  }

  Future<Database> get database async {
    if (_database == null) {
      return await initDatabase();
    }
    return _database!;
  }
}
