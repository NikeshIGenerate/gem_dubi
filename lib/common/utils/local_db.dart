import 'package:gem_dubi/common/models/local_notification.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseProvider {
  static late Database database;

  static const String _DATABASE_NAME = 'gemdubai.db';
  static const String _TABLE_NOTIFICATIONS = 'notifications';
  static const String _COLUMN_ID = 'id';
  static const String _COLUMN_TITLE = 'title';
  static const String _COLUMN_BODY = 'body';
  static const String _COLUMN_CREATED_AT = 'createdAt';

  static Future<void> initDB() async {
    database = await openDatabase(
      join(await getDatabasesPath(), _DATABASE_NAME),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE $_TABLE_NOTIFICATIONS($_COLUMN_ID INTEGER PRIMARY KEY, $_COLUMN_TITLE TEXT, $_COLUMN_BODY TEXT, $_COLUMN_CREATED_AT INTEGER)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  static Future<void> insertNotification(LocalNotification notification) async {
    final db = database;

    await db.insert(_TABLE_NOTIFICATIONS, {
      _COLUMN_ID: notification.hashCode,
      _COLUMN_TITLE: notification.title,
      _COLUMN_BODY: notification.body,
      _COLUMN_CREATED_AT: notification.createdAt.millisecondsSinceEpoch,
    });
  }

  static Future<bool> deleteNotification(int id) async {
    final db = database;

    int affectedRows = await db.delete(_TABLE_NOTIFICATIONS, where: '$_COLUMN_ID = ?', whereArgs: [id]);
    return affectedRows > 0;
  }

  static Future<List<LocalNotification>> getAllNotifications({required int page}) async {
    final db = database;
    // Query the table for all The Notifications.
    final List<Map<String, dynamic>> maps = await db.query(_TABLE_NOTIFICATIONS, orderBy: _COLUMN_CREATED_AT, offset: page, limit: 10);

    return maps.isNotEmpty
        ? List.generate(maps.length, (i) {
            return LocalNotification.fromJson(maps[i]);
          })
        : [];
  }
}
