import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../core/constant/app_colors.dart';

class CommonIntlPhoneField extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onCountryChanged;
  final String initialCountryCode;
    final String? initialValue;
    final bool enabled;
  final Widget? suffix;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final FormFieldValidator<PhoneNumber>? validator;

  const CommonIntlPhoneField(
      {super.key,
      this.controller,
      this.onChanged,
      this.onCountryChanged,
      this.initialCountryCode = 'IN',
      this.decoration,
      this.validator,
      this.suffix,
      this.initialValue,
        this.enabled = true,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: controller,
      validator: validator,
      focusNode: focusNode,
      enabled: enabled,
      initialCountryCode: initialCountryCode,
      initialValue:initialValue ,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black54,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: decoration ??
          InputDecoration(
              labelText: 'Enter your mobile number',
              fillColor: AppColors.grey.withOpacity(0.1),
              focusColor: AppColors.grey.withOpacity(0.1),
              labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff8391A1)),
              errorStyle: const TextStyle(color: Colors.red),
              filled: true,
              border: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.grey.withOpacity(0.1))),
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.grey.withOpacity(0.1))),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.grey.withOpacity(0.1)),
              ),
              suffix: suffix),
      onChanged: (phone) {
        if (onChanged != null) {
          onChanged!(phone.completeNumber);
        }
      },
      onCountryChanged: (country) {
        if (onCountryChanged != null) {
          onCountryChanged!(country.dialCode);
        }
      },
    );
  }
}
