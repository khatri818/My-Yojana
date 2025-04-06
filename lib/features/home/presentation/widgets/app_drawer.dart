import 'package:flutter/material.dart';
import 'package:my_yojana/core/enum/status.dart';
import 'package:provider/provider.dart';
import '../../../../common/app_colors.dart';
import '../../../../constant/image_resource.dart';
import '../../../../core/constant/app_text_styles.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../auth/presentation/manager/auth_manger.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../auth/presentation/pages/register_page.dart';
import '../../../user/presentation/manager/user_manager.dart';
import '../../../user/presentation/pages/user_page.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<UserManager>(
        builder: (context, manager, child) {
          if (manager.userLoadingStatus == Status.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final user = manager.user;
          if (manager.userLoadingStatus.failure || user == null) {
            return const Center(
              child: Text("Something went wrong!"),
            );
          }

          final displayName = user.name ?? "Unknown";

          return ListView(
            children: [
              SizedBox(
                height: 80,
                child: DrawerHeader(child: Image.asset(ImageResource.bannerLogo)),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.orange,
                  radius: 30,
                  child: Text(
                    AppUtils.getInitials(displayName),
                    style: AppTextStyle.title2.copyWith(color: AppColors.white),
                  ),
                ),
                title: Text(
                  displayName,
                  style: AppTextStyle.text1,
                ),
                subtitle: Text(
                  "My Profile",
                  style: AppTextStyle.textFormFieldText1,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const UserPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.arrow_forward,
                  size: 30,
                ),
                title: Text(
                  'About MyYojana',
                  style: AppTextStyle.title4,
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  Icons.arrow_forward,
                  size: 30,
                ),
                title: Text(
                  'How it works',
                  style: AppTextStyle.title4,
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  Icons.arrow_forward,
                  size: 30,
                ),
                title: Text(
                  'Contact us',
                  style: AppTextStyle.title4,
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  Icons.help_outline,
                  size: 30,
                ),
                title: Text(
                  'Help',
                  style: AppTextStyle.title4,
                ),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  size: 30,
                  color: AppColors.backgroundColor,
                ),
                title: Text(
                  'Logout',
                  style: AppTextStyle.title4,
                ),
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        'Log Out',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      content: const Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await context.read<AuthManager>().logout().then((value) {
                              if (value) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (_) => const LoginPage()),
                                      (route) => false,
                                );
                              }
                            });
                          },
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                          child: const Text('No'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
