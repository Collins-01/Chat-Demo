import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/views/auth/register_view.dart';
import 'package:harmony_chat_demo/views/auth/viewmodels/login_viewmodel.dart';
import 'package:harmony_chat_demo/views/widgets/app_text.dart';
import 'package:harmony_chat_demo/views/widgets/widgets.dart';

import '../../utils/utils.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var model = ref.watch(loginViewModel);
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
                AppText.heading1("LOGIN "),
                // const Text("Login"),
                AuthTextField(
                  hintText: 'example@gmail.com',
                  controller: emailController,
                  labelText: "Email",
                  validator: FieldValidators.email,
                ),
                AuthTextField(
                  hintText: '*****6',
                  controller: passwordController,
                  labelText: "Password",
                  validator: FieldValidators.password,
                ),
                const SizedBox(
                  height: 50,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) => const ResgisterView()));
                  },
                  child: AppText.body("Don't have an account? Register"),
                ),
                AppLongButton(
                  title: 'LOGIN',
                  onTap: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    } else {
                      model.login(
                          emailController.text, passwordController.text);
                    }
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
