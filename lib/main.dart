import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'domain/providers/theme_notifier.dart';
import 'presentation/screens/splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(lightTheme),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Covid 19',
      theme: themeNotifier.getTheme(),
      home: SplashScreen(),
    );
  }
}
