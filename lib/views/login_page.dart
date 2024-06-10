import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maids.cc_test/views/widgets/auth_field.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../providers/login_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    TextTheme tt = Theme.of(context).textTheme;
    ColorScheme cs = Theme.of(context).colorScheme;
    return WillPopScope(
      onWillPop: () async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text("wanna close the app?"),
            actions: [
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text(
                  "yes",
                ),
              ),
              TextButton(
                onPressed: () {
                  navigatorKey.currentState!.pop();
                },
                child: const Text(
                  "no",
                ),
              ),
            ],
          ),
        );
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: cs.background,
          body: SingleChildScrollView(
            child: Consumer<LoginProvider>(builder: (_, loginProvider, child) {
              return Form(
                key: loginProvider.loginFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 36),
                      child: Hero(
                        tag: "logo",
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              "assets/images/maids.cc_logo.png",
                              height: MediaQuery.sizeOf(context).width / 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
                      child: Text(
                        "enter your credentials:",
                        style: tt.headlineSmall!.copyWith(color: cs.onBackground),
                      ),
                    ),
                    AuthField(
                      label: "user name",
                      controller: loginProvider.userName,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.person_outline),
                      validator: (val) {
                        return validateInput(loginProvider.userName.text, 1, 500, "user name");
                      },
                      onChanged: (val) {
                        if (loginProvider.buttonPressed) loginProvider.loginFormKey.currentState!.validate();
                      },
                    ),
                    const SizedBox(height: 8),
                    Consumer<LoginProvider>(
                      builder: (_, loginProvider, child) => AuthField(
                        controller: loginProvider.password,
                        keyboardType: TextInputType.text,
                        obscure: !loginProvider.passwordVisible,
                        label: "password",
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            loginProvider.togglePasswordVisibility();
                          },
                          child: Icon(loginProvider.passwordVisible ? CupertinoIcons.eye_slash : CupertinoIcons.eye),
                        ),
                        validator: (val) {
                          return validateInput(loginProvider.password.text, 1, 500, "password");
                        },
                        onChanged: (val) {
                          if (loginProvider.buttonPressed) loginProvider.loginFormKey.currentState!.validate();
                        },
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cs.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: loginProvider.isLoading
                              ? CircularProgressIndicator(color: cs.onPrimary)
                              : Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    "login",
                                    style: tt.titleLarge!.copyWith(color: cs.onPrimary),
                                  ),
                                ),
                        ),
                        onTap: () {
                          loginProvider.login();
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
