import 'package:flutter/material.dart';
import 'package:harmony_chat_demo/views/home_view.dart';

class LoginVew extends StatefulWidget {
  const LoginVew({super.key});

  @override
  State<LoginVew> createState() => _LoginVewState();
}

class _LoginVewState extends State<LoginVew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Login"),
            TextFormField(
              decoration: const InputDecoration(hintText: "Email"),
            ),
            TextFormField(
              decoration: const InputDecoration(hintText: "Password"),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const HomeView()));
                },
                child: const Text("LOGIN")),
          ],
        ),
      ),
    );
  }
}
