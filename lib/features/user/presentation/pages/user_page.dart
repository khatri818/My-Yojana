import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constant/app_colors.dart';
import '../../../../core/constant/app_styles.dart';
import '../../../../core/constant/app_text_styles.dart';
import '../../../../core/enum/status.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../di/injection.dart';
import '../manager/user_manager.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => Injection.userManager, child: const __Body());
  }
}

class __Body extends StatefulWidget {
  const __Body();

  @override
  State<__Body> createState() => __BodyState();
}

String phoneNumber = '';
String countryCode = '';
String firebaseId = '';

class __BodyState extends State<__Body> {
  @override
  void initState() {
    super.initState();
    _getPhoneNumberAndCountryCode();
    Future.delayed(
        Duration.zero, () => context.read<UserManager>().getUser(firebaseId));
  }

  Future<void> _getPhoneNumberAndCountryCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firebaseId = prefs.getString('token') ?? '';
    phoneNumber = prefs.getString('phoneNumber') ?? '';
    countryCode = prefs.getString('countryCode') ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Consumer<UserManager>(builder: (context, manager, child) {
        if (manager.userLoadingStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final user = manager.user;
        if (manager.userLoadingStatus.failure || user == null) {
          return const Center(
            child: Text("something went wrong!"),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      if (user.name != null)
                        CircleAvatar(
                            radius: 75,
                            backgroundColor: AppColors.orange,
                            child: Text(
                              AppUtils.getInitials(user.name!),
                              style: AppTextStyle.title2.copyWith(
                                color: AppColors.white,
                                fontSize: 50,
                              ),
                            )),
                    ],
                  ),
                ),
                AppStyle.sizedBoxH20,

                AppStyle.sizedBoxH20,
              ],
            ),
          ),
        );
      }),
    );
  }
}
