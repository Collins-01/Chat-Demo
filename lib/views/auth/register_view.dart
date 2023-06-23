import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/views/auth/auth.dart';
import 'package:harmony_chat_demo/views/auth/viewmodels/register_viewmodel.dart';
import 'package:harmony_chat_demo/views/widgets/app_text.dart';

import '../widgets/widgets.dart';

class ResgisterView extends ConsumerStatefulWidget {
  const ResgisterView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResgisterViewState();
}

class _ResgisterViewState extends ConsumerState<ResgisterView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var model = ref.watch(registerViewModel);
    return LoaderPage(
      busy: model.isBusy,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText.heading1("REGISTER "),
                // const Text("Login"),
                AuthTextField(
                  hintText: 'example@gmail.com',
                  controller: emailController,
                  labelText: "Email",
                ),
                AuthTextField(
                  hintText: '*****6',
                  controller: passwordController,
                  labelText: "Password",
                ),
                const SizedBox(
                  height: 50,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const LoginView(),
                      ),
                    );
                  },
                  child: AppText.body("Have have an account already? Login"),
                ),
                AppLongButton(
                  title: 'REGISTER',
                  onTap: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    model.register(
                        emailController.text, passwordController.text);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
