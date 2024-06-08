import 'package:flutter/material.dart';
import 'login_page.dart';

class RedirectPage extends StatelessWidget {
  const RedirectPage({super.key});

  @override
  Widget build(BuildContext context) {
    // handle token
    return const LoginPage();
  }
}
