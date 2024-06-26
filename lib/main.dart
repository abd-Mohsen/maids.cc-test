import 'package:flutter/material.dart';
import 'package:maids.cc_test/models/task_model.dart';
import 'package:maids.cc_test/providers/login_provider.dart';
import 'package:maids.cc_test/providers/task_provider.dart';
import 'package:maids.cc_test/providers/user_provider.dart';
import 'package:maids.cc_test/themes.dart';
import 'package:maids.cc_test/views/home_page.dart';
import 'package:maids.cc_test/views/login_page.dart';
import 'package:maids.cc_test/views/redirect_page.dart';
import 'package:maids.cc_test/views/saved_tasks_page.dart';
import 'package:maids.cc_test/views/task_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'maids.cc test',
        themeMode: ThemeMode.dark,
        theme: MyThemes.myDarkMode,
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        initialRoute: '/',
        routes: {
          '/': (context) => const RedirectPage(),
          '/home': (context) => const HomePage(),
          '/login': (context) => const LoginPage(),
          '/savedTasks': (context) => const SavedTasksPage(),
          '/task': (context) {
            final task = ModalRoute.of(context)?.settings.arguments as TaskModel;
            return TaskPage(task: task);
          },
        },
      ),
    );
  }
}
