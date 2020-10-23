import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'mConfig.dart';

class daoSqliteConfig
{
  static Database _database;
  static final _databaseName = "bwinv2.db";

  Future<Database> get database async {
    if (_database != null)
      return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE config ("
              "url1 TEXT,"
              "url2 TEXT"
              ")");
        });
  }

/*
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: 1,
        onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE config ("
              "url1 TEXT,"
              "url2 TEXT"
              ")");
        });
  }*/

  Future<mConfig> getConfig() async {
      final db = await database;

      var res = await db.rawQuery("SELECT * FROM config LIMIT 1");

      if( res.length >0)
      {
        mConfig c = mConfig();
        c.url1 = res[0]["url1"];
        c.url2 = res[0]["url2"];

        return c;
      }
      return null;
     /* List<mConfig> list =
      res.isNotEmpty ? res.toList().map((c) => mConfig.fromMap(c)) : null;
      return list;*/
  }

  newConfig(mConfig newConf) async {
    final db = await database;
    var res = await db.rawInsert(
        "INSERT Into config (url1,url2)"
            " VALUES ('${newConf.url1}','${newConf.url2}')");
    return res;
  }

  updateClient(String sUrl1, String sUrl2) async {
    final db = await database;
    var res = await db.rawUpdate("update config set url1='${sUrl1}', url2 = '${sUrl2}'");
    return res;
  }


}