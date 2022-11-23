import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Column(
        children: [
          TextField(
              decoration: InputDecoration(hintText: "Enter Email"),
              controller: _emailTextEditingController,
              keyboardType: TextInputType.emailAddress,
              enableSuggestions: false),
          TextField(
            decoration: InputDecoration(hintText: "Enter Passord"),
            controller: _passwordTextEditingController,
            obscureText: true,
            enableSuggestions: false,
          ),
          TextButton(
            onPressed: () async {
              try {
                final email = _emailTextEditingController.text;
                final password = _passwordTextEditingController.text;
                print(email);
                print(password);

                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                Navigator.of(context).pushNamedAndRemoveUntil(
                  "/notes/",
                  (route) => false,
                );
              } on FirebaseAuthException catch (e) {
                print(e);
              }
            },
            child: Text("Login"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/register/', (route) => false);
            },
            child: Text("Not registered yet? Register here "),
          ),
        ],
      ),
    );
  }
}
