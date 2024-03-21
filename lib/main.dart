import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:overlay_nams/home_page.dart';
import 'package:overlay_nams/overlay_page.dart';

void main() async {
  runZonedGuarded(() async {
    DartPluginRegistrant.ensureInitialized();
    WidgetsFlutterBinding.ensureInitialized();

    runApp(const MyApp());
  }, (e, stacktrace) async {
    debugPrint('$e, $stacktrace');
  });
}

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const OverlayPage()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
