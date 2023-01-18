import 'dart:convert';

import 'package:euex/database/sqlLitedb.dart';
import 'package:hive/hive.dart';
import 'package:sqflite/sqflite.dart';

part 'activeOrder.g.dart';

@HiveType(typeId: 3)
class ActiveOrder extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(2)
  String? loadingStartTime;
  @HiveField(3)
  String? loadingEndTime;
  @HiveField(4)
  String? unloadingStartTime;
  @HiveField(5)
  String? unloadingEndTime;
  String? loadingStartImage;
  String? loadingEndImage;
  String? unloadingStartImage;
  String? unloadingEndImage;
  bool? loadingStartStatus;
  bool? loadingEndStatus;
  bool? unloadingStartStatus;
  bool? unloadingEndStatus;
  @HiveField(6)
  String? currentStatus;

  ActiveOrder(
      {required this.id,
      this.loadingStartTime,
      this.loadingEndTime,
      this.unloadingStartTime,
      this.unloadingEndTime,
      this.loadingStartImage,
      this.loadingEndImage,
      this.unloadingStartImage,
      this.unloadingEndImage,
      this.loadingStartStatus,
      this.loadingEndStatus,
      this.unloadingStartStatus,
      this.unloadingEndStatus,
      this.currentStatus});

  @override
  String toString() {
    return json.encode(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'loadingStartTime': loadingStartTime,
      'loadingEndTime': loadingEndTime,
      'unloadingStartTime': unloadingStartTime,
      'unloadingEndTime': unloadingEndTime,
      'loadingStartImage': loadingStartImage,
      'loadingEndImage': loadingEndImage,
      'unloadingStartImage': unloadingStartImage,
      'unloadingEndImage': unloadingEndImage,
      'loadingStartStatus': loadingStartStatus,
      'loadingEndStatus': loadingEndStatus,
      'unloadingStartStatus': unloadingStartStatus,
      'unloadingEndStatus': unloadingEndStatus
    };
  }

  factory ActiveOrder.fromMap(Map<String, dynamic> json) => ActiveOrder(
      id: json['id'],
      loadingStartTime: json['loadingStartTime'],
      loadingEndTime: json['loadingEndTime'],
      unloadingStartTime: json['unloadingStartTime'],
      unloadingEndTime: json['unloadingEndTime'],
      loadingStartImage: json['loadingStartImage'],
      loadingEndImage: json['loadingEndImage'],
      unloadingStartImage: json['unloadingStartImage'],
      unloadingEndImage: json['unloadingEndImage'],
      loadingStartStatus: json['loadingStartStatus'] == 1,
      loadingEndStatus: json['loadingEndStatus'] == 1,
      unloadingStartStatus: json['unloadingStartStatus'] == 1,
      unloadingEndStatus: json['unloadingEndStatus'] == 1);
}

class ActiveOrderQuery {
  Future<int> create(ActiveOrder activeOrder) async {
    final db = await SqlLiteDb().database;
    return await db.insert(
      'active_orders',
      activeOrder.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> update(ActiveOrder activeOrder) async {
    final db = await SqlLiteDb().database;
    Map<String, dynamic> updateData = activeOrder.toMap();
    updateData.removeWhere((key, value) => key == null || value == null);
    return await db.update(
      'active_orders',
      updateData,
      where: 'id = ?',
      whereArgs: [activeOrder.id],
    );
  }

  Future<int> delete(id) async {
    final db = await SqlLiteDb().database;
    return await db.delete(
      'active_orders',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAll() async {
    final db = await SqlLiteDb().database;
    return await db.delete('active_orders');
  }

  Future<List<ActiveOrder>> getAll() async {
    final db = await SqlLiteDb().database;
    final List<Map<String, dynamic>> maps = await db.query('active_orders');
    return List.generate(maps.length, (i) {
      return ActiveOrder.fromMap(maps[i]);
    });
  }

  Future<ActiveOrder?> find(id) async {
    final db = await SqlLiteDb().database;
    List<Map<String, dynamic>> result =
        await db.query("active_orders", where: "id = ?", whereArgs: [id]);
    return result.isNotEmpty ? fromMap(result.first) : null;
  }

  Future<ActiveOrder> firstOrCreate(ActiveOrder activeOrder) async {
    final db = await SqlLiteDb().database;
    List<Map<String, dynamic>> result = await db
        .query("active_orders", where: "id = ?", whereArgs: [activeOrder.id]);
    if (result.isNotEmpty) {
      return ActiveOrder.fromMap(result.first);
    }
    await create(activeOrder);
    return activeOrder;
  }

  Future<int> updateValue(id, column, value) async {
    final db = await SqlLiteDb().database;
    Map<String, dynamic> updateData = {column: value};
    return await db.update(
      'active_orders',
      updateData,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<String?> getValue(id, column) async {
    final db = await SqlLiteDb().database;
    List<Map<String, dynamic>> result = await db.query("active_orders",
        where: "id = ?", columns: [column], whereArgs: [id]);
    return result.isNotEmpty ? result.first[column] : null;
  }

  Future<bool> exits(id) async {
    final db = await SqlLiteDb().database;
    List<Map<String, dynamic>> result = await db.query("active_orders",
        where: "id = ?", whereArgs: [id], columns: ['id']);
    return result.isNotEmpty ? true : false;
  }

  fromMap(Map<String, dynamic> json) => ActiveOrder(
      id: json['id'],
      loadingStartTime: json['loadingStartTime'],
      loadingEndTime: json['loadingEndTime'],
      unloadingStartTime: json['unloadingStartTime'],
      unloadingEndTime: json['unloadingEndTime'],
      loadingStartImage: json['loadingStartImage'],
      loadingEndImage: json['loadingEndImage'],
      unloadingStartImage: json['unloadingStartImage'],
      unloadingEndImage: json['unloadingEndImage'],
      loadingStartStatus: json['loadingStartStatus'] == 1,
      loadingEndStatus: json['loadingEndStatus'] == 1,
      unloadingStartStatus: json['unloadingStartStatus'] == 1,
      unloadingEndStatus: json['unloadingEndStatus'] == 1);
}
