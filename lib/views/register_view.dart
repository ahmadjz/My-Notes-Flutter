import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/constants/routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text("Reister"),
      ),
      body: Column(
        children: [
          TextField(
              decoration: const InputDecoration(hintText: "Enter Email"),
              controller: _emailTextEditingController,
              keyboardType: TextInputType.emailAddress,
              enableSuggestions: false),
          TextField(
            decoration: const InputDecoration(hintText: "Enter Passord"),
            controller: _passwordTextEditingController,
            obscureText: true,
            enableSuggestions: false,
          ),
          TextButton(
              onPressed: () async {
                final email = _emailTextEditingController.text;
                final password = _passwordTextEditingController.text;
                print(email);
                print(password);
                try {
                  final cred = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: email, password: password);
                  print(cred);
                } on FirebaseAuthException {}
              },
              child: const Text("Register")),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text("Already a user? Login here "),
          ),
        ],
      ),
    );
  }
}
