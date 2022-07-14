import 'dart:async';
import 'dart:io';
import '../model/data_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _init();

  Future<Database> _init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "favourite.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE FAVOURITE(
    id INTEGER PRIMARY KEY,
    brand STRING,
    name STRING,
    description STRING
    )
    ''');
  }

  Future<int> add(DataModel data) async {
    Database db = await instance.database;
    return await db.insert("FAVOURITE", data.toJson());
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete('FAVOURITE', where: "id = ?", whereArgs: [id]);
  }

  checkData(String name) async {
    Database db = await instance.database;
    final data =
        await db.query('FAVOURITE', where: "name = ?", whereArgs: [name]);
    return (data.isEmpty) ? null : DataModel.fromJson(data.first);
  }

  Future<List<DataModel>> allData() async {
    Database db = await instance.database;
    var data = await db.query('FAVOURITE');
    List<DataModel> dataList =
        data.isNotEmpty ? data.map((e) => DataModel.fromJson(e)).toList() : [];
    return dataList;
  }
}
