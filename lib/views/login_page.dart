import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maids.cc_test/views/widgets/auth_field.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/login_model.dart';
import '../providers/login_provider.dart';
import '../services/remote_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  Future<void> login() async {
    setLoading(true);
    LoginModel? response = await RemoteServices.login(email.text, password.text);
    if (response == null) {
      print("errorrr");
    } else {
      print(response);
      prefs.setString("token", response.token);
      prefs.setString("refresh_token", response.refreshToken);
      navigatorKey.currentState!.pushNamed("/home");
    }
    setLoading(false);
  }

  bool loading = false;
  void setLoading(bool val) {
    setState(() {
      loading = val;
    });
  }

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
          body: SingleChildScrollView(
            child: Form(
              key: loginFormKey,
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
                      "enter your credintials",
                      style: tt.headlineSmall!.copyWith(color: cs.onBackground),
                    ),
                  ),
                  AuthField(
                    label: "email",
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icon(Icons.email_outlined),
                    validator: (val) {
                      return validateInput(email.text, 4, 50, "email");
                    },
                    onChanged: (val) {
                      loginFormKey.currentState!.validate();
                    },
                  ),
                  const SizedBox(height: 8),
                  Consumer<LoginProvider>(
                    builder: (_, loginProvider, child) => AuthField(
                      controller: password,
                      keyboardType: TextInputType.text,
                      obscure: !loginProvider.passwordVisible,
                      label: "password",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          loginProvider.togglePasswordVisibility();
                        },
                        child: Icon(loginProvider.passwordVisible ? CupertinoIcons.eye_slash : CupertinoIcons.eye),
                      ),
                      validator: (val) {
                        return validateInput(password.text, 4, 50, "password");
                      },
                      onChanged: (val) {
                        loginFormKey.currentState!.validate();
                      },
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: loading
                            ? CircularProgressIndicator()
                            : Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(
                                  "login",
                                  style: tt.titleMedium!.copyWith(color: cs.onPrimary),
                                ),
                              ),
                      ),
                      onTap: () {
                        login();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
