import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../common/common_intl_phone_field.dart';
import '../../../../constant/image_resource.dart';
import '../../../../core/constant/app_styles.dart';
import '../../../../core/constant/app_text_styles.dart';
import '../../../../core/utils/log_utility.dart';
import '../../../../core/utils/app_alert.dart';
import '../manager/auth_manger.dart';
import 'otp_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        title: const Text(
          'Login / Signup',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset(ImageResource.bannerLogo, height: 120)),
              const SizedBox(height: 30),
              Text(
                "Welcome to MyYojana!",
                style: AppTextStyle.appbar.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 10),
              const Text(
                "Choose Your Schemes!",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),
              CommonIntlPhoneField(
                controller: phoneController,
                validator: (value) {
                  if (value == null || value.number.length < 10) {
                    return 'Please enter a valid mobile number';
                  } else {
                    FocusScope.of(context).unfocus();
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Consumer<AuthManager>(
                builder: (context, authManager, child) {
                  if (authManager.sendingOTPStatus) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return GestureDetector(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      if (!_isValid()) return;
                      final mobile = '+91${phoneController.text}';
                      LogUtility.info('MOBILE NUMBER ENTERED : $mobile');
                      await authManager.sentOTP(
                        number: mobile,
                        phoneCodeSent: (verificationId, resendingToken) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginOTPScreen(),
                            ),
                          );
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
                          "Continue",
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
              const SizedBox(height: 40),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTextStyle.title3.copyWith(height: 1.5),
                    children: <TextSpan>[
                      const TextSpan(
                        text:
                        'By creating an account or logging in, you agree with MyYojana ',
                      ),
                      TextSpan(
                        text: 'Terms and Conditions',
                        style: AppTextStyle.title2.copyWith(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                      const TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy.',
                        style: AppTextStyle.title2.copyWith(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  bool _isValid() {
    if (phoneController.text.isEmpty) {
      AppAlert.showToast(message: "Please enter mobile number");
      return false;
    }
    if (phoneController.text.length != 10) {
      AppAlert.showToast(message: "Please enter a valid 10-digit mobile number");
      return false;
    }
    return true;
  }
}
