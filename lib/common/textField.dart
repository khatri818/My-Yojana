import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_yojana/common/style.dart';
import 'app_colors.dart';
import 'app_style.dart';

class CommonTextFormField extends StatelessWidget {
  const CommonTextFormField({
    Key? key,
    this.validator,
    this.controller,
    required this.hintText,
    this.keyboardType,
    this.suffix,
    this.autovalidateMode,
    this.errorText,
    this.onChanged,
    this.inputFormatters,
    this.initialValue,
    this.enabled,
  }) : super(key: key);

  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final String hintText;
  final String? initialValue;
  final TextInputType? keyboardType;
  final Widget? suffix;
  final AutovalidateMode? autovalidateMode;
  final void Function(String)? onChanged;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      enabled: enabled,
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
      style: const TextStyle(color: Color.fromARGB(255, 8, 8, 8)),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      initialValue: initialValue,
      decoration: InputDecoration(
        filled: true,
        errorText: errorText,
        fillColor: AppColors.grey.withOpacity(0.2),
        focusColor: AppColors.grey.withOpacity(0.2),
        errorStyle: const TextStyle(color: AppColors.red),
        errorBorder: Styles.outlineInputBorderNone,
        enabledBorder: Styles.outlineInputBorderNone,
        focusedBorder: Styles.outlineInputBorderNone,
        focusedErrorBorder: Styles.outlineInputBorderNone,
        suffixIcon: suffix,
        hintText: hintText,
        hintStyle: Appstyle.textFormFieldText,
      ),
    );
  }
}
