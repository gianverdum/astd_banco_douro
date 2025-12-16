import 'package:flutter/material.dart';
import 'package:flutter_banco_douro/ui/styles/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  void _doLogin() {
    Navigator.pushReplacementNamed(context, "home");
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Image.asset("assets/images/banner.png"),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Image.asset("assets/images/stars.png"),
                ),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 200),
                      Image.asset("assets/images/logo.png", width: 120),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 32),
                          const Text(
                            "Sistema de Gestão de Contas",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 32),
                          ),
                          const SizedBox(height: 32),
                          TextFormField(
                            focusNode: _emailFocus,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              label: Text("E-mail"),
                            ),
                            onFieldSubmitted: (_) {
                              FocusScope.of(
                                context,
                              ).requestFocus(_passwordFocus);
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            focusNode: _passwordFocus,
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              label: Text("Senha"),
                            ),
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).unfocus();
                              _doLogin();
                            },
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () => _doLogin(),
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                AppColor.orange,
                              ),
                            ),
                            child: Text(
                              "Entrar",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
