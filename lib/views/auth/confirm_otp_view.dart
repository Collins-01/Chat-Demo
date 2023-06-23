// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:harmony_chat_demo/views/auth/viewmodels/confirm_otp_viewmodel.dart';
import 'package:harmony_chat_demo/views/widgets/app_text.dart';

import 'package:harmony_chat_demo/views/widgets/app_text_field.dart';
import 'package:harmony_chat_demo/views/widgets/widgets.dart';

class ConfirmOtpView extends ConsumerWidget {
  final String email;
  ConfirmOtpView({
    super.key,
    required this.email,
  });

  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var model = ref.watch(confirmOtpViewModel);
    return LoaderPage(
      busy: model.isBusy,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              children: [
                AppText.heading1("Verify Otp"),
                AppTextField(
                    controller: controller, title: 'Otp', hintText: '1234'),
                const SizedBox(
                  height: 50,
                ),
                AppLongButton(
                    title: 'Verify',
                    onTap: () {
                      if (controller.text.isNotEmpty) {
                        model.verifyOtp(controller.text, email);
                      }
                      return;
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
