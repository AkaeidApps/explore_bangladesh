import 'package:flutter/material.dart';
import 'screens/main_shell.dart';
import 'screens/splash_screen.dart';
import 'services/local_store.dart';
import 'theme/app_theme.dart';

class ExploreBangladeshApp extends StatelessWidget {
  const ExploreBangladeshApp({super.key, required this.store});
  final LocalStore store;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: store,
    builder: (context, _) => MaterialApp(
      title: 'Explore Bangladesh',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: store.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Builder(
        builder: (navContext) => SplashScreen(onFinished: () {
          Navigator.of(navContext).pushReplacement(
            MaterialPageRoute(builder: (_) => MainShell(store: store)),
          );
        }),
      ),
    ),
  );
}
