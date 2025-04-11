import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constant/app_text_styles.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../user/presentation/manager/user_manager.dart';
import '../../../auth/presentation/manager/auth_manger.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String firebaseId = '';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadFirebaseId();
  }

  Future<void> _loadFirebaseId() async {
    final authManager = context.read<AuthManager>();
    final userManager = context.read<UserManager>();

    final userSession = await authManager.checkUser();
    if (!mounted) return;

    if (userSession == null || userSession.isNewUser) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else {
      await userManager.getUser(userSession.token);
      setState(() {
        firebaseId = userSession.token;
        loading = false;
      });
    }
  }

  void _confirmDeleteUser(BuildContext context, String firebaseId) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.1),
                ),
                child: const Icon(Icons.delete_forever_rounded, color: Colors.red, size: 40),
              ),
              const SizedBox(height: 16),
              const Text(
                "Delete Account",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                "Are you sure you want to permanently delete your account? This cannot be undone.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.of(ctx).pop();

                      final userManager = context.read<UserManager>();
                      final authManager = context.read<AuthManager>();
                      final result = await userManager.deleteUser(firebaseId);

                      if (!mounted) return; // ✅ Safe guard after async

                      if (result) {
                        await authManager.logout();
                        if (!mounted) return; // ✅ Double check again (recommended)

                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                              (route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Failed to delete user. Please try again."),
                          ),
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text("Delete"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Color(0xFF2575FC)),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              tileColor: Colors.grey[100],
              leading: const Icon(Icons.delete_forever_rounded, color: Colors.red),
              title: const Text(
                "Delete Account",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
              ),
              subtitle: const Text("This will permanently delete your account."),
              onTap: () {
                if (firebaseId.isNotEmpty) {
                  _confirmDeleteUser(context, firebaseId);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("User ID not found.")),
                  );
                }
              },
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Center(
              child: Text(
                "App Version 1.0.0",
                style: AppTextStyle.text2.copyWith(color: Colors.grey[600]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
