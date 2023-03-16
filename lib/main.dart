import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poc_sembast/my_app.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

Future<Database> openDatabase() async {
  var databasesPath = await getApplicationSupportDirectory();

  String dbPath = '${databasesPath.path}/database/sample.db';
  DatabaseFactory dbFactory = databaseFactoryIo;

  return await dbFactory.openDatabase(dbPath);
}

void main() {
  runApp(const MyApp());
}
