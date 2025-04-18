import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:my_yojana/features/auth/presentation/pages/register_page.dart';
import 'package:provider/provider.dart';
import '../../../../common/common_intl_phone_field.dart';
import '../../../../core/constant/app_styles.dart';
import '../../../../core/constant/app_text_styles.dart';
import '../../../../core/utils/app_alert.dart';
import '../../../home/presentation/pages/bottom_navigation_page.dart';
import '../manager/auth_manger.dart';

class LoginOTPScreen extends StatefulWidget {
  const LoginOTPScreen({super.key});

  @override
  State<LoginOTPScreen> createState() => _LoginOTPScreenState();
}

class _LoginOTPScreenState extends State<LoginOTPScreen> {
  bool wait = false;
  int start = 30;
  late Timer _timer;
  String? otpCode;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Login',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        leading: const BackButton(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppStyle.sizedBoxH40,
              Text(
                "Verify with OTP",
                style: AppTextStyle.appbar.copyWith(fontSize: 22),
              ),
              AppStyle.sizedBoxH30,
              const Text(
                "OTP sent to",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              AppStyle.sizedBoxH20,
              Selector<AuthManager, String>(
                selector: (p0, manager) => manager.phoneNumber ?? '',
                builder: (context, value, child) => Row(
                  children: [
                    Expanded(
                      child: CommonIntlPhoneField(
                        enabled: false,
                        initialValue: value,
                        onCountryChanged: (country) {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                      child: Text("Edit", style: AppTextStyle.text1),
                    ),
                  ],
                ),
              ),
              AppStyle.sizedBoxH30,
              const Text(
                "Enter OTP",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              AppStyle.sizedBoxH20,
              // Wrapped to avoid overflow
              Center(
                child: OtpTextField(
                  numberOfFields: 6,
                  fieldHeight: 50,
                  fieldWidth: 45,
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  borderWidth: 1.8,
                  showFieldAsBox: true,
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB), // subtle off-white background
                  enabledBorderColor: const Color(0xFFE0E0E0),
                  focusedBorderColor: const Color(0xFF4F44FF),
                  disabledBorderColor: const Color(0xFFE0E0E0),
                  cursorColor: const Color(0xFF4F44FF),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  margin: const EdgeInsets.symmetric(horizontal: 6.0),
                  textStyle: const TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    letterSpacing: 1.5,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onCodeChanged: (_) {},
                  onSubmit: (String verificationCode) {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      otpCode = verificationCode;
                    });
                  },
                ),
              ),
              AppStyle.sizedBoxH10,
              Consumer<AuthManager>(
                builder: (context, state, _) {
                  if (state.resendOTPStatus) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Row(
                    children: [
                      InkWell(
                        onTap: wait
                            ? null
                            : () async {
                          if (state.phoneNumber == null ||
                              state.forceResendingToken == null ||
                              state.verificationId == null) return;
                          await state.resendOTP(
                            phoneNumber: state.phoneNumber!,
                            verificationId: state.verificationId!,
                            resendToken: state.forceResendingToken!,
                          );
                          _startTimer();
                          setState(() {
                            start = 30;
                            wait = true;
                          });
                        },
                        child: Row(
                          children: [
                            Text("Resend OTP", style: AppTextStyle.text),
                            if (wait) ...[
                              const SizedBox(width: 4),
                              Text("after", style: AppTextStyle.text),
                              const SizedBox(width: 4),
                              Text(
                                "00:${start < 10 ? '0$start' : start}",
                                style: AppTextStyle.text1,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              AppStyle.sizedBoxH40,
              Consumer<AuthManager>(
                builder: (context, state, child) {
                  if (state.verifyingOTPStatus) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return GestureDetector(
                    onTap: () async {
                      if (otpCode == null) {
                        AppAlert.showToast(message: 'Enter OTP');
                        return;
                      }
                      if (state.verificationId == null) return;
                      await state.verifyOTP(
                        verifyId: state.verificationId!,
                        smsCode: otpCode!,
                        onVerified: (bool isNewUser) {
                          if (isNewUser) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          } else {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const BottomNav(),
                              ),
                                  (route) => false,
                            );
                          }
                        },
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7F00FF), Color(0xFF00B0FF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          "Submit OTP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          wait = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }
}
