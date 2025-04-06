import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_yojana/features/auth/presentation/pages/register_page.dart';
import 'package:provider/provider.dart';
import '../../../../common/common_button.dart';
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
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              'Login/Signup',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            )),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppStyle.sizedBoxH30,
              Image.asset(ImageResource.bannerLogo),
              AppStyle.sizedBoxH30,
              Text(
                "Welcome to MyYojana!",
                style: AppTextStyle.appbar,
              ),
              AppStyle.sizedBoxH20,
              const Text(
                "Choose Your Schemes!",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              AppStyle.sizedBoxH30,
              InkWell(
                onTap: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ));
                },
                child: const Text(
                  "Login/Register",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
              AppStyle.sizedBoxH30,
              CommonIntlPhoneField(
                controller: phoneController,
                validator: (value) {
                  if (value == null || value.number.length < 10) {
                    return 'Please enter mobile number*';
                  } else {
                    FocusScope.of(context).unfocus();
                  }
                  return null;
                },
              ),
              AppStyle.sizedBoxH40,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      // await AuthClass.signInWithGoogle();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: 50,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                          child: Image.asset(
                            ImageResource.googlelogo,
                            scale: 0.6,
                          )),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: 50,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                        child: Image.asset(
                          ImageResource.facebooklogo,
                          scale: 0.6,
                        )),
                  ),
                ],
              ),
              AppStyle.sizedBoxH50,
              Consumer<AuthManager>(builder: (context, authManager, child) {
                if (authManager.sendingOTPStatus) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return CommonButton(
                  label: "Continue",
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    if (!_isValid()) return;
                    final mobile = '+91${phoneController.text}';
                    LogUtility.info('MOBILE NUMBER ENTERED : $mobile');
                    await authManager.sentOTP(
                      number: mobile,
                      phoneCodeSent: (veriicationId, resendingToken) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginOTPScreen(),
                          ),
                        );
                      },
                    );
                  },
                );
              }),
              const Spacer(),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text:
                        'By creating an account or logging in, you agree with MyYojana ',
                        style: AppTextStyle.title3),
                    TextSpan(
                      text: 'Terms and Conditions',
                      style: AppTextStyle.title2,
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                    TextSpan(text: ' and ', style: AppTextStyle.title3),
                    TextSpan(
                      text: 'Privacy Policy.',
                      style: AppTextStyle.title2,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  bool _isValid() {
    if (phoneController.text.isEmpty) {
      AppAlert.showToast(message: "Please enter mobile number");
      return false;
    }
    if (phoneController.text.length < 10 || phoneController.text.length > 10) {
      AppAlert.showToast(message: "Please enter a valid mobile number");
      return false;
    }
    return true;
  }

  void setData(verificationId) {
    setState(() {
      verificationId = verificationId;
    });
  }
}
