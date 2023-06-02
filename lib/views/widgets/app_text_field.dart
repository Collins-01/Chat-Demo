import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harmony_chat_demo/views/widgets/app_text.dart';

import '../../utils/utils.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final String hintText;
  final bool isPassword;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  const AppTextField({
    super.key,
    required this.controller,
    required this.title,
    required this.hintText,
    this.isPassword = false,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool isObscured = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.bodyLarge(
            widget.title,
            color: AppColors.primaryColor,
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
              border: Border.all(
                color: AppColors.textColor,
                width: 0.3,
              ),
            ),
            child: TextFormField(
              inputFormatters: widget.inputFormatters,
              keyboardType: widget.keyboardType,
              validator: widget.validator,
              obscureText: widget.isPassword ? (isObscured) : false,
              controller: widget.controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 17, left: 10),
                border: InputBorder.none,
                hintText: widget.hintText,
                suffixIcon: !widget.isPassword
                    ? const SizedBox.shrink()
                    : IconButton(
                        onPressed: () => toggleVisibility(),
                        icon: Icon(!isObscured
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }

  toggleVisibility() {
    setState(() {
      isObscured = !isObscured;
    });
  }
}
