import 'package:bloc/providers/task_provider.dart';
import 'package:bloc/views/home_page.dart';
import 'package:bloc/views/login_page.dart';
import 'package:bloc/views/redirect_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
late SharedPreferences prefs;

void main() async {
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskProvider()),
      ],
      child: MaterialApp(
        title: 'maids.cc test',
        //home: LoginPage(),
        themeMode: ThemeMode.dark,
        theme: ThemeData.dark(),
        navigatorKey: navigatorKey,
        initialRoute: '/',
        routes: {
          '/': (context) => const RedirectPage(),
          '/home': (context) => const HomePage(),
          '/login': (context) => const LoginPage(),
        },
      ),
    );
  }
}
