import 'package:path/path.dart';
import 'package:rmb/sqlite/UserDataModel.dart';
import 'package:sqflite/sqflite.dart';

import 'DataModel.dart';
import 'KeyModel.dart';

class DB {
  Future<Database> initDB() async {
    String path = await getDatabasesPath();
    return await openDatabase(join(path, "rmb.db"), version: 2,
        onCreate: (Database db, int version) async {
      print('Creating messages table');
      await db.execute('''
          CREATE TABLE messages (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT NOT NULL,
            sourseId INTEGER NOT NULL,
            targetId INTEGER NOT NULL,
            message TEXT NOT NULL
          );
          ''');
      await db.execute('''
          CREATE TABLE user (
            userid INTEGER PRIMARY KEY NOT NULL,
            username TEXT NOT NULL,
            icon TEXT NOT NULL
          );
          ''');

      await db.execute('''
          CREATE TABLE key (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            privateKey TEXT NOT NULL,
            publicKey TEXT NOT NULL
          );
          ''');
    });
  }

  //insert new messages
  Future<bool> insertMessage(DataModel dataModel) async {
    final Database db = await initDB();
    db.insert('messages', dataModel.toMap());
    return true;
  }

  // login
  Future<bool> insertUser(UserDataModel userDataModel) async {
    final Database db = await initDB();
    db.insert('user', userDataModel.toMap());
    return true;
  }

  //insert new key
  Future<bool> insertKey(KeyModel keyModel) async {
    final Database db = await initDB();
    db.insert('key', keyModel.toMap());
    return true;
  }

  //get messages
  Future<List<DataModel>> getMessages() async {
    final Database db = await initDB();
    final List<Map<String, Object?>> datas = await db.query("messages");
    return datas.map((e) => DataModel.fromMap(e)).toList();
  }

  //get user
  Future<List<UserDataModel>> getUser() async {
    final Database db = await initDB();
    final List<Map<String, Object?>> users = await db.query("user");
    return users.map((e) => UserDataModel.fromMap(e)).toList();
  }

  //get key
  Future<List<KeyModel>> getKey() async {
    final Database db = await initDB();
    final List<Map<String, Object?>> keys = await db.query("key");
    return keys.map((e) => KeyModel.fromMap(e)).toList();
  }
}
