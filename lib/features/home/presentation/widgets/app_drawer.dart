import 'package:flutter/material.dart';
import 'package:my_yojana/core/enum/status.dart';
import 'package:provider/provider.dart';
import '../../../../common/app_colors.dart';
import '../../../../core/constant/app_text_styles.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../auth/presentation/manager/auth_manger.dart';
import '../../../auth/presentation/pages/login_page.dart';
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
          if (manager.userLoadingStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = manager.user;
          if (manager.userLoadingStatus.failure || user == null) {
            return const Center(child: Text("Something went wrong!"));
          }

          final displayName = user.name ?? "Unknown";

          return Column(
            children: [
              Container(
                height: 190,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/profile_background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.orange,
                        radius: 40,
                        child: Text(
                          AppUtils.getInitials(displayName),
                          style: AppTextStyle.textFormFieldText1.copyWith(color: AppColors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            displayName,
                            style: AppTextStyle.textFormFieldText1.copyWith(color: AppColors.white),
                          ),
                          Text(
                            "My Profile",
                            style: AppTextStyle.title4.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    children: [
                      _buildDrawerItem(
                        icon: Icons.person, // Solid icon
                        label: 'My Profile',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const UserPage()));
                        },
                      ),
                      _buildDrawerItem(
                        icon: Icons.info, // Solid icon
                        label: 'About MyYojana',
                        onTap: () {},
                      ),
                      _buildDrawerItem(
                        icon: Icons.work, // Solid icon
                        label: 'How it works',
                        onTap: () {},
                      ),
                      _buildDrawerItem(
                        icon: Icons.contact_mail, // Solid icon
                        label: 'Contact us',
                        onTap: () {},
                      ),
                      _buildDrawerItem(
                        icon: Icons.help, // Solid icon
                        label: 'Help',
                        onTap: () {},
                      ),
                      const Divider(),
                      _buildDrawerItem(
                        icon: Icons.logout, // Already solid
                        iconColor: Colors.red,
                        label: 'Logout',
                        labelColor: Colors.red,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Log Out'),
                              content: const Text('Are you sure you want to log out?'),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    final result = await context.read<AuthManager>().logout();
                                    if (result) {
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (_) => const LoginPage()),
                                            (route) => false,
                                      );
                                    }
                                  },
                                  child: const Text('Yes'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('No'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
          );
        },
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    Color? iconColor,
    Color? labelColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 26, color: iconColor ?? Colors.blue),
      title: Text(
        label,
        style: AppTextStyle.title4.copyWith(color: labelColor ?? AppColors.black),
      ),
      onTap: onTap,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
    );
  }
}
