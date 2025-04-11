import 'package:flutter/material.dart';
import 'package:my_yojana/core/enum/status.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../auth/presentation/manager/auth_manger.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../user/presentation/manager/user_manager.dart';
import '../../../user/presentation/pages/user_page.dart';
import '../../../user/presentation/pages/settings_page.dart';

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
              // ✨ Profile Header
              Container(
                height: 220,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/profile_background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.2),
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 38,
                        backgroundColor: Colors.white,
                        child: Text(
                          AppUtils.getInitials(displayName),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2575FC), // ✅ Updated initial color
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "My Profile",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ✨ Navigation Items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  children: [
                    _buildDrawerItem(
                      icon: Icons.person,
                      label: 'My Profile',
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const UserPage())),
                    ),
                    _buildDrawerItem(
                      icon: Icons.settings,
                      label: 'Settings',
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsPage())),
                    ),
                    _buildDrawerItem(
                      icon: Icons.info_outline,
                      label: 'About MyYojana',
                      onTap: () {},
                    ),
                    _buildDrawerItem(
                      icon: Icons.lightbulb_outline,
                      label: 'How it Works',
                      onTap: () {},
                    ),
                    _buildDrawerItem(
                      icon: Icons.contact_mail_outlined,
                      label: 'Contact Us',
                      onTap: () {},
                    ),
                    _buildDrawerItem(
                      icon: Icons.help_outline,
                      label: 'Help',
                      onTap: () {},
                    ),
                    const Divider(thickness: 1, indent: 16, endIndent: 16),
                    _buildDrawerItem(
                      icon: Icons.logout,
                      iconColor: Colors.red,
                      label: 'Logout',
                      labelColor: Colors.red,
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) => Dialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // 🎨 Top Icon / Illustration
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xFF2575FC).withOpacity(0.1),
                                    ),
                                    padding: const EdgeInsets.all(20),
                                    child: const Icon(
                                      Icons.logout_rounded,
                                      color: Color(0xFF2575FC),
                                      size: 48,
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // 📝 Title
                                  const Text(
                                    'Log Out?',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // 💬 Subtitle
                                  const Text(
                                    'Are you sure you want to log out of your account? You can always log back in later.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black54,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // ✅ Action Buttons
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // ❌ Cancel
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                          backgroundColor: Colors.grey[200],
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () => Navigator.of(context).pop(),
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),

                                      // ✅ Confirm Logout
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                          backgroundColor: const Color(0xFF2575FC),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
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
                                        child: const Text(
                                          'Log Out',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // ✨ Footer
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Column(
                  children: [
                    Text(
                      "MyYojana v1.0.0",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Empowering Citizens with Schemes",
                      style: TextStyle(color: Colors.black54, fontSize: 12),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: Icon(
            icon,
            size: 24,
            color: iconColor ?? const Color(0xFF2575FC), // ✅ Default icon color
          ),
          title: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: labelColor ?? Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: onTap,
          dense: true,
          visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
        ),
      ),
    );
  }
}
