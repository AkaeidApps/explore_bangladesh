import 'package:flutter/material.dart';
import 'app.dart';
import 'services/local_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = LocalStore();
  await store.init();
  runApp(ExploreBangladeshApp(store: store));
}
