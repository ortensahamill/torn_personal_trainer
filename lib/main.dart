import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/browser_client.dart';
import 'package:http/http.dart';
import 'package:torn_personal_trainer/models/user.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'landing.dart';

void main() {
  GetIt.instance.registerSingleton<BaseClient>(BrowserClient());
  GetIt.instance.registerSingleton<UserCache>(UserCache());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Torn City Personal Trainer',
      routes: {
        '/': (context) => const Landing(),
        '/login': (context) => const Login(),
        '/home': (context) =>
            const HomePage(title: 'Torn City Personal Trainer'),
      },
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
    );
  }
}
