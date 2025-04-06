import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:my_yojana/features/auth/presentation/pages/register_page.dart';
import 'package:provider/provider.dart';
import '../../../../common/common_button.dart';
import '../../../../common/common_intl_phone_field.dart';
import '../../../../core/constant/app_styles.dart';
import '../../../../core/constant/app_text_styles.dart';
import '../../../../core/utils/app_alert.dart';
import '../../../home/presentation/pages/bottom_navigation_page.dart';
import '../manager/auth_manger.dart';

class LoginOTPScreen extends StatefulWidget {
  const LoginOTPScreen({
    super.key,
  });

  @override
  State<LoginOTPScreen> createState() => _LoginOTPScreenState();
}

class _LoginOTPScreenState extends State<LoginOTPScreen> {
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

  bool wait = false;
  int start = 30;
  late Timer _timer;
  String buttonName = "Resend OTP";
  final TextEditingController otp = TextEditingController();
  String? otpCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Login',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black),
          ),
          leading: const BackButton(
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppStyle.sizedBoxH40,
                Text("Verify with OTP", style: AppTextStyle.appbar),
                AppStyle.sizedBoxH40,
                const Text(
                  "OTP sent to",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                AppStyle.sizedBoxH30,
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
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context, true);
                          },
                          child: Text(
                            "Edit",
                            style: AppTextStyle.text1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                AppStyle.sizedBoxH40,
                const Text(
                  "Enter OTP",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                AppStyle.sizedBoxH30,
                OtpTextField(
                  numberOfFields: 6,
                  mainAxisAlignment: MainAxisAlignment.start,
                  fieldHeight: 50,
                  clearText: true,
                  textStyle: const TextStyle(color: Colors.black),
                  fieldWidth: 50,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  alignment: Alignment.center,
                  autoFocus: false,
                  keyboardType: TextInputType.number,
                  showCursor: true,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  showFieldAsBox: true,
                  onCodeChanged: (String code) {
                  },
                  onSubmit: (String verificationCode) {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      otpCode = verificationCode;
                    });
                  },
                ),
                AppStyle.sizedBoxH10,
                Consumer<AuthManager>(
                  builder: (context, state, _) {
                    if (state.resendOTPStatus) {
                      return const SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(),
                      );
                    }
                    return InkWell(
                      child: Row(
                        children: [
                          Text(
                            "Resend OTP",
                            style: AppTextStyle.text,
                          ),
                          if (wait) ...[
                            Text(
                              " after ",
                              style: AppTextStyle.text,
                            ),
                            Text(
                              "00:${start < 10 ? '0$start' : start}",
                              style: AppTextStyle.text1,
                            ),
                          ]
                        ],
                      ),
                      onTap: () async {
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
                    );
                  },
                ),
                AppStyle.sizedBoxH50,
                Consumer<AuthManager>(
                  builder: (context, state, child) {
                    if (state.verifyingOTPStatus) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return CommonButton(
                        label: "Submit OTP",
                        onPressed: () async {
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
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => const RegisterScreen(),
                                  ));
                                } else {
                                  // final profileProvider =
                                  //     Provider.of<ProfileManager>(context,
                                  //         listen: false);
                                  // profileProvider.fetchProfile(context);
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => const BottomNav(),
                                    ),
                                        (Route<dynamic> route) => false,
                                  );
                                }
                              });
                        });
                  },
                ),
              ],
            ),
          ),
        ));
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
