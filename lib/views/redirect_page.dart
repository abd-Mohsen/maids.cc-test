import 'package:bloc/views/login_page.dart';
import 'package:flutter/material.dart';

class RedirectPage extends StatelessWidget {
  const RedirectPage({super.key});

  @override
  Widget build(BuildContext context) {
    // handle token
    return const LoginPage();
  }
}
