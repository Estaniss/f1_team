import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../model/Team.dart';

class DbHelper {

  String tblTeam = "team";
  String colId = "id";
  String colName = "name";
  String colFistPilot = "fistPilot";
  String colSecondPilot = "secondPilot";
  String colMotor = "motor";
  String colCountry = "country";

  DbHelper._internal();

  static final DbHelper _dbHelper = DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }


  Future<Database> initializeDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + "teams.db";
    var dbTeams = await openDatabase(path, version: 1, onCreate: _createDb);
    return dbTeams;
  }
  void _createDb(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tblTeam($colId INTEGER PRIMARY KEY, $colName TEXT, " +
            "$colFistPilot TEXT, $colSecondPilot TEXT, $colMotor TEXT, $colCountry TEXT)"
    );
  }


  static Database? _db;
  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db!;
  }


  Future<int> insertTeam(Team team) async {
    Database db = await this.db;
    var result = await db.insert(tblTeam, team.toMap());
    return result;
  }

  Future<List> getTeams() async {
    Database db = await this.db;
    var result = await db.rawQuery("SELECT * FROM $tblTeam order by $colId ASC");
    return result;
  }


  Future<int> getCount() async {
    Database db = await this.db;
    var result = Sqflite.firstIntValue(
        await db.rawQuery("select count (*) from $tblTeam")
    );
    return result!;
  }

  Future<int> updateTeam(Team team) async {
    var db = await this.db;
    var result = await db.update(tblTeam,
        team.toMap(),
        where: "$colId = ?",
        whereArgs: [team.id]);
    return result;
  }


  Future<int> deleteTeam(int id) async {
    int result;
    var db = await this.db;
    result = await db.rawDelete('DELETE FROM $tblTeam WHERE $colId = $id');
    return result;
  }


}