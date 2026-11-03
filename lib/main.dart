import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:re_articles/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox<String>('article_drafts');
  await Hive.openBox('settings');

  runApp(const ReArticles());
}