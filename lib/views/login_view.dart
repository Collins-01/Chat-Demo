import 'package:flutter/material.dart';
import 'package:harmony_chat_demo/views/home/home_view.dart';
import 'package:harmony_chat_demo/views/widgets/auth_text_field.dart';

class LoginVew extends StatefulWidget {
  const LoginVew({super.key});

  @override
  State<LoginVew> createState() => _LoginVewState();
}

class _LoginVewState extends State<LoginVew> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Login"),
            AuthTextField(
              hintText: 'example@gmail.com',
              controller: emailController,
              labelText: "Email",
            ),
            AuthTextField(
                hintText: '*****6',
                controller: passwordController,
                labelText: "Password"),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const HomeView()));
              },
              child: const Text("LOGIN"),
            ),
          ],
        ),
      ),
    );
  }
}
