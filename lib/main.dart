import 'package:flutter/material.dart';
import 'package:english/services/score_service.dart';
import 'package:english/services/bookmark_service.dart';
import 'package:english/services/database_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.instance.database;
  await ScoreService.instance.init();
  await BookmarkService.instance.init();
  runApp(const MyApp());
}
