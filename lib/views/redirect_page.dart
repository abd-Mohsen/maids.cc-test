import 'package:flutter/material.dart';
import 'package:maids.cc_test/views/home_page.dart';
import 'login_page.dart';
import 'package:maids.cc_test/main.dart';

class RedirectPage extends StatelessWidget {
  const RedirectPage({super.key});

  @override
  Widget build(BuildContext context) {
    // handle token
    return prefs.getString("token") == null ? const LoginPage() : const HomePage();
  }
}
